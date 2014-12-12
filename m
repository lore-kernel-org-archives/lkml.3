Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965852AbaLLIWg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 03:22:36 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:57091 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933414AbaLLIWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 03:22:34 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-83-548aa5c7c7c1
Message-id: <548AA5C5.4060204@samsung.com>
Date: Fri, 12 Dec 2014 09:22:29 +0100
From: Andrzej Hajda <a.hajda@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.3.0
MIME-version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Mark Brown <broonie@kernel.org>
Cc: open list <linux-kernel@vger.kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mike Turquette <mturquette@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Inki Dae <inki.dae@samsung.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "moderated list:ARM/CLKDEV SUPPORT" 
	<linux-arm-kernel@lists.infradead.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        "open list:DRM PANEL DRIVERS" <dri-devel@lists.freedesktop.org>,
        "moderated list:ARM/S5P EXYNOS AR..." 
	<linux-samsung-soc@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>
Subject: Re: [RFC 04/15] regulator: add restrack support
References: <1418226513-14105-1-git-send-email-a.hajda@samsung.com>
 <1418226513-14105-5-git-send-email-a.hajda@samsung.com>
 <20141210160720.GS11764@sirena.org.uk> <548976D2.7080005@samsung.com>
 <20141211125837.GV11764@sirena.org.uk>
 <20141211134327.GO11285@n2100.arm.linux.org.uk>
In-reply-to: <20141211134327.GO11285@n2100.arm.linux.org.uk>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAIsWRmVeSWpSXmKPExsVy+t/xq7rHl3aFGNybIWkx9eETNov5R86x
	Wlz5+p7N4tyrRywWB/7sYLRoXryezWLS/QksFhee9rBZfLvSwWQx5c9yJotNj6+xWmye/4fR
	4vKuOWwWM87vY7K4fZnXYu2Ru+wWTydcZLNo3XuE3eLnrnksDsIeLc09bB47Z91l99i0qpPN
	4861PWwe++euYfe4332cyWPzknqPvi2rGD2O39jO5PF5k1wAVxSXTUpqTmZZapG+XQJXxppn
	X9kLLnJWnF02jbWB8TR7FyMnh4SAicSaK++hbDGJC/fWs3UxcnEICSxllDgxZRmU84lR4uPq
	JcwgVbwCWhJNO86C2SwCqhITp18B62YT0JT4u/kmG4gtKhAh8WHVVzaIekGJH5PvsYDYIkDx
	Q0/mgsWZBc6zSayZnQViCwtYSMw+sYgdYtkCJon2k41gRZwCNhKL7rUDNXMANehJ3L+oBdEr
	L7F5zVvmCYwCs5CsmIVQNQtJ1QJG5lWMoqmlyQXFSem5RnrFibnFpXnpesn5uZsYIbH4dQfj
	0mNWhxgFOBiVeHhfpHaFCLEmlhVX5h5ilOBgVhLh/RsFFOJNSaysSi3Kjy8qzUktPsTIxMEp
	1cDo1SL/8rjHqp6eS8crxb9scFobXTjbo1TrW4m9zdXI/7t0LR9/+NLLHSJVIngvRuCOpuKk
	54ZWTpNnhd74+3+5a0jJHye2Zw0KwW1/IxZyLjl5QrA57dGBVWs1bP5Olb549YHV40dL+liO
	TnCwupObdmN16gwRHVOxmYxi61cdrnObF2F7YEawEktxRqKhFnNRcSIAj78xKKMCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/2014 02:43 PM, Russell King - ARM Linux wrote:
> On Thu, Dec 11, 2014 at 12:58:37PM +0000, Mark Brown wrote:
>> I'd expect someone reading the change in the regulator API to have at
>> least some idea how this fits in with the rest of the API and how to use
>> it, and probably more importantly I'd expect to be able to understand
>> why this is DT only.
> 
> Yep.
> 
> This is a repetitive problem, and I fully agree with your concern about
> stuff which is supposed to be arch-independent being designed with only
> DT in mind.
> 
> New core kernel features should *not* be designed with only DT in mind -
> DT is not the only firmware description language which the kernel
> supports.  Folk need to understand that if they design a new arch
> independent kernel feature where the sole use case is with DT, that new
> feature is probably going to get rejected, especially when it's
> something as generic as resource tracking.
> 
> The world is not DT only.
> 

OK. I will post next version of patchset with resource/provider lookup
left to frameworks (regulators, clock, etc), this way it will be fully
firmware agnostic. I will add also better description of the framework.

Regards
Andrzej
