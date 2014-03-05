Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757490AbaCEVCc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 16:02:32 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:38506 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755378AbaCEVCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 16:02:30 -0500
Message-ID: <531790E5.8020204@codeaurora.org>
Date: Wed, 05 Mar 2014 13:02:29 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Josh Cartwright <joshc@codeaurora.org>
CC: Alessandro Zummo <a.zummo@towertech.it>, linux-arm-msm@vger.kernel.org,
        rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] rtc: pm8xxx: fixup checkpatch/style issues
References: <1394047776-13827-1-git-send-email-joshc@codeaurora.org> <1394047776-13827-2-git-send-email-joshc@codeaurora.org>
In-Reply-To: <1394047776-13827-2-git-send-email-joshc@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05/14 11:29, Josh Cartwright wrote:
> Before performing additional cleanups to this driver, do the easy
> cleanups first.
>
> Signed-off-by: Josh Cartwright <joshc@codeaurora.org>

Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>

> @@ -253,7 +253,7 @@ static int pm8xxx_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alarm)
>  
>  	ctrl_reg = rtc_dd->ctrl_reg;
>  	ctrl_reg = alarm->enabled ? (ctrl_reg | PM8xxx_RTC_ALARM_ENABLE) :
> -					(ctrl_reg & ~PM8xxx_RTC_ALARM_ENABLE);
> +				    (ctrl_reg & ~PM8xxx_RTC_ALARM_ENABLE);
>  
>  	rc = pm8xxx_write_wrapper(rtc_dd, &ctrl_reg, rtc_dd->rtc_base, 1);
>  	if (rc < 0) {

This could be better style with more lines:

if (alarm->enabled)
    ctrl_reg |= PM8xxx_RTC_ALARM_ENABLE;
else
    ctrl_reg &= ~PM8xxx_RTC_ALARM_ENABLE;

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

