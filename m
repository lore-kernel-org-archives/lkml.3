Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932724AbaEEOOu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 10:14:50 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:41319 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932538AbaEEOOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 10:14:48 -0400
MIME-Version: 1.0
In-Reply-To: <5367946F.1030407@ti.com>
References: <000001cf643d$69e5e350$3db1a9f0$@samsung.com>
	<CAOh2x=m8DzmLOGqL0E_seOZMuzU=O9vQuu-JEp+E5454RmfEXw@mail.gmail.com>
	<003901cf6664$e4e8d2a0$aeba77e0$@samsung.com>
	<CAKohpon7W726Hxj5OJ6SnmPz3gYhAeBRr1wS3SCa3F2hSLriLQ@mail.gmail.com>
	<5367946F.1030407@ti.com>
Date: Mon, 5 May 2014 19:44:48 +0530
Message-ID: <CAKohpon-KZpSJK7PxpLjZS7sVPcYraDxb4oJHN6dxSagD+F--Q@mail.gmail.com>
Subject: Re: [PATCH 1/3] PM / OPP: Add support for descending order for
 cpufreq table
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Nishanth Menon <nm@ti.com>
Cc: Jonghwan Choi <jhbird.choi@samsung.com>,
        Linux PM list <linux-pm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5 May 2014 19:08, Nishanth Menon <nm@ti.com> wrote:
> With the brief history of the patch in linux-pm, I am unable to
> understand why not just use ceil/floor routines to pick up data the
> way you need it. It should not matter if we use an ordered list, or
> some other weird organization inside the storage. There are already
> accessors functions meant to precisely help with the case that is
> being tried here.

To be precise, for exynos they need the position of a frequency when
it is arranged in descending order. And they will simply write this position
in their clock controller later. For example, if frequencies are:
100 MHz, 200, 300, 400, 500, 600

Then they need to write 1 for 600, 2 for 500, 3 for 400, and so on..
I am not able to imaging how ceil/floor would help here.
