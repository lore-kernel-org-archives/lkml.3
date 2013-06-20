Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935520Ab3FTBs7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 21:48:59 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:56335 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935237Ab3FTBs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 21:48:57 -0400
X-AuditID: cbfee68e-b7f276d000002279-d4-51c25f87472a
Message-id: <51C25F93.9050004@samsung.com>
Date: Thu, 20 Jun 2013 10:49:07 +0900
From: Jaehoon Chung <jh80.chung@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510
 Thunderbird/17.0.6
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
 <CAD=FV=XKeRjpH1+ytjMfLuGGqQ5VVub22n=V+UpV=jBCD4LLHw@mail.gmail.com>
 <001801ce6c20$6ba39900$42eacb00$%jun@samsung.com>
In-reply-to: <001801ce6c20$6ba39900$42eacb00$%jun@samsung.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJIsWRmVeSWpSXmKPExsWyRsSkQLc9/lCgweJ3ahab18VbzNt6lNVi
	++uNbBZnlx1ks7jxq43V4vKuOWwWR/73M1qcuv6ZzWLD3amsFh/uX2S2WLjpEJsDt8fshoss
	Hjtn3WX3OHRlLaPHlRNNrB6TF15k9ujbsorR4/MmuQD2KC6blNSczLLUIn27BK6MN192MxVM
	561YcfUiWwPjRq4uRk4OCQETiW1fLjBC2GISF+6tZ+ti5OIQEljKKHHywSQmmKKTf16xQiSm
	M0rsn7OKCcJ5yShxf8kW5i5GDg5eAS2JL00aIA0sAqoSfX/7WEFsNgEdie3fjoMNEhUIk9jU
	0wxm8woISvyYfI8FpFVEQEPiy/wEkJHMAl+ZJDYu3MwMUiMsEC3xacshdohdP5gl7q1YBXYq
	p4CdxNIlJ8GamQX0JO5f1AIJMwvIS2xe85YZ4uhWDon7T80h7hGQ+Db5EFi5hICsxKYDUCWS
	EgdX3GCZwCg2C8lFsxCGzkIydAEj8ypG0dSC5ILipPQiI73ixNzi0rx0veT83E2MwGg9/e9Z
	3w7GmwesDzEmA22cyCwlmpwPjPa8knhDYzMjC1MTU2Mjc0sz0oSVxHnVWqwDhQTSE0tSs1NT
	C1KL4otKc1KLDzEycXBKNTAGa4XZb+B/qDj5WKDzUenwjz2ZhV074pLTnr7KP3BxOt+6Weqn
	7QVNpf5dkRM/aX/eOinkgn/Jwo1Me5Rnl9fGzoyqeqD477Twtdwd+YzO7Yxqk1Yv5F236fD+
	j3t+PJqWxTOnNKRy2o2Ar/myk9gKo8U/afB41zv97L/fVyvRbvqivPDi7AtKLMUZiYZazEXF
	iQDNoUf77AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOKsWRmVeSWpSXmKPExsVy+t9jQd32+EOBBnNvylpsXhdvMW/rUVaL
	7a83slmcXXaQzeLGrzZWi8u75rBZHPnfz2hx6vpnNosNd6eyWny4f5HZYuGmQ2wO3B6zGy6y
	eOycdZfd49CVtYweV040sXpMXniR2aNvyypGj8+b5ALYoxoYbTJSE1NSixRS85LzUzLz0m2V
	vIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOAjlRSKEvMKQUKBSQWFyvp22GaEBripmsB
	0xih6xsSBNdjZIAGEtYwZrz5spupYDpvxYqrF9kaGDdydTFyckgImEic/POKFcIWk7hwbz1b
	FyMXh5DAdEaJ/XNWMUE4Lxkl7i/ZwtzFyMHBK6Al8aVJA6SBRUBVou9vH1gzm4COxPZvx5lA
	bFGBMIlNPc1gNq+AoMSPyfdYQFpFBDQkvsxPABnJLPCVSWLjws3MIDXCAtESn7YcYofY9YNZ
	4t6KVYwgCU4BO4mlS06CNTML6Encv6gFEmYWkJfYvOYt8wRGgVlIVsxCqJqFpGoBI/MqRtHU
	guSC4qT0XCO94sTc4tK8dL3k/NxNjOBk8Ex6B+OqBotDjAIcjEo8vBqXDwYKsSaWFVfmHmKU
	4GBWEuGdJ3EoUIg3JbGyKrUoP76oNCe1+BBjMjAAJjJLiSbnAxNVXkm8obGJmZGlkbmhhZGx
	OWnCSuK8B1utA4UE0hNLUrNTUwtSi2C2MHFwSjUwLjgdwO4WGPr1AVP9XpP37MW5k9RzJbPq
	gg87z/i+NVP+0e+E/Wvvn7divcR1I3tflskSmVvb7dSqW0p5Mhgc7wa23C8uuZUWGOf8QTFe
	9eh0idM6Ygncq2bcV+Ockd88I2HN2mL7qxw17s8nFzyuamHkOan50+B4b3ZhqffiyxlLGD5t
	qtisxFKckWioxVxUnAgA7JwM2koDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

I tested with Seungwon's patch and this patch.
I'm agreed with Seungwon's opinion.

Best Regards,
Jaehoon Chung

On 06/18/2013 09:36 PM, Seungwon Jeon wrote:
> On Thursday, June 13, 2013, Doug Anderson wrote:
>> Seungwon,
>>
>> On Wed, Apr 10, 2013 at 12:02 AM, Seungwon Jeon <tgih.jun@samsung.com> wrote:
>>>>> There are two solutions we have applied.
>>>>
>>>> I'm a little confused.  Have you already applied one or both of the
>>>> solutions you list below, or are you proposing them as alternates to
>>>> the patch I submitted?
>>> Yes, first one already has been applied.
>>> I wanted to introduce our fix. Did you try to test with these fixes?
>>
>> I'm coming back to this after being quite distracted for a while.
>>
>> I'm a little confused in that you said that your first fix was already
>> applied.  I don't see it anywhere.  Did you mean that you've already
>> applied it locally, or that it's applied in some git tree somewhere?
>> If so, can you point me to it?
>>
>> If this hasn't been sent out anywhere, perhaps you could send out
>> official patches?
> Currently, it has just applied for some projects, not official patch.
>>
>> I don't have the failing unit myself, so we'll have to get Bing to try
>> the patches.  You are suggesting that we try applying both of your
>> patches, right?
> Did you test the patch?
> I wonder that both are good for your side.
> 
> Thanks,
> Seungwon Jeon
>>
>> -Doug
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

