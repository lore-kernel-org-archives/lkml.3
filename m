Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754915Ab3FRNCW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 09:02:22 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:42095 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106Ab3FRNCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 09:02:21 -0400
Date: Tue, 18 Jun 2013 15:02:16 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: dzu@denx.de, hjk@hansjkoch.de, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Allow binding drivers/uio/uio_pdrv_genirq.c to devices
 using command line option
Message-ID: <20130618130216.GB15122@amd.pavel.ucw.cz>
References: <20130412184335.GA5510@amd.pavel.ucw.cz>
 <20130617134741.GA15547@amd.pavel.ucw.cz>
 <20130617173738.GA14921@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130617173738.GA14921@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2013-06-17 10:37:38, Greg KH wrote:
> On Mon, Jun 17, 2013 at 03:47:41PM +0200, Pavel Machek wrote:
> > Hi!
> > 
> > > This adds ability to bind uio driver to given open firmware device
> > > using command line option. Thus, userspace driver can be developed and
> > > used without modifying the kernel.
> > > 
> > > Signed-off-by: Pavel Machek <pavel@denx.de> 
> > 
> > Ping? Greg, could you apply this patch? Or is there someone else I
> > should ask to apply it?
> 
> Ugh, Hans seems to have dropped off of the net for a long time now, so I
> guess I'll start queueing up UIO patches again.  Care to resend this?

Here you go. It still applies to your -next tree.

Thanks,
								Pavel
---

This adds ability to bind uio driver to given open firmware device
using command line option. Thus, userspace driver can be developed and
used without modifying the kernel.

Signed-off-by: Pavel Machek <pavel@denx.de> 
Tested-by: Detlev Zundel <dzu@denx.de>

diff --git a/drivers/uio/uio_pdrv_genirq.c b/drivers/uio/uio_pdrv_genirq.c
index c122bca..8fcc2c7 100644
--- a/drivers/uio/uio_pdrv_genirq.c
+++ b/drivers/uio/uio_pdrv_genirq.c
@@ -264,9 +275,13 @@ static const struct dev_pm_ops uio_pdrv_genirq_dev_pm_ops = {
 
 #ifdef CONFIG_OF
 static const struct of_device_id uio_of_genirq_match[] = {
-	{ /* empty for now */ },
+	{ /* This is filled with module_parm */ },
+	{ /* Sentinel */ },
 };
 MODULE_DEVICE_TABLE(of, uio_of_genirq_match);
+
+module_param_string(of_id, uio_of_genirq_match[0].compatible, 128, 0);
+MODULE_PARM_DESC(of_id, "Openfirmware id of the device to be handled by uio");
 #else
 # define uio_of_genirq_match NULL
 #endif

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
