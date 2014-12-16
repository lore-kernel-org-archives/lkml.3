Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751261AbaLPBmg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 20:42:36 -0500
Received: from mail-ig0-f169.google.com ([209.85.213.169]:45183 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175AbaLPBmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 20:42:33 -0500
Date: Mon, 15 Dec 2014 17:42:27 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jaewon Kim <jaewon02.kim@samsung.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-input@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Hyunhee Kim <hyunhee.kim@samsung.com>
Subject: Re: [PATCH v6 1/2] Input: add regulator haptic driver
Message-ID: <20141216014227.GA18491@dtor-ws>
References: <1418380349-32588-1-git-send-email-jaewon02.kim@samsung.com>
 <1418380349-32588-2-git-send-email-jaewon02.kim@samsung.com>
 <20141213195611.GE22702@dtor-ws>
 <548F8645.3070002@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <548F8645.3070002@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2014 at 10:09:25AM +0900, Jaewon Kim wrote:
> Hi Dmitry,
> 
> 2014년 12월 14일 04:56에 Dmitry Torokhov 이(가) 쓴 글:
> >Hi Jaewon,
> >
> >On Fri, Dec 12, 2014 at 07:32:28PM +0900, Jaewon Kim wrote:
...
> >>+static int __maybe_unused regulator_haptic_suspend(struct device *dev)
> >>+{
> >>+	struct platform_device *pdev = to_platform_device(dev);
> >>+	struct regulator_haptic *haptic = platform_get_drvdata(pdev);
> >>+
> >>+	mutex_lock(&haptic->mutex);
> >>+	if (haptic->enabled) {
> >>+		regulator_haptic_enable(haptic, false);
> >>+		haptic->suspend_state = true;
> >Why do we only set suspend_state if an effect was playing? I think we
> >should always indicate that the device is suspended so that we do not
> >try to start playing another effect - while it is true that normally
> >effects are played by request from userspace which should be frozen by
> >now, it is theoretically possible to trigger an effect from kernel as
> >well.
> 
> This variable name seems to make you confuse.
> I used this variable to restore the old state.
> 
> When kernel is entering suspend state while the motor is vibrating,
> I store vibrating state for vibrate again after escape suspend state.
> 
> 
> I will change variable name to "suspend_restore".
> And prevent to start playing effect  when kernel entering suspend state.

You do not need to save if haptic was playing or not - on resume, if
haptic->magnitude != 0 you need to restart playing, otherwise leave it
off.

Thanks.

-- 
Dmitry
