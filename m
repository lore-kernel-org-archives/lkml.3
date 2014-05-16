Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932249AbaEPIS0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 04:18:26 -0400
Received: from 9.mo3.mail-out.ovh.net ([87.98.184.141]:52490 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756296AbaEPIFd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 04:05:33 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Subject: Re: [PATCH] ARM: at91: remove ISI code for AT91SAM9263
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
In-Reply-To: <1400142868.20469.12.camel@x220>
Date: Fri, 16 May 2014 15:49:23 +0800
Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Andrew Victor <linux@maxim.org.za>,
        Nicolas FERRE <nicolas.ferre@atmel.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <F4C251BF-666E-4E89-A6F7-3D96A669A8D8@jcrosoft.com>
References: <1400142868.20469.12.camel@x220>
To: Paul Bolle <pebolle@tiscali.nl>
X-Mailer: Apple Mail (2.1874)
X-Ovh-Tracer-Id: 14055171488394619669
X-Ovh-Remote: 193.138.230.146 (146.230.138.193.client.dyn.strong-ba6.blackoakcomputers.com)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejvddrgeehucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejvddrgeehucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On May 15, 2014, at 4:34 PM, Paul Bolle <pebolle@tiscali.nl> wrote:

> 
> In v2.6.25 code was added for an Image Sensor Interface (ISI) for
> AT91SAM9263. That code depended on the Kconfig macro
> CONFIG_VIDEO_AT91_ISI and its MODULE variant. The related Kconfig symbol
> has never been added to the tree. The net effect of this was that
> at91_add_device_isi() was a NOP. No one noticed because no callers of
> that function were added to the tree at that time.
> 
> The first caller of a function with that name was added in v3.4. But
> that caller apparently only called the function defined for AT91SAM9G45.
> (that function was also added in v3.4). So even then AT91SAM9263's NOP
> version of at91_add_device_isi() remained unused. This means that the
> ISI code for AT91SAM9263 can be removed.
> 

Nack

this is just resources and allow until this is converted to DTS to have the pinctrl and register information

Best Regards,
J.

> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> Untested!
> 
> Could someone please verify that this definition of
> at91_add_device_isi() really never will be called.
> 
> arch/arm/mach-at91/at91sam9263_devices.c | 57 --------------------------------
> 1 file changed, 57 deletions(-)
> 
> diff --git a/arch/arm/mach-at91/at91sam9263_devices.c b/arch/arm/mach-at91/at91sam9263_devices.c
> index 43d53d6156dd..f2dab0a872a1 100644
> --- a/arch/arm/mach-at91/at91sam9263_devices.c
> +++ b/arch/arm/mach-at91/at91sam9263_devices.c
> @@ -897,63 +897,6 @@ void __init at91_add_device_lcdc(struct atmel_lcdfb_pdata *data) {}
> 
> 
> /* --------------------------------------------------------------------
> - *  Image Sensor Interface
> - * -------------------------------------------------------------------- */
> -
> -#if defined(CONFIG_VIDEO_AT91_ISI) || defined(CONFIG_VIDEO_AT91_ISI_MODULE)
> -
> -struct resource isi_resources[] = {
> -	[0] = {
> -		.start	= AT91SAM9263_BASE_ISI,
> -		.end	= AT91SAM9263_BASE_ISI + SZ_16K - 1,
> -		.flags	= IORESOURCE_MEM,
> -	},
> -	[1] = {
> -		.start	= NR_IRQS_LEGACY + AT91SAM9263_ID_ISI,
> -		.end	= NR_IRQS_LEGACY + AT91SAM9263_ID_ISI,
> -		.flags	= IORESOURCE_IRQ,
> -	},
> -};
> -
> -static struct platform_device at91sam9263_isi_device = {
> -	.name		= "at91_isi",
> -	.id		= -1,
> -	.resource	= isi_resources,
> -	.num_resources	= ARRAY_SIZE(isi_resources),
> -};
> -
> -void __init at91_add_device_isi(struct isi_platform_data *data,
> -		bool use_pck_as_mck)
> -{
> -	at91_set_A_periph(AT91_PIN_PE0, 0);	/* ISI_D0 */
> -	at91_set_A_periph(AT91_PIN_PE1, 0);	/* ISI_D1 */
> -	at91_set_A_periph(AT91_PIN_PE2, 0);	/* ISI_D2 */
> -	at91_set_A_periph(AT91_PIN_PE3, 0);	/* ISI_D3 */
> -	at91_set_A_periph(AT91_PIN_PE4, 0);	/* ISI_D4 */
> -	at91_set_A_periph(AT91_PIN_PE5, 0);	/* ISI_D5 */
> -	at91_set_A_periph(AT91_PIN_PE6, 0);	/* ISI_D6 */
> -	at91_set_A_periph(AT91_PIN_PE7, 0);	/* ISI_D7 */
> -	at91_set_A_periph(AT91_PIN_PE8, 0);	/* ISI_PCK */
> -	at91_set_A_periph(AT91_PIN_PE9, 0);	/* ISI_HSYNC */
> -	at91_set_A_periph(AT91_PIN_PE10, 0);	/* ISI_VSYNC */
> -	at91_set_B_periph(AT91_PIN_PE12, 0);	/* ISI_PD8 */
> -	at91_set_B_periph(AT91_PIN_PE13, 0);	/* ISI_PD9 */
> -	at91_set_B_periph(AT91_PIN_PE14, 0);	/* ISI_PD10 */
> -	at91_set_B_periph(AT91_PIN_PE15, 0);	/* ISI_PD11 */
> -
> -	if (use_pck_as_mck) {
> -		at91_set_B_periph(AT91_PIN_PE11, 0);	/* ISI_MCK (PCK3) */
> -
> -		/* TODO: register the PCK for ISI_MCK and set its parent */
> -	}
> -}
> -#else
> -void __init at91_add_device_isi(struct isi_platform_data *data,
> -		bool use_pck_as_mck) {}
> -#endif
> -
> -
> -/* --------------------------------------------------------------------
>  *  Timer/Counter block
>  * -------------------------------------------------------------------- */
> 
> -- 
> 1.9.0
> 

