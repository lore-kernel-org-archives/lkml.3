Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754313AbbAUXgO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 18:36:14 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:39705 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449AbbAUXgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 18:36:10 -0500
Message-ID: <54C037E6.1000208@roeck-us.net>
Date: Wed, 21 Jan 2015 15:36:06 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Doug Anderson <dianders@chromium.org>, Wim Van Sebroeck <wim@iguana.be>
CC: Heiko Stuebner <heiko@sntech.de>, Lunxue Dai <lunxue.dai@rock-chips.com>,
        Jisheng Zhang <jszhang@marvell.com>, Dinh Nguyen <dinguyen@altera.com>,
        linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] watchdog: dw_wdt: Try to get a 30 second watchdog
 by default
References: <1421882243-3631-1-git-send-email-dianders@chromium.org> <1421882243-3631-2-git-send-email-dianders@chromium.org>
In-Reply-To: <1421882243-3631-2-git-send-email-dianders@chromium.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020204.54C037E9.0142,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 18
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

On 01/21/2015 03:17 PM, Doug Anderson wrote:
> The dw_wdt_set_top() function takes in a value in seconds.  In
> dw_wdt_open() we were calling it with a value that's supposed to
> represent the maximum value programmed into the "top" register with a
> comment saying that we were trying to set the watchdog to its maximum
> value.  Instead we ended up setting the watchdog to ~15 seconds.
>
> Let's fix this.  However, setting things to the "max" gives me an 86
> second watchdog in the system I'm looking at.  86 seconds feels a
> little too long.  We'll explicitly choose 30 seconds as a more
> reasonable value.
>
> NOTE: Ideally this driver should be transitioned to be a real watchdog
> driver.  Then we could use "watchdog_init_timeout" and let the timeout
> be specified in a number of ways (device tree, module parameter, etc).
> This patch should be considered a bit of a stopgap solution.
>
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> ---

Reviewed-by: Guenter Roeck <linux@roeck-us.net>


