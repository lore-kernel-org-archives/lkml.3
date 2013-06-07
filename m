Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756576Ab3FGQWH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 12:22:07 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:50418 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756518Ab3FGQWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 12:22:05 -0400
Date: Fri, 7 Jun 2013 18:21:57 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Wolfram Sang <wsa@the-dreams.de>, linux-i2c@vger.kernel.org,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Nicolas Pitre <nico@fluxnic.net>, Lior Amsalem <alior@marvell.com>,
        Maen Suleiman <maen@marvell.com>, Tawfik Bayouk <tawfik@marvell.com>,
        Shadi Ammouri <shadi@marvell.com>, Eran Ben-Avi <benavi@marvell.com>,
        Yehuda Yitschak <yehuday@marvell.com>,
        Nadav Haklai <nadavh@marvell.com>, Ike Pan <ike.pan@canonical.com>,
        Chris Van Hoof <vanhoof@canonical.com>,
        Dan Frazier <dann.frazier@canonical.com>,
        Leif Lindholm <leif.lindholm@arm.com>, Jon Masters <jcm@redhat.com>,
        David Marlin <dmarlin@redhat.com>, linux-kernel@vger.kernel.org,
        Zbigniew Bodek <zbb@semihalf.com>, Piotr Ziecik <kosmo@semihalf.com>
Subject: Re: [PATCH 1/2] i2c-mv64xxx: Add I2C Transaction Generator support
Message-ID: <20130607182157.34188f72@skate>
In-Reply-To: <1370619743-15245-2-git-send-email-gregory.clement@free-electrons.com>
References: <1370619743-15245-1-git-send-email-gregory.clement@free-electrons.com>
	<1370619743-15245-2-git-send-email-gregory.clement@free-electrons.com>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.1 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Gregory CLEMENT,

On Fri,  7 Jun 2013 17:42:22 +0200, Gregory CLEMENT wrote:

>  /* Driver states */
>  enum {
>  	MV64XXX_I2C_STATE_INVALID,
> @@ -110,6 +133,7 @@ struct mv64xxx_i2c_data {
>  	spinlock_t		lock;
>  	struct i2c_msg		*msg;
>  	struct i2c_adapter	adapter;
> +	int			bridge_enabled;

bool ?

> @@ -528,6 +652,7 @@ mv64xxx_of_config(struct mv64xxx_i2c_data *drv_data,
>  {
>  	u32 bus_freq, tclk;
>  	int rc = 0;
> +	const char *bridge_status;
>  
>  	/* CLK is mandatory when using DT to describe the i2c bus. We
>  	 * need to know tclk in order to calculate bus clock
> @@ -554,6 +679,15 @@ mv64xxx_of_config(struct mv64xxx_i2c_data *drv_data,
>  	 * So hard code the value to 1 second.
>  	 */
>  	drv_data->adapter.timeout = HZ;
> +
> +	/*
> +	 * Acquire information on Transaction Generator support.
> +	 */
> +	bridge_status = of_get_property(np, "", NULL);

It is not clear to me what this new bridge_status local variable is
doing.

> +	if (of_property_read_bool(np, "i2c,i2c-bridge"))
> +		drv_data->bridge_enabled = 1;
> +	else
> +		drv_data->bridge_enabled = 0;

This could be written directly as:

	drv_data->bridge_enabled = of_property_read_bool(np, "i2c,i2c-bridge");

Thanks,

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
