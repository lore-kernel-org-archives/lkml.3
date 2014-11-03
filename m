Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753657AbaKCSCW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 13:02:22 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:58909 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753678AbaKCSCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 13:02:14 -0500
Date: Mon, 3 Nov 2014 10:01:50 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Felipe Balbi <balbi@ti.com>
Cc: myungjoo.ham@samsung.com, cw00.choi@samsung.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>, nsekhar@ti.com,
        grant.likely@linaro.org, George Cherian <george.cherian@ti.com>
Subject: Re: [PATCH 1/4] extcon: gpio: Convert the driver to use gpio desc
 API's
Message-ID: <20141103180150.GA10164@roeck-us.net>
References: <1415032350-8459-1-git-send-email-balbi@ti.com>
 <1415032350-8459-2-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415032350-8459-2-git-send-email-balbi@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020203.5457C325.01AA,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 4
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

On Mon, Nov 03, 2014 at 10:32:27AM -0600, Felipe Balbi wrote:
> From: George Cherian <george.cherian@ti.com>
> 
> Convert the driver to use gpiod_* API's.
> 
> Reviewed-by: Roger Quadros <rogerq@ti.com>
> Signed-off-by: George Cherian <george.cherian@ti.com>
> Signed-off-by: Sekhar Nori <nsekhar@ti.com>
> Signed-off-by: Felipe Balbi <balbi@ti.com>
> ---

I think it might be useful and appropriate to explain that and why
you remove support for active-low pins, instead of hiding it in a
seemingly unrelated patch.

Also, since you don't use the platform data flag anymore, you might
as well remove it to give out-of-tree users a fair warning. Overall,
it might be easier to just revert the patch introducing it (5bfbdc9caa7)
before converting extcon to gpiod.

I am just glad that we stopped using extcon for other reasons ;-)

Guenter
