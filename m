Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750997AbaLXA4F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 19:56:05 -0500
Received: from smtprelay0141.hostedemail.com ([216.40.44.141]:34921 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750708AbaLXA4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 19:56:03 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:69:152:355:379:541:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1543:1593:1594:1711:1730:1747:1777:1792:1801:2393:2553:2559:2562:3138:3139:3140:3141:3142:3354:3622:3865:3866:3867:3868:3870:3872:4250:4321:4605:5007:6261:7514:10004:10400:10848:11026:11232:11473:11658:11914:12043:12291:12438:12517:12519:12555:12683:12740:13255:13894:13972:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: lip87_51939fb1e2125
X-Filterd-Recvd-Size: 4307
Message-ID: <1419382559.6157.1.camel@perches.com>
Subject: Re: [PATCH] Drivers: bcma: Fix three coding style issues, more than
 80 characters per line.
From: Joe Perches <joe@perches.com>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: Oscar Forner Martinez <oscar.forner.martinez@gmail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 23 Dec 2014 16:55:59 -0800
In-Reply-To: <CACna6rwTwrZurN+bgerQu_UPsTTv=1iB-C3_MeMiQN0GSyDoMg@mail.gmail.com>
References: <1419378909-14414-1-git-send-email-oscar.forner.martinez@gmail.com>
	 <CACna6rwTwrZurN+bgerQu_UPsTTv=1iB-C3_MeMiQN0GSyDoMg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-12-24 at 00:46 +0100, Rafał Miłecki wrote:
> On 24 December 2014 at 00:55, Oscar Forner Martinez
> <oscar.forner.martinez@gmail.com> wrote:
> > Three lines with more than 80 characters per line have been split in several lines.
> >
> > Signed-off-by: Oscar Forner Martinez <oscar.forner.martinez@gmail.com>
> > ---
> >  drivers/bcma/driver_chipcommon.c | 10 +++++++---
> >  1 file changed, 7 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/bcma/driver_chipcommon.c b/drivers/bcma/driver_chipcommon.c
[]
> > -               bcma_err(cc->core->bus, "serial not supported on this device ccrev: 0x%x\n", ccrev);
> > +               bcma_err(cc->core->bus,
> > +                        "serial not supported on this device ccrev: 0x%x\n",
> > +                        ccrev);
> 
> I think some subsystems agreed to keep dev/bus pointed and string in
> the one line. It makes more sense for me too.

And it would probably be better to invert the test above
and error out immediately to reduce the indentation.

Something like:

 drivers/bcma/driver_chipcommon.c | 42 +++++++++++++++++++++-------------------
 1 file changed, 22 insertions(+), 20 deletions(-)

diff --git a/drivers/bcma/driver_chipcommon.c b/drivers/bcma/driver_chipcommon.c
index 19f6796..e63fabfc 100644
--- a/drivers/bcma/driver_chipcommon.c
+++ b/drivers/bcma/driver_chipcommon.c
@@ -316,29 +316,31 @@ void bcma_chipco_serial_init(struct bcma_drv_cc *cc)
 	unsigned int ccrev = cc->core->id.rev;
 	struct bcma_serial_port *ports = cc->serial_ports;
 
-	if (ccrev >= 11 && ccrev != 15) {
-		baud_base = bcma_chipco_get_alp_clock(cc);
-		if (ccrev >= 21) {
-			/* Turn off UART clock before switching clocksource. */
-			bcma_cc_write32(cc, BCMA_CC_CORECTL,
-				       bcma_cc_read32(cc, BCMA_CC_CORECTL)
-				       & ~BCMA_CC_CORECTL_UARTCLKEN);
-		}
-		/* Set the override bit so we don't divide it */
-		bcma_cc_write32(cc, BCMA_CC_CORECTL,
-			       bcma_cc_read32(cc, BCMA_CC_CORECTL)
-			       | BCMA_CC_CORECTL_UARTCLK0);
-		if (ccrev >= 21) {
-			/* Re-enable the UART clock. */
-			bcma_cc_write32(cc, BCMA_CC_CORECTL,
-				       bcma_cc_read32(cc, BCMA_CC_CORECTL)
-				       | BCMA_CC_CORECTL_UARTCLKEN);
-		}
-	} else {
-		bcma_err(cc->core->bus, "serial not supported on this device ccrev: 0x%x\n", ccrev);
+	if (ccrev < 11 || ccrev == 15) {
+		bcma_err(cc->core->bus,
+			 "serial not supported on this device ccrev: 0x%x\n",
+			 ccrev);
 		return;
 	}
 
+	baud_base = bcma_chipco_get_alp_clock(cc);
+	if (ccrev >= 21) {
+		/* Turn off UART clock before switching clocksource */
+		bcma_cc_write32(cc, BCMA_CC_CORECTL,
+				bcma_cc_read32(cc, BCMA_CC_CORECTL)
+				& ~BCMA_CC_CORECTL_UARTCLKEN);
+	}
+	/* Set the override bit so we don't divide it */
+	bcma_cc_write32(cc, BCMA_CC_CORECTL,
+			bcma_cc_read32(cc, BCMA_CC_CORECTL) |
+			BCMA_CC_CORECTL_UARTCLK0);
+	if (ccrev >= 21) {
+		/* Re-enable the UART clock */
+		bcma_cc_write32(cc, BCMA_CC_CORECTL,
+				bcma_cc_read32(cc, BCMA_CC_CORECTL)
+				| BCMA_CC_CORECTL_UARTCLKEN);
+	}
+
 	irq = bcma_core_irq(cc->core, 0);
 
 	/* Determine the registers of the UARTs */


