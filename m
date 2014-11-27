Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751303AbaK0ODI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 09:03:08 -0500
Received: from mout.kundenserver.de ([212.227.17.24]:58446 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812AbaK0ODG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 09:03:06 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: cw00.choi@samsung.com
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kgene.kim@samsung.com" <kgene.kim@samsung.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "olof@lixom.net" <olof@lixom.net>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "will.deacon@arm.com" <will.deacon@arm.com>,
        "tomasz.figa@gmail.com" <tomasz.figa@gmail.com>,
        "thomas.abraham@linaro.org" <thomas.abraham@linaro.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
        "inki.dae@samsung.com" <inki.dae@samsung.com>,
        "chanho61.park@samsung.com" <chanho61.park@samsung.com>,
        "geunsik.lim@samsung.com" <geunsik.lim@samsung.com>,
        "sw0312.kim@samsung.com" <sw0312.kim@samsung.com>,
        "jh80.chung@samsung.com" <jh80.chung@samsung.com>,
        "a.kesavan@samsung.com" <a.kesavan@samsung.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 11/19] clk: samsung: exynos5433: Add clocks for CMU_BUS{0|1|2} domains
Date: Thu, 27 Nov 2014 15:02:26 +0100
Message-ID: <2120788.f3P3CC6nYQ@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAGTfZH3KmwhJNFdmeWnujbbUbtLf5vSi6i2dbV62DeCtV7n4TQ@mail.gmail.com>
References: <1417073716-22997-1-git-send-email-cw00.choi@samsung.com> <2232281.fbydzq3GMs@wuerfel> <CAGTfZH3KmwhJNFdmeWnujbbUbtLf5vSi6i2dbV62DeCtV7n4TQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
X-Provags-ID: V02:K0:XaQi88cl6R3l6TRcdmx9hI0r/fpOCCVI+lGtwxfDKmd
 Dg6zTJMajKPai0FEMOxRtzXTprJZmBcvKLa7eFb8wjWOEszXJC
 yDpdPrxhgnP7HUJ62FldvAPu4jmI99LUEMx+lu+ns6JWZAJZIi
 KPy9tYtUTvR3ScWqlWYX610cpdGqzB/OIyDxEmkmSK8S+gHE1c
 UMZ7pBYr6vyoxU87YbiVWCFAcWITxIYTDsRToGfyRov7oMOY3x
 f3dhCZkl05vFM9Njfdj2qmcmTZItqMJ8Z8loU5/p5x6vxCn7gc
 NZPFpqahrntmavcBJ4b92j2G6szu4hhWfYhaFt2F9W6SKzsJZh
 chVz/P8RlvVdiLcJIkas=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 27 November 2014 22:41:49 Chanwoo Choi wrote:
> 2014년 11월 27일 목요일, Arnd Bergmann<arnd@arndb.de>님이 작성한 메시지:
> 
> > On Thursday 27 November 2014 21:58:53 Chanwoo Choi wrote:
> > > Dear Arnd,
> > >
> > > On 11/27/2014 09:35 PM, Arnd Bergmann wrote:
> > > > On Thursday 27 November 2014 13:12:08 Sylwester Nawrocki wrote:
> > > >> On 27/11/14 12:56, Chanwoo Choi wrote:
> > > >>> On 11/27/2014 08:41 PM, Arnd Bergmann wrote:
> > > >>>>> On Thursday 27 November 2014 16:35:08 Chanwoo Choi wrote:
> > > >>>>>>> +  - "samsung,exynos5433-cmu-bus0", "samsung,exynos5433-cmu-bus1"
> > > >>>>>>> +    and "samsung,exynos5433-cmu-bus2" - clock controller
> > compatible for CMU_BUS
> > > >>>>>>> +    which generates global data buses clock and global
> > peripheral buses clock.
> > > >>>>>>>
> > > >>>>>>>  - reg: physical base address of the controller and length of
> > memory mapped
> > > >>>>>>>    region.
> > > >>>>>>>
> > > >>>>>
> > > >>>>> This looks like you are duplicating the bindings and the code, but
> > > >>>>> it's really the same hardware multiple times with minor variations
> > > >>>>> that you should be able to describe properly here. Why not make
> > > >>>>> three nodes with the same compatible string and have them handled
> > > >>>>> by the same code?
> > > >>>
> > > >>> Each CMU_BUSx domain of Exynos5433 have different base address as
> > following:
> > > >>> - CMU_BUS0's base address and range : 0x1360_0000 ~ 0x1360_0b04
> > > >>> - CMU_BUS1's base address and range : 0x1480_0000 ~ 0x1480_0b04
> > > >>> - CMU_BUS2's base address and range : 0x1340_0000 ~ 0x1340_0b04
> > > >>>
> > > >>> So, I implement CMU_BUSx domain which has each compatible string.
> > > >
> > > > But the base address is in the reg property, not in the compatible
> > > > property. What I mean is to have multiple nodes like
> > >
> > > The merged clock driver in mainline have different compatible string
> > > if base addresss of clock domain is different. So, I implemented each
> > CMU_BUSx domain
> > > with different compatible string.
> >
> > Why?
> 
> 
> As I explained on below, each clock domain have different clocks.
> So, clocks have unique clock name.
> 
>  If clock driver use only one compatible for various clock domain, clock
> driver have to know the base address of each domain for distinction of
> clock domain. I think It is stong dependency between device and driver.

No, not at all. You can have lots of clock controllers with the same
compatible string defining different instances of the same IP block,
e.g. for compatible="fixed-clock".

> >
> > > >     clock-controller@113600000 {
> > > >             reg = <0 0x113600000 0 0x1000>;
> > > >             compatible = "samsung,exynos5433-cmu";
> > > >             #clock-cells = <1>;
> > > >     };
> > > >
> > > >     clock-controller@114800000 {
> > > >             reg = <0 0x114800000 0 0x1000>;
> > > >             compatible = "samsung,exynos5433-cmu";
> > > >             #clock-cells = <1>;
> > > >     };
> > > >
> > > > The code will just map the local registers for each instance and then
> > > > provide the clocks of the right instance when asked for it.
> > >
> > > Each clock domain has not the same mux/divider/clock. So, just one
> > compatible
> > > string could not support all of clock domains.
> >
> > What are the specific differences?
> 
> 
> 
> > I'm not sure that difference among clock domains because I think it is
> dependent on the opinion of architect of SoC.
> 
> cmu_bus0/1/2 are much similar. Just cmu_bus2 has one more mux/gate clock
> than cmu_bus0/1.

Yes, that's what I mean. You can simply model that extra mux/gate
in the driver, as long as nothing ever tries to access the clock.

	Arnd
