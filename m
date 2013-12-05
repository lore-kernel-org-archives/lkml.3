Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756971Ab3LEQyq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 11:54:46 -0500
Received: from mail-ee0-f51.google.com ([74.125.83.51]:39513 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756973Ab3LEQyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 11:54:43 -0500
Date: Thu, 5 Dec 2013 16:54:39 +0000
From: Jamie Iles <jamie@jamieiles.com>
To: Alan Tull <delicious.quinoa@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-gpio@vger.kernel.org,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-doc@vger.kernel.org, Jamie Iles <jamie@jamieiles.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Heiko Stuebner <heiko@sntech.de>, Alan Tull <atull@altera.com>,
        Dinh Nguyen <dinguyen@altera.com>,
        Yves Vandervennet <rocket.yvanderv@gmail.com>
Subject: Re: [PATCH v8] gpio: add a driver for the Synopsys DesignWare APB
 GPIO block
Message-ID: <20131205165439.GB5924@maple>
References: <1386088876-29205-1-git-send-email-delicious.quinoa@gmail.com>
 <1386088876-29205-2-git-send-email-delicious.quinoa@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386088876-29205-2-git-send-email-delicious.quinoa@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

One minor comment below, otherwise looks great!

Signed-off-by: Jamie Iles <jamie@jamieiles.com>

Thanks,

Jamie

On Tue, Dec 03, 2013 at 10:41:16AM -0600, Alan Tull wrote:
> diff --git a/drivers/gpio/gpio-dwapb.c b/drivers/gpio/gpio-dwapb.c
> new file mode 100644
> index 0000000..e6dc61f
> --- /dev/null
> +++ b/drivers/gpio/gpio-dwapb.c
...
> +static unsigned int dwapb_gpio_nr_ports(struct device_node *of_node)
> +{
> +	unsigned int nr_ports = 0;
> +	struct device_node *np;
> +
> +	for_each_child_of_node(of_node, np)
> +		++nr_ports;
> +
> +	return nr_ports;
> +}

I notice that we now have of_get_child_count() which didn't exist when I 
first wrote the driver, we could use that now.
