Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751943Ab3JQGuL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 02:50:11 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:53744 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863Ab3JQGuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 02:50:08 -0400
Message-ID: <525F8895.5010806@gmail.com>
Date: Thu, 17 Oct 2013 14:49:57 +0800
From: Mark Zhang <nvmarkzhang@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: thierry.reding@gmail.com, rpurdie@rpsys.net, jg1.han@samsung.com,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        tomi.valkeinen@ti.com
CC: linux-pwm@vger.kernel.org,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: How to set fops in "struct platform_pwm_backlight_data"?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is the first time I send mail to linux-pwm, I didn't read through
the mails in this list, so if somebody already asked this question, I'm
sorry about that.

I wanna set some fops in "struct platform_pwm_backlight_data". But the
currrent probe function in pwm_bl.c says:

-------
if (!data) {
	ret = pwm_backlight_parse_dt(&pdev->dev, &defdata);
	if (ret < 0) {
		dev_err(&pdev->dev, "failed to find platform data\n");
		return ret;
	}

	data = &defdata;
}
-------

This looks like if we set the platform data for pwm backlight device,
"pwm_backlight_parse_dt" will never have a chance to be called, which
means the stuffs I defined in backlight DT node will be ignored.

If I don't set the platform data for pwm backlight device, according to
the pwm_backlight_probe, I will never have a chance to set some fops
which I need(like "notify", "check_fb"...).

So, what I suppose to do now? Maybe there is a way to set function
pointers in DT?

Mark
