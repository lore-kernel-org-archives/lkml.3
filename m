Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752377Ab3HOWWu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 18:22:50 -0400
Received: from iona.labri.fr ([147.210.8.143]:37055 "EHLO iona.labri.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751486Ab3HOWWt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 18:22:49 -0400
Message-ID: <520D54CA.4050001@labri.fr>
Date: Thu, 15 Aug 2013 18:23:06 -0400
From: Martin Peres <martin.peres@labri.fr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130806 Thunderbird/17.0.8
MIME-Version: 1.0
To: =?UTF-8?B?UGFsaSBSb2jDoXI=?= <pali.rohar@gmail.com>
CC: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Ben Skeggs <bskeggs@redhat.com>
Subject: Re: [PATCH] nouveau reclocking on nv40 not working since 77145f1cbdf8d28b46ff8070ca749bad821e0774
References: <23735105.M9MNGeX3Gc@pali> <201308151946.26609@pali>
In-Reply-To: <201308151946.26609@pali>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/08/2013 13:46, Pali Rohár wrote:
> On Tuesday 13 August 2013 11:28:01 Pali Rohár wrote:
>> Hello,
>>
>> in commit 77145f1cbdf8d28b46ff8070ca749bad821e0774 was
>> introduced error which cause that on my Nvidia 6600GT card
>> reclocking not working anymore. There is missing assigment of
>> return value from pll_calc to ret.
>>
>> After this patch reclocking on my card working fine again.
>> Above broken commit was introduced in kernel 3.7, so consider
>> backporting this patch to older kernels too.
>>
>> Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
>>
>> diff --git a/drivers/gpu/drm/nouveau/nv40_pm.c
>> b/drivers/gpu/drm/nouveau/nv40_pm.c index 3af5bcd..625f80d
>> 100644
>> --- a/drivers/gpu/drm/nouveau/nv40_pm.c
>> +++ b/drivers/gpu/drm/nouveau/nv40_pm.c
>> @@ -131,7 +131,7 @@ nv40_calc_pll(struct drm_device *dev, u32
>> reg, struct nvbios_pll *pll, if (clk < pll->vco1.max_freq)
>>   		pll->vco2.max_freq = 0;
>>
>> -	pclk->pll_calc(pclk, pll, clk, &coef);
>> +	ret = pclk->pll_calc(pclk, pll, clk, &coef);
>>   	if (ret == 0)
>>   		return -ERANGE;
> Martin, can you look at another problem with my graphics card?
As I told you before, I'm away from my computers, so I cannot test the 
patch. However,
this one seems quite obvious and should be pushed. Thanks.
