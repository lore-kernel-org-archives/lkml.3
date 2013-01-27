Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756423Ab3A0VV5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 16:21:57 -0500
Received: from mail-ia0-f172.google.com ([209.85.210.172]:61117 "EHLO
	mail-ia0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756278Ab3A0VV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 16:21:56 -0500
MIME-Version: 1.0
In-Reply-To: <201301270916.GAE48437.JQSVFFOHFMtLOO@I-love.SAKURA.ne.jp>
References: <201301221817.IDD95831.HVOOFMFJOLFSQt@I-love.SAKURA.ne.jp>
	<CACRpkdYRM9MDt92juV+x9w9BUnHpCSd2KCkZ5F7zwPfhn939ZQ@mail.gmail.com>
	<201301222123.CEJ65174.StJFMOQFVFHOLO@I-love.SAKURA.ne.jp>
	<201301261717.JGJ04628.OOFVHFLOFJMtSQ@I-love.SAKURA.ne.jp>
	<CACRpkdZrtBV-TJrywL4OeiuyD61qt0+txjQ51KFcmtWSc9OYXg@mail.gmail.com>
	<201301270916.GAE48437.JQSVFFOHFMtLOO@I-love.SAKURA.ne.jp>
Date: Sun, 27 Jan 2013 22:21:55 +0100
Message-ID: <CACRpkdaXHXJo-6Y+15uhsVf9=KDpV8dvEWNsCU+FnGQjxY64PQ@mail.gmail.com>
Subject: Re: [3.8-rc4 arm] SCSI_SYM53C8XX_2 module cannot register IRQ
From: Linus Walleij <linus.walleij@linaro.org>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: rob.herring@calxeda.com, grant.likely@secretlab.ca,
        rmk+kernel@arm.linux.org.uk, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 27, 2013 at 1:16 AM, Tetsuo Handa
<penguin-kernel@i-love.sakura.ne.jp> wrote:
> Linus Walleij wrote:
>> I'm trying to reproduce this, but how do you reconfigure the kernel to
>> get PCI, SCSI and such stuff enabled?
>>
>> The stock versatile_defconfig does not even have SCSI enabled...
>
> I'm using a customized config for qemu. I've just updated the config to
> http://I-love.SAKURA.ne.jp/tmp/config-3.8-rc1-arm .

Hm when I try this on the v3.7 I get this:

PCI: enabling device 0000:00:0d.0 (0100 -> 0102)
sym0: <895a> rev 0x0 at pci 0000:00:0d.0 irq 28
sym0: No NVRAM, ID 7, Fast-40, LVD, parity checking
sym0: SCSI BUS has been reset.

So IRQ 28 instead of 27???

Then the device does not work (no clue why it's like that)
but it's trying IRQ 28 atleast.

On v3.8-rc5 I get this:

PCI: enabling device 0000:00:0d.0 (0100 -> 0103)
sym0: <895a> rev 0x0 at pci 0000:00:0d.0 irq 28
sym0: No NVRAM, ID 7, Fast-40, LVD, parity checking
sym0: request irq 28 failure
sym0: giving up ...

OK, so half-guessing I've reproduced part of the problem
atleast...

Yours,
Linus Walleij
