Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879Ab3C2Qjr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 12:39:47 -0400
Received: from smtp.infotech.no ([82.134.31.41]:38467 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753624Ab3C2Qjp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 12:39:45 -0400
Message-ID: <5155C3A6.4060109@interlog.com>
Date: Fri, 29 Mar 2013 12:39:02 -0400
From: Douglas Gilbert <dgilbert@interlog.com>
Reply-To: dgilbert@interlog.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Johan Hovold <jhovold@gmail.com>
CC: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 5/5] rtc-at91rm9200: add support for at91sam9x5
References: <1364573029-19346-1-git-send-email-jhovold@gmail.com> <1364573029-19346-5-git-send-email-jhovold@gmail.com>
In-Reply-To: <1364573029-19346-5-git-send-email-jhovold@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13-03-29 12:03 PM, Johan Hovold wrote:
> Add support for the at91sam9x5-family which must use the shadow
> interrupt mask due to a hardware issue.
> ---
>   drivers/rtc/rtc-at91rm9200.c | 8 ++++++++
>   1 file changed, 8 insertions(+)
>
> diff --git a/drivers/rtc/rtc-at91rm9200.c b/drivers/rtc/rtc-at91rm9200.c
> index 2921866..f3e351f 100644
> --- a/drivers/rtc/rtc-at91rm9200.c
> +++ b/drivers/rtc/rtc-at91rm9200.c
> @@ -318,12 +318,20 @@ static irqreturn_t at91_rtc_interrupt(int irq, void *dev_id)
>   static const struct at91_rtc_config at91rm9200_config = {
>   };
>
> +static const struct at91_rtc_config at91sam9x5_config = {
> +	.use_shadow_imr = true,
> +};
> +
>   #if defined(CONFIG_OF)
>   static const struct of_device_id at91_rtc_dt_ids[] = {
>   	{
>   		.compatible = "atmel,at91rm9200-rtc",
>   		.data = &at91rm9200_config,
>   	},
> +	{
> +		.compatible = "atmel,at91sam9x5-rtc",
> +		.data = &at91sam9x5_config,
> +	},
>   		/* terminator */
>   	}
>   };
>

Johan,
Looks good.

Plus add something like this to at91sam9x5.dtsi after the
i2c@2 entry (at the end):

         rtc {
                 compatible = "atmel,at91sam9x5-rtc";
                 reg = <0xfffffeb0 0x40>;
                 interrupts = <1 4 7>;
                 status = "disabled";
         };


and an "enabler" in ariag25.dts (and perhaps other members
of the 9x5 sub-family), also at the end:

         rtc {
                 status = "okay";
         };

My patches are in Robert Nelson's tree at:
    http://www.eewiki.net/display/linuxonarm/AT91SAM9x5
in the Linux kernel section. My RTC code amounts to the same
thing as you are proposing, without the safety code around
the IMR shadow.

I provide binaries based on that work to Aria G25 users
via a google group. No-one has complained about RTC not
working. SPI and I2C problems are on-going but gradually
being sorted. Hence I know people are using and testing
this code, other than me.

Doug Gilbert
