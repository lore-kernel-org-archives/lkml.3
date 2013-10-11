Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932170Ab3JKLVY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 07:21:24 -0400
Received: from mail1.bemta8.messagelabs.com ([216.82.243.209]:44621 "EHLO
	mail1.bemta8.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751358Ab3JKLVW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 07:21:22 -0400
X-Env-Sender: peter.korsgaard@barco.com
X-Msg-Ref: server-16.tower-46.messagelabs.com!1381490479!27965716!1
X-Originating-IP: [91.183.172.68]
X-StarScan-Received: 
X-StarScan-Version: 6.9.12; banners=-,-,-
X-VirusChecked: Checked
From: Peter Korsgaard <peter.korsgaard@barco.com>
To: Ionut Nicu <ioan.nicu.ext@nsn.com>
CC: Wolfram Sang <wsa@the-dreams.de>,
        Alexander Sverdlin <alexander.sverdlin@nsn.com>,
        <linux-i2c@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] i2c-mux-gpio: use gpio_set_value_cansleep()
References: <5257CE71.5060408@nsn.com>
X-message-flag: thor uptime: 541 days, 14:25, 10 users
Date: Fri, 11 Oct 2013 13:21:19 +0200
In-Reply-To: <5257CE71.5060408@nsn.com> (Ionut Nicu's message of "Fri, 11 Oct
	2013 12:09:53 +0200")
Message-ID: <87wqlkgij4.fsf@thor.barco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "IN" == Ionut Nicu <ioan.nicu.ext@nsn.com> writes:

IN> Some gpio chips may have get/set operations that
IN> can sleep. gpio_set_value() only works for chips
IN> which do not sleep, for the others we will get a
IN> kernel warning. Using gpio_set_value_cansleep()
IN> will work for both chips that do sleep and those
IN> who don't.

IN> Signed-off-by: Ionut Nicu <ioan.nicu.ext@nsn.com>
IN> ---
IN>  drivers/i2c/muxes/i2c-mux-gpio.c |    4 ++--
IN>  1 files changed, 2 insertions(+), 2 deletions(-)

IN> diff --git a/drivers/i2c/muxes/i2c-mux-gpio.c b/drivers/i2c/muxes/i2c-mux-gpio.c
IN> index a764da7..550e094 100644
IN> --- a/drivers/i2c/muxes/i2c-mux-gpio.c
IN> +++ b/drivers/i2c/muxes/i2c-mux-gpio.c
IN> @@ -30,8 +30,8 @@ static void i2c_mux_gpio_set(const struct gpiomux *mux, unsigned val)
IN>     int i;

IN>     for (i = 0; i < mux->data.n_gpios; i++)
IN> -           gpio_set_value(mux->gpio_base + mux->data.gpios[i],
IN> -                          val & (1 << i));
IN> +           gpio_set_value_cansleep(mux->gpio_base + mux->data.gpios[i],
IN> +                           val & (1 << i));

The indentation of the 2nd line seems wrong (should match
mux->gpio_base), otherwise it looks good:

Acked-by: Peter Korsgaard <peter.korsgaard@barco.com>

--
Sorry about disclaimer - It's out of my control.
Bye, Peter Korsgaard
This message is subject to the following terms and conditions: MAIL DISCLAIMER<http://www.barco.com/en/maildisclaimer>
