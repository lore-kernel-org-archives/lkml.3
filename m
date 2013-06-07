Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756770Ab3FGQZK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 12:25:10 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:50462 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754584Ab3FGQZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 12:25:05 -0400
Date: Fri, 7 Jun 2013 18:25:00 +0200
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
        Zbigniew Bodek <zbb@semihalf.com>
Subject: Re: [PATCH 1/2] i2c-mv64xxx: Fix timing issue on Armada XP (errata
 FE-8471889)
Message-ID: <20130607182500.10593e73@skate>
In-Reply-To: <1370620140-17177-2-git-send-email-gregory.clement@free-electrons.com>
References: <1370620140-17177-1-git-send-email-gregory.clement@free-electrons.com>
	<1370620140-17177-2-git-send-email-gregory.clement@free-electrons.com>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.1 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Gregory CLEMENT,

On Fri,  7 Jun 2013 17:48:59 +0200, Gregory CLEMENT wrote:

> +/*
> + * 5us delay in order to avoid repeated start
> + * timing violation on Armada XP SoC.
> + */
> +static int mv64xxx_i2c_errata_delay;

This should probably be a per-I2C controller variable, i.e in
mv64xxx_i2c_data.


> +	if (!mv64xxx_i2c_errata_delay &&
> +	    of_machine_is_compatible("marvell,armadaxp"))
> +		mv64xxx_i2c_errata_delay = 1;

I am wondering whether it should be done this way, or using a separate
DT property.

Best regards,

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
