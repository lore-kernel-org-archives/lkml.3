Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932368Ab3LIIpI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 03:45:08 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33474 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760827Ab3LIIo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 03:44:56 -0500
Date: Mon, 9 Dec 2013 09:44:25 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: Sergei Ianovich <ynvich@gmail.com>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        James Cameron <quozl@laptop.org>,
        Russell King <linux@arm.linux.org.uk>, Jiri Slaby <jslaby@suse.cz>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Zhou Zhu <zzhu3@marvell.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Stefan Seyfried <seife+kernel@b1-systems.com>,
        John Crispin <blogic@openwrt.org>, Paul Bolle <pebolle@tiscali.nl>,
        "moderated list:ARM PORT" <linux-arm-kernel@lists.infradead.org>,
        "open list:SERIAL DRIVERS" <linux-serial@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>
Subject: Re: [PATCH v2] serial: rewrite pxa2xx-uart to use 8250_core
Message-ID: <20131209084425.GO24559@pengutronix.de>
Mail-Followup-To: Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sergei Ianovich <ynvich@gmail.com>, linux-kernel@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	James Cameron <quozl@laptop.org>,
	Russell King <linux@arm.linux.org.uk>, Jiri Slaby <jslaby@suse.cz>,
	Grant Likely <grant.likely@linaro.org>,
	Rob Herring <rob.herring@calxeda.com>, Zhou Zhu <zzhu3@marvell.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Haojian Zhuang <haojian.zhuang@gmail.com>,
	Stefan Seyfried <seife+kernel@b1-systems.com>,
	John Crispin <blogic@openwrt.org>, Paul Bolle <pebolle@tiscali.nl>,
	"moderated list:ARM PORT" <linux-arm-kernel@lists.infradead.org>,
	"open list:SERIAL DRIVERS" <linux-serial@vger.kernel.org>,
	"open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>
References: <1386286149-2855-1-git-send-email-ynvich@gmail.com>
 <1386321003-8960-1-git-send-email-ynvich@gmail.com>
 <20131209083815.GA5231@xps8300>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131209083815.GA5231@xps8300>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 09:41:38 up 106 days, 18:12, 43 users,  load average: 0.18, 0.13,
 0.12
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 09, 2013 at 10:38:15AM +0200, Heikki Krogerus wrote:
> Hi,
> 
> > +	return 0;
> > +
> > + err_clk:
> > +	clk_unprepare(data->clk);
> > + err_free_clk:
> > +	devm_clk_put(&pdev->dev, data->clk);
> > + err_free:
> > +	devm_kfree(&pdev->dev, data);
> 
> And there labels could be dropped.

This should really be fixed. Explicitly releasing devm_* allocated
resources invalidates the whole idea of the devm functions. People
looking for templates shouldn't find examples for this in the kernel.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
