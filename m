Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751487AbbAVHZj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 02:25:39 -0500
Received: from mail-qc0-f182.google.com ([209.85.216.182]:50368 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817AbbAVHZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 02:25:33 -0500
MIME-Version: 1.0
In-Reply-To: <1421893915-19309-1-git-send-email-pang.xunlei@linaro.org>
References: <1421893915-19309-1-git-send-email-pang.xunlei@linaro.org>
Date: Wed, 21 Jan 2015 23:25:33 -0800
Message-ID: <CALAqxLXMSdWmCWAYJ2thzFpUfptOt6gGhBY9vgm+bwA+29=QEg@mail.gmail.com>
Subject: Re: [PATCH 1/5] drivers/rtc/interface.c: Update code to use
 y2038-safe time interfaces
From: John Stultz <john.stultz@linaro.org>
To: Xunlei Pang <pang.xunlei@linaro.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Arnd Bergmann <arnd.bergmann@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2015 at 6:31 PM, Xunlei Pang <pang.xunlei@linaro.org> wrote:
> Currently, interface.c uses y2038 problematic rtc_tm_to_time()
> and rtc_time_to_tm(). So replace them with their corresponding
> y2038-safe versions: rtc_tm_to_time64() and rtc_time64_to_tm().


Ok, I've queued this set of 5 (with a few minor tweaks). If I don't
hear any other objections I'll submit them in with my 3.20 set.

You're other patchset focusing on the setmms64 change and the hardware
specific rtc drivers should probably go in via Alessandro (unless
Alessandro suggests otherwise).  There may be slight fuzz in -next
between the first patch here and that patchset (which I hit), but it
should be easy enough to resolve.

thanks
-john
