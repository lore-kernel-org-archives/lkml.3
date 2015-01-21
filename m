Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752100AbbAUIeu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 03:34:50 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:35202 "EHLO
	mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750812AbbAUIel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 03:34:41 -0500
X-Listener-Flag: 11101
Subject: Re: [PATCH v4 2/2] I2C: mediatek: Add driver for MediaTek I2C
 controller
From: Eddie Huang <eddie.huang@mediatek.com>
To: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
CC: Wolfram Sang <wsa@the-dreams.de>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        <srv_heupstream@mediatek.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
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
        Xudong Chen <xudong.chen@mediatek.com>, <linux-i2c@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <yingjoe.chen@mediatek.com>,
        <yh.chen@mediatek.com>, Sascha Hauer <kernel@pengutronix.de>
In-Reply-To: <20150121082022.GT22880@pengutronix.de>
References: <1421404418-50718-1-git-send-email-eddie.huang@mediatek.com>
	 <1421404418-50718-3-git-send-email-eddie.huang@mediatek.com>
	 <20150118101816.GF22880@pengutronix.de>
	 <1421810004.15468.825.camel@mtksdaap41>
	 <20150121082022.GT22880@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 21 Jan 2015 16:34:35 +0800
Message-ID: <1421829275.6546.6.camel@mtksdaap41>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
X-MTK: N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Uwe,

On Wed, 2015-01-21 at 09:20 +0100, Uwe Kleine-König wrote:
> Hello,
> 
> On Wed, Jan 21, 2015 at 11:13:24AM +0800, Eddie Huang wrote:
> > > > +	/* set when doing the transfer */
> > > > +	u16 irq_stat;			/* interrupt status */
> > > > +	unsigned int speed_hz;		/* The speed in transfer */
> > > > +	bool trans_stop;		/* i2c transfer stop */
> > > > +	enum mtk_trans_op op;
> > > > +	u16 msg_len;
> > > > +	u8 *msg_buf;			/* pointer to msg data */
> > > > +	u16 msg_aux_len;		/* WRRD mode to set AUX_LEN register*/
> > > > +	u16 addr;	/* 7bit slave address, without read/write bit */
> > > Wouldn't it be easier to maintain a pointer to the message to be
> > > transferred?
> > I think use mtk_i2c pointer is more flexible than maintain a pointer to
> > message.
> Not sure you understood what I intended to suggest. My idea was to drop
> 
> 	u16 msg_len;
> 	u8 *msg_buf;
> 	u16 msg_aux_len; // maybe
> 	u16 addr;
> 
> from struct mtk_i2c and add a struct i2c_msg *msg instead. Up to you to
> decide.
> 
Because this driver pass mtk_i2c pointer between functions, it's
flexible to use any member of struct mtk_i2c. The good thing is avoid
passing one more struct i2c_msg parameter between functions, or another
struct copy. The bad thing is make struct mtk_i2c larger. I prefer to
keep as it is now.

Best Regards
Eddie


