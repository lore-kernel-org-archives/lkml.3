Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933976Ab3CHJ1N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 04:27:13 -0500
Received: from mail-we0-f170.google.com ([74.125.82.170]:64211 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933331Ab3CHJ1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 04:27:11 -0500
MIME-Version: 1.0
In-Reply-To: <5139ADF5.2050307@ti.com>
References: <1362640461-29106-1-git-send-email-prabhakar.lad@ti.com> <5139ADF5.2050307@ti.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Fri, 8 Mar 2013 14:56:49 +0530
Message-ID: <CA+V-a8tVKcnCN4eRC8MfUqdEv-p+h=7MKYN==JYQZ7MM-TGQ3Q@mail.gmail.com>
Subject: Re: [PATCH] davinci: vpif: Fix module build for capture and display
To: Sekhar Nori <nsekhar@ti.com>
Cc: LMML <linux-media@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sekhar,

On Fri, Mar 8, 2013 at 2:53 PM, Sekhar Nori <nsekhar@ti.com> wrote:
> Hi Prabhakar,
>
> On 3/7/2013 12:44 PM, Prabhakar lad wrote:
>> From: Lad, Prabhakar <prabhakar.lad@ti.com>
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
>> Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
>> ---
>>  drivers/media/platform/davinci/vpif.c |    4 ++++
>>  1 files changed, 4 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/media/platform/davinci/vpif.c b/drivers/media/platform/davinci/vpif.c
>> index 28638a8..8fbb4a2 100644
>> --- a/drivers/media/platform/davinci/vpif.c
>> +++ b/drivers/media/platform/davinci/vpif.c
>> @@ -44,6 +44,8 @@ static struct resource      *res;
>>  spinlock_t vpif_lock;
>>
>>  void __iomem *vpif_base;
>> +EXPORT_SYMBOL(vpif_base);
>
> Should be EXPORT_SYMBOL_GPL() as nothing except GPL code would be
> needing this internal symbol.
>
> Also exporting this shows that the driver is written for only one
> instance. It seems to me that the driver modules can use much better
> abstractions so all these exports wont be needed but having broken
> module build is bad as well.
>
OK as of now I'll go with EXPORT_SYMBOL_GPL() and revisit this at later
point of time.

Regards,
--Prabhakar

> Thanks,
> Sekhar
