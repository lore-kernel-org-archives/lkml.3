Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763518Ab3ECUdc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 16:33:32 -0400
Received: from nm2-vm0.access.bullet.mail.sp2.yahoo.com ([98.139.44.158]:33362
	"EHLO nm2-vm0.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762019Ab3ECUdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 16:33:31 -0400
X-Yahoo-Newman-Id: 844983.95737.bm@smtp118.sbc.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: H4P3sQwVM1lxwPMmT3GT.FVIRPk.k7UVjYXD1kxDuPoSx1K
 mKIm3X_l92c0B3gDmnHgdMcE8aZKT..hir8GzkvfuinVPEXenXscSX5LsRlV
 2pQN4j0Cc42Tgr.JZWGKFUmlnETtX9khMAwIBkVKj.njBN1iGQXl3PGA1NPj
 _kskq3PtF6eDfrlCOcixjJCO6TVrdcZX3_xlyALcD7l_9z8M2kjGDme6h2OJ
 luypwVQsgqMBMA50W38Y00DPcvrHLMPqtmWuSc2ZAXdCRh4W2wFvz9jhw.Tf
 yYhEZXkd5qyl1mqN_tyHHpe47HLbhWs0wRkXzGtrEr5Oxy2vy_dzFj5VhOXg
 VXlPZH0_OojjfLKb0T4cDhSUpVy6okZSs1tKvLrTvu3DHYvsnskK8K_PCJrP
 _Sugjvz__bIZVggKtY_PzzQ2GUNY6aAzTnvVQw.M7__8kHR6B0MeAacYv40U
 DzwnC5ZtmoOFLSw11Wv_9xnVkGQHDY14lE_E-
X-Yahoo-SMTP: zfeO.4KswBCc_PdwTE8HfYDCQ1aNmIcSvQHkDP4uSDBNBSXeKQ--
X-Rocket-Received: from localhost (linux@108.223.40.66 with plain)
        by smtp118.sbc.mail.gq1.yahoo.com with SMTP; 03 May 2013 20:33:30 +0000 UTC
Date: Fri, 3 May 2013 13:33:35 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Dirk Eibach <dirk.eibach@gdsys.cc>
Cc: linux-kernel@vger.kernel.org, Kumar Gala <galak@kernel.crashing.org>,
        Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH] powerpc: Make Book E watchdog reset type configurable
Message-ID: <20130503203335.GA13417@roeck-us.net>
References: <1367505913-18970-1-git-send-email-dirk.eibach@gdsys.cc>
 <20130502161720.GA7797@roeck-us.net>
 <429ec64cf7c30a139db40eb20fd3e682@gdsys.cc>
 <20130503011741.GA23266@roeck-us.net>
 <7be2cb3417615ff206270a756c6422d6@gdsys.cc>
 <20130503134610.GA31037@roeck-us.net>
 <d735c13abccd6ba75fd65658ab94654d@gdsys.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d735c13abccd6ba75fd65658ab94654d@gdsys.cc>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 03, 2013 at 08:30:03PM +0200, Dirk Eibach wrote:
> 
> 
> Am 03.05.2013 15:46, schrieb Guenter Roeck:
> >On Fri, May 03, 2013 at 10:33:13AM +0200, Dirk Eibach wrote:
> >>Hi Guenter,
> >>
> >>>>>>diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
> >>>>>>index e89fc31..6048593 100644
> >>>>>>--- a/drivers/watchdog/Kconfig
> >>>>>>+++ b/drivers/watchdog/Kconfig
> >>>>>>@@ -1172,6 +1172,38 @@ config BOOKE_WDT_DEFAULT_TIMEOUT
> >>>>>>
> >>>>>>	  The value can be overridden by the wdt_period command-line
> >>>>>>parameter.
> >>>>>>
> >>>>>>+choice
> >>>>>>+	prompt "PowerPC Book-E Watchdog reset type"
> >>>>>>+	depends on BOOKE_WDT
> >>>>>>+	default BOOKE_WDT_RESET_CHIP
> >>>>>>+	help
> >>>>>>+	  Specify what kind of reset will be executed on watchdog
> >>>>>>timeout.
> >>>>>>+
> >>>>>Seems to me it would be much better to make this configurable via
> >>>>>platform data
> >>>>>and/or device tree.
> >>>>
> >>>>good catch. What do the device-tree gurus think to be a nice
> >>>>property name?
> >>
> >>having a closer look, I realized booke_wdt is not device-tree based
> >>yet. Migrating it would come close to a rewrite, breaking
> >>compatibility for all current users. Sorry, this is way beyond the
> >
> >Really ? I don't think making it a platform driver would be that hard,
> >or break anything.
> 
> Maybe I am missing something, but wouldn't making it a device-tree
> driver mean, that I would have to identify all users of BOOKE_WDT
> and add it to their device trees?
> 
Not necessarily; only if the platform driver doesn't auto-instantiate.
I'll play with it and see if I can get it working.

On the other side, that wouldn't be too bad either. As far as I can see
from a quick search, there is no default configuration in the upstream kernel
which has BOOKE_WDT enabled.

Guenter
