Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753125AbaKXJEB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 04:04:01 -0500
Received: from mail-lb0-f178.google.com ([209.85.217.178]:48737 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414AbaKXJD6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 04:03:58 -0500
MIME-Version: 1.0
In-Reply-To: <1416819560-10931-1-git-send-email-geert@linux-m68k.org>
References: <1416819560-10931-1-git-send-email-geert@linux-m68k.org>
Date: Mon, 24 Nov 2014 10:03:56 +0100
X-Google-Sender-Auth: As2ZMkRM8DKD4fPvlNmk2MTWWfw
Message-ID: <CAMuHMdWWoBRm3QRpVaymiqV5afhp5mYg_v3vifb4iJrNE5_TPw@mail.gmail.com>
Subject: Re: Build regressions/improvements in v3.18-rc6
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 24, 2014 at 9:59 AM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> JFYI, when comparing v3.18-rc6[1]  to v3.18-rc5[3], the summaries are:
>   - build errors: +27/-8

  + /home/kisskb/slave/src/Documentation/mic/mpssd/mpssd.c: error:
(near initialization for ‘virtblk_dev_page.blk_config.capacity’):  =>
152:3
  + /home/kisskb/slave/src/Documentation/mic/mpssd/mpssd.c: error:
(near initialization for ‘virtblk_dev_page.blk_config.seg_max’):  =>
151:3
  + /home/kisskb/slave/src/Documentation/mic/mpssd/mpssd.c: error:
(near initialization for ‘virtblk_dev_page.host_features’):  => 149:3
  + /home/kisskb/slave/src/Documentation/mic/mpssd/mpssd.c: error:
(near initialization for ‘virtnet_dev_page.host_features’):  => 119:3
  + /home/kisskb/slave/src/Documentation/mic/mpssd/mpssd.c: error:
braced-group within expression allowed only inside a function:  =>
116:10, 93:10, 113:10, 146:10, 96:10
  + /home/kisskb/slave/src/Documentation/mic/mpssd/mpssd.c: error:
initializer element is not constant:  => 149:3, 152:3, 151:3, 119:3
  + /home/kisskb/slave/src/Documentation/prctl/disable-tsc-ctxt-sw-stress-test.c:
error: impossible register constraint in ‘asm’:  => 34:1
  + /home/kisskb/slave/src/Documentation/prctl/disable-tsc-on-off-stress-test.c:
error: impossible register constraint in ‘asm’:  => 36:1
  + /home/kisskb/slave/src/Documentation/prctl/disable-tsc-test.c:
error: impossible register constraint in ‘asm’:  => 36:1
  + /home/kisskb/slave/src/Documentation/vDSO/vdso_standalone_test_x86.c:
error: impossible register constraint in ‘asm’:  => 49:2

i386-randconfig

  + /home/kisskb/slave/src/arch/powerpc/lib/sstep.c: error: 'do_lfd'
undeclared (first use in this function):  => 1874:29
  + /home/kisskb/slave/src/arch/powerpc/lib/sstep.c: error: 'do_lfs'
undeclared (first use in this function):  => 1872:29
  + /home/kisskb/slave/src/arch/powerpc/lib/sstep.c: error: 'do_stfd'
undeclared (first use in this function):  => 1928:30
  + /home/kisskb/slave/src/arch/powerpc/lib/sstep.c: error: 'do_stfs'
undeclared (first use in this function):  => 1926:30
  + /home/kisskb/slave/src/arch/powerpc/lib/sstep.c: error: implicit
declaration of function 'do_fp_load'
[-Werror=implicit-function-declaration]:  => 1872:4
  + /home/kisskb/slave/src/arch/powerpc/lib/sstep.c: error: implicit
declaration of function 'do_fp_store'
[-Werror=implicit-function-declaration]:  => 1926:4

powerpc-randconfig

  + /home/kisskb/slave/src/fs/hostfs/hostfs_user.c: error: 'AT_FDCWD'
undeclared (first use in this function):  => 378
  + /home/kisskb/slave/src/fs/hostfs/hostfs_user.c: error: (Each
undeclared identifier is reported only once:  => 378
  + /home/kisskb/slave/src/fs/hostfs/hostfs_user.c: error: for each
function it appears in.):  => 378

um_defconfig (broken userspace)

> [1] http://kisskb.ellerman.id.au/kisskb/head/8117/ (120 out of 119 configs)
> [3] http://kisskb.ellerman.id.au/kisskb/head/8092/ (120 out of 119 configs)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
