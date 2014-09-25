Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514AbaIYPLF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 11:11:05 -0400
Received: from mail-bn1bbn0106.outbound.protection.outlook.com ([157.56.111.106]:40352
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752759AbaIYPLD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 11:11:03 -0400
Date: Thu, 25 Sep 2014 23:10:14 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Stefan Agner <stefan@agner.ch>
CC: <kernel@pengutronix.de>, <festevam@gmail.com>,
        <jingchang.lu@freescale.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] ARM: vf610: Use ARM Global Timer as clocksource
Message-ID: <20140925151012.GI6405@dragon>
References: <1410437175-6636-1-git-send-email-stefan@agner.ch>
 <1410437175-6636-2-git-send-email-stefan@agner.ch>
 <20140925075013.GD6405@dragon>
 <7006ad6e519c2ce3eeded54d35c87183@agner.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <7006ad6e519c2ce3eeded54d35c87183@agner.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [180.108.234.93]
X-ClientProxiedBy: SIXPR01CA005.apcprd01.prod.exchangelabs.com (10.242.58.15)
 To DM2PR03MB350.namprd03.prod.outlook.com (10.141.54.21)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR03MB350;
X-Forefront-PRVS: 0345CFD558
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6009001)(189002)(24454002)(199003)(51704005)(377424004)(4396001)(31966008)(20776003)(64706001)(46406003)(77096002)(92566001)(83072002)(83322001)(86362001)(76482002)(33716001)(54356999)(92726001)(93886004)(33656002)(50986999)(120916001)(87976001)(81342003)(79102003)(42186005)(95666004)(21056001)(99396003)(83506001)(10300001)(77982003)(46102003)(107046002)(80022003)(74502003)(110136001)(101416001)(66066001)(97736003)(102836001)(85852003)(50466002)(105586002)(23726002)(85306004)(76176999)(74662003)(106356001)(47776003)(97756001)(81542003)(90102001);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR03MB350;H:dragon;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2014 at 10:25:13AM +0200, Stefan Agner wrote:
> Am 2014-09-25 09:50, schrieb Shawn Guo:
> > On Thu, Sep 11, 2014 at 02:06:15PM +0200, Stefan Agner wrote:
> >> Use ARM Global Timer as clocksource instead of the PIT timer. This
> >> leaves the PIT timer for other users e.g. the secondary Cortex-M4
> >> core. Also, the Global Timer has double the precission (running at
> >> pheripheral clock compared to IPG clock) and a 64-bit incrementing
> >> counter register.
> > 
> > I just think of one thing.  Will this change cause a problem of the low
> > power idle support in case we want to power down ARM core in there?
> > 
> 
> I'm not sure what really happend to the Global Timer when we power down
> the ARM core. We use a clocksoure of different power domain now, so it
> might make a difference in low power modes, but I think it will improve
> things: The PIT timer's clock currently have been clock gated even in
> STOP mode, which does not power down the ARM core. And it would be shut
> down completely in LP-Mode 1-3 which since PIT is part of the big power
> domain 1. 
> 
> But AFAIK, its not required that the clocksource is running while in low
> power modes. The time should just not jump, and if the timers registers
> are lost during suspend, a proper suspend/resume support need to be
> implemented. 

Sorry, I should be more specific in the first place.  What I'm concerned
is more about clockevent than clocksource.  If some day we have a
cpuidle driver for vf610, which powers off ARM core in a deep C-state,
the clockevent device will be gone as long as system enters the C-state,
and no timer interrupt can wake up the core from idle state.

Shawn
