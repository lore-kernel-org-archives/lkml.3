Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481AbaHSPW5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 11:22:57 -0400
Received: from fr1.as29.net ([62.210.131.231]:18357 "EHLO
	toothrot.meleeweb.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751976AbaHSPWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 11:22:55 -0400
Date: Tue, 19 Aug 2014 17:22:38 +0200
From: Bertrand Jacquin <beber@meleeweb.net>
To: Andi Kleen <andi@firstfloor.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, Willy Tarreau <w@1wt.eu>
Subject: Re: [PATCH 2/3] kbuild: handle module compression while running
 'make modules_install'.
Message-ID: <20140819152238.GB2164@lady-voodoo.exosec.local>
References: <1408215016-1848-1-git-send-email-beber@meleeweb.net>
 <1408215016-1848-3-git-send-email-beber@meleeweb.net>
 <87lhqkmxdl.fsf@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87lhqkmxdl.fsf@tassilo.jf.intel.com>
Jabber-ID: beber@meleeweb.net
X-GPG-Key: 0x39BB8CF4
X-GPG-DirectLink: http://pgp.mit.edu:11371/pks/lookup?op=get&search=0x39BB8CF4
X-GPG-Fingerprint: 2CBD 6A23 D980 3E32 66D1  573D 89B8 C953 39BB 8CF4
X-Pants: On
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

D'ar meurzh 19 a viz Eost 2014 e 15 eur 17, « Andi Kleen » he deus skrivet :
> Bertrand Jacquin <beber@meleeweb.net> writes:
> >  
> > +# CONFIG_MODULE_COMPRESS, if defined, will cause module to be compressed
> > +# after they are installed in agreement with CONFIG_MODULE_COMPRESS_GZIP
> > +# or CONFIG_MODULE_COMPRESS_XZ.
> > +
> > +mod_compress_cmd = true
> > +ifdef CONFIG_MODULE_COMPRESS
> > +  ifdef CONFIG_MODULE_COMPRESS_GZIP
> > +    mod_compress_cmd = gzip -n -9
> 
> Please don't use gzip -9. The gain is very small, but it can make
> the time to compress much longer. Just use plain gzip.
> 
> I suspect it doesn't make sense either for xz.

I understand your concern about this, but does is make sense to not use
-9 when then following files use gzip or other compression tools with -9 :

  arch/blackfin/Makefile:14:GZFLAGS          := -9

  arch/powerpc/boot/wrapper:297:        gzip -n -f -9 "$vmz.$$"
  arch/powerpc/boot/wrapper:422:    gzip -n -f -9 "$ofile"
  arch/powerpc/boot/wrapper:469:    gzip -n --force -9 --stdout "$ofile.bin" > "$odir/otheros.bld"

  arch/arm/Makefile:23:GZFLAGS            :=-9
  arch/arm64/Makefile:16:GZFLAGS          :=-9

  arch/m68k/Makefile:138: gzip -9c vmlinux.tmp >vmlinux.gz
  arch/m68k/Makefile:141: gzip -9c vmlinux >vmlinux.gz

  arch/mips/lasat/image/Makefile:46:      gzip -cf -9 $< > $@

  arch/parisc/Makefile:121:       @gzip -cf -9 $< > $@

  scripts/package/mkspec:115:echo 'bzip2 -9 vmlinux'
  scripts/package/builddeb:20:    gzip -9 "$pdir/usr/share/doc/$pname/changelog.Debian"
  scripts/package/Makefile:127:   -f -9 $(perf-tar).tar)

  scripts/gen_initramfs_list.sh:229:compr="gzip -n -9 -f"
  scripts/gen_initramfs_list.sh:245:                && compr="gzip -n -9 -f"
  scripts/gen_initramfs_list.sh:248:                && compr="bzip2 -9 -f"
  scripts/gen_initramfs_list.sh:251:                && compr="lzma -9 -f"
  scripts/gen_initramfs_list.sh:257:                && compr="lzop -9 -f"
  scripts/gen_initramfs_list.sh:260:                && compr="lz4 -l -9 -f"

  scripts/Makefile.lib:241:cmd_gzip = (cat $(filter-out FORCE,$^) | gzip -n -f -9 > $@) || \
  scripts/Makefile.lib:311:       bzip2 -9 && $(call size_append, $(filter-out FORCE,$^))) > $@ || \
  scripts/Makefile.lib:319:       lzma -9 && $(call size_append, $(filter-out FORCE,$^))) > $@ || \
  scripts/Makefile.lib:324:       lzop -9 && $(call size_append, $(filter-out FORCE,$^))) > $@ || \

-- 
Beber
