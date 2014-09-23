Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813AbaIWIOJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 04:14:09 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:12947 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070AbaIWIOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 04:14:05 -0400
Message-ID: <54212BC7.4070905@atmel.com>
Date: Tue, 23 Sep 2014 10:13:59 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Boris BREZILLON <boris.brezillon@free-electrons.com>,
        "Jean-Christophe Plagniol-Villard" <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>,
        Alessandro Zummo <a.zummo@towertech.it>, <rtc-linux@googlegroups.com>,
        "Samuel Ortiz" <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, Johan Hovold <jhovold@gmail.com>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 1/9] rtc: at91sam9: remove references to mach specific
 headers
References: <1411400563-570-1-git-send-email-boris.brezillon@free-electrons.com> <1411400563-570-2-git-send-email-boris.brezillon@free-electrons.com>
In-Reply-To: <1411400563-570-2-git-send-email-boris.brezillon@free-electrons.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/09/2014 17:42, Boris BREZILLON :
> In order to support multi platform kernel drivers should not include
> machine specific headers.
> Copy RTT macros in the driver code and remove any machine specific
> headers.
> 
> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
> Acked-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

> ---
>  drivers/rtc/rtc-at91sam9.c | 22 ++++++++++++++++++----
>  1 file changed, 18 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/rtc/rtc-at91sam9.c b/drivers/rtc/rtc-at91sam9.c
> index 5963743..51f0038 100644
> --- a/drivers/rtc/rtc-at91sam9.c
> +++ b/drivers/rtc/rtc-at91sam9.c
> @@ -22,10 +22,6 @@
>  #include <linux/platform_data/atmel.h>
>  #include <linux/io.h>
>  
> -#include <mach/at91_rtt.h>
> -#include <mach/cpu.h>
> -#include <mach/hardware.h>
> -
>  /*
>   * This driver uses two configurable hardware resources that live in the
>   * AT91SAM9 backup power domain (intended to be powered at all times)
> @@ -47,6 +43,24 @@
>   * registers available, likewise usable for more than "RTC" support.
>   */
>  
> +#define AT91_RTT_MR		0x00			/* Real-time Mode Register */
> +#define AT91_RTT_RTPRES		(0xffff << 0)		/* Real-time Timer Prescaler Value */
> +#define AT91_RTT_ALMIEN		(1 << 16)		/* Alarm Interrupt Enable */
> +#define AT91_RTT_RTTINCIEN	(1 << 17)		/* Real Time Timer Increment Interrupt Enable */
> +#define AT91_RTT_RTTRST		(1 << 18)		/* Real Time Timer Restart */
> +
> +#define AT91_RTT_AR		0x04			/* Real-time Alarm Register */
> +#define AT91_RTT_ALMV		(0xffffffff)		/* Alarm Value */
> +
> +#define AT91_RTT_VR		0x08			/* Real-time Value Register */
> +#define AT91_RTT_CRTV		(0xffffffff)		/* Current Real-time Value */
> +
> +#define AT91_RTT_SR		0x0c			/* Real-time Status Register */
> +#define AT91_RTT_ALMS		(1 << 0)		/* Real-time Alarm Status */
> +#define AT91_RTT_RTTINC		(1 << 1)		/* Real-time Timer Increment */
> +
> +#define AT91_SLOW_CLOCK		32768
> +
>  /*
>   * We store ALARM_DISABLED in ALMV to record that no alarm is set.
>   * It's also the reset value for that field.
> 


-- 
Nicolas Ferre
