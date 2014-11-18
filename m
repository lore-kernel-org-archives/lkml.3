Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995AbaKRKUE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 05:20:04 -0500
Received: from mout.kundenserver.de ([212.227.17.10]:49837 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753265AbaKRKUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 05:20:02 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Kevin Cernekee <cernekee@gmail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jon Fraser <jfraser@broadcom.com>, Dmitry Torokhov <dtor@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        Linux MIPS Mailing List <linux-mips@linux-mips.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jonas Gorski <jonas.gorski@gmail.com>
Subject: Re: [PATCH V2 22/22] MIPS: Add multiplatform BMIPS target
Date: Tue, 18 Nov 2014 11:19:51 +0100
Message-ID: <12543154.MaArN0zy9N@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAJiQ=7B6Xwz2iqqH4vEG8WzPOzHj7NHsuGWqq49uy-E34RHp4A@mail.gmail.com>
References: <1416097066-20452-1-git-send-email-cernekee@gmail.com> <3357597.nYlNZ6O0nJ@wuerfel> <CAJiQ=7B6Xwz2iqqH4vEG8WzPOzHj7NHsuGWqq49uy-E34RHp4A@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:J+GcyzG5e8+IZqaDVFOygOa1NjCOebCZGc92OQUYqGS
 9u905NTZD5ojaaEAOx0NhSGkcaqd3n/sPlM+rFT370Wk/QT9OZ
 G82K9YYxCRqARcUkufnjKTl7KPpLdwJQ372lntNIMJTpLzGLYx
 L5lQ66sBSxhOSZKYNKynygrUac46MWBvyuK5d5eMMxHXAw7RIy
 Ugj9Bn/CeIEHu+MMi5vxW7okxaT5Jwipk7i6TeOL29CqMIGExu
 17dkOFpHcwz67y+XZpNeajuFexopSqytXYCrQq49QgBYgqDYea
 n1rB2rBkLdnLiuQn7wOLpCOUuQEvZzFJOPsSCm9hT0JUdTr+pb
 dKjMsqHkAWTnhJBOQ3xQ=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 17 November 2014 13:21:45 Kevin Cernekee wrote:
> On Mon, Nov 17, 2014 at 12:40 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> >> One possible complication: for BCM63xx/BCM7xxx (MIPS) there is no
> >> decompressor in the kernel.  The firmware loads an ELF image into
> >> memory and jumps directly to kernel_entry.
> >>
> >
> > Right, that complicates it a bit, but is there a reason why a decompressor
> > would be hard to do, or would be considered a bad thing?
> > There is already generic decompressor code in arch/mips/boot/compressed/
> > that I would assume you could use without firmware changes. Are you
> > worried about boot time overhead?
> 
> Currently the bootloader is responsible for decompressing the image.
> On STB the bootloader typically loads a gzipped ELF file; on DSL/CM
> the bootloader unpacks a custom image format containing an
> LZMA-compressed kernel in some form.  So we would be
> double-compressing the same kernel in this scheme.
> 
> STB/DSL should be able to boot the arch/mips/boot/compressed "vmlinuz"
> ELF file; I tested STB.  CM might be questionable, but doesn't need
> decompressor mods because the bootloader is DT-aware.
> 
> Also, the decompressor may need to be modified so that it recognizes /
> passes / doesn't overwrite DTB blobs coming from the bootloader.  And
> to make sure it doesn't stomp on any of the code or data that our
> bootloaders use for their callback mechanisms.
> 
> So, one possibility is to submit a V3 patch which allows 0 or 1 DTB
> files to be compiled in statically (similar to
> CONFIG_ARM_APPENDED_DTB) and requires a DT-aware bootloader or
> decompressor for anything else.  Any opinions?

That sounds like a good approach, in particular with the patch that
Jonas linked to. With that, most or all of your arch/mips/bmips/setup.c
should become completely generic, and I would think the rest can
be handled through a function that is called after looking up the
root "compatible" property in DT.

	Arnd
