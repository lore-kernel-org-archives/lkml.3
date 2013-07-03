Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756013Ab3GCLvI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 07:51:08 -0400
Received: from 6.mo2.mail-out.ovh.net ([87.98.165.38]:56378 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752503Ab3GCLvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 07:51:06 -0400
Date: Wed, 3 Jul 2013 13:10:16 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Boris BREZILLON <b.brezillon@overkiz.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-fbdev@vger.kernel.org
X-Ovh-Mailout: 178.32.228.2 (mo2.mail-out.ovh.net)
Subject: Re: [PATCH v2 4/4] at91/avr32/atmel_lcdfb: prepare clk before
 calling enable
Message-ID: <20130703111016.GM305@game.jcrosoft.org>
References: <1372147702-4074-1-git-send-email-b.brezillon@overkiz.com>
 <1372148053-4477-1-git-send-email-b.brezillon@overkiz.com>
 <51C951C2.8090901@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51C951C2.8090901@atmel.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 356347322541058924
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrleekucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrleekucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10:16 Tue 25 Jun     , Nicolas Ferre wrote:
> On 25/06/2013 10:14, Boris BREZILLON :
> >Replace clk_enable/disable with clk_prepare_enable/disable_unprepare to
> >avoid common clk framework warnings.
> >
> >Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
> 
> Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> 
> Jean-Christophe, can you take this one?

Yes I'll

Best Regards,
J.
> 
> Thanks, best regards,
> 
> >---
> >  drivers/video/atmel_lcdfb.c |    8 ++++----
> >  1 file changed, 4 insertions(+), 4 deletions(-)
> >
> >diff --git a/drivers/video/atmel_lcdfb.c b/drivers/video/atmel_lcdfb.c
> >index 540909d..8525457 100644
> >--- a/drivers/video/atmel_lcdfb.c
> >+++ b/drivers/video/atmel_lcdfb.c
> >@@ -893,14 +893,14 @@ static int __init atmel_lcdfb_init_fbinfo(struct atmel_lcdfb_info *sinfo)
> >
> >  static void atmel_lcdfb_start_clock(struct atmel_lcdfb_info *sinfo)
> >  {
> >-	clk_enable(sinfo->bus_clk);
> >-	clk_enable(sinfo->lcdc_clk);
> >+	clk_prepare_enable(sinfo->bus_clk);
> >+	clk_prepare_enable(sinfo->lcdc_clk);
> >  }
> >
> >  static void atmel_lcdfb_stop_clock(struct atmel_lcdfb_info *sinfo)
> >  {
> >-	clk_disable(sinfo->bus_clk);
> >-	clk_disable(sinfo->lcdc_clk);
> >+	clk_disable_unprepare(sinfo->bus_clk);
> >+	clk_disable_unprepare(sinfo->lcdc_clk);
> >  }
> >
> >
> >
> 
> 
> -- 
> Nicolas Ferre
