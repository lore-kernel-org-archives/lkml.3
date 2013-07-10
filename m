Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753899Ab3GJJhC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 05:37:02 -0400
Received: from mail.skyhub.de ([78.46.96.112]:34186 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751620Ab3GJJhA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 05:37:00 -0400
Date: Wed, 10 Jul 2013 11:36:42 +0200
From: Borislav Petkov <bp@alien8.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Kyungsik Lee <kyungsik.lee@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Marek <mmarek@suse.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        CE Linux Developers List <celinux-dev@lists.celinuxforum.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        hyojun.im@lge.com, chan.jeong@lge.com, raphael.andy.lee@gmail.com,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <rmk@arm.linux.org.uk>,
        Florian Fainelli <florian@openwrt.org>,
        Yann Collet <yann.collet.73@gmail.com>,
        Chanho Min <chanho.min@lge.com>,
        Linux-Next <linux-next@vger.kernel.org>,
        "uclinux-dist-devel@blackfin.uclinux.org" 
	<uclinux-dist-devel@blackfin.uclinux.org>
Subject: Re: [PATCH -next 2/2] kbuild: fix for updated LZ4 tool with the new
 streaming format
Message-ID: <20130710093642.GC14873@pd.tnic>
References: <1367829775-4434-1-git-send-email-kyungsik.lee@lge.com>
 <1367829775-4434-2-git-send-email-kyungsik.lee@lge.com>
 <20130506095124.GA22041@pd.tnic>
 <CAMuHMdWH9w5fj6HRXi+9QcBJym4dukAFsPVGZVqSSk3yTZJUcA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAMuHMdWH9w5fj6HRXi+9QcBJym4dukAFsPVGZVqSSk3yTZJUcA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 10, 2013 at 10:12:46AM +0200, Geert Uytterhoeven wrote:
> >> diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
> >> index a0ab6d7..c9bfbb0 100644
> >> --- a/scripts/Makefile.lib
> >> +++ b/scripts/Makefile.lib
> >> @@ -313,7 +313,7 @@ cmd_lzo = (cat $(filter-out FORCE,$^) | \
> >>
> >>  quiet_cmd_lz4 = LZ4     $@
> >>  cmd_lz4 = (cat $(filter-out FORCE,$^) | \
> >> -     lz4demo -c1 stdin stdout && $(call size_append, $(filter-out FORCE,$^))) > $@ || \
> >> +     lz4c -l -c1 stdin stdout && $(call size_append, $(filter-out FORCE,$^))) > $@ || \
> >
> > You probably want to check for the presence of lz4c on the system and
> > bail with an informative message if absent.
> 
> Yep, x86_64-randconfig
> (http://kisskb.ellerman.id.au/kisskb/buildresult/9110794/):
> 
>   LZ4     arch/x86/boot/compressed/vmlinux.bin.lz4
> /bin/sh: lz4c: command not found

Sure, it had to be 2 months and to hit upstream for there still to be no
fix. Geez...

Anyone reading this and willing to try his skills with an
introductory-level patch, feel free to address this. I'll help testing
and upstreaming it.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
