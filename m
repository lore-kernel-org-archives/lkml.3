Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751120AbaK0SQR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 13:16:17 -0500
Received: from mail-oi0-f46.google.com ([209.85.218.46]:40694 "EHLO
	mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784AbaK0SQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 13:16:15 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <000d01d00a05$7ffe4970$7ffadc50$@gmail.com>
References: <20141124085059.GA15770@hudson.localdomain> <20141125100703.GA9287@hudson.localdomain> <af603da34acc4caca630ca58eda7eb1e@BN1PR06MB070.namprd06.prod.outlook.com> <20141126200238.GB27014@hudson.localdomain> <000d01d00a05$7ffe4970$7ffadc50$@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: RE: [BUG] [PATCH] next: cyapa: fix inop touchpad after resume on Acer C720
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Date: Thu, 27 Nov 2014 10:16:09 -0800
To: Dudley Du <dudley.dulixin@gmail.com>,
        "'Jeremiah Mahler'" <jmmahler@gmail.com>
CC: linux-kernel@vger.kernel.org, Dudley Du <dudl@cypress.com>
Message-ID: <189CB621-DEBE-4C54-AE62-9441D50C7C55@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On November 26, 2014 9:45:49 PM PST, Dudley Du <dudley.dulixin@gmail.com> wrote:
>Jeremiah,
>
>I didn't make the special patch for the linux-next before, so I don't
>know why
>this patch is there and have issue.

That was the patch we've discussed some times back and you mentioned it was working for you so I applied it to next.

I'll make sure to apply the fixup promptly.

>Based on current code in the linux-next, I made below patch to fix this
>issue.
>Could you please try again with attached patch fix.
>
>Thanks,
>Dudley
>
>> -----Original Message-----
>> From: Jeremiah Mahler [mailto:jmmahler@gmail.com]
>> Sent: 2014?11?27? 4:03
>> To: Dudley Du
>> Cc: linux-kernel@vger.kernel.org
>> Subject: Re: [BUG] [PATCH] next: cyapa: fix inop touchpad after
>resume on Acer
>> C720
>> 
>> Dudley,
>> 
>> On Wed, Nov 26, 2014 at 06:16:00AM +0000, Dudley Du wrote:
>> > More info: I did all testings based on kernel 3.14.0 on Acer C70.
>> >
>> 
>> I am testing with linux-next 3.18-rc6 on an Acer C720.
>> 
>> http://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/
>> 
>> > Thanks,
>> > Dudley
>> >
>> []
>> 
>> --
>> - Jeremiah Mahler
>
>From bb717b1c1525ef6b889f0ef735d920eed9e76e72 Mon Sep 17 00:00:00 2001
>From: Dudley Du <dudley.dulixin@gmail.com>
>Date: Thu, 27 Nov 2014 13:35:09 +0800
>Subject: [PATCH] input: cyapa: fix irq error issue in cyapa_resume
>To: dmitry.torokhov@gmail.com,
>    jmmahler@gmail.com
>Cc: bleung@google.com,
>    linux-input@vger.kernel.org
>
>This patch is aimed to fix the irq error happened on cyapa_resume when
>doing suspend/resume testing.
>The root cause of this issue is that the cyapa->irq has been removed
>but
>still used in the driver.
>
>Signed-off-by: Dudley Du <dudley.dulixin@gmail.com>
>---
> drivers/input/mouse/cyapa.c | 6 +++---
> 1 file changed, 3 insertions(+), 3 deletions(-)
>
>diff --git a/drivers/input/mouse/cyapa.c b/drivers/input/mouse/cyapa.c
>index c84a9eb..caaba7b 100644
>--- a/drivers/input/mouse/cyapa.c
>+++ b/drivers/input/mouse/cyapa.c
>@@ -938,7 +938,7 @@ static int __maybe_unused cyapa_suspend(struct
>device *dev)
> 			 power_mode, error);
> 
> 	if (device_may_wakeup(dev))
>-		cyapa->irq_wake = (enable_irq_wake(cyapa->irq) == 0);
>+		cyapa->irq_wake = (enable_irq_wake(cyapa->client->irq) == 0);
> 
> 	mutex_unlock(&input->mutex);
> 
>@@ -956,7 +956,7 @@ static int __maybe_unused cyapa_resume(struct
>device *dev)
> 	mutex_lock(&input->mutex);
> 
> 	if (device_may_wakeup(dev) && cyapa->irq_wake)
>-		disable_irq_wake(cyapa->irq);
>+		disable_irq_wake(cyapa->client->irq);
> 
> 	power_mode = input->users ? PWR_MODE_FULL_ACTIVE : PWR_MODE_OFF;
> 	error = cyapa_set_power_mode(cyapa, PWR_MODE_FULL_ACTIVE);
>@@ -964,7 +964,7 @@ static int __maybe_unused cyapa_resume(struct
>device *dev)
> 		dev_warn(dev, "resume: set power mode to %d failed: %d\n",
> 			 power_mode, error);
> 
>-	enable_irq(cyapa->irq);
>+	enable_irq(cyapa->client->irq);
> 
> 	mutex_unlock(&input->mutex);
> 

Hi Dudley,
Thanks.

-- 
Dmitry
