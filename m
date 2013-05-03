Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762649Ab3ECNqK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 09:46:10 -0400
Received: from nm5.access.bullet.mail.sp2.yahoo.com ([98.139.44.132]:41431
	"EHLO nm5.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762240Ab3ECNqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 09:46:08 -0400
X-Yahoo-Newman-Id: 55371.10300.bm@smtp114.sbc.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: WGVqOyYVM1ka36hGW89fXH6NAIjdTa4JM.5F44WlWp3Qiqi
 gx3XHP4X7w37teVbjXbBXftlquvFRtl4syizKsO0AbJR1F3upsd5qt.tjFqY
 aQn4jjkuACz9Vi9jTtIOPzfcC3v.7sJPEglORTacXc12ikeDMMMDb_zHVjY4
 R6szz7rp.fBdRWVpiiqs9X.QUc9y4EmMab7Sim26HoO.XtLb.DXuBNqiCiv4
 q0aZArgpfp0xlFlEOnbjx_4M7X7ZJuI5yDrZaMVoEjSQmdmmBHy.cMyzVSEb
 2cmIgKcLY.IKdd_lmHBmaSJTPmTYrUDQiGTz1Fl.D56ea864Y8hVab60xj2W
 LFor250.BSb2VFbaNivtbQ53fxo5EXKhB_VK5_VJIVU_gm13zVRS7JhPASfe
 RfjCsISBRa_mtX0E4ShU1QKMo2G1eKwuswVa5yTgLqtVNpxI58h10q0XINhG
 13bDzvJ1IH0UjN4UGQl1f3.BhUCyxoj27Icg-
X-Yahoo-SMTP: zfeO.4KswBCc_PdwTE8HfYDCQ1aNmIcSvQHkDP4uSDBNBSXeKQ--
X-Rocket-Received: from localhost (linux@108.223.40.66 with plain)
        by smtp114.sbc.mail.gq1.yahoo.com with SMTP; 03 May 2013 06:46:05 -0700 PDT
Date: Fri, 3 May 2013 06:46:10 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Dirk Eibach <dirk.eibach@gdsys.cc>
Cc: linux-kernel@vger.kernel.org, Kumar Gala <galak@kernel.crashing.org>,
        Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH] powerpc: Make Book E watchdog reset type configurable
Message-ID: <20130503134610.GA31037@roeck-us.net>
References: <1367505913-18970-1-git-send-email-dirk.eibach@gdsys.cc>
 <20130502161720.GA7797@roeck-us.net>
 <429ec64cf7c30a139db40eb20fd3e682@gdsys.cc>
 <20130503011741.GA23266@roeck-us.net>
 <7be2cb3417615ff206270a756c6422d6@gdsys.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7be2cb3417615ff206270a756c6422d6@gdsys.cc>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 03, 2013 at 10:33:13AM +0200, Dirk Eibach wrote:
> Hi Guenter,
> 
> >>>>diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
> >>>>index e89fc31..6048593 100644
> >>>>--- a/drivers/watchdog/Kconfig
> >>>>+++ b/drivers/watchdog/Kconfig
> >>>>@@ -1172,6 +1172,38 @@ config BOOKE_WDT_DEFAULT_TIMEOUT
> >>>>
> >>>>	  The value can be overridden by the wdt_period command-line
> >>>>parameter.
> >>>>
> >>>>+choice
> >>>>+	prompt "PowerPC Book-E Watchdog reset type"
> >>>>+	depends on BOOKE_WDT
> >>>>+	default BOOKE_WDT_RESET_CHIP
> >>>>+	help
> >>>>+	  Specify what kind of reset will be executed on watchdog
> >>>>timeout.
> >>>>+
> >>>Seems to me it would be much better to make this configurable via
> >>>platform data
> >>>and/or device tree.
> >>
> >>good catch. What do the device-tree gurus think to be a nice
> >>property name?
> 
> having a closer look, I realized booke_wdt is not device-tree based
> yet. Migrating it would come close to a rewrite, breaking
> compatibility for all current users. Sorry, this is way beyond the

Really ? I don't think making it a platform driver would be that hard,
or break anything.

> time I have for this project. So I suggest merging the change the
> way it is, as it is clearly an improvement.
> 
That will be up to Wim to decide.

Thanks,
Guenter
