Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753258AbbANPh4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 10:37:56 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:53233 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182AbbANPhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 10:37:55 -0500
Message-ID: <54B68D4D.2040309@collabora.co.uk>
Date: Wed, 14 Jan 2015 16:37:49 +0100
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Kukjin Kim <kgene@kernel.org>
CC: Kukjin Kim <kgene.kim@samsung.com>, linux-samsung-soc@vger.kernel.org,
        Doug Anderson <dianders@chromium.org>, linux-kernel@vger.kernel.org,
        Kevin Hilman <khilman@linaro.org>, Olof Johansson <olof@lixom.net>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH RESEND 1/4] ARM: dts: Add power and lid GPIO keys pinctrl
 for exynos5250-snow
References: <1420212257-22443-1-git-send-email-javier.martinez@collabora.co.uk> <1420212257-22443-2-git-send-email-javier.martinez@collabora.co.uk> <54B688A6.9090902@kernel.org>
In-Reply-To: <54B688A6.9090902@kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Kukjin,

On 01/14/2015 04:17 PM, Kukjin Kim wrote:
>>  
>>  &pinctrl_0 {
>> +	power_key_irq: power-key-irq {
>> +		samsung,pins = "gpx1-3";
>> +		samsung,pin-function = <0xf>;
> 
> I think, this setting should be same with exynos5250-spring but different.
> 
> from: arch/arm/boot/dts/exynos5250-spring.dts
> 491         power_key_irq: power-key-irq {
> 492                 samsung,pins = "gpx1-3";
> 493                 samsung,pin-function = <0>;
> 494                 samsung,pin-pud = <0>;
> 495                 samsung,pin-drv = <0>;
> 496         };
> 
> Hmm...0xf should be correct so need to fix the spring DT?
> 

Yes, the same problem has exynos5250-snow.dts. This is less relevant now
after commit f6a8249f9e55 ("pinctrl: exynos: Lock GPIOs as interrupts
when used as EINTs") that moved the pinmux reconfiguration to
.irq_{request,release}_resources() preventing the pads to be reconfigured
as regulator input/output.

But still for correctness we should audit spring / snow and change to 0xf.

Best regards,
Javier

