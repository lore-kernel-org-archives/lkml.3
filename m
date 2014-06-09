Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933212AbaFILXX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 07:23:23 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51008 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932283AbaFILXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 07:23:21 -0400
Date: Mon, 9 Jun 2014 13:23:11 +0200
From: Philipp Zabel <pza@pengutronix.de>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>,
        p.zabel@pengutronix.de, alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/9] reset: add the Berlin reset controller driver
Message-ID: <20140609112311.GA22176@pengutronix.de>
References: <1401983326-19205-1-git-send-email-antoine.tenart@free-electrons.com>
 <1401983326-19205-2-git-send-email-antoine.tenart@free-electrons.com>
 <53958D52.2050402@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53958D52.2050402@gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 13:12:02 up 47 days,  4:43, 31 users,  load average: 0,03, 0,10,
 0,08
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: pza@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sebastian,

On Mon, Jun 09, 2014 at 12:32:50PM +0200, Sebastian Hesselbarth wrote:
> I currently have no way to look it up myself, but is reset API providing
> a way to deal with phandle+specifier with more than one parameter?

You could provide a custom rcdev->of_xlate callback and encode
multiple phandle args into the reset line "index".

static int of_reset_xlate(struct reset_controller_dev *rcdev,
                          const struct of_phandle_args *reset_spec)
{
	return reset_spec->args[0] * 32 + reset_spec->args[1];
}

> Chip-ctrl has a bunch of other reset bits spread over the regset, having
> the offset encoded in the specifier would save us some SoC specific
> boiler plate, i.e.
> 
> reset = <&chip 0x104 14>;

That should be possible.

regards
Philipp
