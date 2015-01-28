Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761997AbbA1Usf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:48:35 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:35063 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756053AbbA1Us1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:48:27 -0500
Date: Wed, 28 Jan 2015 10:58:43 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Doug Anderson <dianders@chromium.org>
Cc: Wim Van Sebroeck <wim@iguana.be>, Heiko Stuebner <heiko@sntech.de>,
        Lunxue Dai <lunxue.dai@rock-chips.com>,
        Jisheng Zhang <jszhang@marvell.com>, Dinh Nguyen <dinguyen@altera.com>,
        linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] watchdog: dw_wdt: pat the watchdog before
 enabling it
Message-ID: <20150128185843.GB6730@roeck-us.net>
References: <1422397517-20426-1-git-send-email-dianders@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1422397517-20426-1-git-send-email-dianders@chromium.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020205.54C93177.0035,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 15
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
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

On Tue, Jan 27, 2015 at 02:25:16PM -0800, Doug Anderson wrote:
> On some dw_wdt implementations the "top" register may be initted to 0
> at bootup.  In such a case, each "pat" of the watchdog will reset the
> timer to 0xffff.  That's pretty short.
> 
> The input clock of the wdt can be any of a wide range of values.  On
> an rk3288 system, I've seen the wdt clock be 24.75 MHz.  That means
> each tick is ~40ns and we'll count to 0xffff in ~2.6ms.
> 
> Because of the above two facts, it's a really good idea to pat the
> watchdog after initting the "top" register properly and before
> enabling the watchdog.  If you don't then there's no way we'll get the
> next heartbeat in time.
> 
> Jisheng Zhang fixed this problem on some dw_wdt versions by using the
> TOP_INIT feature.  However, the dw_wdt on rk3288 doesn't have TOP_INIT
> so it's a good idea to also pat the watchdog manually.
> 
> Signed-off-by: Doug Anderson <dianders@chromium.org>

Reviewed-by: Guenter Roeck <linux@roeck-us.net>
