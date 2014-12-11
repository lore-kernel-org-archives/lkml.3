Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757299AbaLKKuS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 05:50:18 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:34577 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756681AbaLKKuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 05:50:15 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-fc-548976e349fd
Message-id: <548976D2.7080005@samsung.com>
Date: Thu, 11 Dec 2014 11:49:54 +0100
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
Subject: Re: [RFC 04/15] regulator: add restrack support
References: <1418226513-14105-1-git-send-email-a.hajda@samsung.com>
 <1418226513-14105-5-git-send-email-a.hajda@samsung.com>
 <20141210160720.GS11764@sirena.org.uk>
In-reply-to: <20141210160720.GS11764@sirena.org.uk>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJIsWRmVeSWpSXmKPExsVy+t/xy7qPyzpDDJbP0bU48GIhi8XUh0/Y
	LOYfOcdqceXrezaLc68esVgc+LOD0aJ58Xo2i0n3J7BYXHjaw2bx7UoHk8WUP8uZLDY9vsZq
	sXn+H0aLy7vmsFnMOL+PyeL2ZV6LtUfusls8nXCRzaJ17xF2i5+75rE4iHi0NPeweTzZdJHR
	Y+esu+wem1Z1snncubaHzWP/3DXsHve7jzN5bF5S79G3ZRWjx/Eb25k8Pm+SC+CO4rJJSc3J
	LEst0rdL4Mp4Ovsoa8FF3oqH5y6yNTB+4upi5OSQEDCReHDxIjOELSZx4d56ti5GLg4hgaWM
	Eg8mtzOCJIQEPjFKNM7iB7F5BbQkFn2fyAJiswioSrxoe88GYrMJaEr83XwTzBYViJD4sOor
	G0S9oMSPyffA6kUElCWuft8LZjMLzGGX2LzLHMQWFrCQmH1iETvE4mWMEnsWvQNr5hQwlnj8
	8xfQdRxADXoS9y9qQfTKS2xe85Z5AqPALCQrZiFUzUJStYCReRWjaGppckFxUnqukV5xYm5x
	aV66XnJ+7iZGSHR+3cG49JjVIUYBDkYlHt6M+M4QIdbEsuLK3EOMEhzMSiK8VhFAId6UxMqq
	1KL8+KLSnNTiQ4xMHJxSDYyBOxIPcrXe7ZHduuv+ybzqJzm2ukoc52t6V3zNiOYv7XKXvVXN
	l+t+4Ufn6vUx1xyTT7Jnavla5yystWwt7Ht2Pfpfz8m9+rwzRM/5XXlyQeeefDnze8P5oUv7
	2BQfBKZP6DooPHOLwcrQrfut7h/csIzZTOrKmQ7mSFk+8XuZ+3tLPf6fi1RiKc5INNRiLipO
	BAC6c7/nrAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On 12/10/2014 05:07 PM, Mark Brown wrote:
> On Wed, Dec 10, 2014 at 04:48:22PM +0100, Andrzej Hajda wrote:
>> Regulators supports various methods of lookup.
>> The patch adds restrack support only to DT based regulators.
> Why, what does this mean and how might one use it?  I've not looked at
> the code since I don't know what it's supposed to accomplish...

Looking at this patch makes no sense without looking at cover letter
or at the patch adding restrack framework. In short adding restrack support
to regulators will allow to:
- proper handle regulator provider unbind/re-bind, currently it results
in oopses, crashes and hangs,
- avoid late probe due to deferred probing, currently if probe is
deferred, re-probe occurs in late initcall,
- track appearance of resources which can alter behavior of the driver
if present but they are not required,
  I am not sure if there are use cases for it in case of regulators, but
other resources have such use cases,
- as a bonus we can have simpler allocation of various resources, please
look at cover letter for example.

>
> One very high level thing is that anything that only works for DT only
> seems to be a non-starter, the API should be hiding details of the
> firmware interface.

I agree, but as this is RFC, not everything is finished. It seems I have
forgotten to mention it clearly in cover
letter.
Anyway it seems I should adjust patchset and move matching code from
restrack/track core to specific frameworks.
This way any current or future lookup method should be supported.

But the main purpose of this patchset is to get opinions, if the main
ideas are OK. And if the patchset can be
eventually accepted.

Regards
Andrzej

