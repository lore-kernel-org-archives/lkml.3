Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757696Ab3CYJki (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 05:40:38 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:33920 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755482Ab3CYJkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 05:40:37 -0400
MIME-Version: 1.0
In-Reply-To: <1364203632.1390.254.camel@x61.thuisdomein>
References: <1364203632.1390.254.camel@x61.thuisdomein>
Date: Mon, 25 Mar 2013 13:40:35 +0400
Message-ID: <CAHj3AVn83fum-2BQnEKxxajdL=VLrdNQGQ2cWf7dzOYbVHiqQw@mail.gmail.com>
Subject: Re: [PATCH] staging: lirc: remove dead code
From: Denis Kirjanov <kirjanov@gmail.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Jarod Wilson <jarod@wilsonet.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just found that the exactly the same patch has been posted a while ago:
http://driverdev.linuxdriverproject.org/pipermail/devel/2012-November/033623.html

On 3/25/13, Paul Bolle <pebolle@tiscali.nl> wrote:
> lirc uses the CONFIG_SA1100_BITSY Kconfig macro. But its Kconfig symbol
> was removed in v2.4.13. So we can remove a few lines of dead code.
>
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> Untested, but of rather low risk. Note that support for the
> machine_is_bitsy() macro was already removed in v2.4.10.
>
>  drivers/staging/media/lirc/lirc_sir.c | 10 ----------
>  1 file changed, 10 deletions(-)
>
> diff --git a/drivers/staging/media/lirc/lirc_sir.c
> b/drivers/staging/media/lirc/lirc_sir.c
> index 63a554c..f781c53 100644
> --- a/drivers/staging/media/lirc/lirc_sir.c
> +++ b/drivers/staging/media/lirc/lirc_sir.c
> @@ -787,12 +787,6 @@ static int init_hardware(void)
>  	spin_lock_irqsave(&hardware_lock, flags);
>  	/* reset UART */
>  #ifdef LIRC_ON_SA1100
> -#ifdef CONFIG_SA1100_BITSY
> -	if (machine_is_bitsy()) {
> -		pr_info("Power on IR module\n");
> -		set_bitsy_egpio(EGPIO_BITSY_IR_ON);
> -	}
> -#endif
>  #ifdef CONFIG_SA1100_COLLIE
>  	sa1100_irda_set_power_collie(3);	/* power on */
>  #endif
> @@ -942,10 +936,6 @@ static void drop_hardware(void)
>  	Ser2UTCR3 = sr.utcr3;
>
>  	Ser2HSCR0 = sr.hscr0;
> -#ifdef CONFIG_SA1100_BITSY
> -	if (machine_is_bitsy())
> -		clr_bitsy_egpio(EGPIO_BITSY_IR_ON);
> -#endif
>  #ifdef CONFIG_SA1100_COLLIE
>  	sa1100_irda_set_power_collie(0);	/* power off */
>  #endif
> --
> 1.7.11.7
>
> _______________________________________________
> devel mailing list
> devel@linuxdriverproject.org
> http://driverdev.linuxdriverproject.org/mailman/listinfo/devel
>


-- 
Regards,
Denis
