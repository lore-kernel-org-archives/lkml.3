Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435AbaEIL7b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 07:59:31 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:36570 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752858AbaEIL73 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 07:59:29 -0400
MIME-Version: 1.0
In-Reply-To: <CAKohpomX_ZXSyk7RuCyO1t8VUee5H5KN5zj1-VhDp+ZtFbF-xA@mail.gmail.com>
References: <000001cf643d$69e5e350$3db1a9f0$@samsung.com>
	<CAOh2x=m8DzmLOGqL0E_seOZMuzU=O9vQuu-JEp+E5454RmfEXw@mail.gmail.com>
	<003901cf6664$e4e8d2a0$aeba77e0$@samsung.com>
	<CAKohpon7W726Hxj5OJ6SnmPz3gYhAeBRr1wS3SCa3F2hSLriLQ@mail.gmail.com>
	<5367946F.1030407@ti.com>
	<CAKohpon-KZpSJK7PxpLjZS7sVPcYraDxb4oJHN6dxSagD+F--Q@mail.gmail.com>
	<CAGo_u6pUVeMM9mqe5htvM1X_4pkRGEUVOA2ty4ZPfUyLcLZkrw@mail.gmail.com>
	<CAKohpokfcptseU6ST+e_GfU6poVJxXCXMeoYCvT65060v5GJYQ@mail.gmail.com>
	<003e01cf6984$fb950280$f2bf0780$@samsung.com>
	<CAGo_u6o0J_T_hnmDAiYpsDxe77iKPCjuWisZJfTjYYOVGJF96A@mail.gmail.com>
	<CAKohpo=qbj9w5=wWHEG=9c2spjbbhaDaXG+F-Lhe9QffV9sDbw@mail.gmail.com>
	<001501cf6a5c$07bc2520$17346f60$@samsung.com>
	<CAGo_u6rAY1Cqh6_1RPsjGMwqNSVr=yW+VgyXfEjA6V+LT-SMcQ@mail.gmail.com>
	<000301cf6a62$413c16b0$c3b44410$@samsung.com>
	<CAKohponiuHYjLve5ywLSGtDPPFN9a54gzZUicn1m702B2Ct3Pw@mail.gmail.com>
	<000e01cf6b23$58fda900$0af8fb00$@samsung.com>
	<CAKohpomX_ZXSyk7RuCyO1t8VUee5H5KN5zj1-VhDp+ZtFbF-xA@mail.gmail.com>
Date: Fri, 9 May 2014 04:59:28 -0700
Message-ID: <CAGZ6kuO_N+bZpWa8uQiZUCTWscMbwAd7EL-1dbCJX9JCvFDnyQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] PM / OPP: Add support for descending order for
 cpufreq table
From: jonghwan Choi <jhbird.choi@gmail.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Jonghwan Choi <jhbird.choi@samsung.com>, Nishanth Menon <nm@ti.com>,
        Linux PM list <linux-pm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 8, 2014 at 11:00 PM, Viresh Kumar <viresh.kumar@linaro.org> wrote:

> Why? So, as far as I got it your dividers are nothing but 0,1,2...
> i.e.
> Freqs: 400  500  600  700  800
> div:      4      3      2      1      0
>
> right? That's what you are doing in exynos5440. So just add this in your
> probe after doing: dev_pm_opp_init_cpufreq_table
>
> for(i = 0; all-available-freqs; i++)
>     dvfs_info->freq_table[i].driver_data = dvfs_info->freq_count - i;
>
> And this will work with changes in dts files.

I am sorry
I couldn’t provide detailed information about this suggestion.
This suggestion is not for exynos5440. This is for exynos4210,
exynos4x12 and exynos5250.
(But this can be applied to exynos5440 also)
I want to make exynos cpufreq driver simple.
There are exynos-cpufreq.c, exynos4210-cpufreq.c exynos4x12-cpufreq.
exynos5250-cpufreq.c for exynos soc.
And exynos4210-cpufreq.c, exynos4x12 and exynos5250-cpufreq. c has a
clk divider table for each frequency.

example) exynos4210-cpufreq.c
static struct apll_freq apll_freq_4210[] = {
        /*
         * values:
         * freq
         * clock divider for CORE, COREM0, COREM1, PERIPH, ATB,
PCLK_DBG, APLL, RESERVED
         * clock divider for COPY, HPM, RESERVED
         * PLL M, P, S
         */
        APLL_FREQ(1200, 0, 3, 7, 3, 4, 1, 7, 0, 5, 0, 0, 150, 3, 1),
        APLL_FREQ(1000, 0, 3, 7, 3, 4, 1, 7, 0, 4, 0, 0, 250, 6, 1),
        APLL_FREQ(800,  0, 3, 7, 3, 3, 1, 7, 0, 3, 0, 0, 200, 6, 1),
        APLL_FREQ(500,  0, 3, 7, 3, 3, 1, 7, 0, 3, 0, 0, 250, 6, 2),
        APLL_FREQ(200,  0, 1, 3, 1, 3, 1, 0, 0, 3, 0, 0, 200, 6, 3),
};

If we can pass this clk divider value to exynos cpufreq driver through
DT, we can remove most of exynosxxxx-cpufreq.c files/codes. And when
new frequency is added/removed or new soc is released, for supporting
dvfs we have only to describe frequency, voltage and divider value in
dts file.

Thanks

Best Regards.
