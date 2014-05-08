Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752426AbaEHFzg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 01:55:36 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:36037 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043AbaEHFze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 01:55:34 -0400
MIME-Version: 1.0
In-Reply-To: <000301cf6a62$413c16b0$c3b44410$@samsung.com>
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
Date: Thu, 8 May 2014 11:25:34 +0530
Message-ID: <CAKohponiuHYjLve5ywLSGtDPPFN9a54gzZUicn1m702B2Ct3Pw@mail.gmail.com>
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

On 8 May 2014 07:37, Jonghwan Choi <jhbird.choi@samsung.com> wrote:

As asked earlier by Nishanth:

- Avoid top-posting (the practice of putting your answer above the quoted
  text you are responding to).  It makes your response harder to read and
  makes a poor impression.

Reference: Documentation/development-process/2.Process

> I believe that 3 item is required for DVFS. Those are frequency, voltage, divider value.

Not necessarily. People may need a multiplier as well or some other
configuration and so this stuff was left for drivers to implement.

> How about adding that divider value into struct dev_pm_opp like this;

Wouldn't work for all and so NAK.

> struct dev_pm_opp {
>         struct list_head node;
>
>         bool available;
>         unsigned long rate;
>         unsigned long u_volt;
>         unsigned int ctl[2]; // Added
>
>         struct device_opp *dev_opp;
>         struct rcu_head head;
> };

Always paste a diff, its impossible to read this :(

> In my test, it works very wel..

Working isn't enough :)

You don't have a complicated list of dividers, these are simple
values from 0 to total-num-of-freq -1 and that can be handled very
easily in your code.. Please do it there.
