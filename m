Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753200Ab3EIRsR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 13:48:17 -0400
Received: from nm13.access.bullet.mail.mud.yahoo.com ([66.94.237.214]:40039
	"EHLO nm13.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752447Ab3EIRsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 13:48:16 -0400
X-Yahoo-Newman-Id: 608434.42433.bm@smtp111.sbc.mail.ne1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: hFQqfyQVM1lXCGnl2gl0qFhFCKokrdZ_oS2MjFbkE5jvUDo
 lZ970bOG97yzTNnzoqvO1kBCYTlTO9BXVqMuyyI0xXAnm3h0cRdJXsCRuO9o
 N2LhyxKpKubRhaRwvIBdrx2PtkWoo1vtzJA_Ukqw4wxhp6iBARjQPs07CNVN
 uXo7cdnVwRDzzAlG_AI26JQJHtY0AIE1mKJuSpjQPzrYXXEjf.yruKGGzdh3
 Ear4IT5J0SgRHd890yH_rRyubfU2zQsWAh5T3_2u_6eRTGhsZWZ_7YLAg94W
 loyXLPGrIStkW03I38GcanoTh1Ax1kEHD8WFD.fGPKnwbnji7LRudIFsvZCY
 HYo4Pa70moFPlGnuqpFPX3Fmjsa8iYYgsM4FaR9UEN8OG3yXBEKs5tV.HmI5
 El7LoCnoXVGgYZzCAqmuUI7ZfV1ulUHyTEkEwnjJdlMWOmiCqsFpEDmEm_Ju
 j4gSTJRwr1nHcWs43Ys9vibqeB1FyB30UM28-
X-Yahoo-SMTP: zfeO.4KswBCc_PdwTE8HfYDCQ1aNmIcSvQHkDP4uSDBNBSXeKQ--
X-Rocket-Received: from localhost (linux@108.223.40.66 with plain)
        by smtp111.sbc.mail.ne1.yahoo.com with SMTP; 09 May 2013 10:48:15 -0700 PDT
Date: Thu, 9 May 2013 10:48:22 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        lm-sensors@lm-sensors.org, Jean Delvare <khali@linux-fr.org>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Jingoo Han <jg1.han@samsung.com>
Subject: Re: [PATCH 0/3] pm: Introduce __pm to mark power management code
Message-ID: <20130509174822.GA30549@roeck-us.net>
References: <1368119366-8716-1-git-send-email-linux@roeck-us.net>
 <Pine.LNX.4.44L0.1305091337050.1796-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1305091337050.1796-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 09, 2013 at 01:38:36PM -0400, Alan Stern wrote:
> On Thu, 9 May 2013, Guenter Roeck wrote:
> 
> > The following patch series introduces a marker for power management functions
> > and data. This this marker, #ifdef CONFIG_PM and #ifdef CONFIG_PM_SLEEP
> > can be removed from most of the code. This ensures that the conditional code
> > still compiles but is not included in the object file.
> > 
> > As a side effect, drivers declaring struct dev_pm_ops unconditionally
> > get a bit smaller if CONFIG_PM_SLEEP is not configured.
> 
> What about code that depends on CONFIG_PM_RUNTIME?  Or code that 
> depends on CONFIG_PM_SLEEP but not on CONFIG_PM_RUNTIME?
> 
Should we also introduce __pm_sleep and __pm_runtime ?

Thanks,
Guenter
