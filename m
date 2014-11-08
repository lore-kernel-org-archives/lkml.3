Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753084AbaKHVcI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 16:32:08 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:57351 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751231AbaKHVcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 16:32:05 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, linux-pm@vger.kernel.org
Subject: Re: [PATCH] Fix entering suspend-to-IDLE if no freeze_oops is set
Date: Sat, 08 Nov 2014 22:52:55 +0100
Message-ID: <3316608.URmAE8zNYQ@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1415463433-5267-1-git-send-email-dbaryshkov@gmail.com>
References: <1415463433-5267-1-git-send-email-dbaryshkov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, November 08, 2014 07:17:13 PM Dmitry Eremin-Solenikov wrote:
> If no freeze_ops is set, trying to enter suspend-to-IDLE will cause a
> nice oops in platform_suspend_prepare_late(). Add respective checks to
> platform_suspend_prepare_late() and platform_resume_early() functions.
> 
> Fixes: a8d46b9e (ACPI / sleep: Rework the handling of ACPI GPE wakeup ...)
> Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>

Applied, thanks!

> ---
>  kernel/power/suspend.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/power/suspend.c b/kernel/power/suspend.c
> index 4ca9a33..c347e3c 100644
> --- a/kernel/power/suspend.c
> +++ b/kernel/power/suspend.c
> @@ -146,7 +146,7 @@ static int platform_suspend_prepare(suspend_state_t state)
>  
>  static int platform_suspend_prepare_late(suspend_state_t state)
>  {
> -	return state == PM_SUSPEND_FREEZE && freeze_ops->prepare ?
> +	return state == PM_SUSPEND_FREEZE && freeze_ops && freeze_ops->prepare ?
>  		freeze_ops->prepare() : 0;
>  }
>  
> @@ -164,7 +164,7 @@ static void platform_resume_noirq(suspend_state_t state)
>  
>  static void platform_resume_early(suspend_state_t state)
>  {
> -	if (state == PM_SUSPEND_FREEZE && freeze_ops->restore)
> +	if (state == PM_SUSPEND_FREEZE && freeze_ops && freeze_ops->restore)
>  		freeze_ops->restore();
>  }
>  
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
