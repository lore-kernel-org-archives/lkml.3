Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757435Ab3APVcG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 16:32:06 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:50237 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756549Ab3APVcF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 16:32:05 -0500
Message-ID: <1358371862.6252.11.camel@cumari.coelho.fi>
Subject: Re: [PATCH] OMAP: omap4-panda: add WiLink shared transport power
 functions
From: Luciano Coelho <coelho@ti.com>
To: Fabio Estevam <festevam@gmail.com>
CC: <tony@atomide.com>, <linux-omap@vger.kernel.org>, <linux@arm.linux.org.uk>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Date: Wed, 16 Jan 2013 23:31:02 +0200
In-Reply-To: <CAOMZO5DtKT9wFvJz+nvJZRgR5aNf1xv9O7FOo4YocOoSsujQ=g@mail.gmail.com>
References: <1358368495-10499-1-git-send-email-coelho@ti.com>
	 <CAOMZO5DtKT9wFvJz+nvJZRgR5aNf1xv9O7FOo4YocOoSsujQ=g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-01-16 at 19:10 -0200, Fabio Estevam wrote:
> On Wed, Jan 16, 2013 at 6:34 PM, Luciano Coelho <coelho@ti.com> wrote:
> 
> > +static int wilink_st_init(void)
> > +{
> > +       int status;
> > +
> > +       status = gpio_request(GPIO_BT_EN, "kim");
> > +       if (status) {
> > +               pr_err("%s: failed to request gpio %d\n", __func__,
> > +                      GPIO_BT_EN);
> > +               return status;
> > +       }
> > +
> > +       status = gpio_direction_output(GPIO_BT_EN, 0);
> > +       if (status)
> > +               pr_err("%s: unable to configure gpio %d", __func__,
> > +                      GPIO_BT_EN);
> > +
> 
> You could use gpio_request_one() instead.

Good point.  I'll send v2 using this instead:

gpio_request_one(GPIO_BT_EN, GPIOF_OUT_INIT_LOW, "kim")

--
Luca.

