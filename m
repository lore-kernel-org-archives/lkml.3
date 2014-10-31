Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757284AbaJaJRv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 05:17:51 -0400
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:58337 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756896AbaJaJRs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 05:17:48 -0400
Message-ID: <1414747065.1964.15.camel@x220>
Subject: Re: iwlwifi: mvm:  BACKPORT_WANT_DEV_COREDUMP?
From: Paul Bolle <pebolle@tiscali.nl>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Valentin Rothberg <valentinrothberg@gmail.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Intel Linux Wireless <ilw@linux.intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 31 Oct 2014 10:17:45 +0100
In-Reply-To: <1414746518.3014.18.camel@jlt4.sipsolutions.net>
References: <1414744834.1964.7.camel@x220>
	 (sfid-20141031_094119_721260_FECF8114) <1414745106.3014.17.camel@jlt4.sipsolutions.net>
	 <1414746397.1964.13.camel@x220>
	 (sfid-20141031_100713_493693_5EC4F5B9) <1414746518.3014.18.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 31 Oct 2014 09:17:46.0247 (UTC) FILETIME=[888D0970:01CFF4EB]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-10-31 at 10:08 +0100, Johannes Berg wrote:
> On Fri, 2014-10-31 at 10:06 +0100, Paul Bolle wrote:
> > Perhaps you could also look into somehow guarding the call of
> > dev_coredumpm(), that this commit added, with checks for
> > CONFIG_DEV_COREDUMP. See, I had a quick look at all this and selecting
> > WANT_DEV_COREDUMP might not be enough, because DISABLE_DEV_COREDUMP can
> > still, well, disable DEV_COREDUMP. Or am I misreading the Kconfig
> > symbols that regulate DEV_COREDUMP?
> 
> No, you're correctly reading that. However, the devcoredump header file
> provides simple functions in this case. That means there's some extra
> work (allocating and filling the buffer just to free it immediately) but
> it simplifies the code.

I see. More than a quick look was required here. Thanks for explaining
this!


Paul Bolle

