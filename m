Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756938Ab3BVUhY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 15:37:24 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:50172 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756413Ab3BVUhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 15:37:22 -0500
Message-ID: <5127D6FE.2020802@linaro.org>
Date: Fri, 22 Feb 2013 12:37:18 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Dong Zhu <bluezhudong@gmail.com>
CC: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] timekeeping: avoid adjust kernel time once hwclock kept
 in UTC time
References: <20121206140334.GA24261@zhudong.nay.redhat.com>
In-Reply-To: <20121206140334.GA24261@zhudong.nay.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/2012 06:03 AM, Dong Zhu wrote:
>  From c126376cf1837b0956e0268056db61870fbbc1d4 Mon Sep 17 00:00:00 2001
> From: Dong Zhu <bluezhudong@gmail.com>
> Date: Thu, 6 Dec 2012 21:45:00 +0800
> Subject: [PATCH] timekeeping: avoid adjust kernel time once hwclock kept in
>   UTC time
>
> If the Hardware Clock kept in local time,kernel will adjust the time
> to be UTC time.But if Hardware Clock kept in UTC time,system will make
> a dummy settimeofday call first (sys_tz.tz_minuteswest = 0) to make sure
> the time is not shifted,so at this point I think maybe it is not necessary
> to set the kernel time once the sys_tz.tz_minuteswest is zero.
>
> Signed-off-by: Dong Zhu <bluezhudong@gmail.com>

Sorry for the long delay here, and thank you for the reminder!

I've merged this patch in my tree (reworking it to merge with other 
changes in that area). And I'm likely to make a follow on patch that 
will use timekeeping_inject_offset() so we don't add any extra time 
error unnecessarily. Both will be queued for 3.10.

thanks
-john

