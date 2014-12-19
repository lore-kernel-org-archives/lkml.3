Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752059AbaLSHQm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 02:16:42 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:53544 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbaLSHQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 02:16:41 -0500
Date: Thu, 18 Dec 2014 23:16:37 -0800
From: Jeremiah Mahler <jmmahler@gmail.com>
To: karthik nayak <karthik.188@gmail.com>
Cc: trivial@kernel.org, gregkh@linuxfoundation.org, anarey@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: rtl8192u: removed an unnecessary else statement
Message-ID: <20141219071637.GA11802@hudson.localdomain>
Mail-Followup-To: Jeremiah Mahler <jmmahler@gmail.com>,
	karthik nayak <karthik.188@gmail.com>, trivial@kernel.org,
	gregkh@linuxfoundation.org, anarey@gmail.com,
	linux-kernel@vger.kernel.org
References: <1418894411-9787-1-git-send-email-karthik.188@gmail.com>
 <20141218223819.GB6742@hudson.localdomain>
 <5493AD9A.30509@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5493AD9A.30509@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Karthik,

On Fri, Dec 19, 2014 at 10:16:18AM +0530, karthik nayak wrote:
> 
> On 12/19/2014 04:08 AM, Jeremiah Mahler wrote:
> >Karthik,
> >
> >On Thu, Dec 18, 2014 at 02:50:11PM +0530, Karthik Nayak wrote:
> >>As per checkpatch warning, removed an unnecessary else statement
> >>proceeding an if statement with a return.
> >>
> >>Signed-off-by: Karthik Nayak <karthik.188@gmail.com>
> >>---
> >>  drivers/staging/rtl8192u/r8192U_dm.c | 16 +++++++---------
> >>  1 file changed, 7 insertions(+), 9 deletions(-)
> >>
> >>diff --git a/drivers/staging/rtl8192u/r8192U_dm.c b/drivers/staging/rtl8192u/r8192U_dm.c
> >>index 936565d..b3b508c 100644
> >>--- a/drivers/staging/rtl8192u/r8192U_dm.c
> >>+++ b/drivers/staging/rtl8192u/r8192U_dm.c
> >>@@ -480,15 +480,13 @@ static void dm_bandwidth_autoswitch(struct net_device *dev)
> >>  	if(priv->CurrentChannelBW == HT_CHANNEL_WIDTH_20 ||!priv->ieee80211->bandwidth_auto_switch.bautoswitch_enable){
> >>  		return;
> >>-	}else{
> >>-		if(priv->ieee80211->bandwidth_auto_switch.bforced_tx20Mhz == false){//If send packets in 40 Mhz in 20/40
> >>-			if(priv->undecorated_smoothed_pwdb <= priv->ieee80211->bandwidth_auto_switch.threshold_40Mhzto20Mhz)
> >>-				priv->ieee80211->bandwidth_auto_switch.bforced_tx20Mhz = true;
> >>-		}else{//in force send packets in 20 Mhz in 20/40
> >>-			if(priv->undecorated_smoothed_pwdb >= priv->ieee80211->bandwidth_auto_switch.threshold_20Mhzto40Mhz)
> >>-				priv->ieee80211->bandwidth_auto_switch.bforced_tx20Mhz = false;
> >>-
> >>-		}
> >>+	}
> >>+	if(priv->ieee80211->bandwidth_auto_switch.bforced_tx20Mhz == false){//If send packets in 40 Mhz in 20/40
> >>+		if(priv->undecorated_smoothed_pwdb <= priv->ieee80211->bandwidth_auto_switch.threshold_40Mhzto20Mhz)
> >>+			priv->ieee80211->bandwidth_auto_switch.bforced_tx20Mhz = true;
> >>+	}else{//in force send packets in 20 Mhz in 20/40
> >>+		if(priv->undecorated_smoothed_pwdb >= priv->ieee80211->bandwidth_auto_switch.threshold_20Mhzto40Mhz)
> >>+			priv->ieee80211->bandwidth_auto_switch.bforced_tx20Mhz = false;
> >>  	}
> >>  }	// dm_BandwidthAutoSwitch
> >[...]
> >
> >Wow, I don't think I have ever seen a file with so many checkpatch errors!
> >
> >Instead of only fixing one instance of one error I would fix all
> >instances of that type of error.  Since the changes would be very
> >similar it should still be easy to review.
> >
> >You could even make a whole patch series with each patch fixing one type
> >of error.  Although I would keep the series to just a few at first until
> >you are sure you are doing everything right.
> >
> Hello Jeremiah,
> I agree, there are a lot of errors, so I fixed a single issue.
> This is just to get used to checkpatch system.
> I can write patches to fix the other things, but I rather not.
> I hope you get the point.
> Regards
> Karthik Nayak

Starting small sounds like a good idea.

-- 
- Jeremiah Mahler
