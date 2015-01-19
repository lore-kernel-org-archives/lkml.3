Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070AbbASWwS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 17:52:18 -0500
Received: from mail-wg0-f50.google.com ([74.125.82.50]:65075 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614AbbASWwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 17:52:16 -0500
From: Peter Korsgaard <peter@korsgaard.com>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Peter Korsgaard <jacmet@sunsite.dk>
Subject: Re: [PATCH 8/8] gpio/mpc8xxx: Use of_mm_gpiochip_remove
References: <1421581173-28416-1-git-send-email-ricardo.ribalda@gmail.com>
	<1421581173-28416-9-git-send-email-ricardo.ribalda@gmail.com>
Date: Mon, 19 Jan 2015 23:52:11 +0100
In-Reply-To: <1421581173-28416-9-git-send-email-ricardo.ribalda@gmail.com>
	(Ricardo Ribalda Delgado's message of "Sun, 18 Jan 2015 12:39:33
	+0100")
Message-ID: <87fvb69yec.fsf@dell.be.48ers.dk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Ricardo" == Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com> writes:

 > Since d621e8bae5ac9c67 (Create of_mm_gpiochip_remove), there is a
 > counterpart for of_mm_gpiochip_add.

 > This patch implements the remove function of the driver making use of
 > it.

 > Cc: Linus Walleij <linus.walleij@linaro.org>
 > Cc: Alexandre Courbot <gnurou@gmail.com>
 > Cc: Peter Korsgaard <jacmet@sunsite.dk>
 > Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
 > ---
 >  drivers/gpio/gpio-mpc8xxx.c | 28 +++++++++++++++++++++++-----
 >  1 file changed, 23 insertions(+), 5 deletions(-)

 > diff --git a/drivers/gpio/gpio-mpc8xxx.c b/drivers/gpio/gpio-mpc8xxx.c
 > index 57eb794..a6952ba3 100644
 > --- a/drivers/gpio/gpio-mpc8xxx.c
 > +++ b/drivers/gpio/gpio-mpc8xxx.c
 > @@ -40,6 +40,7 @@ struct mpc8xxx_gpio_chip {
 >  	 */
 >  	u32 data;
 >  	struct irq_domain *irq;
 > +	unsigned int irqn;
 >  	const void *of_dev_id_data;
 >  };
 
 > @@ -350,13 +351,14 @@ static int mpc8xxx_probe(struct platform_device *pdev)
 >  	struct of_mm_gpio_chip *mm_gc;
 >  	struct gpio_chip *gc;
 >  	const struct of_device_id *id;
 > -	unsigned hwirq;
 >  	int ret;
 
 >  	mpc8xxx_gc = devm_kzalloc(&pdev->dev, sizeof(*mpc8xxx_gc), GFP_KERNEL);
 >  	if (!mpc8xxx_gc)
 >  		return -ENOMEM;
 
 > +	platform_set_drvdata(pdev, mpc8xxx_gc);
 > +
 >  	spin_lock_init(&mpc8xxx_gc->lock);
 
 >  	mm_gc = &mpc8xxx_gc->mm_gc;
 > @@ -377,8 +379,8 @@ static int mpc8xxx_probe(struct platform_device *pdev)
 >  	if (ret)
 >  		return ret;
 
 > -	hwirq = irq_of_parse_and_map(np, 0);
 > -	if (hwirq == NO_IRQ)
 > +	mpc8xxx_gc->irqn = irq_of_parse_and_map(np, 0);
 > +	if (mpc8xxx_gc->irqn == NO_IRQ)
 >  		return 0;


With this return 0 converted to do of_mm_gpiochip_remove():

Acked-by: Peter Korsgaard <peter@korsgaard.com>

-- 
Bye, Peter Korsgaard
