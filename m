Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755AbaEGBAI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 21:00:08 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:45933 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752188AbaEGBAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 21:00:06 -0400
MIME-Version: 1.0
In-Reply-To: <003e01cf6984$fb950280$f2bf0780$@samsung.com>
References: <000001cf643d$69e5e350$3db1a9f0$@samsung.com>
	<CAOh2x=m8DzmLOGqL0E_seOZMuzU=O9vQuu-JEp+E5454RmfEXw@mail.gmail.com>
	<003901cf6664$e4e8d2a0$aeba77e0$@samsung.com>
	<CAKohpon7W726Hxj5OJ6SnmPz3gYhAeBRr1wS3SCa3F2hSLriLQ@mail.gmail.com>
	<5367946F.1030407@ti.com>
	<CAKohpon-KZpSJK7PxpLjZS7sVPcYraDxb4oJHN6dxSagD+F--Q@mail.gmail.com>
	<CAGo_u6pUVeMM9mqe5htvM1X_4pkRGEUVOA2ty4ZPfUyLcLZkrw@mail.gmail.com>
	<CAKohpokfcptseU6ST+e_GfU6poVJxXCXMeoYCvT65060v5GJYQ@mail.gmail.com>
	<003e01cf6984$fb950280$f2bf0780$@samsung.com>
Date: Tue, 6 May 2014 20:00:03 -0500
X-Google-Sender-Auth: LKt70elXBd6EWzr9u1Mm1TNM0-s
Message-ID: <CAGo_u6o0J_T_hnmDAiYpsDxe77iKPCjuWisZJfTjYYOVGJF96A@mail.gmail.com>
Subject: Re: [PATCH 1/3] PM / OPP: Add support for descending order for
 cpufreq table
From: Nishanth Menon <nm@ti.com>
To: Jonghwan Choi <jhbird.choi@samsung.com>
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 6, 2014 at 6:43 PM, Jonghwan Choi <jhbird.choi@samsung.com> wrote:
> Hi

Please dont top post. it is usually frowned upon.

>
> My holiday is finished.
>
> I implemented another cpufreq driver. And that driver also have to use exynos_sort_descend_freq_table().
> Then exynos5440 and new cpufreq have a duplicate function.(exynos_sort_descend_freq_table().
> So I want to solve it.

As discussed in the thread, creating stuff that are common into a
common file, and even isolating this into cpufreq specific solution
might be good.

[1] now moves that entire logic of table creation to be cpufreq
specific - we could consider modifier functions to them.

In some quick tests by reversing table [2], I cant see any difference
in behavior in ascending[3] or descending[4] order of the cpufreq
table.

So, we could do [2] as default as well, if it is determined to impact
no one else making any form of assumptions on table ordering - but it
might be preferable for drivers not to depend on framework ordering of
data as things could change in the future.

[1] https://patchwork.kernel.org/patch/4115141/ +
https://patchwork.kernel.org/patch/4115101/
[2] http://slexy.org/view/s21HyCUhXK
[3] http://slexy.org/view/s202xTUG59
[4] http://slexy.org/view/s20ewFa6PW


Regards,
Nishanth Menon
