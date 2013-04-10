Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936773Ab3DJIwT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 04:52:19 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:62939 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936532Ab3DJIvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 04:51:55 -0400
X-AuditID: cbfee690-b7f656d0000007e3-ad-51652829f5f9
Message-id: <51652828.10907@samsung.com>
Date: Wed, 10 Apr 2013 17:51:52 +0900
From: Jaehoon Chung <jh80.chung@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308
 Thunderbird/17.0.4
MIME-version: 1.0
To: Seungwon Jeon <tgih.jun@samsung.com>
Cc: "'Doug Anderson'" <dianders@chromium.org>,
        "'Jaehoon Chung'" <jh80.chung@samsung.com>,
        "'Chris Ball'" <cjb@laptop.org>,
        "'Will Newton'" <will.newton@gmail.com>,
        "'Bing Zhao'" <bzhao@marvell.com>,
        "'Ashok Nagarajan'" <asnagarajan@chromium.org>,
        "'Paul Stewart'" <pstew@chromium.org>,
        "'Olof Johansson'" <olof@lixom.net>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] RFC: mmc: dw_mmc: Always go to STATE_DATA_BUSY from
 STATE_DATA_ERROR
References: <1363382956-14557-1-git-send-email-dianders@chromium.org>
 <5146EAB0.1030705@samsung.com>
 <CAD=FV=Ww-iK=-vg4jnJe6w4836-yQUoUyxNvCYsDQ5w0q-OMMQ@mail.gmail.com>
 <515E88E3.5070507@samsung.com>
 <003401ce3453$19d1e8c0$4d75ba40$%jun@samsung.com>
 <CAD=FV=V+ZZ0MUtuWKUOgR9NPyAquUjFC6KtHvAP-4iHXAYpjqA@mail.gmail.com>
 <001601ce35b9$652c5870$2f850950$%jun@samsung.com>
In-reply-to: <001601ce35b9$652c5870$2f850950$%jun@samsung.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJIsWRmVeSWpSXmKPExsWyRsSkQFdTIzXQ4EuvsMXmdfEW87YeZbXY
	/nojm8XZZQfZLG78amO1uLxrDpvFkf/9jBanrn9ms9hwdyqrxYf7F5ktFm46xObA7TG74SKL
	x85Zd9k9Dl1Zy+hx5UQTq8fkhReZPfq2rGL0+LxJLoA9issmJTUnsyy1SN8ugStjWv8TxoJ5
	GhV3GxayNzAele1i5OSQEDCRWHztODOELSZx4d56ti5GLg4hgaWMEq3bWti7GDnAiu51+UPE
	FzFKPDsCEgdxXjJKHJr5hgWkm1dAQ2LT07Ngk1gEVCWmbp8AFmcT0JHY/u04E4gtKhAmsWl6
	HytEvaDEj8n3WEAWiAD1fpmfADKTWeArk8TGhZvB5ggLREt82nIIatlfJom2k9vYQBo4Bewk
	dnzKBzGZBfQk7l/UAilnFpCX2LzmLTNIuYRAI4fEuhXzWSDuEZD4NvkQC8QzshKbDkA9LClx
	cMUNlgmMYrOQXDQLYeosJFMXMDKvYhRNLUguKE5KLzLRK07MLS7NS9dLzs/dxAiM1tP/nk3Y
	wXjvgPUhxmSgjROZpUST84HRnlcSb2hsZmRhamJqbGRuaUaasJI4r3qLdaCQQHpiSWp2ampB
	alF8UWlOavEhRiYOTqkGRmbedZdm98+5tLfy8t73R9uYL6//w8PksvPu3YPn59fPtZF8evib
	+VV1X6NGpjMTGi/mup9Wv25xVn7y+ayFcVMt6uO3Nx17biraU7Nk+szI7VkfTrf2Mf849Oj3
	p+rDa5qZnNx1j21rKM21rZxhkBSZGb+uZfVJB9eVwZFPrjGI8d9ccM5s+mclluKMREMt5qLi
	RACMCm6d7AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGKsWRmVeSWpSXmKPExsVy+t9jAV1NjdRAgytdXBab18VbzNt6lNVi
	++uNbBZnlx1ks7jxq43V4vKuOWwWR/73M1qcuv6ZzWLD3amsFh/uX2S2WLjpEJsDt8fshoss
	Hjtn3WX3OHRlLaPHlRNNrB6TF15k9ujbsorR4/MmuQD2qAZGm4zUxJTUIoXUvOT8lMy8dFsl
	7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zBygI5UUyhJzSoFCAYnFxUr6dpgmhIa46VrA
	NEbo+oYEwfUYGaCBhDWMGdP6nzAWzNOouNuwkL2B8ahsFyMHh4SAicS9Lv8uRk4gU0ziwr31
	bF2MXBxCAosYJZ4daWGHcF4yShya+YYFpIpXQENi09OzzCA2i4CqxNTtE8DibAI6Etu/HWcC
	sUUFwiQ2Te9jhagXlPgx+R4LyDIRoN4v8xNAZjILfGWS2LhwM9gcYYFoiU9bDkEt+8sk0XZy
	GxtIA6eAncSOT/kgJrOAnsT9i1og5cwC8hKb17xlnsAoMAvJhlkIVbOQVC1gZF7FKJpakFxQ
	nJSea6RXnJhbXJqXrpecn7uJEZwKnknvYFzVYHGIUYCDUYmHd4FhSqAQa2JZcWXuIUYJDmYl
	Ed5m1dRAId6UxMqq1KL8+KLSnNTiQ4zJQP9PZJYSTc4Hpqm8knhDYxMzI0sjc0MLI2Nz0oSV
	xHkPtloHCgmkJ5akZqemFqQWwWxh4uCUamBc3Nd69Xtvs6G6a+Q+xpITrzZevCUe36X61OJo
	48EHS9c2X2BbOm/v8Xv1gvE6RV8KLi1yzvfLza1zMJkrtO3Wg+7WLWfmnlX/UBF0Y8r6zTP2
	7Jt6JvfW2Tn7e36sMrbfPYE5q/SJ2wVRlY3mcm//P2q8H/mndfHDnsOKS2XTksU4H12ovzjp
	ihJLcUaioRZzUXEiAIbTU0BJAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10/2013 04:02 PM, Seungwon Jeon wrote:
