Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756052AbbAZKX7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 05:23:59 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:60168 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752703AbbAZKXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 05:23:54 -0500
Date: Mon, 26 Jan 2015 11:23:52 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Fu, Zhonghui" <zhonghui.fu@linux.intel.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, len.brown@intel.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pm@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        chuansheng.liu@intel.com
Subject: Change behaviour when tracing ... nasty trap (was Re: [PATCH]
 PM/Trace: get rid of synchronous resume limit during PM trace)
Message-ID: <20150126102352.GA1758@amd>
References: <54C5CB77.4000109@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54C5CB77.4000109@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2015-01-26 13:07:03, Fu, Zhonghui wrote:
> >From f9c841d1f943d81b5ab0aac7483e794a7f966296 Mon Sep 17 00:00:00 2001
> From: Zhonghui Fu <zhonghui.fu@linux.intel.com>
> Date: Mon, 26 Jan 2015 11:27:08 +0800
> Subject: [PATCH] PM/Trace: get rid of synchronous resume limit during PM trace
> 
> There are some kind of dependency between devices in some
> hardware platforms. So, asynchronous resuming devices may
> hang system due to wrong resume order. As a result, should
> not fore synchronously resuming devices during tracing
> PM events.
> 
> Signed-off-by: Zhonghui Fu <zhonghui.fu@linux.intel.com>
> ---
>  drivers/base/power/main.c    |    3 +--
>  include/linux/resume-trace.h |    7 -------
>  2 files changed, 1 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
> index 9717d5f..5df148b 100644
> --- a/drivers/base/power/main.c
> +++ b/drivers/base/power/main.c
> @@ -517,8 +517,7 @@ static int device_resume_noirq(struct device *dev, pm_message_t state, bool asyn
>  
>  static bool is_async(struct device *dev)
>  {
> -	return dev->power.async_suspend && pm_async_enabled
> -		&& !pm_trace_is_enabled();
> +	return dev->power.async_suspend && pm_async_enabled;
>  }
>

Actually... whoever did the original patch was evil person. Changing
behaviour when tracing is requested is evil, evil, evil. Git blame
tells me

Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com>

went to the dark side.

									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
