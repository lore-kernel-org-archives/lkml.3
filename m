Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756726AbaJaJGn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 05:06:43 -0400
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:51430 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752765AbaJaJGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 05:06:41 -0400
Message-ID: <1414746397.1964.13.camel@x220>
Subject: Re: iwlwifi: mvm:  BACKPORT_WANT_DEV_COREDUMP?
From: Paul Bolle <pebolle@tiscali.nl>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Valentin Rothberg <valentinrothberg@gmail.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Intel Linux Wireless <ilw@linux.intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 31 Oct 2014 10:06:37 +0100
In-Reply-To: <1414745106.3014.17.camel@jlt4.sipsolutions.net>
References: <1414744834.1964.7.camel@x220>
	 (sfid-20141031_094119_721260_FECF8114) <1414745106.3014.17.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 31 Oct 2014 09:06:38.0367 (UTC) FILETIME=[FA76A2F0:01CFF4E9]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-10-31 at 09:45 +0100, Johannes Berg wrote:
> On Fri, 2014-10-31 at 09:40 +0100, Paul Bolle wrote:
> > Your commit aadede6e9f4c ("iwlwifi: mvm: port to devcoredump framework")
> > landed in today's linux-next (next-20141031). It adds a select statement
> > for BACKPORT_WANT_DEV_COREDUMP. There's no Kconfig symbol 
> > BACKPORT_WANT_DEV_COREDUMP so this select is currently a nop. (In
> > https://lkml.org/lkml/2014/9/30/578 I proposed a patch that emits a
> > warning in cases like this.)
> > 
> > Did you perhaps meant to select WANT_DEV_COREDUMP?
> 
> Yes. We'll fix it up in the iwlwifi tree.
> 
> Thanks for the report!

Perhaps you could also look into somehow guarding the call of
dev_coredumpm(), that this commit added, with checks for
CONFIG_DEV_COREDUMP. See, I had a quick look at all this and selecting
WANT_DEV_COREDUMP might not be enough, because DISABLE_DEV_COREDUMP can
still, well, disable DEV_COREDUMP. Or am I misreading the Kconfig
symbols that regulate DEV_COREDUMP?

Thanks,


Paul Bolle

