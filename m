Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932206AbaHYL7Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 07:59:25 -0400
Received: from mail-by2lp0242.outbound.protection.outlook.com ([207.46.163.242]:11758
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755314AbaHYL7X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 07:59:23 -0400
Date: Mon, 25 Aug 2014 19:59:01 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Liu Ying <Ying.Liu@freescale.com>
CC: <linux-pwm@vger.kernel.org>, <thierry.reding@gmail.com>,
        <s.hauer@pengutronix.de>, <LW@KARO-electronics.de>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 3/3] pwm: i.MX: Avoid sample FIFO overflow for i.MX
 PWM version2
Message-ID: <20140825115628.GA7008@dragon>
References: <1401274213-8954-1-git-send-email-Ying.Liu@freescale.com>
 <1401274213-8954-3-git-send-email-Ying.Liu@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1401274213-8954-3-git-send-email-Ying.Liu@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(979002)(6009001)(199003)(189002)(24454002)(51704005)(19580395003)(77982001)(21056001)(102836001)(76482001)(54356999)(20776003)(81156004)(107046002)(47776003)(110136001)(44976005)(33656002)(79102001)(19580405001)(99396002)(6806004)(46102001)(74662001)(31966008)(85306004)(33716001)(105606002)(97736001)(87936001)(83322001)(92726001)(106466001)(81342001)(92566001)(81542001)(64706001)(86362001)(26826002)(84676001)(50986999)(68736004)(57986006)(23756003)(85852003)(69596002)(90102001)(76176999)(104016003)(95666004)(83072002)(83506001)(4396001)(74502001)(80022001)(50466002)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB524;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 03142412E2
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Shawn.Guo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2014 at 06:50:13PM +0800, Liu Ying wrote:
> The i.MX PWM version2 is embedded in several i.MX SoCs,
> such as i.MX27, i.MX51 and i.MX6SL.  There is a 4-word(16bit)
> sample FIFO in this IP.  Each FIFO slot determines the duty
> period of a PWM waveform in one full cycle.  The IP spec
> mentions that we should not write a fourth sample because
> the FIFO will become full and triggers a FIFO write error
> (FWE) which will prevent the PWM from starting once it is
> enabled.  In order to avoid any sample FIFO overflow issue,
> this patch clears all sample FIFO by doing software reset
> in the configuration hook when the controller is disabled
> or waits for a full PWM cycle to get a relinquished FIFO
> slot when the controller is enabled and the FIFO is fully
> loaded.
> 
> The FIFO overflow issue can be reproduced by the following
> commands on the i.MX6SL EVK platform, assuming we use PWM2
> for the debug LED which is driven by the pin HSIC_STROBE
> and the maximal brightness is 255.
> echo 0   > /sys/class/leds/user/brightness
> echo 0   > /sys/class/leds/user/brightness
> echo 0   > /sys/class/leds/user/brightness
> echo 0   > /sys/class/leds/user/brightness
> echo 255 > /sys/class/leds/user/brightness
> Here, FWE happens(PWMSR register reads 0x58) and the LED
> can not be lighten.
> 
> Another way to reproduce the FIFO overflow issue is to run
> this script:
> while true;
> 	do echo 255 > /sys/class/leds/user/brightness;
> done
> 
> Cc: Thierry Reding <thierry.reding@gmail.com>
> Cc: Sascha Hauer <s.hauer@pengutronix.de>
> Cc: Shawn Guo <shawn.guo@freescale.com>
> Cc: Lothar Waﬂmann <LW@KARO-electronics.de>
> Cc: linux-pwm@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org
> Signed-off-by: Liu Ying <Ying.Liu@freescale.com>

The whole series,

Acked-by: Shawn Guo <shawn.guo@freescale.com>

Thierry,

Can you pick them up if they look good to you?

Shawn
