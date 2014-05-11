Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758136AbaEKLip (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 07:38:45 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:43008 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757950AbaEKLil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 07:38:41 -0400
MIME-Version: 1.0
In-Reply-To: <536CD6BD.9000804@ti.com>
References: <000001cf643d$69e5e350$3db1a9f0$@samsung.com>
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
	<CAGZ6kuO_N+bZpWa8uQiZUCTWscMbwAd7EL-1dbCJX9JCvFDnyQ@mail.gmail.com>
	<536CD6BD.9000804@ti.com>
Date: Sun, 11 May 2014 04:38:40 -0700
Message-ID: <CAGZ6kuPzpxh-r9-KfPDOGXQXjqcthMV07Nd_dgwvBd7w+F9A+w@mail.gmail.com>
Subject: Re: [PATCH 1/3] PM / OPP: Add support for descending order for
 cpufreq table
From: jonghwan Choi <jhbird.choi@gmail.com>
To: Nishanth Menon <nm@ti.com>
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
        Jonghwan Choi <jhbird.choi@samsung.com>,
        Linux PM list <linux-pm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 9, 2014 at 6:23 AM, Nishanth Menon <nm@ti.com> wrote:
> Have you considered the option of having a clock driver which can
> decide the divider (based on dts OR index or whatever)?
>
> example: you could do clk_set_rate(apll, rate);
> and instead of implementing clock divider programmation inside cpufreq
> driver, you let corresponding clock driver do it for you. that allows
> you to reuse clock driver with various parameters needed for your SoC
> variations. IMHO, we are trying to solve a problem meant to be solved
> in clock framework instead of within cpufreq.


I already considered it.
(But it only passes on  what cpufreq driver has to do to clock framework.
For changing clock rate, if changing operation just divides a rate of
parent it can be solved easily
But exycpufreq driver is  more complicated.

Previously, to change frequency, pll value and clk divider value were
changed in cpufreq driver.
Later someone moved the code which changes pll value to clock framework.
In there, pll values are maintained as table per frequency. And if
frequency is added/removed, values of
pll table should be changed.
when we change the pll value through clk_set_rate, internally  to find
proper pll value,  pll table is searched.
If proper pll value is found, that value is written into the register)

My suggestion is that all these change details should be removed
according to adding/removing frequency.
I believe that cpufreq driver just writes a specific value per
frequency  into the register for dvfs(Maybe other work is also needed)

If we just describe the specific value per frequency in dts file, the
driver will get that information through DT, and use it for DVFS.)
Then when a new chip is  released(if the chip has the same h/w
interface - register map), we only have to do as above.


Thanks

Best Regards
