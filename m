Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755590Ab3KOKnX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 05:43:23 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:57959 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753058Ab3KOKnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 05:43:15 -0500
Message-ID: <5285FABC.2080005@atmel.com>
Date: Fri, 15 Nov 2013 11:43:08 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Johan Hovold <jhovold@gmail.com>, <rtc-linux@googlegroups.com>,
        "Andrew Morton" <akpm@linux-foundation.org>
CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Andrew Victor <linux@maxim.org.za>,
        Alessandro Zummo <a.zummo@towertech.it>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 3/3] ARM: at91/rtc: disable interrupts at shutdown
References: <1363025279-17615-1-git-send-email-jhovold@gmail.com> <1381917376-21107-1-git-send-email-jhovold@gmail.com> <1381917376-21107-4-git-send-email-jhovold@gmail.com>
In-Reply-To: <1381917376-21107-4-git-send-email-jhovold@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/10/2013 11:56, Johan Hovold :
> Make sure RTC-interrupts are disabled at shutdown.
>
> As the RTC is generally powered by backup power (VDDBU), its interrupts
> are not disabled on wake-up, user, watchdog or software reset. This
> could cause troubles on other systems (e.g. older kernels) if an
> interrupt occurs before a handler has been installed at next boot.
>
> Let us be well-behaved and disable them on clean shutdowns at least (as
> do the RTT-based rtc-at91sam9 driver).
>
> Signed-off-by: Johan Hovold <jhovold@gmail.com>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Thank you Johan.

Andrew, could you add this patch to your rtc queue or should I re-send it ?

Best regards,

> ---
>   drivers/rtc/rtc-at91rm9200.c | 9 +++++++++
>   1 file changed, 9 insertions(+)
>
> diff --git a/drivers/rtc/rtc-at91rm9200.c b/drivers/rtc/rtc-at91rm9200.c
> index 7418926..ea088e9 100644
> --- a/drivers/rtc/rtc-at91rm9200.c
> +++ b/drivers/rtc/rtc-at91rm9200.c
> @@ -442,6 +442,14 @@ static int __exit at91_rtc_remove(struct platform_device *pdev)
>   	return 0;
>   }
>
> +static void at91_rtc_shutdown(struct platform_device *pdev)
> +{
> +	/* Disable all interrupts */
> +	at91_rtc_write(AT91_RTC_IDR, AT91_RTC_ACKUPD | AT91_RTC_ALARM |
> +					AT91_RTC_SECEV | AT91_RTC_TIMEV |
> +					AT91_RTC_CALEV);
> +}
> +
>   #ifdef CONFIG_PM_SLEEP
>
>   /* AT91RM9200 RTC Power management control */
> @@ -480,6 +488,7 @@ static SIMPLE_DEV_PM_OPS(at91_rtc_pm_ops, at91_rtc_suspend, at91_rtc_resume);
>
>   static struct platform_driver at91_rtc_driver = {
>   	.remove		= __exit_p(at91_rtc_remove),
> +	.shutdown	= at91_rtc_shutdown,
>   	.driver		= {
>   		.name	= "at91_rtc",
>   		.owner	= THIS_MODULE,
>


-- 
Nicolas Ferre
