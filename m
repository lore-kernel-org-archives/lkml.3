Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933349Ab3ECP7Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 11:59:25 -0400
Received: from nm16.access.bullet.mail.mud.yahoo.com ([66.94.237.217]:20296
	"EHLO nm16.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932459Ab3ECP7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 11:59:24 -0400
X-Yahoo-Newman-Id: 918896.67067.bm@smtp107.sbc.mail.ne1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 93uXoWEVM1lYieju3GJpKp8OpCEvjAK6QcZxW8PKhGk083_
 rmjkkN_plpHpM3gPIeqrVqRRG3LIZgm0ZYoHEVJdbLhbB39PQDlgTWlpyQ5D
 8AaB9JQyHcgePKkgIie5DBklZlXbRN9d3YlZuS9q1oyQdJy.Apr4b_Su6qUe
 XKDtFTefjRhUcM_cdclrxxzExPEAxdLTcqHRimV43iPWCVY.5RGTeIE1X_P1
 6mqUFOK135wUxA6ccW46llldoQeT4Y6vz0HBCRD7KGnbHJRs8USnr4n8p8Te
 6nz6vK5ievEf2jJZ2E4O.aL87Kc2OnkCN8RWaOPX8wQh9xfy0BDGJo7fiUgj
 v1d0TCtobCfyNeM..RB.rMX30PdrcbiVLwJTG8d_Guom5Dl4Yp_JDevJ5CnH
 Fa90tpKJCetefzzclHCa5C1iCEyLaoDVTVZEUiFvEey3EJJM80eIKbssOXeW
 tSFNCIJE92lsT7bbhlhcxCutGDYeViSoC9xk-
X-Yahoo-SMTP: zfeO.4KswBCc_PdwTE8HfYDCQ1aNmIcSvQHkDP4uSDBNBSXeKQ--
X-Rocket-Received: from localhost (linux@108.223.40.66 with plain)
        by smtp107.sbc.mail.ne1.yahoo.com with SMTP; 03 May 2013 08:59:23 -0700 PDT
Date: Fri, 3 May 2013 08:59:27 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Dirk Eibach <dirk.eibach@gdsys.cc>
Cc: linux-kernel@vger.kernel.org, Kumar Gala <galak@kernel.crashing.org>,
        Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH] powerpc: Make Book E watchdog reset type configurable
Message-ID: <20130503155927.GA8695@roeck-us.net>
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
> time I have for this project. So I suggest merging the change the
> way it is, as it is clearly an improvement.
> 
I sent a couple of RFC patches converting the driver to a platform driver and
adding of support to linux-watchdog and linux-kernel mailing lists.
Compile tested only, and missing is automatic driver instantiation.

Guenter
