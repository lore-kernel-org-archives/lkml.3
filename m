Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727Ab3KZHTo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 02:19:44 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:53078 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753540Ab3KZHTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 02:19:42 -0500
X-AuditID: 85900ec0-d452db9000001514-8f-52944b8bbfdf
Message-ID: <52944B7B.40504@hitachi.com>
Date: Tue, 26 Nov 2013 16:19:23 +0900
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120604 Thunderbird/13.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>, yrl.pp-manager.tt@hitachi.com,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] timer: Add __sched to msleep() and msleep_interruptible()
References: <20131111081815.20618.79098.stgit@yunodevel>
In-Reply-To: <20131111081815.20618.79098.stgit@yunodevel>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Would you review this patch?

Thanks,
Yoshihiro YUNOMAE

(2013/11/11 17:18), Yoshihiro YUNOMAE wrote:
> Add __sched to msleep() and msleep_interruptible() for avoiding to show
> these functions in WCHAN. If a driver calls msleep() or msleep_interruptible()
> in a lot of places, users cannot understand that the driver might sleep which
> functions execute msleep() or msleep_interruptible(). So, by applying this
> patch, users can confirm the function calling msleep() or msleep_interruptible()
> from WCHAN.
>
> Signed-off-by: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: linux-kernel@vger.kernel.org
> ---
>   kernel/timer.c |    4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/timer.c b/kernel/timer.c
> index 6582b82..cc1470f 100644
> --- a/kernel/timer.c
> +++ b/kernel/timer.c
> @@ -1660,7 +1660,7 @@ void __init init_timers(void)
>    * msleep - sleep safely even with waitqueue interruptions
>    * @msecs: Time in milliseconds to sleep for
>    */
> -void msleep(unsigned int msecs)
> +void __sched msleep(unsigned int msecs)
>   {
>   	unsigned long timeout = msecs_to_jiffies(msecs) + 1;
>
> @@ -1674,7 +1674,7 @@ EXPORT_SYMBOL(msleep);
>    * msleep_interruptible - sleep waiting for signals
>    * @msecs: Time in milliseconds to sleep for
>    */
> -unsigned long msleep_interruptible(unsigned int msecs)
> +unsigned long __sched msleep_interruptible(unsigned int msecs)
>   {
>   	unsigned long timeout = msecs_to_jiffies(msecs) + 1;
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

-- 
Yoshihiro YUNOMAE
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: yoshihiro.yunomae.ez@hitachi.com


