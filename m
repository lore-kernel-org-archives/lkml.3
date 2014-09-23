Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754906AbaIWIPB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 04:15:01 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:13210 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753745AbaIWIPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 04:15:00 -0400
Message-ID: <54212C00.2090800@atmel.com>
Date: Tue, 23 Sep 2014 10:14:56 +0200
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
Subject: Re: [PATCH v6 2/9] rtc: at91sam9: use standard readl/writel functions
 instead of raw versions
References: <1411400563-570-1-git-send-email-boris.brezillon@free-electrons.com> <1411400563-570-3-git-send-email-boris.brezillon@free-electrons.com>
In-Reply-To: <1411400563-570-3-git-send-email-boris.brezillon@free-electrons.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can be good to know why... here.

Otherwise, you can add my:
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>


On 22/09/2014 17:42, Boris BREZILLON :
> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
> Acked-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> ---
>  drivers/rtc/rtc-at91sam9.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/rtc/rtc-at91sam9.c b/drivers/rtc/rtc-at91sam9.c
> index 51f0038..74a9ca0 100644
> --- a/drivers/rtc/rtc-at91sam9.c
> +++ b/drivers/rtc/rtc-at91sam9.c
> @@ -77,14 +77,14 @@ struct sam9_rtc {
>  };
>  
>  #define rtt_readl(rtc, field) \
> -	__raw_readl((rtc)->rtt + AT91_RTT_ ## field)
> +	readl((rtc)->rtt + AT91_RTT_ ## field)
>  #define rtt_writel(rtc, field, val) \
> -	__raw_writel((val), (rtc)->rtt + AT91_RTT_ ## field)
> +	writel((val), (rtc)->rtt + AT91_RTT_ ## field)
>  
>  #define gpbr_readl(rtc) \
> -	__raw_readl((rtc)->gpbr)
> +	readl((rtc)->gpbr)
>  #define gpbr_writel(rtc, val) \
> -	__raw_writel((val), (rtc)->gpbr)
> +	writel((val), (rtc)->gpbr)
>  
>  /*
>   * Read current time and date in RTC
> 


-- 
Nicolas Ferre
