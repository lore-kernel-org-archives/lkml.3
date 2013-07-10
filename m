Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755109Ab3GJS2T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 14:28:19 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:50574 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755089Ab3GJS2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 14:28:17 -0400
Date: Wed, 10 Jul 2013 20:28:15 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Borislav Petkov <bp@alien8.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Kyungsik Lee <kyungsik.lee@lge.com>,
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
Message-ID: <20130710182815.GA362@x4>
References: <1367829775-4434-1-git-send-email-kyungsik.lee@lge.com>
 <1367829775-4434-2-git-send-email-kyungsik.lee@lge.com>
 <20130506095124.GA22041@pd.tnic>
 <CAMuHMdWH9w5fj6HRXi+9QcBJym4dukAFsPVGZVqSSk3yTZJUcA@mail.gmail.com>
 <20130710093642.GC14873@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130710093642.GC14873@pd.tnic>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013.07.10 at 11:36 +0200, Borislav Petkov wrote:
> On Wed, Jul 10, 2013 at 10:12:46AM +0200, Geert Uytterhoeven wrote:
> > >> diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
> > >> index a0ab6d7..c9bfbb0 100644
> > >> --- a/scripts/Makefile.lib
> > >> +++ b/scripts/Makefile.lib
> > >> @@ -313,7 +313,7 @@ cmd_lzo = (cat $(filter-out FORCE,$^) | \
> > >>
> > >>  quiet_cmd_lz4 = LZ4     $@
> > >>  cmd_lz4 = (cat $(filter-out FORCE,$^) | \
> > >> -     lz4demo -c1 stdin stdout && $(call size_append, $(filter-out FORCE,$^))) > $@ || \
> > >> +     lz4c -l -c1 stdin stdout && $(call size_append, $(filter-out FORCE,$^))) > $@ || \
> > >
> > > You probably want to check for the presence of lz4c on the system and
> > > bail with an informative message if absent.
> > 
> > Yep, x86_64-randconfig
> > (http://kisskb.ellerman.id.au/kisskb/buildresult/9110794/):
> > 
> >   LZ4     arch/x86/boot/compressed/vmlinux.bin.lz4
> > /bin/sh: lz4c: command not found
> 
> Sure, it had to be 2 months and to hit upstream for there still to be no
> fix. Geez...

Well, there's also no hand-holding when lzop is missing for LZO.
And the error message is clear enough. No?

BTW speaking of introductory-level patches, what about the following
one:

Now that lz4 kernel compression is available, add *.lz4 to .gitignore

diff --git a/.gitignore b/.gitignore
index 3b8b9b3..7e9932e 100644
--- a/.gitignore
+++ b/.gitignore
@@ -29,6 +29,7 @@ modules.builtin
 *.bz2
 *.lzma
 *.xz
+*.lz4
 *.lzo
 *.patch
 *.gcno


-- 
Markus
