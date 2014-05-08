Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753096AbaEHN5Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 09:57:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46519 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750768AbaEHN5W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 09:57:22 -0400
Message-ID: <536B8CDD.7040600@redhat.com>
Date: Thu, 08 May 2014 15:55:41 +0200
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Alexander Bersenev <bay@hackerdom.ru>,
        linux-sunxi <linux-sunxi@googlegroups.com>, david@hardeman.nu,
        devicetree@vger.kernel.org, galak@codeaurora.org,
        grant.likely@linaro.org, ijc+devicetree@hellion.org.uk,
        james.hogan@imgtec.com, linux-arm-kernel@lists.infradead.org,
        linux@arm.linux.org.uk, m.chehab@samsung.com, mark.rutland@arm.com,
        maxime.ripard@free-electrons.com, pawel.moll@arm.com,
        rdunlap@infradead.org, robh+dt@kernel.org, sean@mess.org,
        srinivas.kandagatla@st.com, wingrime@linux-sunxi.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: Re: [PATCH v5 0/3] ARM: sunxi: Add support for consumer infrared
 devices
References: <1398871010-30681-1-git-send-email-bay@hackerdom.ru>
In-Reply-To: <1398871010-30681-1-git-send-email-bay@hackerdom.ru>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 04/30/2014 05:16 PM, Alexander Bersenev wrote:
> This patch introduces Consumer IR(CIR) support for sunxi boards.
> 
> This is based on Alexsey Shestacov's work based on the original driver 
> supplied by Allwinner.
> 
> Signed-off-by: Alexander Bersenev <bay@hackerdom.ru>
> Signed-off-by: Alexsey Shestacov <wingrime@linux-sunxi.org>

Alexander, v5 still has various issues which need fixing,
do you plan to do a v6 soon ?

Regards,

Hans

> 
> ---
> Changes since version 1: 
>  - Fix timer memory leaks 
>  - Fix race condition when driver unloads while interrupt handler is active
>  - Support Cubieboard 2(need testing)
> 
> Changes since version 2:
> - More reliable keydown events
> - Documentation fixes
> - Rename registers accurding to A20 user manual
> - Remove some includes, order includes alphabetically
> - Use BIT macro
> - Typo fixes
> 
> Changes since version 3:
> - Split the patch on smaller parts
> - More documentation fixes
> - Add clock-names in DT
> - Use devm_clk_get function to get the clocks
> - Removed gpios property from ir's DT
> - Changed compatible from allwinner,sunxi-ir to allwinner,sun7i-a20-ir in DT
> - Use spin_lock_irq instead spin_lock_irqsave in interrupt handler
> - Add myself in the copyright ;)
> - Coding style and indentation fixes
> 
> Changes since version 4:
> - Try to fix indentation errors by sending patches with git send-mail
> 
> Alexander Bersenev (3):
>   ARM: sunxi: Add documentation for sunxi consumer infrared devices
>   ARM: sunxi: Add driver for sunxi IR controller
>   ARM: sunxi: Add IR controller support in DT on A20
> 
>  .../devicetree/bindings/media/sunxi-ir.txt         |  23 ++
>  arch/arm/boot/dts/sun7i-a20-cubieboard2.dts        |   6 +
>  arch/arm/boot/dts/sun7i-a20-cubietruck.dts         |   6 +
>  arch/arm/boot/dts/sun7i-a20.dtsi                   |  31 +++
>  drivers/media/rc/Kconfig                           |  10 +
>  drivers/media/rc/Makefile                          |   1 +
>  drivers/media/rc/sunxi-ir.c                        | 303 +++++++++++++++++++++
>  7 files changed, 380 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/sunxi-ir.txt
>  create mode 100644 drivers/media/rc/sunxi-ir.c
> 
