Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755294Ab3CTFUE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 01:20:04 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:37293 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475Ab3CTFUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 01:20:02 -0400
MIME-Version: 1.0
In-Reply-To: <20130319153043.23f7d127@redhat.com>
References: <1362739747-4166-1-git-send-email-prabhakar.lad@ti.com> <20130319153043.23f7d127@redhat.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Wed, 20 Mar 2013 10:49:40 +0530
Message-ID: <CA+V-a8sEBLE=9mmhPbkF3f0skEBkJgCKctq=EYiYZxcCPMhbgg@mail.gmail.com>
Subject: Re: [PATCH v2] davinci: vpif: Fix module build for capture and display
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: LMML <linux-media@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Sekhar Nori <nsekhar@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mauro,

On Wed, Mar 20, 2013 at 12:00 AM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> Em Fri,  8 Mar 2013 16:19:07 +0530
> Prabhakar lad <prabhakar.csengg@gmail.com> escreveu:
>
>> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>>
>> export the symbols which are used by two modules vpif_capture and
>> vpif_display.
>>
>> This patch fixes following error:
>> ERROR: "ch_params" [drivers/media/platform/davinci/vpif_display.ko] undefined!
>> ERROR: "vpif_ch_params_count" [drivers/media/platform/davinci/vpif_display.ko] undefined!
>> ERROR: "vpif_base" [drivers/media/platform/davinci/vpif_display.ko] undefined!
>> ERROR: "ch_params" [drivers/media/platform/davinci/vpif_capture.ko] undefined!
>> ERROR: "vpif_ch_params_count" [drivers/media/platform/davinci/vpif_capture.ko] undefined!
>> ERROR: "vpif_base" [drivers/media/platform/davinci/vpif_capture.ko] undefined!
>> make[1]: *** [__modpost] Error 1
>>
>> Reported-by: Sekhar Nori <nsekhar@ti.com>
>> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>> ---
>>  Changes for v2:
>>  1: use EXPORT_SYMBOL_GPL instead of EXPORT_SYMBOL() as pointed by
>>     Sekhar.
>>
>>  drivers/media/platform/davinci/vpif.c |    4 ++++
>>  1 files changed, 4 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/media/platform/davinci/vpif.c b/drivers/media/platform/davinci/vpif.c
>> index 28638a8..42c7eba 100644
>> --- a/drivers/media/platform/davinci/vpif.c
>> +++ b/drivers/media/platform/davinci/vpif.c
>> @@ -44,6 +44,8 @@ static struct resource      *res;
>>  spinlock_t vpif_lock;
>>
>>  void __iomem *vpif_base;
>> +EXPORT_SYMBOL_GPL(vpif_base);
>> +
>>  struct clk *vpif_clk;
>>
>>  /**
>> @@ -220,8 +222,10 @@ const struct vpif_channel_config_params ch_params[] = {
>>               .stdid = V4L2_STD_625_50,
>>       },
>>  };
>> +EXPORT_SYMBOL_GPL(ch_params);
>
> Please don't use simple names like that. It would be very easy that some
> other driver could try to declare the same symbol. Instead, prefix it
> with the driver name (vpif_ch_params).
>
Agreed, I'll respin a new version fixing it.

Cheers,
--Prabhakar

>>
>>  const unsigned int vpif_ch_params_count = ARRAY_SIZE(ch_params);
>> +EXPORT_SYMBOL_GPL(vpif_ch_params_count);
>>
>>  static inline void vpif_wr_bit(u32 reg, u32 bit, u32 val)
>>  {
>
> Regards,
> Mauro
