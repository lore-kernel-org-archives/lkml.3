Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751437AbaCVMiP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 08:38:15 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:53413 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213AbaCVMiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 08:38:12 -0400
Message-ID: <532D8474.8020601@kernel.org>
Date: Sat, 22 Mar 2014 12:39:16 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-iio@vger.kernel.org, linux-input@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>
Subject: Re: [PATCH v2 12/15] ARM: at91: remove atmel_tsadcc platform_data
References: <1395064628-644-1-git-send-email-alexandre.belloni@free-electrons.com> <1395064628-644-13-git-send-email-alexandre.belloni@free-electrons.com>
In-Reply-To: <1395064628-644-13-git-send-email-alexandre.belloni@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/03/14 13:57, Alexandre Belloni wrote:
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
See below.
> ---
>   arch/arm/mach-at91/board.h          | 3 ---
>   include/linux/platform_data/atmel.h | 7 -------
>   2 files changed, 10 deletions(-)
>
> diff --git a/arch/arm/mach-at91/board.h b/arch/arm/mach-at91/board.h
> index 6c08b341167d..4e773b55bc2d 100644
> --- a/arch/arm/mach-at91/board.h
> +++ b/arch/arm/mach-at91/board.h
> @@ -118,9 +118,6 @@ struct isi_platform_data;
>   extern void __init at91_add_device_isi(struct isi_platform_data *data,
>   		bool use_pck_as_mck);
>
> - /* Touchscreen Controller */
> -extern void __init at91_add_device_tsadcc(struct at91_tsadcc_data *data);
> -
>   /* CAN */
>   extern void __init at91_add_device_can(struct at91_can_data *data);
>
> diff --git a/include/linux/platform_data/atmel.h b/include/linux/platform_data/atmel.h
> index cea9f70133c5..4b452c6a2f7b 100644
> --- a/include/linux/platform_data/atmel.h
> +++ b/include/linux/platform_data/atmel.h
> @@ -86,13 +86,6 @@ struct atmel_uart_data {
>   	struct serial_rs485	rs485;		/* rs485 settings */
>   };
>
> - /* Touchscreen Controller */
> -struct at91_tsadcc_data {
> -	unsigned int    adc_clock;
> -	u8		pendet_debounce;
> -	u8		ts_sample_hold_time;
> -};
> -
I believe this is still in use in the driver you don't remove until patch 14.

Probably best to reorder the patches...
>   /* CAN */
>   struct at91_can_data {
>   	void (*transceiver_switch)(int on);
>

