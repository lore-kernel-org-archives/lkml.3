Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752056AbaEIE7c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 00:59:32 -0400
Received: from gn237.zone.eu ([217.146.67.237]:17113 "EHLO gn237.zone.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751124AbaEIE7b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 00:59:31 -0400
From: "Priit Laes" <plaes@plaes.org>
Message-ID: <1399611909.13870.0.camel@chi>
Subject: Re: [linux-sunxi] Re: [PATCH v2 3/7] mfd: add support for sun6i
 PRCM (Power/Reset/Clock Management) unit
To: linux-sunxi@googlegroups.com
Cc: Lee Jones <lee.jones@linaro.org>,
        Emilio =?ISO-8859-1?Q?L=F3pez?= <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Chen-Yu Tsai <wens@csie.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Shuge <shuge@allwinnertech.com>, kevin@allwinnertech.com,
        Hans de Goede <hdegoede@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, dev@linux-sunxi.org
Date: Fri, 09 May 2014 08:05:09 +0300
In-Reply-To: <536BE366.8080907@free-electrons.com>
References: <1399483554-8824-1-git-send-email-boris.brezillon@free-electrons.com>
	 <1399483554-8824-4-git-send-email-boris.brezillon@free-electrons.com>
	 <20140508110205.GB5767@lee--X1> <536BE366.8080907@free-electrons.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.12.1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ühel kenal päeval, N, 08.05.2014 kell 22:04, kirjutas Boris BREZILLON:
> On 08/05/2014 13:02, Lee Jones wrote:
> >> The PRCM (Power/Reset/Clock Management) block exposes several subdevices
> >> in different subsystems (clk, reset ...)
> >>
> >> Add basic support for the PRCM unit with clk (AR100, AHB0, and APB0 clks)
> >> and reset controller subdevices.
> >>
> >> Other subdevices might be added later (if needed).
> >>
> >> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
> >> ---
> >>  drivers/mfd/Kconfig      |   8 +++
> >>  drivers/mfd/Makefile     |   1 +
> >>  drivers/mfd/sun6i-prcm.c | 151 +++++++++++++++++++++++++++++++++++++++++++++++
> >>  3 files changed, 160 insertions(+)
> >>  create mode 100644 drivers/mfd/sun6i-prcm.c
> > [...]
> >
> >> +#include <linux/module.h>
> >> +#include <linux/kernel.h>
> >> +#include <linux/errno.h>
> >> +#include <linux/err.h>
> >> +#include <linux/spinlock.h>
> >> +#include <linux/io.h>
> >> +#include <linux/slab.h>
> >> +#include <linux/mutex.h>
> >> +#include <linux/completion.h>
> >> +#include <linux/irq.h>
> >> +#include <linux/jiffies.h>
> >> +#include <linux/bitops.h>
> >> +#include <linux/fs.h>
> >> +#include <linux/of.h>
> >> +#include <linux/of_irq.h>
> >> +#include <linux/platform_device.h>
> >> +#include <linux/uaccess.h>
> >> +#include <linux/mfd/core.h>
> > I'm pretty sure you don't need half of these.  Please only add the
> > ones you make use of.
> 
> Sure (this is what happens when you copy/paste from another driver :-))

Also, alphabetic order would be nice.

Päikest,
Priit Laes :)
