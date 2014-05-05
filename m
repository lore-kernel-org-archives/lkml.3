Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933025AbaEEOq5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 10:46:57 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:63674 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932770AbaEEOqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 10:46:55 -0400
MIME-Version: 1.0
In-Reply-To: <CAKohpokfcptseU6ST+e_GfU6poVJxXCXMeoYCvT65060v5GJYQ@mail.gmail.com>
References: <000001cf643d$69e5e350$3db1a9f0$@samsung.com>
	<CAOh2x=m8DzmLOGqL0E_seOZMuzU=O9vQuu-JEp+E5454RmfEXw@mail.gmail.com>
	<003901cf6664$e4e8d2a0$aeba77e0$@samsung.com>
	<CAKohpon7W726Hxj5OJ6SnmPz3gYhAeBRr1wS3SCa3F2hSLriLQ@mail.gmail.com>
	<5367946F.1030407@ti.com>
	<CAKohpon-KZpSJK7PxpLjZS7sVPcYraDxb4oJHN6dxSagD+F--Q@mail.gmail.com>
	<CAGo_u6pUVeMM9mqe5htvM1X_4pkRGEUVOA2ty4ZPfUyLcLZkrw@mail.gmail.com>
	<CAKohpokfcptseU6ST+e_GfU6poVJxXCXMeoYCvT65060v5GJYQ@mail.gmail.com>
Date: Mon, 5 May 2014 09:46:54 -0500
X-Google-Sender-Auth: Y_chQqAXgaY7krSRvhzTyfdTXSs
Message-ID: <CAGo_u6p1xLe7cPnCNKe3WixhAY6tmX=-a7CQes9nsV81SpTEvw@mail.gmail.com>
Subject: Re: [PATCH 1/3] PM / OPP: Add support for descending order for
 cpufreq table
From: Nishanth Menon <nm@ti.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
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

On Mon, May 5, 2014 at 9:38 AM, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> On 5 May 2014 19:53, Nishanth Menon <nm@ti.com> wrote:
>> ceil and floor allows us to walk down the opp entries the direction we
>> want it to.
>> one can convert that data any way one wants it - especially when custom
>> mapping such as this is desired.
>
> Yeah, but doing that for every frequency transition is not right.
> Otherwise they already have a solution, where they reverse order
> of frequencies for their driver. exynos_sort_descend_freq_table().
>
> Probably that's a better solution then :)
Such a map should probably be done at probe, unless we have strong
reasons why not to.

>
> But, Jonghwan was probably trying to get this solved in the framework
> only, in case anybody else needs it.
>
Lets keep things simple for the time being. ideally users of a
framework should not depend on internal organization of data.

Regards,
Nishanth Menon
