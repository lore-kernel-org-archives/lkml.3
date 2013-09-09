Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752077Ab3IIE2P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 00:28:15 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:46758 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663Ab3IIE2N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 00:28:13 -0400
MIME-Version: 1.0
In-Reply-To: <201309081325.36159@pali>
References: <520DFD9F.1070006@labri.fr>
	<201308190859.32696@pali>
	<CACAvsv5a5JVZa=yFi7zy=zpHtFBCig+K8n-G9LOHN1vnKr94Dg@mail.gmail.com>
	<201309081325.36159@pali>
Date: Mon, 9 Sep 2013 14:28:13 +1000
Message-ID: <CACAvsv6PGZ2J9HMbFvQ5egeaB=z_jVTZpWdFG=muZL1G7An+SQ@mail.gmail.com>
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

On Sun, Sep 8, 2013 at 9:25 PM, Pali Rohár <pali.rohar@gmail.com> wrote:
> On Wednesday 21 August 2013 02:24:01 Ben Skeggs wrote:
>> On Mon, Aug 19, 2013 at 4:59 PM, Pali Rohár
> <pali.rohar@gmail.com> wrote:
>> > On Friday 16 August 2013 14:57:07 Pali Rohár wrote:
>> >> In commit 77145f1cbdf8d28b46ff8070ca749bad821e0774 was
>> >> introduced error which cause that reclocking on nv40 not
>> >> working anymore. There is missing assigment of return value
>> >> from pll_calc to ret.
>> >>
>> >> Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
>> >> Signed-off-by: Martin Peres <martin.peres@labri.fr>
>> >> ---
>> >>
>> >>  drivers/gpu/drm/nouveau/nv40_pm.c |    2 +-
>> >>  1 file changed, 1 insertion(+), 1 deletion(-)
>> >>
>> >> diff --git a/drivers/gpu/drm/nouveau/nv40_pm.c
>> >> b/drivers/gpu/drm/nouveau/nv40_pm.c index 3af5bcd..625f80d
>> >> 100644
>> >> --- a/drivers/gpu/drm/nouveau/nv40_pm.c
>> >> +++ b/drivers/gpu/drm/nouveau/nv40_pm.c
>> >> @@ -131,7 +131,7 @@ nv40_calc_pll(struct drm_device *dev,
>> >> u32 reg, struct nvbios_pll *pll, if (clk <
>> >> pll->vco1.max_freq)
>> >>
>> >>               pll->vco2.max_freq = 0;
>> >>
>> >> -     pclk->pll_calc(pclk, pll, clk, &coef);
>> >> +     ret = pclk->pll_calc(pclk, pll, clk, &coef);
>> >>
>> >>       if (ret == 0)
>> >>
>> >>               return -ERANGE;
>> >
>> > Hello, it is possible to include this patch in 3.11?
>> > Or it is too late now and need to wait for 3.12?
>>
>> I've picked up the patch and will submit it in my next
>> 3.11-fixes pull request.
>>
>> Thanks,
>> Ben.
>>
>
> Hello, now I see that patch is in 3.11, thanks! Ben, what do you
> think, can be this patch backported to older kernels?
Personally, I don't care at all.  The current PM code is a dead end,
and completely not "supported" (hence why it's hidden behind a magic
parameter).  If I had my way it'd have been completely ripped out
already.

If someone wants to backport and test it on earlier kernels though, by
all means, go ahead :)

Thanks,
Ben.

>
> --
> Pali Rohár
> pali.rohar@gmail.com
