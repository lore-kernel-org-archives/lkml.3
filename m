Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751697AbaCFHCq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 02:02:46 -0500
Received: from mail-ie0-f173.google.com ([209.85.223.173]:52907 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810AbaCFHCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 02:02:44 -0500
MIME-Version: 1.0
In-Reply-To: <20140305100405.GG1883@distanz.ch>
References: <1673333.LFj7fBDsDS@daeseok-laptop.cloud.net>
	<20140305100405.GG1883@distanz.ch>
Date: Thu, 6 Mar 2014 16:02:44 +0900
Message-ID: <CAHb8M2CN76KQ_a1fr_uw_qk+TDh3Lp7esn+MT6E4EA-27p+gJg@mail.gmail.com>
Subject: Re: [PATCH] staging: cxt1e1: use kzalloc instead of kmalloc/memset 0
From: DaeSeok Youn <daeseok.youn@gmail.com>
To: Tobias Klauser <tklauser@distanz.ch>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        "sachin.kamat" <sachin.kamat@linaro.org>,
        devel <devel@driverdev.osuosl.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Dulshani Gunawardhana <dulshani.gunawardhana89@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for review.

OK. I will try to change all of OS_kmalloc to kmalloc/kzalloc.
And I also check GFP_DMA flag in kmalloc/kzalloc.

Regards,
Daeseok Youn

2014-03-05 19:04 GMT+09:00 Tobias Klauser <tklauser@distanz.ch>:
> On 2014-03-05 at 03:37:15 +0100, Daeseok Youn <daeseok.youn@gmail.com> wrote:
>>
>> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
>> ---
>>  drivers/staging/cxt1e1/sbecom_inline_linux.h |    6 ++----
>>  1 files changed, 2 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/staging/cxt1e1/sbecom_inline_linux.h b/drivers/staging/cxt1e1/sbecom_inline_linux.h
>> index ba3ff3e..6dd1b55 100644
>> --- a/drivers/staging/cxt1e1/sbecom_inline_linux.h
>> +++ b/drivers/staging/cxt1e1/sbecom_inline_linux.h
>> @@ -46,11 +46,9 @@ void        pci_write_32 (u_int32_t *p, u_int32_t v);
>>  static inline void *
>>  OS_kmalloc (size_t size)
>>  {
>> -    char       *ptr = kmalloc (size, GFP_KERNEL | GFP_DMA);
>> +     char *ptr = kzalloc(size, GFP_KERNEL | GFP_DMA);
>>
>> -    if (ptr)
>> -        memset (ptr, 0, size);
>> -    return ptr;
>> +     return ptr;
>>  }
>
> It would probably be even better to get rid of this function altogether
> and replace all calls to it by kmalloc/kzalloc.
>
> From a quick look at the users of OS_kmalloc, it also looks like GFP_DMA
> isn't needed for all of them.
>
> Cheers
> Tobias
