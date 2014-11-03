Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751783AbaKCWwU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 17:52:20 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:35559 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113AbaKCWwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 17:52:18 -0500
Date: Mon, 3 Nov 2014 14:52:13 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Chris Zhong <zyw@rock-chips.com>,
        Zhang Qing <zhangqing@rock-chips.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH v3 19/47] mfd: rk808: Register power-off handler with
 kernel power-off handler
Message-ID: <20141103225213.GB18594@roeck-us.net>
References: <1414425354-10359-1-git-send-email-linux@roeck-us.net>
 <1414425354-10359-20-git-send-email-linux@roeck-us.net>
 <20141103175346.GI12011@x1>
 <20141103190602.GE10558@roeck-us.net>
 <20141103224227.GF13359@x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141103224227.GF13359@x1>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020206.54580722.00BA,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 10
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

On Mon, Nov 03, 2014 at 10:42:27PM +0000, Lee Jones wrote:
> On Mon, 03 Nov 2014, Guenter Roeck wrote:
> 
> > On Mon, Nov 03, 2014 at 05:53:46PM +0000, Lee Jones wrote:
> > > On Mon, 27 Oct 2014, Guenter Roeck wrote:
> > > 
> > > > Register with kernel power-off handler instead of setting pm_power_off
> > > > directly. Register with low priority to reflect that the original code
> > > > only sets pm_power_off if it was not already set.
> > > > 
> > > > Cc: Chris Zhong <zyw@rock-chips.com>
> > > > Cc: Zhang Qing <zhangqing@rock-chips.com>
> > > > Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> > > > ---
> > > > v3:
> > > > - Replace poweroff in all newly introduced variables and in text
> > > >   with power_off or power-off as appropriate
> > > > - Replace POWEROFF_PRIORITY_xxx with POWER_OFF_PRIORITY_xxx
> > > > v2:
> > > > - New patch
> > > > 
> > > >  drivers/mfd/rk808.c       | 30 ++++++++++++++++--------------
> > > >  include/linux/mfd/rk808.h |  2 ++
> > > >  2 files changed, 18 insertions(+), 14 deletions(-)
> > > 
> > > Code looks okay:
> > > 
> > > Acked-by: Lee Jones <lee.jones@linaro.org>
> > > 
> > Thanks!
> > 
> > > ... but how are you thinking about handling this set?
> > > 
> > 
> > Plan is to send the entire series directly to Linus in the next
> > commit window, as suggested by several of the affected maintainers.
> > 
> > I am still missing an Ack for patch 1 of the series. If/when I get
> > that, I'll set up the series except for the last patch to be added
> > to linux-next for it to get some exposure.
> > 
> > Of course, that plan may all fall apart if someone objects. In that case,
> > the patches would have to be taken over several releases by the individual
> > maintainers.
> 
> Very well.  Either is okay with me.  It might also be worth
> considering speaking to Linus and requesting permission to send during
> -rc1 to minimise the risk of a huge number of conflicts.
> 
That sounds like a good idea. I may have to split the patches into two
parts anyway, to catch any new code setting pm_power_off directly. Maybe 
the first part can go in during the commit window and the final part
after -rc1.

Thanks,
Guenter
