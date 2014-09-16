Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754397AbaIPO1z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 10:27:55 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:33684 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753527AbaIPO1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 10:27:54 -0400
Date: Tue, 16 Sep 2014 10:27:53 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Subhransu S. Prusty" <subhransu.s.prusty@intel.com>
cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>, <linux-kernel@vger.kernel.org>,
        <vinod.koul@intel.com>
Subject: Re: [PATCH] PM: Add helper to mark last busy and autosuspend
In-Reply-To: <1410864231-10334-1-git-send-email-subhransu.s.prusty@intel.com>
Message-ID: <Pine.LNX.4.44L0.1409161024580.1166-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Sep 2014, Subhransu S. Prusty wrote:

> pm_runtime_mark_last_busy and pm_runtime_put_autosuspend are used together
> in quite a lot of places. Add a helper for these.
> 
> Signed-off-by: Subhransu S. Prusty <subhransu.s.prusty@intel.com>
> ---
>  include/linux/pm_runtime.h | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/include/linux/pm_runtime.h b/include/linux/pm_runtime.h
> index 367f49b..256ec50 100644
> --- a/include/linux/pm_runtime.h
> +++ b/include/linux/pm_runtime.h
> @@ -277,4 +277,10 @@ static inline void pm_runtime_dont_use_autosuspend(struct device *dev)
>  	__pm_runtime_use_autosuspend(dev, false);
>  }
>  
> +static inline int pm_runtime_last_busy_and_autosuspend(struct device *dev)
> +{
> +	pm_runtime_mark_last_busy(dev);
> +	return pm_runtime_put_autosuspend(dev);
> +}
> +
>  #endif

What's the advantage?  Removing a few bytes of source code?  There will 
no change to the object code.  (Not to mention that your patch didn't 
actually change _any_ of the places where both routines get called!)

Besides, if you're going to make an addition to the runtime PM API like 
this, then you also have to update Documentation/power/runtime_pm.txt.

Alan Stern

