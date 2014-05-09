Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753298AbaEIGAS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 02:00:18 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:42413 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124AbaEIGAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 02:00:16 -0400
MIME-Version: 1.0
In-Reply-To: <000e01cf6b23$58fda900$0af8fb00$@samsung.com>
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
Date: Fri, 9 May 2014 11:30:15 +0530
Message-ID: <CAKohpomX_ZXSyk7RuCyO1t8VUee5H5KN5zj1-VhDp+ZtFbF-xA@mail.gmail.com>
Subject: Re: [PATCH 1/3] PM / OPP: Add support for descending order for
 cpufreq table
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Jonghwan Choi <jhbird.choi@samsung.com>
Cc: Nishanth Menon <nm@ti.com>, Linux PM list <linux-pm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9 May 2014 06:39, Jonghwan Choi <jhbird.choi@samsung.com> wrote:
> -> In exynos cpufreq driver, if we want to support more frequency, then

Don't add "->" to your replies, it doesn't make it more readable but less.

> we have to describe frequency information in dts file and have to change exynos cpufreq
>  driver file also(For adding divider value).

Why? So, as far as I got it your dividers are nothing but 0,1,2...
i.e.
Freqs: 400  500  600  700  800
div:      4      3      2      1      0

right? That's what you are doing in exynos5440. So just add this in your
probe after doing: dev_pm_opp_init_cpufreq_table

for(i = 0; all-available-freqs; i++)
    dvfs_info->freq_table[i].driver_data = dvfs_info->freq_count - i;

And this will work with changes in dts files.
