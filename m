Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751816AbaJ0WiE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 18:38:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51371 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750785AbaJ0WiC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 18:38:02 -0400
Date: Mon, 27 Oct 2014 23:37:39 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Alexis Berlemont <alexis.berlemont@gmail.com>
Cc: linux-kernel@vger.kernel.org, dsahern@gmail.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, paulus@samba.org, acme@kernel.org,
        namhyung@kernel.org, mmarek@suse.cz
Subject: Re: [PATCH v4 00/14] Kbuild for perf
Message-ID: <20141027223739.GA21965@krava.redhat.com>
References: <20141024124601.GX14687@kernel.org>
 <1414275639-1053-1-git-send-email-alexis.berlemont@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <1414275639-1053-1-git-send-email-alexis.berlemont@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 26, 2014 at 12:20:25AM +0200, Alexis Berlemont wrote:
> Hello,
> 
> Here is a proposal of perf's build process managed by Kbuild:
> * The file Makefile.perf is replaced by Makefile.kbuild
> * Makefile.kbuild generates a default .config file if none exists
>   (allyesconfig)
> * Makefile.kbuild adapts the .config file according to the
>   features-check tests results
> * Makefile.kbuild builds external dependencies (linux/tools/lib/*)
> * Makefile.kbuild leaves the rest to Kbuild 
> 
> Changes since v3:
>  * Patchs were generated starting from the following branch:
>  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git perf/core
>  * Add Kconfig options for 32-bit compatibility VDSOs
>  * Target build-test: for each .config-based test case, call "make
>    olddefconfig" so as to prevent failure because of new Kconfig
>    symbol(s)

hi,
I tried 'make clean && make' and got attached errors.
I'm running Fedora 20 on x86_64

jirka


---
  BUILD:   Doing 'make [33m-j4[m' parallel build
  GEN     tools/perf/PERF-VERSION-FILE
make[3]: *** No rule to make target `kernelversion'.  Stop.
  MKDIR    libapi_dirs
  CC       /home/jolsa/kernel.org/linux-perf/tools/lib/api/fs/fs.o
  CC       /home/jolsa/kernel.org/linux-perf/tools/lib/api/fs/debugfs.o
  CC       /home/jolsa/kernel.org/linux-perf/tools/lib/api/fd/array.o
  AR       libapikfs.a
  LD      tools/perf/arch/built-in.o
  LD      tools/perf/built-in.o
  LD      tools/perf/perf
/bin/ld: skipping incompatible /lib/libpthread.so when searching for -lpthread
/bin/ld: skipping incompatible /lib/libpthread.a when searching for -lpthread
/bin/ld: skipping incompatible /lib/libpthread.so when searching for -lpthread
/bin/ld: skipping incompatible /lib/libpthread.a when searching for -lpthread
/bin/ld: skipping incompatible /lib/librt.so when searching for -lrt
/bin/ld: skipping incompatible /lib/librt.a when searching for -lrt
/bin/ld: skipping incompatible /lib/librt.so when searching for -lrt
/bin/ld: skipping incompatible /lib/librt.a when searching for -lrt
/bin/ld: skipping incompatible /lib/libm.so when searching for -lm
/bin/ld: skipping incompatible /lib/libm.a when searching for -lm
/bin/ld: skipping incompatible /lib/libm.so when searching for -lm
/bin/ld: skipping incompatible /lib/libm.a when searching for -lm
/bin/ld: skipping incompatible /lib/libdl.so when searching for -ldl
/bin/ld: skipping incompatible /lib/libdl.a when searching for -ldl
/bin/ld: skipping incompatible /lib/libdl.so when searching for -ldl
/bin/ld: skipping incompatible /lib/libdl.a when searching for -ldl
/bin/ld: skipping incompatible /lib/libdl.so when searching for -ldl
/bin/ld: skipping incompatible /lib/libdl.a when searching for -ldl
/bin/ld: skipping incompatible /lib/libdl.so when searching for -ldl
/bin/ld: skipping incompatible /lib/libdl.a when searching for -ldl
/bin/ld: skipping incompatible /lib/libresolv.so when searching for -lresolv
/bin/ld: skipping incompatible /lib/libresolv.a when searching for -lresolv
/bin/ld: skipping incompatible /lib/libresolv.so when searching for -lresolv
/bin/ld: skipping incompatible /lib/libresolv.a when searching for -lresolv
/bin/ld: skipping incompatible /lib/libnsl.so when searching for -lnsl
/bin/ld: skipping incompatible /lib/libnsl.a when searching for -lnsl
/bin/ld: skipping incompatible /lib/libnsl.so when searching for -lnsl
/bin/ld: skipping incompatible /lib/libnsl.a when searching for -lnsl
/bin/ld: skipping incompatible /lib/libdl.so when searching for -ldl
/bin/ld: skipping incompatible /lib/libdl.a when searching for -ldl
/bin/ld: skipping incompatible /lib/libdl.so when searching for -ldl
/bin/ld: skipping incompatible /lib/libdl.a when searching for -ldl
/bin/ld: skipping incompatible /lib/libm.so when searching for -lm
/bin/ld: skipping incompatible /lib/libm.a when searching for -lm
/bin/ld: skipping incompatible /lib/libm.so when searching for -lm
/bin/ld: skipping incompatible /lib/libm.a when searching for -lm
/bin/ld: skipping incompatible /lib/libcrypt.so when searching for -lcrypt
/bin/ld: skipping incompatible /lib/libcrypt.a when searching for -lcrypt
/bin/ld: skipping incompatible /lib/libcrypt.so when searching for -lcrypt
/bin/ld: skipping incompatible /lib/libcrypt.a when searching for -lcrypt
/bin/ld: skipping incompatible /lib/libutil.so when searching for -lutil
/bin/ld: skipping incompatible /lib/libutil.a when searching for -lutil
/bin/ld: skipping incompatible /lib/libutil.so when searching for -lutil
/bin/ld: skipping incompatible /lib/libutil.a when searching for -lutil
/bin/ld: skipping incompatible /lib/libpthread.so when searching for -lpthread
/bin/ld: skipping incompatible /lib/libpthread.a when searching for -lpthread
/bin/ld: skipping incompatible /lib/libpthread.so when searching for -lpthread
/bin/ld: skipping incompatible /lib/libpthread.a when searching for -lpthread
/bin/ld: skipping incompatible /lib/libc.so when searching for -lc
/bin/ld: skipping incompatible /lib/libc.a when searching for -lc
/bin/ld: skipping incompatible /lib/libc.so when searching for -lc
/bin/ld: skipping incompatible /lib/libc.a when searching for -lc
/bin/ld: skipping incompatible /lib/libpthread.so when searching for -lpthread
/bin/ld: skipping incompatible /lib/libpthread.a when searching for -lpthread
/bin/ld: skipping incompatible /lib/libpthread.so when searching for -lpthread
/bin/ld: skipping incompatible /lib/libpthread.a when searching for -lpthread
/bin/ld: skipping incompatible /lib/libdl.so when searching for -ldl
/bin/ld: skipping incompatible /lib/libdl.a when searching for -ldl
/bin/ld: skipping incompatible /lib/libdl.so when searching for -ldl
/bin/ld: skipping incompatible /lib/libdl.a when searching for -ldl
/bin/ld: skipping incompatible /lib/libutil.so when searching for -lutil
/bin/ld: skipping incompatible /lib/libutil.a when searching for -lutil
/bin/ld: skipping incompatible /lib/libutil.so when searching for -lutil
/bin/ld: skipping incompatible /lib/libutil.a when searching for -lutil
/bin/ld: skipping incompatible /lib/libm.so when searching for -lm
/bin/ld: skipping incompatible /lib/libm.a when searching for -lm
/bin/ld: skipping incompatible /lib/libm.so when searching for -lm
/bin/ld: skipping incompatible /lib/libm.a when searching for -lm
/bin/ld: skipping incompatible /lib/libdl.so when searching for -ldl
/bin/ld: skipping incompatible /lib/libdl.a when searching for -ldl
/bin/ld: skipping incompatible /lib/libdl.so when searching for -ldl
/bin/ld: skipping incompatible /lib/libdl.a when searching for -ldl
/bin/ld: skipping incompatible /lib/libc.so when searching for -lc
/bin/ld: skipping incompatible /lib/libc.a when searching for -lc
/bin/ld: skipping incompatible /lib/libc.so when searching for -lc
/bin/ld: skipping incompatible /lib/libc.a when searching for -lc
