Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751834AbaLOI24 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 03:28:56 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:59855 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966AbaLOI2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 03:28:53 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-77-548e9bc262a1
Message-id: <548E9BB9.806@samsung.com>
Date: Mon, 15 Dec 2014 09:28:41 +0100
From: Andrzej Hajda <a.hajda@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.3.0
MIME-version: 1.0
To: Mark Brown <broonie@kernel.org>
Cc: open list <linux-kernel@vger.kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mike Turquette <mturquette@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
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
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        boris.brezillon@free-electrons.com
Subject: Re: [RFC 02/15] drivers/base: add restrack framework
References: <1418226513-14105-1-git-send-email-a.hajda@samsung.com>
 <1418226513-14105-3-git-send-email-a.hajda@samsung.com>
 <20141212165230.GP11764@sirena.org.uk>
In-reply-to: <20141212165230.GP11764@sirena.org.uk>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJIsWRmVeSWpSXmKPExsVy+t/xy7qHZveFGJzrNbU48GIhi8XUh0/Y
	LOYfOcdqceXrezaLc68esVgc+LOD0aJ58Xo2i0n3J7BYXHjaw2bx7UoHk8WUP8uZLDY9vsZq
	sXn+H0aLy7vmsFnMOL+PyeL2ZV6LtUfusls8nXCRzaJ17xF2i5+75rE4iHi0NPeweTzZdJHR
	Y+esu+wem1Z1snncubaHzWP/3DXsHve7jzN5bF5S79G3ZRWjx/Eb25k8Pm+SC+CO4rJJSc3J
	LEst0rdL4MpomdnOWNDAX/Hh5lW2BsY/3F2MnBwSAiYSB089ZYewxSQu3FvP1sXIxSEksJRR
	Ys73zUwQzidGif+rrzCDVPEKqEnM+XIVKMHBwSKgKvFmZQpImE1AU+Lv5ptsILaoQITEh1Vf
	2SDKBSV+TL7HAmKLCChLXP2+F8xmFpjDLrF5lzmILSxgKzGj4yULxK5ljBJ/tjWB7eIUMJbY
	umQzC8guZgE9ifsXtSB65SU2r3nLPIFRYBaSFbMQqmYhqVrAyLyKUTS1NLmgOCk910ivODG3
	uDQvXS85P3cTIyQ6v+5gXHrM6hCjAAejEg/vj8TeECHWxLLiytxDjBIczEoivN3xfSFCvCmJ
	lVWpRfnxRaU5qcWHGJk4OKUaGNMkup1mLRWKtEoQ3HS8+tE5t8VV6ffm35aa2rn5YD/DN8YX
	Nku2OOy76rmpZfnnw5N7tf4dWHfqjlnl7AssanO36zXLxfB47t1msLtjd9HJiw69oVo9Ob46
	f9hn5P2V/X3ENuy5/SX1QzOTUnaZrBXdxsS0afPKZnmplmDdTLsjT1xrV+v9fqTEUpyRaKjF
	XFScCAAb4hBXrAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2014 05:52 PM, Mark Brown wrote:
> On Wed, Dec 10, 2014 at 04:48:20PM +0100, Andrzej Hajda wrote:
>> restrack framework allows tracking presence of resources with dynamic life
>> time. Typical example of such resources are all resources provided by device
> I don't know about anyone else but I'm having a hard time reading the
> restrack name, it looks like a misspelling of restack to me.

Any alternative names?

>
> At a high level my biggest questions here are the relationship between
> this and the component code and usability.  The usability concern I have
> is that I see no diagnostics or trace here at all.  This means that if a
> user looks at their system, sees that the device model claims the driver
> for a device bound to the device but can't see any sign of the device
> doing anything they don't have any way of telling why that is other than
> to look in the driver code, see what resources it was trying to depend
> on and then go back to the running system to try to understand which of
> those resources hasn't appeared.

I will move the code for provider matching to frameworks,
so it will be easy to add just dev_info after every failed attempt
of getting resource, including deferring. This is the simplest solution
and it should be similar in verbosity to deferred probing.

Maybe other solution is to provide debug_fs (or device) attribute showing
restrack status per device.

>
>> +int restrack_up(unsigned long type, const void *id, void *data)
>> +int restrack_down(unsigned long type, const void *id, void *data)
> Again I'm not sure that the up and down naming is meaningful in the
> context of this interface.
>
>> +static void restrack_itb_cb(struct track_block *itb, void *data, bool on)
>> +{
> itb_cb?

Ups I forgot to rename few variables from my previous attempt.
itb - stayed for interface tracker block.

Regards
Andrzej


