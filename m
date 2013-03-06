Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752851Ab3CFB5f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 20:57:35 -0500
Received: from mail-lb0-f169.google.com ([209.85.217.169]:58827 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751759Ab3CFB53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 20:57:29 -0500
MIME-Version: 1.0
In-Reply-To: <20130304101142.GJ17833@n2100.arm.linux.org.uk>
References: <1362386358-3556-1-git-send-email-acooks@gmail.com>
	<20130304101142.GJ17833@n2100.arm.linux.org.uk>
Date: Wed, 6 Mar 2013 09:57:27 +0800
Message-ID: <CAJtEV7bGjdJdCsKZ05+FbzoNDeMd2YUh=B=qc=ev_Z2ESg7vPQ@mail.gmail.com>
Subject: Re: [PATCH] check for allocation failure in ioat_dma_self_test
From: Andrew Cooks <acooks@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Dan Williams <djbw@fb.com>, Vinod Koul <vinod.koul@intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 4, 2013 at 6:11 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Mon, Mar 04, 2013 at 04:39:16PM +0800, Andrew Cooks wrote:
>> diff --git a/drivers/dma/ioat/dma.c b/drivers/dma/ioat/dma.c
>> index 1879a59..1f706c4 100644
>> --- a/drivers/dma/ioat/dma.c
>> +++ b/drivers/dma/ioat/dma.c
>> @@ -832,7 +832,18 @@ int ioat_dma_self_test(struct ioatdma_device *device)
>>       }
>>
>>       dma_src = dma_map_single(dev, src, IOAT_TEST_SIZE, DMA_TO_DEVICE);
>> +     err = dma_mapping_error(dev, dma_src);
>> +     if (err) {
>> +             dev_err(dev, "dma mapping failed: -%d\n", err);
>> +             goto free_resources;
>> +     }
>
> NAK.  Please take the time to check what the functions you're using return
> rather than assuming what they return.

I see. The same mistake occurs in a few other drivers. I'll rework and
resend this and if all goes well I'll clean up the others.
