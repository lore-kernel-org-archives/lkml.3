Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752626AbbAHB0V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 20:26:21 -0500
Received: from mail-qg0-f54.google.com ([209.85.192.54]:57084 "EHLO
	mail-qg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752409AbbAHB0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 20:26:20 -0500
Date: Wed, 7 Jan 2015 17:26:16 -0800
From: Brian Norris <computersforpeace@gmail.com>
To: Arnd Bergmann <arnd@linaro.org>
Cc: Chunyan Zhang <zhang.chunyan@linaro.org>, dwmw2@infradead.org,
        john.stultz@linaro.org, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, zhang.lyra@gmail.com
Subject: Re: [PATCH v3] mtd: test: Replace timeval with ktime_t in
 speedtest.c and torturetest.c
Message-ID: <20150108012616.GQ9759@ld-irv-0074>
References: <1418873011-4974-1-git-send-email-zhang.chunyan@linaro.org>
 <4170676.z5yoWA4Rtc@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4170676.z5yoWA4Rtc@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 18, 2014 at 08:53:10AM +0100, Arnd Bergmann wrote:
> On Thursday 18 December 2014 11:23:31 Chunyan Zhang wrote:
> > This patch changes the 32-bit time type (timeval) to the 64-bit one
> > (ktime_t), since 32-bit time types will break in the year 2038.
> > 
> > I use ktime_t instead of timeval to define 'start' and 'finish'
> > which are used to get the time for tow points.
> > 
> > This patch also changes do_gettimeofday() to ktime_get() accordingly,
> > since ktime_get returns a ktime_t, but do_gettimeofday returns a
> > struct timeval, and the other reason is that ktime_get() uses
> > the monotonic clock.
> > 
> > This patch is based on another patch which privides a millisecond
> > time difference function 'ktime_ms_delta' in ktime.h
> > 
> > http://lkml.iu.edu//hypermail/linux/kernel/1412.2/00625.html
> > 
> > Signed-off-by: Chunyan Zhang <zhang.chunyan@linaro.org>
> > Reviewed-by: Arnd Bergmann <arnd@arndb.de>
> > 
> 
> The new version still looks good to me, but as there is now a
> dependency on another patch, I'd suggest we queue this up in the
> y2038 branch together with the patch that introduces ktime_ms_delta.
> 
> David or Brian, can you provide an Ack for this, or do you have
> any objections?

I just tested v2, which doesn't have this dependency and has only a
trivial difference from v3. Seems to work OK. So:

Tested-by: Brian Norris <computersforpeace@gmail.com>
Acked-by: Brian Norris <computersforpeace@gmail.com>

Feel free to queue it in the dependent branch.

Thanks,
Brian
