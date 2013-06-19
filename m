Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756626Ab3FSHn6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 03:43:58 -0400
Received: from mail-bk0-f50.google.com ([209.85.214.50]:34344 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755576Ab3FSHn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 03:43:56 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Tushar Behera <tushar.behera@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        mturquette@linaro.org, kgene.kim@samsung.com, patches@linaro.org,
        swarren@wwwdotorg.org, grant.likely@linaro.org,
        rob.herring@calxeda.com, devicetree-discuss@lists.ozlabs.org,
        broonie@kernel.org, l.majewski@samsung.com, s.nawrocki@samsung.com
Subject: Re: [PATCH 2/2] clk: exynos4: Add alias for cpufreq related clocks
Date: Wed, 19 Jun 2013 09:43:52 +0200
Message-ID: <65316055.UrW2Xpt9hs@flatron>
User-Agent: KMail/4.10.4 (Linux/3.9.6-gentoo; KDE/4.10.4; x86_64; ; )
In-Reply-To: <51C13886.1050201@linaro.org>
References: <1370517749-29892-1-git-send-email-tushar.behera@linaro.org> <51BE95A5.5090509@linaro.org> <51C13886.1050201@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tushar,

On Wednesday 19 of June 2013 10:20:14 Tushar Behera wrote:
> On 06/17/2013 10:20 AM, Tushar Behera wrote:
> > On 06/11/2013 12:23 AM, Tomasz Figa wrote:
> >> On Monday 10 of June 2013 09:13:11 Tushar Behera wrote:
> >>> On 06/08/2013 05:20 PM, Tomasz Figa wrote:
> >>>> On Thursday 06 of June 2013 16:52:28 Tushar Behera wrote:
> > [ ... ]
> > 
> >>>>>  	MUX_A(mout_core, "mout_core", mout_core_p4210,
> >>>>> 
> >>>>> -			SRC_CPU, 16, 1, "mout_core"),
> >>>>> +			SRC_CPU, 16, 1, "moutcore"),
> >>>> 
> >>>> IMHO those typo corrections are not part of this patch.
> >>> 
> >>> But the older drivers (before migration to CCF) were using the clock
> >>> "moutcore" (not "mout_core").
> >> 
> >> I mean, this should be placed in a separate patch, as this change is
> >> not "adding alias for cpufreq related clocks", but rather fixing a
> >> typo.> 
> > Is it ok if I split this patch into 2, one adding clock alias
> > 'mout_apll' and another one fixing the alias names 'mout_mpll',
> > 'moutcore' and 'armclk'?
> 
> I have to fix up another clock for exynos4x12 too. I feel all these
> modifications are too small to justify different patches. I would modify
> the commit message appropriately.

Fine.

> > [ ... ]
> > 
> >>>> Basically I don't like the idea of those global aliases, which IMHO
> >>>> should be completely dropped. Someone might not like it, but I'd go
> >>>> with the conversion of our cpufreq drivers to platform drivers
> >>>> instead, which could receive things like clocks and regulators
> >>>> using
> >>>> DT-based lookups.
> >>> 
> >>> I agree. Migration of exynos-cpufreq driver as a platform driver is
> >>> the
> >>> best solution. But unless someone picks up that work, cpufreq
> >>> support
> >>> for EXYNOS4 based systems is broken because of the incorrect clock
> >>> aliases.
> >> 
> >> We have patches for this in our internal tree. I will clean them up a
> >> bit and submit soon.
> > 
> > If you are going to submit the cpufreq driver patches for v3.11, then
> > we can ignore this patchset. Otherwise, I would prefer to get these
> > patches merged for v3.11 to get cpufreq working. Once the driver
> > changes are incorporated, we can very well modify these later.

I hope we can get my patches merged for 3.11, but just to be safe and have 
things working for now, please proceed with yours.

I need a bit more time for this, because IMHO the current design of our 
cpufreq drivers is inappropriate (directly accessing CMU registers) with 
common clock framework already existing and it needs to be redesigned.

Best regards,
Tomasz

