Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757050AbaCEXyb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 18:54:31 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:52798 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755012AbaCEXy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 18:54:26 -0500
Date: Wed, 5 Mar 2014 17:51:38 -0600
From: Josh Cartwright <joshc@codeaurora.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Josh Cartwright <joshc@codeaurora.org>,
        Alessandro Zummo <a.zummo@towertech.it>, linux-arm-msm@vger.kernel.org,
        rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] rtc: pm8xxx: fixup checkpatch/style issues
Message-ID: <20140305235138.GD18529@joshc.qualcomm.com>
References: <1394047776-13827-1-git-send-email-joshc@codeaurora.org>
 <1394047776-13827-2-git-send-email-joshc@codeaurora.org>
 <531790E5.8020204@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <531790E5.8020204@codeaurora.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 05, 2014 at 01:02:29PM -0800, Stephen Boyd wrote:
> On 03/05/14 11:29, Josh Cartwright wrote:
> > Before performing additional cleanups to this driver, do the easy
> > cleanups first.
> >
> > Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
> 
> Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>

Thanks for the reviews.

> > @@ -253,7 +253,7 @@ static int pm8xxx_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alarm)
> >  
> >  	ctrl_reg = rtc_dd->ctrl_reg;
> >  	ctrl_reg = alarm->enabled ? (ctrl_reg | PM8xxx_RTC_ALARM_ENABLE) :
> > -					(ctrl_reg & ~PM8xxx_RTC_ALARM_ENABLE);
> > +				    (ctrl_reg & ~PM8xxx_RTC_ALARM_ENABLE);
> >  
> >  	rc = pm8xxx_write_wrapper(rtc_dd, &ctrl_reg, rtc_dd->rtc_base, 1);
> >  	if (rc < 0) {
> 
> This could be better style with more lines:
> 
> if (alarm->enabled)
>     ctrl_reg |= PM8xxx_RTC_ALARM_ENABLE;
> else
>     ctrl_reg &= ~PM8xxx_RTC_ALARM_ENABLE;

Agreed, I'll clean this up in a v2.

I might go back and see just how much can be cleanup up to use the
regmap_update_bits() API as well.

Thanks,
  Josh

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
