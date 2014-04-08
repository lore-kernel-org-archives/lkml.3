Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756640AbaDHMIv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 08:08:51 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:35711 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756552AbaDHMIt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 08:08:49 -0400
Message-ID: <5343E6CF.8000409@mm-sol.com>
Date: Tue, 08 Apr 2014 15:08:47 +0300
From: Stanimir Varbanov <svarbanov@mm-sol.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Courtney Cavin <courtney.cavin@sonymobile.com>
CC: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Subject: Re: [PATCH 3/9] crypto: qce: Add dma and sg helpers
References: <1396541886-10966-1-git-send-email-svarbanov@mm-sol.com> <1396541886-10966-4-git-send-email-svarbanov@mm-sol.com> <20140403231525.GE17066@sonymobile.com> <533EAE81.6060109@mm-sol.com> <20140407224256.GG17066@sonymobile.com>
In-Reply-To: <20140407224256.GG17066@sonymobile.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On 04/08/2014 01:42 AM, Courtney Cavin wrote:
> On Fri, Apr 04, 2014 at 03:07:13PM +0200, Stanimir Varbanov wrote:
>>>> diff --git a/drivers/crypto/qce/dma.h b/drivers/crypto/qce/dma.h
>>>> new file mode 100644
>>>> index 000000000000..932b02fd8f25
>>>> --- /dev/null
>>>> +++ b/drivers/crypto/qce/dma.h
>>>> @@ -0,0 +1,57 @@
>>>> +/*
>>>> + * Copyright (c) 2011-2014, The Linux Foundation. All rights reserved.
>>>> + *
>>>> + * This program is free software; you can redistribute it and/or modify
>>>> + * it under the terms of the GNU General Public License version 2 and
>>>> + * only version 2 as published by the Free Software Foundation.
>>>> + *
>>>> + * This program is distributed in the hope that it will be useful,
>>>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>>>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>>>> + * GNU General Public License for more details.
>>>> + */
>>>> +
>>>> +#ifndef _DMA_H_
>>>> +#define _DMA_H_
>>>> +
>>>> +#define QCE_AUTHIV_REGS_CNT		16
>>>> +#define QCE_AUTH_BYTECOUNT_REGS_CNT	4
>>>> +#define QCE_CNTRIV_REGS_CNT		4
>>>> +
>>>> +/* result dump format */
>>>> +struct qce_result_dump {
>>>> +	u32 auth_iv[QCE_AUTHIV_REGS_CNT];
>>>> +	u32 auth_byte_count[QCE_AUTH_BYTECOUNT_REGS_CNT];
>>>> +	u32 encr_cntr_iv[QCE_CNTRIV_REGS_CNT];
>>>> +	u32 status;
>>>> +	u32 status2;
>>>> +};
>>>> +
>>>> +#define QCE_IGNORE_BUF_SZ	(2 * QCE_BAM_BURST_SIZE)
>>>
>>> QCE_BAM_BURST_SIZE is defined in common.h in 6/9.  Either that file
>>> needs to be included from this one, or the definition needs to be moved.
>>
>> I decided to not include any files in driver private headers. Thus I
>> include the private header files in relevant c files in order.
> 
> Actually, that is exactly what I was trying to indicate as undesirable.
> Please modify this so that each individual header file doesn't require
> you to include another file for usage.

OK, queued for version 2.

-- 
regards,
Stan
