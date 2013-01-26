Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790Ab3AZXxA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 18:53:00 -0500
Received: from mail-ia0-f182.google.com ([209.85.210.182]:48176 "EHLO
	mail-ia0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754367Ab3AZXw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 18:52:58 -0500
MIME-Version: 1.0
In-Reply-To: <201301261717.JGJ04628.OOFVHFLOFJMtSQ@I-love.SAKURA.ne.jp>
References: <201301202124.BFJ81722.SFOHtJFOLQFVOM@I-love.SAKURA.ne.jp>
	<CACRpkdY1sJPkPJx8zFbYOsvHFUM4S_6_eLWjifBpNyqH7cCrDA@mail.gmail.com>
	<201301221817.IDD95831.HVOOFMFJOLFSQt@I-love.SAKURA.ne.jp>
	<CACRpkdYRM9MDt92juV+x9w9BUnHpCSd2KCkZ5F7zwPfhn939ZQ@mail.gmail.com>
	<201301222123.CEJ65174.StJFMOQFVFHOLO@I-love.SAKURA.ne.jp>
	<201301261717.JGJ04628.OOFVHFLOFJMtSQ@I-love.SAKURA.ne.jp>
Date: Sun, 27 Jan 2013 00:52:58 +0100
Message-ID: <CACRpkdZrtBV-TJrywL4OeiuyD61qt0+txjQ51KFcmtWSc9OYXg@mail.gmail.com>
Subject: Re: [3.8-rc4 arm] SCSI_SYM53C8XX_2 module cannot register IRQ
From: Linus Walleij <linus.walleij@linaro.org>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: rob.herring@calxeda.com, grant.likely@secretlab.ca,
        rmk+kernel@arm.linux.org.uk, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 26, 2013 at 9:17 AM, Tetsuo Handa
<penguin-kernel@i-love.sakura.ne.jp> wrote:

> I did a blind git bisection (i.e. starting
>
>   $ qemu-system-arm -M versatilepb -hda hda.img -kernel arch/arm/boot/zImage -append "root=/dev/sda1 init=/bin/sh" -nographic
>
> and watching "top" for %CPU usage of qemu-system-arm , assuming that it goes to
> 100% only if detection of block device for / partition failed and kernel called
> panic(), goes to 0% otherwise) in two patterns.
>
>   $ git bisect start HEAD b1112249 v3.7 v3.6 v3.5 v3.4 v3.3 v3.2 v3.1 v3.0 -- arch/arm drivers/scsi/sym53c8xx_2/ drivers/scsi/*.[ch]
>
>   $ git bisect start v3.8-rc1 95e629b7 b8db6b8 810883f0 b10bca0b 14318efb 414a6750e b1112249 v3.7 v3.6 v3.5 v3.4 v3.3 v3.2 v3.1 v3.0
>
> Both patterns resulted in that commit 07c9249f
> "ARM: 7554/1: VIC: use irq_domain_add_simple()" is the cause of
>
>   PCI: enabling device 0000:00:0c.0 (0100 -> 0103)
>   sym0: <895a> rev 0x0 at pci 0000:00:0c.0 irq 27
>   sym0: No NVRAM, ID 7, Fast-40, LVD, parity checking
>   sym0: request irq 27 failure
>   sym0: giving up ...
>
> message.
>
> Would you have a look?

I'm trying to reproduce this, but how do you reconfigure the kernel to
get PCI, SCSI and such stuff enabled?

The stock versatile_defconfig does not even have SCSI enabled...

Yours,
Linus Walleij
