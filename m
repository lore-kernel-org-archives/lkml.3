Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752893Ab3JKXio (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 19:38:44 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:47689 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752549Ab3JKXil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 19:38:41 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+fZN0kgrWQaNkV3bg+9/s+
Date: Fri, 11 Oct 2013 16:38:33 -0700
From: Tony Lindgren <tony@atomide.com>
To: Sebastian Reichel <sre@debian.org>
Cc: Sebastian Reichel <sre@ring0.de>, linux-input@vger.kernel.org,
        "=?utf-8?Q?'Beno=C3=AEt?= Cousson'" <bcousson@baylibre.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org
Subject: Re: [PATCH 1/2] Input: twl4030_keypad - add device tree support
Message-ID: <20131011233833.GE29913@atomide.com>
References: <1381353447-32708-1-git-send-email-sre@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381353447-32708-1-git-send-email-sre@debian.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Sebastian Reichel <sre@debian.org> [131009 14:25]:
> Add device tree support for twl4030 keypad driver and update the
> Documentation with twl4030 keypad device tree binding information.
> 
> This patch also adds a twl4030 keypad node to the twl4030.dtsi file,
> so that board files can just add the keymap.
> 
> Tested on Nokia N900.

Nice :) Just few cosmetic comments below.
>  
> +#ifdef CONFIG_OF
> +static int twl4030_keypad_parse_dt(struct device *dev,
> +				 struct twl4030_keypad *keypad_data)
> +{

I guess the way to go nowadays is to use #IS_ENABLED(CONFIG_OF) here
and later on in this patch.

> @@ -331,20 +358,12 @@ static int twl4030_kp_program(struct twl4030_keypad *kp)
>  static int twl4030_kp_probe(struct platform_device *pdev)
>  {
>  	struct twl4030_keypad_data *pdata = pdev->dev.platform_data;
> -	const struct matrix_keymap_data *keymap_data;
> +	const struct matrix_keymap_data *keymap_data = NULL;
>  	struct twl4030_keypad *kp;
>  	struct input_dev *input;
>  	u8 reg;
>  	int error;
>  
> -	if (!pdata || !pdata->rows || !pdata->cols || !pdata->keymap_data ||
> -	    pdata->rows > TWL4030_MAX_ROWS || pdata->cols > TWL4030_MAX_COLS) {
> -		dev_err(&pdev->dev, "Invalid platform_data\n");
> -		return -EINVAL;
> -	}
> -
> -	keymap_data = pdata->keymap_data;
> -
>  	kp = kzalloc(sizeof(*kp), GFP_KERNEL);
>  	input = input_allocate_device();
>  	if (!kp || !input) {

I assume you have tested the above so it does not break things
for legacy booting?

Other than that:

Acked-by: Tony Lindgren <tony@atomide.com>
