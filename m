Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751801Ab3HUAYD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 20:24:03 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:60444 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471Ab3HUAYB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 20:24:01 -0400
MIME-Version: 1.0
In-Reply-To: <201308190859.32696@pali>
References: <520DFD9F.1070006@labri.fr>
	<1376657827-8105-1-git-send-email-pali.rohar@gmail.com>
	<201308190859.32696@pali>
Date: Wed, 21 Aug 2013 10:24:01 +1000
Message-ID: <CACAvsv5a5JVZa=yFi7zy=zpHtFBCig+K8n-G9LOHN1vnKr94Dg@mail.gmail.com>
Subject: Re: [PATCH] nouveau: fix reclocking on nv40
From: Ben Skeggs <skeggsb@gmail.com>
To: =?ISO-8859-1?Q?Pali_Roh=E1r?= <pali.rohar@gmail.com>
Cc: Ben Skeggs <bskeggs@redhat.com>, Martin Peres <martin.peres@labri.fr>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 19, 2013 at 4:59 PM, Pali Rohár <pali.rohar@gmail.com> wrote:
> On Friday 16 August 2013 14:57:07 Pali Rohár wrote:
>> In commit 77145f1cbdf8d28b46ff8070ca749bad821e0774 was
>> introduced error which cause that reclocking on nv40 not
>> working anymore. There is missing assigment of return value
>> from pll_calc to ret.
>>
>> Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
>> Signed-off-by: Martin Peres <martin.peres@labri.fr>
>> ---
>>  drivers/gpu/drm/nouveau/nv40_pm.c |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/gpu/drm/nouveau/nv40_pm.c
>> b/drivers/gpu/drm/nouveau/nv40_pm.c index 3af5bcd..625f80d
>> 100644
>> --- a/drivers/gpu/drm/nouveau/nv40_pm.c
>> +++ b/drivers/gpu/drm/nouveau/nv40_pm.c
>> @@ -131,7 +131,7 @@ nv40_calc_pll(struct drm_device *dev, u32
>> reg, struct nvbios_pll *pll, if (clk < pll->vco1.max_freq)
>>               pll->vco2.max_freq = 0;
>>
>> -     pclk->pll_calc(pclk, pll, clk, &coef);
>> +     ret = pclk->pll_calc(pclk, pll, clk, &coef);
>>       if (ret == 0)
>>               return -ERANGE;
>
> Hello, it is possible to include this patch in 3.11?
> Or it is too late now and need to wait for 3.12?
I've picked up the patch and will submit it in my next 3.11-fixes pull request.

Thanks,
Ben.

>
> --
> Pali Rohár
> pali.rohar@gmail.com
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
>
