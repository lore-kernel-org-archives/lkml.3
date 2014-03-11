Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753840AbaCKAqt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 20:46:49 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:59095 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751802AbaCKAqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 20:46:48 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH Resend] PM: Remove unnecessary !!
Date: Tue, 11 Mar 2014 02:02:07 +0100
Message-ID: <2023407.4iLFilWYAW@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.13.0+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <40f994376d56b4fa090fc2d27403c2188a4af0a4.1394460079.git.viresh.kumar@linaro.org>
References: <40f994376d56b4fa090fc2d27403c2188a4af0a4.1394460079.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, March 10, 2014 07:31:51 PM Viresh Kumar wrote:
> Double ! or !! are normally required to get 0 or 1 out of a expression. A
> comparision always returns 0 or 1 and hence there is no need to apply double !
> over it again.
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

Queued up for 3.15, thanks!

> ---
>  kernel/power/suspend.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/power/suspend.c b/kernel/power/suspend.c
> index 62ee437..90b3d93 100644
> --- a/kernel/power/suspend.c
> +++ b/kernel/power/suspend.c
> @@ -39,7 +39,7 @@ static const struct platform_suspend_ops *suspend_ops;
>  
>  static bool need_suspend_ops(suspend_state_t state)
>  {
> -	return !!(state > PM_SUSPEND_FREEZE);
> +	return state > PM_SUSPEND_FREEZE;
>  }
>  
>  static DECLARE_WAIT_QUEUE_HEAD(suspend_freeze_wait_head);
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
