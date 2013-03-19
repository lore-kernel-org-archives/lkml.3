Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932382Ab3CSPCY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 11:02:24 -0400
Received: from mga11.intel.com ([192.55.52.93]:23199 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754705Ab3CSPCV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 11:02:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,872,1355126400"; 
   d="scan'208";a="305198259"
Date: Tue, 19 Mar 2013 23:02:04 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Bob Liu <lliubbo@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        David Howells <dhowells@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: make[2]: execvp: /bin/bash: Argument list too long
Message-ID: <20130319150204.GA11928@localhost>
References: <5148064c.NHUmXnvVxwyYN+nc%fengguang.wu@intel.com>
 <20130318235058.8c3c78ec.akpm@linux-foundation.org>
 <20130319131025.GC2706@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20130319131025.GC2706@phenom.dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 19, 2013 at 09:10:25AM -0400, Konrad Rzeszutek Wilk wrote:
> On Mon, Mar 18, 2013 at 11:50:58PM -0700, Andrew Morton wrote:
> > On Tue, 19 Mar 2013 14:31:40 +0800 kbuild test robot <fengguang.wu@intel.com> wrote:
> > 
> > > tree:   git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next master
> > > head:   0e78c0989334e9c1d578ba25621de14e8441d8b4
> > > commit: 7cac5501aa2bd4777906fa0cdccc1b1ce18b3166 staging: zcache: enable zcache to be built/loaded as a module
> > > date:   26 hours ago
> > > config: make ARCH=i386 allmodconfig
> > > 
> > > All error/warnings:
> > > 
> > > >> make[2]: execvp: /bin/bash: Argument list too long
> > >    make[2]: *** [__modpost] Error 127
> > >    make[2]: Target `_modpost' not remade because of errors.
> > > 
> > 
> > Hey, I see that very occasionally, but it goes away all by itself.  Are
> > you sure that
> > staging-zcache-enable-ramster-to-be-built-loaded-as-a-module.patch
> > causes it?

Sorry, I confirmed that it's a wrong bisect..

> Is there a way to print out what the argument list is?

Good idea! I managed to catch the error command with

        strace -e trace=process -s 4096 -f -o argtoolong make -j1 --debug=j V=1 ARCH=i386 modules

71827 vfork()                           = 72102
72102 execve("/bin/sh", ["/bin/sh", "-c", "echo '  scripts/mod/modpost -m -a -o /cc/wfg/sound-compiletest/Module.symvers      -s'; scripts/
mod/modpost -m -a -o /cc/wfg/sound-compiletest/Module.symvers      -s vmlinux arch/x86/crypto/ablk_helper.o arch/x86/crypto/aes-i586.o arch
/x86/crypto/aesni-intel.o arch/x86/crypto/crc32-pclmul.o arch/x86/crypto/crc32c-intel.o arch/x86/crypto/glue_helper.o arch/x86/crypto/salsa
20-i586.o arch/x86/crypto/serpent-sse2-i586.o arch/x86/crypto/twofish-i586.o arch/x86/kernel/apm.o arch/x86/kernel/cpu/mcheck/mce-inject.o 
arch/x86/kernel/cpuid.o arch/x86/kernel/microcode.o arch/x86/kernel/msr.o arch/x86/kernel/test_nx.o arch/x86/kvm/kvm-amd.o arch/x86/kvm/kvm-intel.o arch/x86/kvm/kvm.o arch/x86/mm/testmmiotrace.o arch/x86/oprofile/oprofile.o arch/x86/platform/iris/iris.o arch/x86/platform/scx200/scx200.o arch/x86/video/fbdev.o block/cfq-iosched.o block/deadline-iosched.o crypto/af_alg.o crypto/algif_hash.o crypto/algif_skcipher.o crypto/ansi_cprng.o crypto/anubis.o crypto/arc4.o crypto/asymmetric_keys/pefile_key_parser.o crypto/asymmetric_keys/pkcs7_message.o crypto/async_tx/async_memcpy.o crypto/async_tx/async_pq.o crypto/async_tx/async_raid6_recov.o crypto/async_tx/async_tx.o crypto/async_tx/async_xor.o crypto/async_tx/raid6test.o crypto/authenc.o crypto/authencesn.o crypto/blowfish_common.o crypto/blowfish_generic.o crypto/camellia_generic.o crypto/cast5_generic.o crypto/cast6_generic.o crypto/cast_common.o crypto/cbc.o crypto/ccm.o crypto/crc32.o crypto/crc32c.o crypto/cryptd.o crypto/crypto_null.o crypto/crypto_user.o crypto/ctr.o crypto/cts.o crypto/deflate.o crypto/des_generic.o crypto/ecb.o crypto/fcrypt.o crypto/gcm.o crypto/gf128mul.o crypto/ghash-generic.o crypto/khazad.o crypto/lrw.o crypto/lzo.o crypto/md4.o crypto/michael_mic.o crypto/pcbc.o crypto/pcrypt.o crypto/rmd128.o crypto/rmd160.o crypto/rmd256.o crypto/rmd320.o crypto/salsa20_generic.o crypto/seed.o crypto/seqiv.o crypto/serpent_generic.o crypto/sha256_generic.o crypto/sha512_generic.o crypto/tcrypt.o crypto/tea.o crypto/tgr192.o crypto/twofish_common.o crypto/twofish_generic.o crypto/vmac.o crypto/wp512.o crypto/xcbc.o crypto/xor.o crypto/xts.o crypto/zlib.o drivers/acpi/ac.o drivers/acpi/acpi_ipmi.o drivers/acpi/acpi_pad.o drivers/acpi/apei/einj.o drivers/acpi/apei/erst-dbg.o drivers/acpi/battery.o drivers/acpi/button.o drivers/acpi/custom_method.o drivers/acpi/ec_sys.o drivers/acpi/fan.o drivers/acpi/processor.o drivers/acpi/sbs.o drivers/acpi/sbshc.o drivers/acpi/thermal.o drivers/acpi/video.o drivers/ata/acard-ahci.o drivers/ata/ahci.o drivers/ata/ahci_platform.o drivers/ata/ata_generic.o drivers/ata/ata_piix.o drivers/ata/libahci.o drivers/ata/libata.o drivers/ata/pata_acpi.o drivers/ata/pata_ali.o drivers/ata/pata_amd.o drivers/ata/pata_arasan_cf.o drivers/ata/pata_artop.o drivers/ata/pata_atiixp.o drivers/ata/pata_atp867x.o drivers/ata/pata_cmd640.o drivers/ata/pata_cmd64x.o drivers/ata/pata_cs5520.o drivers/ata/pata_cs5530.o drivers/ata/pata_cs5535.o drivers/ata/pata_cs5536.o drivers/ata/pata_cypress.o drivers/ata/pata_efar.o drivers/ata/pata_hpt366.o drivers/ata/pata_hpt37x.o drivers/ata/pata_hpt3x2n.o drivers/ata/pata_hpt3x3.o drivers/ata/pata_isapnp.o drivers/ata/pata_it8213.o drivers/ata/pata_it821x.o drivers/ata/pata_jmicron.o drivers/ata/pata_legacy.o drivers/ata/pata_marvell.o drivers/ata/pata_mpiix.o drivers/ata/pata_netcell.o drivers/ata/pata_ninja32.o drivers/ata/pata_ns87410.o drivers/ata/pata_ns87415.o drivers/ata/pata_oldpiix.o drivers/ata/pata_opti.o drivers/ata/pata_optidma.o drivers/ata/pata_pcmcia.o drivers/ata/pata_pdc2027x.o drivers/ata/pata_pdc202xx_old.o drivers/ata/pata_piccolo.o drivers/ata/pata_platform.o drivers/ata/pata_radisys.o drivers/ata/pata_rdc.o drivers/ata/pata_rz1000.o drivers/ata/pata_sc1200.o drivers/ata/pata_sch.o drivers/ata/pata_serverworks.o drivers/ata/pata_sil680.o drivers/ata/pata_sis.o drivers/ata/pata_sl82c105.o drivers/ata/pata_triflex.o drivers/ata/pata_via.o drivers/ata/pdc_adma.o drivers/ata/sata_highbank.o drivers/ata/sata_inic162x.o drivers/ata/sata_mv.o drivers/ata/sata_nv.o drivers/ata/sata_promise.o "...], [/* 119 vars */] <unfinished ...>
71827 wait4(-1,  <unfinished ...>
72102 <... execve resumed> )            = -1 E2BIG (Argument list too long)
72102 exit_group(127)                   = ?
71827 <... wait4 resumed> [{WIFEXITED(s) && WEXITSTATUS(s) == 127}], 0, NULL) = 72102
71827 --- SIGCHLD (Child exited) @ 0 (0) ---

Thanks,
Fengguang
