Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752542Ab3I0HgL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 03:36:11 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:33958 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258Ab3I0HgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 03:36:09 -0400
Message-ID: <52453545.3090504@collabora.co.uk>
Date: Fri, 27 Sep 2013 09:35:33 +0200
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130704 Icedove/17.0.7
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Kevin Hilman <khilman@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Lars Poeschel <larsi@wh2.tu-dresden.de>,
        Grant Likely <grant.likely@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Kumar Gala <galak@codeaurora.org>, Pawel Moll <pawel.moll@arm.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Enric Balletbo i Serra <eballetbo@gmail.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Balaji T K <balajitk@ti.com>, Tony Lindgren <tony@atomide.com>,
        Jon Hunter <jgchunter@gmail.com>, linux-gpio@vger.kernel.org,
        linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, r.sricharan@ti.com, holler@ahsoftware.de,
        aaro.koskinen@iki.fi, Paul Walmsley <paul@pwsan.com>, joelf@ti.com
Subject: Re: [RFC v2] gpio/omap: auto-setup a GPIO when used as an IRQ
References: <1380009480-4975-1-git-send-email-javier.martinez@collabora.co.uk> <5244C0C4.2030004@wwwdotorg.org>
In-Reply-To: <5244C0C4.2030004@wwwdotorg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 09/27/2013 01:18 AM, Stephen Warren wrote:
> On 09/24/2013 01:58 AM, Javier Martinez Canillas wrote:
>> The OMAP GPIO controller HW requires a pin to be configured in GPIO
>> input mode in order to operate as an interrupt input. Since drivers
>> should not be aware of whether an interrupt pin is also a GPIO or not,
>> the HW should be fully configured/enabled as an IRQ if a driver solely
>> uses IRQ APIs such as request_irq(), and never calls any GPIO-related
>> APIs. As such, add the missing HW setup to the OMAP GPIO controller's
>> irq_chip driver.
>> 
>> Since this bypasses the GPIO subsystem we have to ensure that another
>> caller won't be able to request the same GPIO pin that is used as an
>> IRQ and set its direction as output. Requesting the GPIO and setting
>> its direction as input is allowed though.
> 
> FWIW, the concept of this patch,
> Acked-by: Stephen Warren <swarren@nvidia.com>
> 
> I didn't review the code; just skimmed it to see where the new
> functionality was implemented.
> 

Thanks Stephen,

I split the changes as suggested by Tony and posted as a patch-set and not an
RFC anymore:

[PATCH 1/2] gpio/omap: maintain GPIO and IRQ usage separately [1]
[PATCH 2/2] gpio/omap: auto-setup a GPIO when used as an IRQ [2]

Linus,

Could you please add Stephen Acked-by when taking the patches and also George
Cherian Tested-by that sent for this RFC. George it would be great if you can
also comment on which OMAP platform you had tested.

I cc'ed Aaro Koskinen and Paul Walmsley now which seems to have OMAP1 platforms
to test. Could you please test [1] and [2] on a OMAP1 board? These patches
solves a long standing issue we have on OMAP2+ when booting with DT and it would
be great if you can check that it does not cause regressions on OMAP1 based boards.

Thanks a lot and best regards,
Javier

[1]: https://patchwork.kernel.org/patch/2937351/
[2]: https://patchwork.kernel.org/patch/2937371/
