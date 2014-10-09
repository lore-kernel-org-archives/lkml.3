Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756445AbaJIJFY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 05:05:24 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33207 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755436AbaJIJDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 05:03:40 -0400
Message-ID: <1412845410.6809.3.camel@pengutronix.de>
Subject: Re: [PATCH] reset: socfpga: use arch_initcall for early
 initialization
From: Philipp Zabel <p.zabel@pengutronix.de>
To: dinguyen@opensource.altera.com
Cc: dinh.linux@gmail.com, s.trumtrar@pengutronix.de, grant.likely@linaro.org,
        robh+dt@kernel.org, atull@opensource.altera.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 09 Oct 2014 11:03:30 +0200
In-Reply-To: <1412822646-11257-1-git-send-email-dinguyen@opensource.altera.com>
References: <1412822646-11257-1-git-send-email-dinguyen@opensource.altera.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.6-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:96de:80ff:fec2:9969
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, den 08.10.2014, 21:44 -0500 schrieb
dinguyen@opensource.altera.com:
> From: Dinh Nguyen <dinguyen@opensource.altera.com>
> 
> There are certain drivers that are required to get loaded very early using
> arch_initcall. An example of such a driver is the SOCFPGA's FPGA bridge driver.
> This driver has to get loaded early because it needs to enable FPGA components
> that are connected to the bridge.
> 
> This FPGA bridge driver will using the reset controller API to toggle it's
> reset bits, thus, it needs the reset driver to be loaded as early as possible
> in order for it to get used properly.

Without knowing the details, this sounds like the wrong approach. Can't
the bridge driver return -EPROBE_DEFER until the reset controller is
available?

regards
Philipp

