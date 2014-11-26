Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345AbaKZQEf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 11:04:35 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41954 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028AbaKZQEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 11:04:33 -0500
Date: Wed, 26 Nov 2014 17:04:07 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: Wolfram Sang <wsa@the-dreams.de>, Sekhar Nori <nsekhar@ti.com>,
        linux-i2c@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Mike Looijmans <milo-software@users.sourceforge.net>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Santosh Shilimkar <ssantosh@kernel.org>,
        Murali Karicheri <m-karicheri2@ti.com>, devicetree@vger.kernel.org
Subject: Re: [PATCH v2 5/5] i2c: davinci: use ICPFUNC to toggle I2C as gpio
 for bus recovery
Message-ID: <20141126160407.GN4431@pengutronix.de>
References: <1417010393-30598-1-git-send-email-grygorii.strashko@ti.com>
 <1417010393-30598-6-git-send-email-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1417010393-30598-6-git-send-email-grygorii.strashko@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Nov 26, 2014 at 03:59:53PM +0200, Grygorii Strashko wrote:
> Having a board where the I2C bus locks up occasionally made it clear
> that the bus recovery in the i2c-davinci driver will only work on
> some boards, because on regular boards, this will only toggle GPIO
> lines that aren't muxed to the actual pins.
> 
> The I2C controller on SoCs like da850 (and da830), Keystone 2 has the
> built-in capability to bit-bang its lines by using the ICPFUNC registers
> of the i2c controller.
> Implement the suggested procedure by toggling SCL and checking SDA using
> the ICPFUNC registers of the I2C controller when present. Allow platforms
> to indicate the presence of the ICPFUNC registers with a has_pfunc platform
> data flag and add optional DT property "ti,has-pfunc" to indicate
> the same in DT.
On what does it depend if this pfunc stuff works or not? Only the SoC,
or also on some board specific properties? Given the former using the
compatible string to detect its availability would be better. (In this
case also sorry, didn't consider this case when requesting the property
in the last round.)

The patch looks ok.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
