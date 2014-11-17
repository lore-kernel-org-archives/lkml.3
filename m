Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471AbaKQXHR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 18:07:17 -0500
Received: from arrakis.dune.hu ([78.24.191.176]:47472 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753106AbaKQXHP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 18:07:15 -0500
MIME-Version: 1.0
In-Reply-To: <CAJiQ=7B6Xwz2iqqH4vEG8WzPOzHj7NHsuGWqq49uy-E34RHp4A@mail.gmail.com>
References: <1416097066-20452-1-git-send-email-cernekee@gmail.com>
 <2911624.UJRs5QOPN5@wuerfel> <CAJiQ=7BH8K=Q+JcWTKSfn6xAteOF4B6jahMu_qVd-FyZWD3pjA@mail.gmail.com>
 <3357597.nYlNZ6O0nJ@wuerfel> <CAJiQ=7B6Xwz2iqqH4vEG8WzPOzHj7NHsuGWqq49uy-E34RHp4A@mail.gmail.com>
From: Jonas Gorski <jogo@openwrt.org>
Date: Tue, 18 Nov 2014 00:06:48 +0100
Message-ID: <CAOiHx=kutuOw4kTukm3FvSS-Fwah_yF2byDQFdpM9YQCn6x93g@mail.gmail.com>
Subject: Re: [PATCH V2 22/22] MIPS: Add multiplatform BMIPS target
To: Kevin Cernekee <cernekee@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Ralf Baechle <ralf@linux-mips.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jon Fraser <jfraser@broadcom.com>, Dmitry Torokhov <dtor@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        Linux MIPS Mailing List <linux-mips@linux-mips.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17, 2014 at 10:21 PM, Kevin Cernekee <cernekee@gmail.com> wrote:
> Currently the bootloader is responsible for decompressing the image.
> On STB the bootloader typically loads a gzipped ELF file; on DSL/CM
> the bootloader unpacks a custom image format containing an
> LZMA-compressed kernel in some form.  So we would be
> double-compressing the same kernel in this scheme.

For the latter I use a patch[1] for mips head.S that detects if
there's a dtb appended to the vmlinux.bin, which would be trivial to
adapt to what the well-defined (b)mips interface expects. Of course
then there is no board detection at all, but I think that's an
acceptable trade off.


Jonas

[1] http://git.openwrt.org/?p=openwrt.git;a=blob;f=target/linux/brcm63xx/patches-3.14/366-MIPS-add-support-for-vmlinux.bin-appended-DTB.patch;h=344e78b5b41e03bff5f3d1f9cce1e8e2cb1a9368;hb=HEAD
