Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219AbaLALMF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 06:12:05 -0500
Received: from mail-la0-f47.google.com ([209.85.215.47]:65395 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753152AbaLALMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 06:12:00 -0500
From: Andrey Skvortsov <andrej.skvortzov@gmail.com>
X-Google-Original-From: Andrey Skvortsov <Andrej.Skvortzov@gmail.com>
Date: Mon, 1 Dec 2014 14:11:25 +0300
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPI / WAKEUP : enable wakeup power for physical child
 devices
Message-ID: <20141201111125.GA11974@localhost.localdomain>
Mail-Followup-To: Andrey Skvortsov <Andrej.Skvortzov@gmail.com>,
	"Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-acpi@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <1416139801-6537-1-git-send-email-Andrej.Skvortzov@gmail.com>
 <2396976.mWgWcINWd3@vostro.rjw.lan>
 <20141130172401.GC5215@crion89>
 <1446027.JMxKZRkq7f@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1446027.JMxKZRkq7f@vostro.rjw.lan>
X-PGP-Key: fp="21AF 2E6F 04EC 7E11 21C6  E399 2236 2F26 57A3 AEAD";
 id="0x57A3AEAD";
 get=<hkp://pgp.mit.edu/pks/lookup?search=0x22362F2657A3AEAD&op=get>;
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 01, 2014 at 02:15:36AM +0100, Rafael J. Wysocki wrote:

> > > 
> > > -> dev->wakeup.prepare_count here shold be different from 0 at this point.
> > 
> > Thank you very much for the tip. I checked prepare_count, it was 0.
> > I tried fix that and patched ssb and b44 drivers, that are used for my Ethernet card.
> > The code is below. Is this a better way to solve this problem? 
> 
> Having a cursory look at the changes only, I think so.

Thank you, then I will format the patch in a proper way and submit it.

> > diff --git a/drivers/net/ethernet/broadcom/b44.c b/drivers/net/ethernet/broadcom/b44.c
> > index 416620f..ebac411 100644
> > --- a/drivers/net/ethernet/broadcom/b44.c
> > +++ b/drivers/net/ethernet/broadcom/b44.c
> > @@ -2103,7 +2103,9 @@ static int b44_set_wol(struct net_device *dev, struct ethtool_wolinfo *wol)
> >  	else
> >  		bp->flags &= ~B44_FLAG_WOL_ENABLE;

-- 
Best regards,
Andrey Skvortsov

PGP Key ID: 0x57A3AEAD
