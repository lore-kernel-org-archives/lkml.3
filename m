Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753515AbbALOLu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 09:11:50 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:51226 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485AbbALOLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 09:11:47 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-4c-54b3d621ddb5
Message-id: <1421071901.20276.7.camel@AMDC1943>
Subject: Re: [PATCH v2 3/5] pinctrl: exynos: Fix GPIO setup failure because
 domain clock being gated
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Mike Turquette <mturquette@linaro.org>, Kukjin Kim <kgene@kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Vivek Gautam <gautam.vivek@samsung.com>,
        Kevin Hilman <khilman@kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Date: Mon, 12 Jan 2015 15:11:41 +0100
In-reply-to: <CA+Ln22H_a9CWxrYO_i9Esm6keXA8XLLYmE1Vg-8ynamJ1sAwpQ@mail.gmail.com>
References: <1417011857-10419-1-git-send-email-k.kozlowski@samsung.com>
 <1417011857-10419-4-git-send-email-k.kozlowski@samsung.com>
 <CACRpkdb8F8YcvFeHPvOKHjx_p4HEpimck3XRabB3oHpZTdmRQQ@mail.gmail.com>
 <1417183724.18249.36.camel@AMDC1943>
 <CA+Ln22Ejo51VPWf6DmuRvV_fZr_H=-BXAshSPSOokNE1bz=-QA@mail.gmail.com>
 <1417423043.4055.14.camel@AMDC1943>
 <CA+Ln22H_a9CWxrYO_i9Esm6keXA8XLLYmE1Vg-8ynamJ1sAwpQ@mail.gmail.com>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu2
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFLMWRmVeSWpSXmKPExsVy+t/xa7qK1zaHGPQtMrHYOGM9q8X8I+dY
	LdquHGS3OPq7wKL/8Wtmi6ebHzNZnG16w24x5c9yJotNj6+xWmye/4fR4vKuOWwWM87vY7K4
	fZnXYu2Ru+wWTydcZLM4/Kad1WLVrj+MDoIeLc09bB5/n19n8dg56y67x6ZVnWwed67tYfPY
	vKTeo2/LKkaPz5vkAjiiuGxSUnMyy1KL9O0SuDLe3Iov2CpdMbnXroHxsWgXIyeHhICJxL9L
	X5ggbDGJC/fWs3UxcnEICSxllHjz/AA7hPOZUWLm5PksIFW8AvoS/XdOMIPYwgJpEtumz2IE
	sdkEjCU2L1/CBmKLCKhLfJvSD9bMLLCJTWLlymdgCRYBVYnOT01ADRwcnALBEnNmRkEsWM4s
	sePMCrBBzEDNk+YtYgapkRBQlmjsd4PYKyjxY/I9FogSeYnNa94yT2AUmIWkYxaSsllIyhYw
	Mq9iFE0tTS4oTkrPNdIrTswtLs1L10vOz93ECImvrzsYlx6zOsQowMGoxMNrKbU5RIg1say4
	MvcQowQHs5IIr2sZUIg3JbGyKrUoP76oNCe1+BAjEwenVANjzIJlinPK7r6682jppkDejbNS
	LFctOnXmk6l9wfrgM6f9DgVNb9c71aHykOte3oVkMbkTgkGPWi5FTnAtlQ05OivCxs/L5pW4
	mev+VZ8eJVZcSrp04aLJ7lrliWrZajyHAltTNx2dFHx8t0qjbIPXlmOXy98XZi1+b1jTbvB/
	e3zr4d8CB83WK7EUZyQaajEXFScCANr/9kSNAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On pon, 2014-12-01 at 23:34 +0900, Tomasz Figa wrote:
> 2014-12-01 17:37 GMT+09:00 Krzysztof Kozlowski <k.kozlowski@samsung.com>:
> >
> > On nie, 2014-11-30 at 21:19 +0900, Tomasz Figa wrote:
> >> Hi Krzysztof,
> >>
(...)
> >
> >> Also isn't a similar problem happening due to power domains? I believe
> >> the whole maudio block is located in a separate power domain but
> >> somehow it doesn't get turned off?
> >
> > There is Maudio power domain... but I think it is not related here.
> 
> Could you somehow check what happens when the maudio power domain is
> turned off and maudio pin controller is accessed? Could you also check
> the difference in power consumption with this domain powered on and
> off?

Hi Tomasz,

Some time ago you asked for some details of Exynos5420 Maudio domain
behavior. Here it goes:

1. mau domain ON, EPL: OFF: boot hang (this was behavior after adding
runtime PM to pl330 driver)

2. maud domain OFF, EPLL OFF: boot hang

3. maud domain ON, EPLL ON: works (current linux-next and mainline)

4. maud domain OFF, EPLL ON: works, almost the same energy consumption
as in (3) (diff: 0.1% so it is smaller than measuring accuracy).

However an unspecified imprecise abort shows up in (4):
[   11.911628] Freeing unused kernel memory: 328K (c0674000 - c06c6000)
[   12.122695] usb 5-1.4: new high-speed USB device number 3 using exynos-ehci
[   12.190011] Unhandled fault: imprecise external abort (0x1406) at 0x00000000
[   12.219062] usb 5-1.4: New USB device found, idVendor=0b95, idProduct=772a
[   12.224548] usb 5-1.4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[   12.231794] usb 5-1.4: Product: AX88772
[   12.235681] usb 5-1.4: Manufacturer: ASIX Elec. Corp.
[   12.240707] usb 5-1.4: SerialNumber: 000001
[   12.248835] asix 5-1.4:1.0 (unnamed net_device) (uninitialized): invalid hw address, using random
root@(none):/#

Best regards,
Krzysztof

> 
> > Pinctrl driver does not have runtime PM and is not attached to a domain.
> > I thought about other solution to this problem (with utilization of
> > power domains):
> >  - add runtime PM to pinctrl and audss clocks,
> >  - attach pinctrl and audss clocks to maudio power domain,
> >  - enable the clock when power domain is turned on.
> > However almost the same changes had to be added to pinctrl and audss
> > clocks drivers (replace clock_enable() with pm_runtime_get_sync()).
> 
> Well, if the dependency is there due to hardware design, I think it
> needs to be reflected in the drivers as well.
> 
> Few other issues that came to my mind:
> 
>  - Your previous patch added clock control only to pinctrl operations.
> Shouldn't GPIO operations be included as well?
> 
>  - If power domain dependency is there too, what happens with GPIO
> pins if the domain is powered off? If they lose their states, wouldn't
> it necessary to keep the domain powered on whenever there is some GPIO
> pin requested (which usually = in use)? (I'd assume that special
> functions shouldn't take a reference on runtime PM, because they are
> related to IP blocks in the same PM domain, which will implicitly keep
> the domain powered on.)
> 
>  - Doesn't the clock controller also lose its state whenever the power
> domain is powered off? I guess that would be similar to ISP clock
> controller, issues of which are still not resolved in mainline.
> Sylwester could tell you more about this, I guess.
> 
> Best regards,
> Tomasz

