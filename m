Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333AbaEHInN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 04:43:13 -0400
Received: from mail-qc0-f175.google.com ([209.85.216.175]:55169 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753243AbaEHInJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 04:43:09 -0400
MIME-Version: 1.0
In-Reply-To: <20140507144306.GO7438@ldesroches-Latitude-E6320>
References: <1399391006-16007-1-git-send-email-alexandre.belloni@free-electrons.com>
	<20140507144306.GO7438@ldesroches-Latitude-E6320>
Date: Thu, 8 May 2014 10:43:08 +0200
Message-ID: <CAPDyKFr83mB4RWdVAPREDcHjBKKQktbEFKHhDRpPrQioEMtNZw@mail.gmail.com>
Subject: Re: [PATCH] mmc: atmel: don't test host->data
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Ludovic Desroches <ludovic.desroches@atmel.com>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chris Ball <chris@printf.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7 May 2014 16:43, Ludovic Desroches <ludovic.desroches@atmel.com> wrote:
> On Tue, May 06, 2014 at 05:43:26PM +0200, Alexandre Belloni wrote:
>> Found using smatch:
>> drivers/mmc/host/atmel-mci.c:827 atmci_pdc_complete() warn: variable
>> dereferenced before check 'host->data' (see line 807)
>>
>> Stop testing host->data as it is not NULL at that point.
>
> I agree
>
>>
>> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> Acked-by: Ludovic Desroches <ludovic.desroches@atmel.com>
>

Thanks! I pick it up for the PR I send to Chris.

Kind regards
Ulf Hansson

>> ---
>>  drivers/mmc/host/atmel-mci.c | 13 +++----------
>>  1 file changed, 3 insertions(+), 10 deletions(-)
>>
>> diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
>> index 42706ea0ba85..aece7cafbb97 100644
>> --- a/drivers/mmc/host/atmel-mci.c
>> +++ b/drivers/mmc/host/atmel-mci.c
>> @@ -820,16 +820,9 @@ static void atmci_pdc_complete(struct atmel_mci *host)
>>
>>       atmci_pdc_cleanup(host);
>>
>> -     /*
>> -      * If the card was removed, data will be NULL. No point trying
>> -      * to send the stop command or waiting for NBUSY in this case.
>> -      */
>> -     if (host->data) {
>> -             dev_dbg(&host->pdev->dev,
>> -                     "(%s) set pending xfer complete\n", __func__);
>> -             atmci_set_pending(host, EVENT_XFER_COMPLETE);
>> -             tasklet_schedule(&host->tasklet);
>> -     }
>> +     dev_dbg(&host->pdev->dev, "(%s) set pending xfer complete\n", __func__);
>> +     atmci_set_pending(host, EVENT_XFER_COMPLETE);
>> +     tasklet_schedule(&host->tasklet);
>>  }
>>
>>  static void atmci_dma_cleanup(struct atmel_mci *host)
>> --
>> 1.9.1
>>
