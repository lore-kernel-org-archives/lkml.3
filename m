Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752004AbbAUIUy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 03:20:54 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49597 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754AbbAUIUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 03:20:48 -0500
Date: Wed, 21 Jan 2015 09:20:22 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Eddie Huang <eddie.huang@mediatek.com>
Cc: Wolfram Sang <wsa@the-dreams.de>,
        Matthias Brugger <matthias.bgg@gmail.com>, srv_heupstream@mediatek.com,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Jean Delvare <jdelvare@suse.de>, Arnd Bergmann <arnd@arndb.de>,
        Doug Anderson <dianders@chromium.org>,
        Andrew Bresticker <abrestic@chromium.org>,
        Max Schwarz <max.schwarz@online.de>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Anders Berg <anders.berg@avagotech.com>,
        Neelesh Gupta <neelegup@linux.vnet.ibm.com>,
        Wei Yan <sledge.yanwei@huawei.com>, Lee Jones <lee.jones@linaro.org>,
        Simon Glass <sjg@chromium.org>, Jim Cromie <jim.cromie@gmail.com>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Beniamino Galvani <b.galvani@gmail.com>,
        Xudong Chen <xudong.chen@mediatek.com>, linux-i2c@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, yingjoe.chen@mediatek.com,
        yh.chen@mediatek.com, Sascha Hauer <kernel@pengutronix.de>
Subject: Re: [PATCH v4 2/2] I2C: mediatek: Add driver for MediaTek I2C
 controller
Message-ID: <20150121082022.GT22880@pengutronix.de>
References: <1421404418-50718-1-git-send-email-eddie.huang@mediatek.com>
 <1421404418-50718-3-git-send-email-eddie.huang@mediatek.com>
 <20150118101816.GF22880@pengutronix.de>
 <1421810004.15468.825.camel@mtksdaap41>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1421810004.15468.825.camel@mtksdaap41>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Jan 21, 2015 at 11:13:24AM +0800, Eddie Huang wrote:
> > > +	/* set when doing the transfer */
> > > +	u16 irq_stat;			/* interrupt status */
> > > +	unsigned int speed_hz;		/* The speed in transfer */
> > > +	bool trans_stop;		/* i2c transfer stop */
> > > +	enum mtk_trans_op op;
> > > +	u16 msg_len;
> > > +	u8 *msg_buf;			/* pointer to msg data */
> > > +	u16 msg_aux_len;		/* WRRD mode to set AUX_LEN register*/
> > > +	u16 addr;	/* 7bit slave address, without read/write bit */
> > Wouldn't it be easier to maintain a pointer to the message to be
> > transferred?
> I think use mtk_i2c pointer is more flexible than maintain a pointer to
> message.
Not sure you understood what I intended to suggest. My idea was to drop

	u16 msg_len;
	u8 *msg_buf;
	u16 msg_aux_len; // maybe
	u16 addr;

from struct mtk_i2c and add a struct i2c_msg *msg instead. Up to you to
decide.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