> On Tuesday, April 09, 2013, Doug Anderson wrote:
>> Seungwon,
>>
>> On Mon, Apr 8, 2013 at 5:17 AM, Seungwon Jeon <tgih.jun@samsung.com> wrote:
>>> I guess Doug are debugging it with wifi, right?
>>
>> Yes, we're debugging it on the Samsung ARM Chromebook on a part that
>> has an SDIO WiFi module by Marvell.  Bing Zhao (CCed) has a unit in
>> hand that generates lots of CRC errors and has been testing patches
>> I've sent him.
>>
>>
>>> The problem happens when dw_mci_stop_dma is called in the middle of data transfers.
>>> If data error occurs in the end of block, EVENT_XFER_COMPLETE might be set. So, it's fine.
>>> Actually, dw_mci_idmac_stop_dma stops the dma working, there is no further interrupt for dma
>> completion.
>>
>> That sounds right to me.
>>
>>
>>> There are two solutions we have applied.
>>
>> I'm a little confused.  Have you already applied one or both of the
>> solutions you list below, or are you proposing them as alternates to
>> the patch I submitted?
> Yes, first one already has been applied.
> I wanted to introduce our fix. Did you try to test with these fixes?
Actually i have tested with Seungwon's fixes. It looks good.

> 
>>
>>> #1. deferring the call of dw_mci_stop_dma until EVENT_XFER_COMPLETE flag is set into pending_events.
>>> In this case, dma transfer will be continued with error.
>>>
>>> @@ -1062,7 +1062,6 @@ static void dw_mci_tasklet_func(unsigned long priv)
>>>                 case STATE_SENDING_DATA:
>>>                         if (test_and_clear_bit(EVENT_DATA_ERROR,
>>>                                                &host->pending_events)) {
>>> -                               dw_mci_stop_dma(host);
>>>                                 if (data->stop)
>>>                                         send_stop_cmd(host, data);
>>>                                 state = STATE_DATA_ERROR;
>>> @@ -1155,6 +1154,9 @@ static void dw_mci_tasklet_func(unsigned long priv)
>>>                                                 &host->pending_events))
>>>                                 break;
>>>
>>> +                       dw_mci_stop_dma(host);
>>> +                       set_bit(EVENT_XFER_COMPLETE, &host->completed_events);
>>> +
>>>                         state = STATE_DATA_BUSY;
>>>                         break;
>>
>> I can't say that I'm quite familiar enough with the intricate details
>> of the driver to know whether this is a good idea or guaranteed to
>> work.  Do we really think that we'll still get the end of the transfer
>> properly if we've seen an error already?  I worry that we won't.
> For example, let's pretend data CRC error occurs during data read.
> Peer device doesn't know that error occurrence and data transmission still keeps going.
> dma will run as long as host doesn't take the stop or see the end of descriptor.
>>
>>
>>> #2. set EVENT_XFER_COMPLETE flag when dw_mci_stop_dma is called regardless using_dma.
>>>
>>> @@ -299,10 +299,9 @@ static void dw_mci_stop_dma(struct dw_mci *host)
>>>         if (host->using_dma) {
>>>                 host->dma_ops->stop(host);
>>>                 host->dma_ops->cleanup(host);
>>> -       } else {
>>> -               /* Data transfer was stopped by the interrupt handler */
>>> -               set_bit(EVENT_XFER_COMPLETE, &host->pending_events);
>>>         }
>>> +
>>> +       set_bit(EVENT_XFER_COMPLETE, &host->pending_events);
>>>  }
>>
>> This is fairly similar to my patch but goes further.  I believe my
>> patch has this effect but only for the call to dw_mci_stop_dma() in
>> STATE_SENDING_DATA in the tasklet.  Your affects all 3 calls to
>> dw_mci_stop_dma().
I think we can also use the second approach.
but i think that it also needs to test with this.
>>
>> This seems reasonable but I don't have confidence in my understanding
>> of this driver's state machine (especially with regards to the error
>> conditions) that I can say which is better.  If you think that this is
>> a more correct solution than mine then we can give it some testing.
> Yes. As a result, both patches prevent tasklet's hanging.
> In that regard, two patches give the similar effect.
> But I think your fix are just removing the test_bit to wait for EVENT_XFER_COMPLETE.
> 'clear_bit(...) part which is added might be of no effect.
> It doesn't make sense a bit.
> 
> <quotation>
>  		case STATE_DATA_ERROR:
> -			if (!test_and_clear_bit(EVENT_XFER_COMPLETE,
> -						&host->pending_events))
> -				break;
> -
> +			clear_bit(EVENT_XFER_COMPLETE, &host->pending_events);
> </quotation>
> 
> Thanks,
> Seugwon Jeon
>>
>> Thanks!
>>
>> -Doug
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

