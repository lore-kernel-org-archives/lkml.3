Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760652Ab3EBQRT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 12:17:19 -0400
Received: from nm16-vm0.access.bullet.mail.sp2.yahoo.com ([98.139.44.166]:21954
	"EHLO nm16-vm0.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758223Ab3EBQRS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 12:17:18 -0400
X-Yahoo-Newman-Id: 453915.17765.bm@smtp120.sbc.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: i1kqaEAVM1nR3DW68xUDOnLzyduVqUTccAJnj596eb8goBw
 5_5ZUzDn6qSvzxnVrq4t50IhdadXqPEAoNF2D6HFGYEXUB4dFxB74e2R24hk
 MhJmSjSoDFzJOgA41xrrrOSTT6BcMM0T.lOvF8BAA9YNSEIrUxhz9aZIi_FV
 6BS2lSnfYpg05LBHRz6UcQlwGU_5xE4h_1EYC_X0oHjS2Ny6lPGXZ0V4twdm
 5r707Uq4EFdyxLXh2FMG4L8Z82.tN8Wshm6yIHAQm8zGZtqCn_2vJV5CLXwL
 HodvoBWRt5yhrUhC1OSU4KF31.04xS8cB4v8i1A79qZQI3IMtZ0WBsPW4Mln
 O.YvmF.1QN3rZ_0hMstRy5QziO3HGkcUj0UHaaRxVUkgFIXrsSoz29OcJt_z
 ItklqnL1rQ5M3qDRP7XtoitNAIluJmI7l6hWWHH64Tsds5NGp.jW84pWabqq
 nwsOGDsvq677mwAA_bYO9hfnknS3qhH_n
X-Yahoo-SMTP: zfeO.4KswBCc_PdwTE8HfYDCQ1aNmIcSvQHkDP4uSDBNBSXeKQ--
X-Rocket-Received: from localhost (linux@108.223.40.66 with plain)
        by smtp120.sbc.mail.gq1.yahoo.com with SMTP; 02 May 2013 16:17:17 +0000 UTC
Date: Thu, 2 May 2013 09:17:20 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: dirk.eibach@gdsys.cc
Cc: linux-kernel@vger.kernel.org, Kumar Gala <galak@kernel.crashing.org>,
        Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org
Subject: Re: [PATCH] powerpc: Make Book E watchdog reset type configurable
Message-ID: <20130502161720.GA7797@roeck-us.net>
References: <1367505913-18970-1-git-send-email-dirk.eibach@gdsys.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367505913-18970-1-git-send-email-dirk.eibach@gdsys.cc>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 02, 2013 at 04:45:13PM +0200, dirk.eibach@gdsys.cc wrote:
> From: Dirk Eibach <dirk.eibach@gdsys.cc>
> 
> Signed-off-by: Dirk Eibach <dirk.eibach@gdsys.cc>
> Cc: Kumar Gala <galak@kernel.crashing.org>
> Cc: Wim Van Sebroeck <wim@iguana.be>
> Cc: linux-watchdog@vger.kernel.org
> ---
>  drivers/watchdog/Kconfig     |   32 ++++++++++++++++++++++++++++++++
>  drivers/watchdog/booke_wdt.c |   10 +++++++++-
>  2 files changed, 41 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
> index e89fc31..6048593 100644
> --- a/drivers/watchdog/Kconfig
> +++ b/drivers/watchdog/Kconfig
> @@ -1172,6 +1172,38 @@ config BOOKE_WDT_DEFAULT_TIMEOUT
>  
>  	  The value can be overridden by the wdt_period command-line parameter.
>  
> +choice
> +	prompt "PowerPC Book-E Watchdog reset type"
> +	depends on BOOKE_WDT
> +	default BOOKE_WDT_RESET_CHIP
> +	help
> +	  Specify what kind of reset will be executed on watchdog timeout.
> +
Seems to me it would be much better to make this configurable via platform data 
and/or device tree.

Guenter
