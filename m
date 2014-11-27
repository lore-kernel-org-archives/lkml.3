Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751279AbaK0NPx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 08:15:53 -0500
Received: from mout.kundenserver.de ([212.227.126.130]:49963 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946AbaK0NPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 08:15:51 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        kgene.kim@samsung.com, mark.rutland@arm.com, olof@lixom.net,
        catalin.marinas@arm.com, will.deacon@arm.com, tomasz.figa@gmail.com,
        thomas.abraham@linaro.org, linus.walleij@linaro.org,
        kyungmin.park@samsung.com, inki.dae@samsung.com,
        chanho61.park@samsung.com, geunsik.lim@samsung.com,
        sw0312.kim@samsung.com, jh80.chung@samsung.com, a.kesavan@samsung.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 11/19] clk: samsung: exynos5433: Add clocks for CMU_BUS{0|1|2} domains
Date: Thu, 27 Nov 2014 14:15:18 +0100
Message-ID: <2232281.fbydzq3GMs@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <5477200D.5030706@samsung.com>
References: <1417073716-22997-1-git-send-email-cw00.choi@samsung.com> <3556463.Me1EFEY7Zb@wuerfel> <5477200D.5030706@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:3ie9xaov1u+EO5Zl0cBIG5o7SWPdqjmY9/MIAq5+mtY
 oAJxd6yl5aCZQ3zdDoKGNHeCc9iQN74RurUxqES+Yzv9BOBcxU
 HyaKQnPfsFXzxaKXLCB5lVwvySPpDvbedGcZkuJI1/fmDKWcrZ
 pYWTnuKJvBaGmPWm24fBXbR5Yzoptc0yFltJK8bYgLbtTZzmm4
 LPgh2g2lAlcDYXskzeJwkjFL0deccQJCn1qYozE0sLjOAu3ObF
 7VL6jfo4zNYH/JzFl3jWbNIPOAWdcZP9mfUg/Y2SVlYE8LUAZG
 hLBRG0CDJxSEQPMpUfdrfSXSbu3NgvI4bZ6JbIZGxHOhwqVSXS
 VF5ihlOywT9FUWSuUAZ4=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 27 November 2014 21:58:53 Chanwoo Choi wrote:
> Dear Arnd,
> 
> On 11/27/2014 09:35 PM, Arnd Bergmann wrote:
> > On Thursday 27 November 2014 13:12:08 Sylwester Nawrocki wrote:
> >> On 27/11/14 12:56, Chanwoo Choi wrote:
> >>> On 11/27/2014 08:41 PM, Arnd Bergmann wrote:
> >>>>> On Thursday 27 November 2014 16:35:08 Chanwoo Choi wrote:
> >>>>>>> +  - "samsung,exynos5433-cmu-bus0", "samsung,exynos5433-cmu-bus1"
> >>>>>>> +    and "samsung,exynos5433-cmu-bus2" - clock controller compatible for CMU_BUS
> >>>>>>> +    which generates global data buses clock and global peripheral buses clock.
> >>>>>>>  
> >>>>>>>  - reg: physical base address of the controller and length of memory mapped
> >>>>>>>    region.
> >>>>>>>
> >>>>>
> >>>>> This looks like you are duplicating the bindings and the code, but
> >>>>> it's really the same hardware multiple times with minor variations
> >>>>> that you should be able to describe properly here. Why not make
> >>>>> three nodes with the same compatible string and have them handled
> >>>>> by the same code?
> >>>
> >>> Each CMU_BUSx domain of Exynos5433 have different base address as following:
> >>> - CMU_BUS0's base address and range : 0x1360_0000 ~ 0x1360_0b04
> >>> - CMU_BUS1's base address and range : 0x1480_0000 ~ 0x1480_0b04
> >>> - CMU_BUS2's base address and range : 0x1340_0000 ~ 0x1340_0b04
> >>>
> >>> So, I implement CMU_BUSx domain which has each compatible string.
> > 
> > But the base address is in the reg property, not in the compatible
> > property. What I mean is to have multiple nodes like
> 
> The merged clock driver in mainline have different compatible string
> if base addresss of clock domain is different. So, I implemented each CMU_BUSx domain
> with different compatible string.

Why?

> > 	clock-controller@113600000 {
> > 		reg = <0 0x113600000 0 0x1000>;
> > 		compatible = "samsung,exynos5433-cmu";
> > 		#clock-cells = <1>;
> > 	};
> > 
> > 	clock-controller@114800000 {
> > 		reg = <0 0x114800000 0 0x1000>;
> > 		compatible = "samsung,exynos5433-cmu";
> > 		#clock-cells = <1>;
> > 	};
> > 
> > The code will just map the local registers for each instance and then
> > provide the clocks of the right instance when asked for it.
> 
> Each clock domain has not the same mux/divider/clock. So, just one compatible
> string could not support all of clock domains.

What are the specific differences? I saw that one of them has more
outputs than the others but it seemed like a superset, so you just
wouldn't be allowed to access the non-connected outputs.

	Arnd
