Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753258AbaILI6p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 04:58:45 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40867 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753084AbaILI6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 04:58:44 -0400
Date: Fri, 12 Sep 2014 10:58:36 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-i2c@vger.kernel.org, Jean Delvare <jdelvare@suse.de>,
        Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-sh@vger.kernel.org
Subject: Re: [RFC 0/4] i2c: slave support framework for Linux devices
Message-ID: <20140912085836.GS3755@pengutronix.de>
References: <1410274470-12712-1-git-send-email-wsa@the-dreams.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1410274470-12712-1-git-send-email-wsa@the-dreams.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Wolfram,

On Tue, Sep 09, 2014 at 04:54:26PM +0200, Wolfram Sang wrote:
> Finally, here is my take on the often desired feature that Linux can not only
> be an I2C master, but also an I2C slave. Compared to my draft sent out last
> week, this RFC has been tested on hardware (Renesas Lager board) and works \o/
> 
> One big part still missing is documentation, so brave ones need to "use the
> source". However, this approach turned out to be even less intrusive than
> expected, so that is hopefully a good sign.
Some thoughts from reading through your patch set:

- If I understand correctly you cannot register an i2c slave without
  also registering a master, right? I don't think this is troubling in
  practice, is it?
  For abstraction I would prefer to make these different concepts
  though.

- The IMHO most (even only?) useful slave is "i2cslvdev", i.e. a
  userspace device. With that you wouldn't need device tree stuff, the
  driver would just offer the device if supported. Userspace then could
  care about the rest (slave address, functionality, ...).

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
