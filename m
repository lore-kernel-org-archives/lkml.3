Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753459AbaFZIeI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 04:34:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55875 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750770AbaFZIeF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 04:34:05 -0400
Date: Thu, 26 Jun 2014 10:34:03 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Jiri Slaby <jslaby@suse.cz>
cc: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-kernel@vger.kernel.org, tj@kernel.org, rostedt@goodmis.org,
        mingo@redhat.com, akpm@linux-foundation.org, andi@firstfloor.org,
        paulmck@linux.vnet.ibm.com, pavel@ucw.cz, jirislaby@gmail.com,
        Vojtech Pavlik <vojtech@suse.cz>, Michael Matz <matz@suse.de>,
        Udo Seidel <udoseidel@gmx.de>
Subject: Re: [PATCH -repost 05/21] kgr: update Kconfig documentation
In-Reply-To: <53ABD8FB.9000700@suse.cz>
Message-ID: <alpine.LNX.2.00.1406261030210.15939@pobox.suse.cz>
References: <1403694435-3180-1-git-send-email-jslaby@suse.cz> <1403694435-3180-5-git-send-email-jslaby@suse.cz> <20140625134212.4fb38e14@alan.etchedpixels.co.uk> <53ABD8FB.9000700@suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jun 2014, Jiri Slaby wrote:

> >> ---
> >>  kernel/Kconfig.kgraft | 3 +++
> >>  samples/Kconfig       | 4 ++++
> >>  2 files changed, 7 insertions(+)
> >>
> >> diff --git a/kernel/Kconfig.kgraft b/kernel/Kconfig.kgraft
> >> index f38d82c06580..bead93646071 100644
> >> --- a/kernel/Kconfig.kgraft
> >> +++ b/kernel/Kconfig.kgraft
> >> @@ -5,3 +5,6 @@ config KGRAFT
> >>  	bool "kGraft infrastructure"
> >>  	depends on DYNAMIC_FTRACE_WITH_REGS
> >>  	depends on HAVE_KGRAFT
> >> +	help
> >> +	  Select this to enable kGraft online kernel patching. The
> >> +	  runtime price is zero, so it is safe to say Y here.
> >> diff --git a/samples/Kconfig b/samples/Kconfi
> > 
> > The runtime impact is that you've just introduced a virus and trojan
> > writers delight into your kernel. There's a balance between convenience
> > and security but given most users will never use kgraft this advice seems
> > incorrect.
> 
> This now writes:
> +       help
> +         Select this to enable kGraft online kernel patching. The
> +         runtime price is nearly zero, so it is safe to say Y here
> +         provided you are aware of all the consequences (e.g. in
> +         security).
> 
> Is it OK with you?

This might cause a false impression that we are actually opening a 
security hole into a system, which is not true at all.

Yes, backdoor writeres might (or might not) make use of kGraft API, but 
they have gazillion of other comparable options (*probes, ftrace, 
text_poke(), ...).

I'd perhaps propose something like

"Select this to enable kGraft live kernel patching. The runtime penalty is 
nearly zero, so it is safe to say Y here if you want the kernel to expose 
API for live patching to modules".

-- 
Jiri Kosina
SUSE Labs
