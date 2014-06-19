Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757405AbaFSHMj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 03:12:39 -0400
Received: from nasmtp01.atmel.com ([192.199.1.246]:35599 "EHLO
	DVREDG02.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753396AbaFSHMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 03:12:37 -0400
Message-ID: <53A28D49.2040400@atmel.com>
Date: Thu, 19 Jun 2014 15:12:09 +0800
From: Bo Shen <voice.shen@atmel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
CC: Thierry Reding <thierry.reding@gmail.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        David Airlie <airlied@linux.ie>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, <devicetree@vger.kernel.org>,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        <linux-doc@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        <linux-kernel@vger.kernel.org>, <linux-pwm@vger.kernel.org>,
        "Alexandre Belloni" <alexandre.belloni@free-electrons.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 7/7] ARM: at91/dt: enable the LCD panel on sama5d3xek
 boards
References: <1402329860-27520-1-git-send-email-boris.brezillon@free-electrons.com> <1402329860-27520-8-git-send-email-boris.brezillon@free-electrons.com>
In-Reply-To: <1402329860-27520-8-git-send-email-boris.brezillon@free-electrons.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.168.5.13]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Boris,

On 06/10/2014 12:04 AM, Boris BREZILLON wrote:
> diff --git a/arch/arm/boot/dts/sama5d33ek.dts b/arch/arm/boot/dts/sama5d33ek.dts
> index cbd6a3f..f2ab41d 100644
> --- a/arch/arm/boot/dts/sama5d33ek.dts
> +++ b/arch/arm/boot/dts/sama5d33ek.dts
> @@ -36,9 +36,33 @@
>   			macb0: ethernet@f0028000 {
>   				status = "okay";
>   			};
> +
> +			hlcdc: hlcdc@f0030000 {
> +				status = "okay";
> +
> +				hlcdc-display-controller {
> +					atmel,panel = <&panel 3 0>;

One question here, in the driver code, it will configuration the frame 
buffer mode depends on this parameter.
So, my question is if the framebuffer bits per pixel is different with 
output bits per pixel, how to setting it?

For example, frame buffer use 16 bits/pixel, while output 24 bits/pixel.

> +				};
> +			};
>   		};
>   	};
>

Best Regards,
Bo Shen
