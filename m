Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932333Ab3LWRsA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 12:48:00 -0500
Received: from mail-bk0-f42.google.com ([209.85.214.42]:39278 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932310Ab3LWRr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 12:47:58 -0500
MIME-Version: 1.0
In-Reply-To: <1387819238.22671.71.camel@joe-AO722>
References: <1387818706-6129-1-git-send-email-taras.kondratiuk@linaro.org>
	<1387819238.22671.71.camel@joe-AO722>
Date: Mon, 23 Dec 2013 19:47:57 +0200
Message-ID: <CAArO44s4vsLzK9z-ODyKz45TBYt=EGHTvT81Ycnfo=ag0BagTQ@mail.gmail.com>
Subject: Re: [RESEND PATCH v2] mfd: twl6030: Fix endianness problem in IRQ handler
From: Taras Kondratiuk <taras.kondratiuk@linaro.org>
To: Joe Perches <joe@perches.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Patch Tracking <patches@linaro.org>,
        Linaro Networking <linaro-networking@linaro.org>,
        Linaro Kernel <linaro-kernel@lists.linaro.org>,
        Danke Xie <d.xie@sta.samsung.com>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23 December 2013 19:20, Joe Perches <joe@perches.com> wrote:
> On Mon, 2013-12-23 at 19:11 +0200, Taras Kondratiuk wrote:
>> From: Danke Xie <d.xie@sta.samsung.com>
>>
>> The current TWL 6030 IRQ handler assumes little endianness.
>> This change makes it endian-neutral.
> []
>> diff --git a/drivers/mfd/twl6030-irq.c b/drivers/mfd/twl6030-irq.c
> []
>> @@ -196,8 +197,9 @@ static irqreturn_t twl6030_irq_thread(int irq, void *data)
>>       if (sts.bytes[2] & 0x10)
>>               sts.bytes[2] |= 0x08;
>>
>> -     for (i = 0; sts.int_sts; sts.int_sts >>= 1, i++)
>> -             if (sts.int_sts & 0x1) {
>> +     int_sts = le32_to_cpu(sts.int_sts);
>> +     for (i = 0; int_sts; int_sts >>= 1, i++)
>> +             if (int_sts & 0x1) {
>>                       int module_irq =
>>                               irq_find_mapping(pdata->irq_domain,
>>                                                pdata->irq_mapping_tbl[i]);
>
> instead of the
>
>         for (...) {
>                 if (foo & 1) {
>
>
> maybe using ffs would be better/faster
>
>         while ((bit = ffs(int_sts))) {
>
> etc...

Makes sense, but the aim of this patch is to fix endianness issue.
This micro-optimisation can be done as a separate patch.

-- 
Regards,
Taras Kondratiuk
