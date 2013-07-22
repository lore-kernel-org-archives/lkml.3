Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932557Ab3GVRU5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 13:20:57 -0400
Received: from 4.mo4.mail-out.ovh.net ([178.32.98.131]:53603 "EHLO
	mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932101Ab3GVRU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 13:20:56 -0400
X-Greylist: delayed 1047 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Jul 2013 13:20:56 EDT
Date: Mon, 22 Jul 2013 19:03:44 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Boris BREZILLON <b.brezillon@overkiz.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
X-Ovh-Mailout: 178.32.228.4 (mo4.mail-out.ovh.net)
Subject: Re: [PATCH v4 0/5] ARM: at91: prepare transition to common clk
 framework
Message-ID: <20130722170344.GK16015@ns203013.ovh.net>
References: <1374132753-15206-1-git-send-email-b.brezillon@overkiz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374132753-15206-1-git-send-email-b.brezillon@overkiz.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Ovh-Tracer-Id: 7357755891826797433
X-Ovh-Remote: 91.121.171.124 (ns203013.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeijedrfeefucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeijedrfeefucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09:32 Thu 18 Jul     , Boris BREZILLON wrote:
> Hello,
> 
> This patch series prepares the transition to common clk framework by
> replacing all the clk_enable and clk_disable calls by clk_prepare_unable and
> clk_disable_unprepare to avoid common clock framework warnings.
on the whole serie

Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>

> 
> Best Regards,
> Boris
> 
> Changes since v3:
>  - move usb clock config patches out of this series
>  - move clk_prepare/unprepare calls out of critical sections (ssc and
>    mci drivers)
>  - remove already applied spi clk_prepare patch 
> 
> Changes since v2:
>  - add configuraton of usb clock in ohci and udc drivers
>  - add clk_prepare patch for usba udc driver
>  - add clk_prepare patch for spi driver
>  - remove already applied udc clk_prepare patch
> 
> Changes since v1:
>  - remove unneeded clk_unprepare in mci driver
>  - remove already applied patches (ehci, ohci, dma and serial)
> 
> Changes since common clk patch series:
>  - add clk_prepare_enable return check
>  - fix a deadlock in atmel-mci (missing spin_unlock)
>  - remove already applied patches (atmel-ssc and pwm-atmel-tcb)
> 
> Boris BREZILLON (5):
>   ARM: at91/tc/clocksource: replace clk_enable/disable with
>     clk_prepare_enable/disable_unprepare.
>   mmc: atmel-mci: prepare clk before calling enable
>   at91/avr32/atmel_lcdfb: prepare clk before calling enable
>   USB: gadget: atmel_usba: prepare clk before calling enable
>   ASoC: atmel-ssc: remove clk_disable_unprepare call from critical
>     section
> 
>  drivers/clocksource/tcb_clksrc.c    |   10 +++++-----
>  drivers/misc/atmel-ssc.c            |   11 ++++++++---
>  drivers/mmc/host/atmel-mci.c        |   34 +++++++++++++++++++++++++++-------
>  drivers/usb/gadget/atmel_usba_udc.c |   28 +++++++++++++++++++++-------
>  drivers/video/atmel_lcdfb.c         |    8 ++++----
>  5 files changed, 65 insertions(+), 26 deletions(-)
> 
> -- 
> 1.7.9.5
> 
