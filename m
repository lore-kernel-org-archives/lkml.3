Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758184Ab3GOWDq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 18:03:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50131 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755095Ab3GOWDp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 18:03:45 -0400
Date: Mon, 15 Jul 2013 15:03:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Kyungsik Lee <kyungsik.lee@lge.com>, Michal Marek <mmarek@suse.cz>,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        x86@kernel.org, celinux-dev@lists.celinuxforum.org,
        linux-arm-kernel@lists.infradead.org, hyojun.im@lge.com,
        chan.jeong@lge.com, raphael.andy.lee@gmail.com,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <rmk@arm.linux.org.uk>, Borislav Petkov <bp@alien8.de>,
        Florian Fainelli <florian@openwrt.org>,
        Yann Collet <yann.collet.73@gmail.com>,
        Chanho Min <chanho.min@lge.com>
Subject: Re: [PATCH -next 2/2] kbuild: fix for updated LZ4 tool with the new
 streaming format
Message-Id: <20130715150342.35f7620ffe0835e3e2bc37d0@linux-foundation.org>
In-Reply-To: <20130712075602.GA4002@gmail.com>
References: <1367829775-4434-1-git-send-email-kyungsik.lee@lge.com>
	<1367829775-4434-2-git-send-email-kyungsik.lee@lge.com>
	<20130712075602.GA4002@gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Jul 2013 09:56:02 +0200 Ingo Molnar <mingo@kernel.org> wrote:

> 
> * Kyungsik Lee <kyungsik.lee@lge.com> wrote:
> >  quiet_cmd_lz4 = LZ4     $@
> >  cmd_lz4 = (cat $(filter-out FORCE,$^) | \
> > -	lz4demo -c1 stdin stdout && $(call size_append, $(filter-out FORCE,$^))) > $@ || \
> > +	lz4c -l -c1 stdin stdout && $(call size_append, $(filter-out FORCE,$^))) > $@ || \
> >  	(rm -f $@ ; false)
> 
> None of the major distros I tried has the lz4 or lz4c binary available, 
> and this breaks randconfig builds:
> 
>   /bin/sh: lz4c: command not found
> 
> If:
> 
>  CONFIG_HAVE_KERNEL_LZ4=y
>  CONFIG_KERNEL_LZ4=y
>  CONFIG_RD_LZ4=y
>  CONFIG_LZ4_DECOMPRESS=y
>  CONFIG_DECOMPRESS_LZ4=y
> 
> If a utility is not widely available yet and if the utility is not in the 
> kernel proper, could you please at least make sure that randconfig does 
> not stumble over non-buildable kernels?

I don't know how to do this.  Any suggestions?

It has to be done at `make config' time.  We'd need to probe for the
presence of lz4c and then....  what?

Is there any precedent for this?

I don't think we can just ignore the absence of lz4c - the user has
selected a config which his system cannot build.  The problem lies
within randconfig itself.
