Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751703AbaGGTCN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 15:02:13 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:43255 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578AbaGGTCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 15:02:10 -0400
MIME-Version: 1.0
In-Reply-To: <CAF1_xX38AWEK5sW8v_RrL=HzAg7JRNyCzgKNuZFzCGV4y2O7Og@mail.gmail.com>
References: <CAF1_xX2oeG0YCLaLZR9ZUY2qiD0-sVB6L10dZppnae7iZV_U3g@mail.gmail.com>
	<53A1A354.7030107@suse.cz>
	<CAF1_xX38AWEK5sW8v_RrL=HzAg7JRNyCzgKNuZFzCGV4y2O7Og@mail.gmail.com>
Date: Mon, 7 Jul 2014 21:02:08 +0200
Message-ID: <CAPVoSvSmzRWSJeR9dyBO0qS6-9SWA_d-CjGuQeULGS_MRUY77w@mail.gmail.com>
Subject: Re: Regression: firmware: Simplify directory creation + b43 = fails
 to build
From: Torsten Kaiser <just.for.lkml@googlemail.com>
To: Ronald <ronald645@gmail.com>
Cc: Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2014 at 6:25 PM, Ronald <ronald645@gmail.com> wrote:
> From my .config
>
>  ==> cat /usr/src/config | grep -i b43
> CONFIG_EXTRA_FIRMWARE="b43/ucode5.fw b43/b0g0initvals5.fw
> b43/b0g0bsinitvals5.fw b43/pcm5.fw"
> ... snip ...

That might be rather later, but I seem to have the same problem:
  CHK     kernel/config_data.h
  MK_FW   firmware/amd-ucode/microcode_amd.bin.gen.S
/bin/sh: firmware/amd-ucode/microcode_amd.bin.gen.S: No such file or directory
/bin/sh: firmware/amd-ucode/microcode_amd.bin.gen.S: No such file or directory
/bin/sh: firmware/amd-ucode/microcode_amd.bin.gen.S: No such file or directory
/bin/sh: firmware/amd-ucode/microcode_amd.bin.gen.S: No such file or directory
/bin/sh: firmware/amd-ucode/microcode_amd.bin.gen.S: No such file or directory
/bin/sh: firmware/amd-ucode/microcode_amd.bin.gen.S: No such file or directory
/bin/sh: firmware/amd-ucode/microcode_amd.bin.gen.S: No such file or directory
/bin/sh: firmware/amd-ucode/microcode_amd.bin.gen.S: No such file or directory
/bin/sh: firmware/amd-ucode/microcode_amd.bin.gen.S: No such file or directory
/bin/sh: firmware/amd-ucode/microcode_amd.bin.gen.S: No such file or directory
/bin/sh: firmware/amd-ucode/microcode_amd.bin.gen.S: No such file or directory
/bin/sh: firmware/amd-ucode/microcode_amd.bin.gen.S: No such file or directory
/bin/sh: firmware/amd-ucode/microcode_amd.bin.gen.S: No such file or directory
/bin/sh: firmware/amd-ucode/microcode_amd.bin.gen.S: No such file or directory
/bin/sh: firmware/amd-ucode/microcode_amd.bin.gen.S: No such file or directory
firmware/Makefile:185: recipe for target
'firmware/amd-ucode/microcode_amd.bin.gen.S' failed
make[1]: *** [firmware/amd-ucode/microcode_amd.bin.gen.S] Error 1
Makefile:896: recipe for target 'firmware' failed
make: *** [firmware] Error 2

The directory firmware/amd-ucode does not exist in the kernel source
tree, but my .config seems to need it:
CONFIG_EXTRA_FIRMWARE="radeon/R700_rlc.bin radeon/RV710_uvd.bin
radeon/RV730_smc.bin amd-ucode/microcode_amd.bin"
CONFIG_EXTRA_FIRMWARE_DIR="/lib/firmware"

Just doing a "mkdir firmware/amd-ucode" lets the build continue and I
get a working 3.16 kernel.

With 3.15 and earlier I never had a problem with this, but 3.16-rc4
just failed with above message.

Do you need my full .config or any other information about my system?
I would be happy to provide that and/or test a patch.

Thanks for looking into this!

Torsten
