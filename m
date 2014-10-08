Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932463AbaJHP6d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 11:58:33 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:42475 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932324AbaJHP61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 11:58:27 -0400
Date: Wed, 8 Oct 2014 08:57:56 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@stlinux.com, wim@iguana.be, linux-watchdog@vger.kernel.org,
        David Paris <david.paris@st.com>
Subject: Re: [PATCH 4/4] watchdog: st_wdt: Add new driver for ST's LPC
 Watchdog
Message-ID: <20141008155756.GA17676@roeck-us.net>
References: <1412760810-23199-1-git-send-email-lee.jones@linaro.org>
 <1412760810-23199-5-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412760810-23199-5-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Suspect
X-CTCH-VOD: Unknown
X-CTCH-Flags: 512
X-CTCH-RefID: str=0001.0A020206.54355F23.0028,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=512,sb=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: 
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 2
X-CTCH-SenderID-TotalMessages: 3
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 3
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 08, 2014 at 10:33:30AM +0100, Lee Jones wrote:
> Signed-off-by: David Paris <david.paris@st.com>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/watchdog/Kconfig  |  16 +++
>  drivers/watchdog/Makefile |   1 +
>  drivers/watchdog/st_wdt.c | 317 ++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 334 insertions(+)
>  create mode 100644 drivers/watchdog/st_wdt.c
> 

Unfortunately (built with W=1):

drivers/watchdog/st_wdt.c: In function 'st_wdog_load_timer':
drivers/watchdog/st_wdt.c:114:14: warning: comparison between signed and
unsigned integer expressions [-Wsign-compare]
drivers/watchdog/st_wdt.c: In function 'st_wdog_remove':
drivers/watchdog/st_wdt.c:273:24: error: 'clk' undeclared (first use in this
function)

and checkpatch complains a bit: 

WARNING: please, no space before tabs
#303: FILE: drivers/watchdog/st_wdt.c:236:
+^Ist_wdog->dev ^I^I= &pdev->dev;$

WARNING: please, no space before tabs
#304: FILE: drivers/watchdog/st_wdt.c:237:
+^Ist_wdog->base ^I^I= base;$

WARNING: please, no space before tabs
#306: FILE: drivers/watchdog/st_wdt.c:239:
+^Ist_wdog->warm_reset ^I= of_property_read_bool(np, "st,warm_reset");$

Guenter
