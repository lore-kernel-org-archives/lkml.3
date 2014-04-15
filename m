Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751052AbaDOVM5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 17:12:57 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48440 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbaDOVMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 17:12:55 -0400
Message-ID: <534DA0D4.4010301@linaro.org>
Date: Tue, 15 Apr 2014 14:12:52 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Ulf Hansson <ulf.hansson@linaro.org>
CC: Peter Maydell <peter.maydell@linaro.org>, Chris Ball <chris@printf.net>,
        Johan Rudholm <jrudholm@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Regression?] qemu-system-arm flooding "sd_write_data: not in
 Receiving-Data state"
References: <534C7D36.9090008@linaro.org> <CAPDyKFp=DikkmXnyHsTJF6W_FpTDJZYiSk9n7Nh+RwY=r=P4-Q@mail.gmail.com>
In-Reply-To: <CAPDyKFp=DikkmXnyHsTJF6W_FpTDJZYiSk9n7Nh+RwY=r=P4-Q@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/15/2014 12:26 AM, Ulf Hansson wrote:
> On 15 April 2014 02:28, John Stultz <john.stultz@linaro.org> wrote:
>> $ qemu-system-arm -version
>> QEMU emulator version 1.5.0 (Debian 1.5.0+dfsg-3ubuntu5.3), Copyright
>> (c) 2003-2008 Fabrice Bellard
>>
>> Booting w/:
>> qemu-system-arm -kernel zImage-arm -M vexpress-a9 -cpu cortex-a9
>> -nographic -m 1024  -append 'root=/dev/mmcblk0p2 rw mem=1024M
>> raid=noautodetect console=ttyAMA0,38400n8 rootwait vmalloc=256MB
>> devtmpfs.mount=0' -sd test-arm.img -redir tcp:4300::22
>>
>> Let me know if you have any other questions or need any other info to
>> help trouble-shoot this.
> I am quite new to the qemu-system-arm model, I will need to spend some
> time with it to be able to help out more.
>
> Though, maybe you can provide me with some information about the qemu
> environment you are using?
>
> 1. Especially, what variant of the ARM primcell pl180 is being
> modelled/used here? The mmci driver handles a handful of different
> variants.

Not totally sure, honestly.

>From dmesg, the mmc related messages are:
mmci-pl18x mb:mmci: mmc0: PL181 manf 41 rev0 at 0x10005000 irq 41,42 (pio)
mmc0: new SDHC card at address 4567
mmcblk0: mmc0:4567 QEMU! 2.00 GiB
mmcblk0: p1 p2 p3 p4 < p5 p6 >


> 2. What type of mmc/sd card is being modelled/used here?

Not sure, other then if the SDHC bit above is enlightening. Is there
some other debug info (from sysfs or something) I can get to you to
answer these better?

I can also provide a .config and point you to similar disk images as I'm
using so you can reproduce if you'd like.

thanks
-john


