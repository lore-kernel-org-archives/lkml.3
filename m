Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754936AbaJ1Jul (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 05:50:41 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:39709 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728AbaJ1Juk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 05:50:40 -0400
MIME-Version: 1.0
In-Reply-To: <1414488999-12138-1-git-send-email-geert@linux-m68k.org>
References: <1414488999-12138-1-git-send-email-geert@linux-m68k.org>
Date: Tue, 28 Oct 2014 10:50:38 +0100
X-Google-Sender-Auth: uFQ_h38__A1JLDGbSBHqjIRw-38
Message-ID: <CAMuHMdVgbpcxgt6d9+ew2v+L0r2Woju6dTTv0nfLGk5LjRMkXg@mail.gmail.com>
Subject: Re: Build regressions/improvements in v3.18-rc2
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Peter Foley <pefoley2@pefoley.com>, Randy Dunlap <rdunlap@infradead.org>,
        Erik Bosman <ejbosman@cs.vu.nl>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 10:36 AM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> JFYI, when comparing v3.18-rc2[1]  to v3.18-rc1[3], the summaries are:
>   - build errors: +16/-17

  + /scratch/kisskb/src/Documentation/mic/mpssd/mpssd.c: error: (near
initialization for 'virtblk_dev_page.blk_config.capacity'):  => 152:3
  + /scratch/kisskb/src/Documentation/mic/mpssd/mpssd.c: error: (near
initialization for 'virtblk_dev_page.blk_config.seg_max'):  => 151:3
  + /scratch/kisskb/src/Documentation/mic/mpssd/mpssd.c: error: (near
initialization for 'virtblk_dev_page.host_features'):  => 149:3
  + /scratch/kisskb/src/Documentation/mic/mpssd/mpssd.c: error: (near
initialization for 'virtnet_dev_page.host_features'):  => 119:3
  + /scratch/kisskb/src/Documentation/mic/mpssd/mpssd.c: error:
braced-group within expression allowed only inside a function:  =>
146:10, 93:10, 116:10, 96:10, 113:10
  + /scratch/kisskb/src/Documentation/mic/mpssd/mpssd.c: error:
initializer element is not constant:  => 151:3, 119:3, 152:3, 149:3

powerpc-randconfig

On big-endian, the htoleX macros expand to function calls,
which is not compatible with static initialization.

  + /scratch/kisskb/src/Documentation/prctl/disable-tsc-ctxt-sw-stress-test.c:
error: impossible register constraint in 'asm':  => 34:1
  + /scratch/kisskb/src/Documentation/prctl/disable-tsc-on-off-stress-test.c:
error: impossible register constraint in 'asm':  => 36:1
  + /scratch/kisskb/src/Documentation/prctl/disable-tsc-test.c: error:
impossible register constraint in 'asm':  => 36:1

powerpc-randconfig

Embedding x86-specific asm in sample code is not portable.
Building this should probably depend on x86?

> [1] http://kisskb.ellerman.id.au/kisskb/head/8016/ (all 119 configs)
> [3] http://kisskb.ellerman.id.au/kisskb/head/8002/ (all 119 configs)


Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
