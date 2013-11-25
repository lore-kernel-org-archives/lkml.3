Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516Ab3KYMBr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 07:01:47 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:56029 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753344Ab3KYMBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 07:01:42 -0500
Date: Mon, 25 Nov 2013 12:01:25 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Heiko =?utf-8?Q?St=C3=BCbner?= <heiko@sntech.de>
Cc: Alessandro Zummo <a.zummo@towertech.it>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        Mike Turquette <mturquette@linaro.org>
Subject: Re: [PATCH 2/2] rtc: add hym8563 rtc-driver
Message-ID: <20131125120125.GD32081@e106331-lin.cambridge.arm.com>
References: <201311222254.07730.heiko@sntech.de>
 <201311222255.48943.heiko@sntech.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201311222255.48943.heiko@sntech.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[...]

> +static int hym8563_probe(struct i2c_client *client,
> +                        const struct i2c_device_id *id)
> +{
> +       struct hym8563 *hym8563;
> +       int ret, gpio_int;
> +
> +       hym8563 = devm_kzalloc(&client->dev, sizeof(hym8563), GFP_KERNEL);
> +       if (!hym8563)
> +               return -ENOMEM;
> +
> +       hym8563->client = client;
> +       i2c_set_clientdata(client, hym8563);
> +
> +       device_set_wakeup_capable(&client->dev, true);
> +
> +       gpio_int = of_get_gpio(client->dev.of_node, 0);
> +       if (!gpio_is_valid(gpio_int)) {
> +               dev_err(&client->dev, "failed to get interrupt gpio\n");
> +               return -EINVAL;
> +       }
> +
> +       ret = devm_gpio_request_one(&client->dev, gpio_int,
> +                                     GPIOF_DIR_IN, "hym8563_int");
> +       if (ret) {
> +               dev_err(&client->dev, "request of gpio %d failed, %d\n",
> +                       gpio_int, ret);
> +               return ret;
> +       }

>From here on the gpio is never used or even stashed away anywhere.
What's the point in requesting it and then leaking it?

Thanks,
Mark.
