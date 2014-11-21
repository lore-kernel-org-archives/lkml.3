Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555AbaKUNKO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 08:10:14 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38206 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751596AbaKUNKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 08:10:12 -0500
Date: Fri, 21 Nov 2014 14:10:08 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: Wolfram Sang <wsa@the-dreams.de>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sekhar Nori <nsekhar@ti.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Santosh Shilimkar <ssantosh@kernel.org>,
        Murali Karicheri <m-karicheri2@ti.com>
Subject: Re: [2/5] i2c: davinci: query STP always when NACK is received
Message-ID: <20141121131008.GQ27002@pengutronix.de>
References: <1416477788-5544-3-git-send-email-grygorii.strashko@ti.com>
 <20141120221953.GI27002@pengutronix.de>
 <546F34B9.1000206@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <546F34B9.1000206@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Nov 21, 2014 at 02:48:57PM +0200, Grygorii Strashko wrote:
> On 11/21/2014 12:19 AM, Uwe Kleine-König wrote:
> >> diff --git a/drivers/i2c/busses/i2c-davinci.c b/drivers/i2c/busses/i2c-davinci.c
> >> index 9bbfb8f..2cef115 100644
> >> --- a/drivers/i2c/busses/i2c-davinci.c
> >> +++ b/drivers/i2c/busses/i2c-davinci.c
> >> @@ -411,11 +411,9 @@ i2c_davinci_xfer_msg(struct i2c_adapter *adap, struct i2c_msg *msg, int stop)
> >>   	if (dev->cmd_err & DAVINCI_I2C_STR_NACK) {
> >>   		if (msg->flags & I2C_M_IGNORE_NAK)
> >>   			return msg->len;
> >> -		if (stop) {
> >> -			w = davinci_i2c_read_reg(dev, DAVINCI_I2C_MDR_REG);
> >> -			w |= DAVINCI_I2C_MDR_STP;
> >> -			davinci_i2c_write_reg(dev, DAVINCI_I2C_MDR_REG, w);
> >> -		}
> >> +		w = davinci_i2c_read_reg(dev, DAVINCI_I2C_MDR_REG);
> >> +		w |= DAVINCI_I2C_MDR_STP;
> >> +		davinci_i2c_write_reg(dev, DAVINCI_I2C_MDR_REG, w);
> > I think this is a good change, but I wonder if the handling of
> > I2C_M_IGNORE_NAK is correct here. If the controller reports a NACK say
> > for the 2nd byte of a 5-byte-message, the transfer supposed to
> > continue, right? (Hmm, maybe the framework handle this and restarts the
> > transfer with I2C_M_NOSTART but the davinci driver doesn't seem to
> > handle this flag?)
> 
> Have nothing to say about handling of I2C_M_IGNORE_NAK. I'm not going to
> change current behavior - davinci driver will interrupt transfer of i2c_msg always
>  in case of NACK and start transfer of the next i2c_msg (if exist).
> In my opinion, Above question is out of scope of this patch.
Yeah right, that's exactly what I thought.

Thinking again I wonder if with your change handling is correct when the
sender wants to do a repeated start. That would need a more detailed
look into the driver.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
