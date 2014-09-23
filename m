Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783AbaIWHrz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 03:47:55 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:19218 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752738AbaIWHry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 03:47:54 -0400
Date: Tue, 23 Sep 2014 15:45:01 +0800
From: Jisheng Zhang <jszhang@marvell.com>
To: Guenter Roeck <linux@roeck-us.net>
CC: "wim@iguana.be" <wim@iguana.be>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/2] watchdog: dw_wdt: restart the counter immediately
 after enabling WDT
Message-ID: <20140923154501.50dc8111@xhacker>
In-Reply-To: <541D867C.6080407@roeck-us.net>
References: <1411108199-1280-1-git-send-email-jszhang@marvell.com>
	<1411108199-1280-2-git-send-email-jszhang@marvell.com>
	<541D867C.6080407@roeck-us.net>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.28,0.0.0000
 definitions=2014-09-23_03:2014-09-23,2014-09-23,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1409230081
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Guenter,

On Sat, 20 Sep 2014 06:51:56 -0700
Guenter Roeck <linux@roeck-us.net> wrote:

> On 09/18/2014 11:29 PM, Jisheng Zhang wrote:
> > The TOP_INIT may be zero, so the timeout period may be very short after
> > initialization is done, thus the system may be reset soon after enabling.
> > We fix this problem by restarting the counter immediately after enabling
> > WDT.
> >
> > Signed-off-by: Jisheng Zhang <jszhang@marvell.com>
> > ---
> >   drivers/watchdog/dw_wdt.c | 1 +
> >   1 file changed, 1 insertion(+)
> >
> > diff --git a/drivers/watchdog/dw_wdt.c b/drivers/watchdog/dw_wdt.c
> > index 9f21029..ad0619d 100644
> > --- a/drivers/watchdog/dw_wdt.c
> > +++ b/drivers/watchdog/dw_wdt.c
> > @@ -146,6 +146,7 @@ static int dw_wdt_open(struct inode *inode, struct
> > file *filp) dw_wdt_set_top(DW_WDT_MAX_TOP);
> >   		writel(WDOG_CONTROL_REG_WDT_EN_MASK,
> >   		       dw_wdt.regs + WDOG_CONTROL_REG_OFFSET);
> > +		dw_wdt_keepalive();
> >   	}
> >
> >   	dw_wdt_set_next_heartbeat();
> >
> After getting access to the datasheet, I concluded that this fix is wrong
> or at least more risky than necessary. The datasheet states that top_init,
> ie bit 4-7 of the wdt_torr register, needs to be initialized with the
> desired timeout period prior to enabling the watchdog. dw_wdt_set_top()
> sets it to 0 instead, ie to the lowest possible timeout period.
> 

In patch V2, 
I initialize the TOP_INIT when setting TOP in function dw_wdt_set_top(), this
also can fix the "reboot soon" problem. Could you please have a review again?

Thanks,
Jisheng
