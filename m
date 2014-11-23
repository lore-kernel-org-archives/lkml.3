Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752185AbaKWSwI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 13:52:08 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39412 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050AbaKWSwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 13:52:06 -0500
Date: Sun, 23 Nov 2014 19:52:00 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-i2c@vger.kernel.org, linux-sh@vger.kernel.org,
        Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
        Jean Delvare <jdelvare@suse.de>, Simon Horman <horms@verge.net.au>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/3] i2c: slave-eeprom: add eeprom simulator driver
Message-ID: <20141123185200.GD4431@pengutronix.de>
References: <1416326695-13083-1-git-send-email-wsa@the-dreams.de>
 <1416326695-13083-3-git-send-email-wsa@the-dreams.de>
 <20141121071941.GK27002@pengutronix.de>
 <20141121141624.GT27002@pengutronix.de>
 <20141122181406.GC9698@katana>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141122181406.GC9698@katana>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hallo Wolfram,

On Sat, Nov 22, 2014 at 07:14:06PM +0100, Wolfram Sang wrote:
> > > > +	case I2C_SLAVE_REQ_READ_END:
> > > > +		eeprom->buffer_idx++;
> > > You don't check here for buffer_idx >= ARRAY_SIZE(buffer)?
> > > Ditto in the I2C_SLAVE_REQ_WRITE_END case.
> > I just noticed that buffer_idx is an u8, so it overflows at 255+1. So
> > the probe routine should error out if size is bigger than 256.
> 
> But size is currently fixed to 256, so all is fine. Yes, if we extend it
> for bigger sizes, all that stuff needs to be taken care of, right.
yeah, it's well hidden, but true. So IMHO worth a comment.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
