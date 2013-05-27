Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753780Ab3E0JE5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 05:04:57 -0400
Received: from mout.gmx.net ([212.227.15.19]:64469 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751885Ab3E0JEz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 05:04:55 -0400
X-Authenticated: #9962044
X-Provags-ID: V01U2FsdGVkX1/64ex3jaX6oYVtYOo1ufjQgk4q3e9l7f2+krK5D+
	nCtE1E9GqVahJs
From: Marc Dietrich <marvin24@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: GOTO Masanori <gotom@debian.or.jp>,
        YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 1/2] SCSI: nsp32: replace large udelay by mdelay
Date: Mon, 27 May 2013 11:04:48 +0200
Message-ID: <1772560.cdelMaBfqM@fb07-iapwap2.physik.uni-giessen.de>
User-Agent: KMail/4.10.2 (Linux/3.9.2-8.g04040b9-desktop; KDE/4.10.2; x86_64; ; )
In-Reply-To: <3402164.UHqBT8YQpR@fb07-iapwap2.physik.uni-giessen.de>
References: <cover.1369251478.git.marvin24@gmx.de> <495d02a8263a553dd3f67b354f5ec9beb784a5d3.1369251478.git.marvin24@gmx.de> <3402164.UHqBT8YQpR@fb07-iapwap2.physik.uni-giessen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="ISO-8859-1"
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James,

Am Mittwoch, 22. Mai 2013, 22:33:18 schrieb Marc Dietrich:
> Looks like Arnd already send a fix for this. Sorry for the noise.

are you going to pick up Arnd's patch [1] for scsi-stable (3.10) branch? 

Marc

[1] https://patchwork.kernel.org/patch/2489251/

> Am Mittwoch, 22. Mai 2013, 21:48:41 schrieb Marc Dietrich:
> > ARM has a maximum of 2000 usec delay. Use mdelay for larger delays.
> > This affects distro kernels mostly.
> > 
> > Cc: GOTO Masanori <gotom@debian.or.jp>
> > Cc: YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>
> > Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
> > Cc: linux-scsi@vger.kernel.org
> > Cc: linux-kernel@vger.kernel.org
> > Signed-off-by: Marc Dietrich <marvin24@gmx.de>
> > ---
> > 
> >  drivers/scsi/nsp32.c |    2 +-
> >  drivers/scsi/nsp32.h |    2 +-
> >  2 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/scsi/nsp32.c b/drivers/scsi/nsp32.c
> > index 1e3879d..e2f796f 100644
> > --- a/drivers/scsi/nsp32.c
> > +++ b/drivers/scsi/nsp32.c
> > @@ -2899,7 +2899,7 @@ static void nsp32_do_bus_reset(nsp32_hw_data *data)
> > 
> >  	 * reset SCSI bus
> >  	 */
> >  	
> >  	nsp32_write1(base, SCSI_BUS_CONTROL, BUSCTL_RST);
> > 
> > -	udelay(RESET_HOLD_TIME);
> > +	mdelay(RESET_HOLD_TIME);
> > 
> >  	nsp32_write1(base, SCSI_BUS_CONTROL, 0);
> >  	for(i = 0; i < 5; i++) {
> >  	
> >  		intrdat = nsp32_read2(base, IRQ_STATUS); /* dummy read */
> > 
> > diff --git a/drivers/scsi/nsp32.h b/drivers/scsi/nsp32.h
> > index c022182..b2b3dc6 100644
> > --- a/drivers/scsi/nsp32.h
> > +++ b/drivers/scsi/nsp32.h
> > @@ -605,7 +605,7 @@ typedef struct _nsp32_hw_data {
> > 
> >  /*
> >  
> >   * TIME definition
> >   */
> > 
> > -#define RESET_HOLD_TIME		10000	/* reset time in us (SCSI-2 says the
> > +#define RESET_HOLD_TIME		10	/* reset time in ms (SCSI-2 says the
> > 
> >  					   minimum is 25us) */
> >  
> >  #define SEL_TIMEOUT_TIME	10000	/* 250ms defined in SCSI specification
> >  
> >  					   (25.6us/1unit) */

