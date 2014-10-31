Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932118AbaJaJIv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 05:08:51 -0400
Received: from s3.sipsolutions.net ([5.9.151.49]:50655 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756918AbaJaJIt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 05:08:49 -0400
Message-ID: <1414746518.3014.18.camel@jlt4.sipsolutions.net>
Subject: Re: iwlwifi: mvm:  BACKPORT_WANT_DEV_COREDUMP?
From: Johannes Berg <johannes@sipsolutions.net>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Valentin Rothberg <valentinrothberg@gmail.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Intel Linux Wireless <ilw@linux.intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 31 Oct 2014 10:08:38 +0100
In-Reply-To: <1414746397.1964.13.camel@x220> (sfid-20141031_100713_493693_5EC4F5B9)
References: <1414744834.1964.7.camel@x220>
	 (sfid-20141031_094119_721260_FECF8114) <1414745106.3014.17.camel@jlt4.sipsolutions.net>
	 <1414746397.1964.13.camel@x220> (sfid-20141031_100713_493693_5EC4F5B9)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2-1+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-10-31 at 10:06 +0100, Paul Bolle wrote:
> On Fri, 2014-10-31 at 09:45 +0100, Johannes Berg wrote:
> > On Fri, 2014-10-31 at 09:40 +0100, Paul Bolle wrote:
> > > Your commit aadede6e9f4c ("iwlwifi: mvm: port to devcoredump framework")
> > > landed in today's linux-next (next-20141031). It adds a select statement
> > > for BACKPORT_WANT_DEV_COREDUMP. There's no Kconfig symbol 
> > > BACKPORT_WANT_DEV_COREDUMP so this select is currently a nop. (In
> > > https://lkml.org/lkml/2014/9/30/578 I proposed a patch that emits a
> > > warning in cases like this.)
> > > 
> > > Did you perhaps meant to select WANT_DEV_COREDUMP?
> > 
> > Yes. We'll fix it up in the iwlwifi tree.
> > 
> > Thanks for the report!
> 
> Perhaps you could also look into somehow guarding the call of
> dev_coredumpm(), that this commit added, with checks for
> CONFIG_DEV_COREDUMP. See, I had a quick look at all this and selecting
> WANT_DEV_COREDUMP might not be enough, because DISABLE_DEV_COREDUMP can
> still, well, disable DEV_COREDUMP. Or am I misreading the Kconfig
> symbols that regulate DEV_COREDUMP?

No, you're correctly reading that. However, the devcoredump header file
provides simple functions in this case. That means there's some extra
work (allocating and filling the buffer just to free it immediately) but
it simplifies the code.

johannes

