Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751669Ab3FWLaX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jun 2013 07:30:23 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:47913 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750953Ab3FWLaV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jun 2013 07:30:21 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: pavel@ucw.cz, len.brown@intel.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, shuahkhan@gmail.com
Subject: Re: [PATCH 2/2] power: Add warning message about incorrect system date and time after resume when pm_trace is enabled
Date: Sun, 23 Jun 2013 13:39:47 +0200
Message-ID: <3910179.5qQFOJRmrs@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1371658518-2878-1-git-send-email-shuah.kh@samsung.com>
References: <1371658518-2878-1-git-send-email-shuah.kh@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, June 19, 2013 10:15:18 AM Shuah Khan wrote:
> pm_trace uses the system's Real Time Clock (RTC) to save the magic number.
> Reason for this is that the RTC is the only reliably available piece of
> hardware during resume operations where a value can be set that will
> survive a reboot.
> 
> Consequence is that after a resume (even if it is successful) your system
> clock will have a value corresponding to the magic number instead of the
> correct date/time! It is therefore advisable to use a program like ntp-date
> or rdate to reset the correct date/time from an external time source when
> using this trace option.
> 
> There is no run-time message to warn users of the consequences of enabling
> pm_trace. Adding a warning message to pm_trace_store() will serve as a
> reminder to users to set the system date and time after resume.
> 
> Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
> ---
>  kernel/power/main.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/kernel/power/main.c b/kernel/power/main.c
> index d77663b..4f769a6 100644
> --- a/kernel/power/main.c
> +++ b/kernel/power/main.c
> @@ -528,6 +528,7 @@ pm_trace_store(struct kobject *kobj, struct kobj_attribute *attr,
>  
>  	if (sscanf(buf, "%d", &val) == 1) {
>  		pm_trace_enabled = !!val;
> +		pr_warn("CAUTION: this option will cause your machine's real-time clock to be set to an invalid time after a resume. Remember to set correct time after resume\n");
>  		return n;

Can you please make it short so that it fits a single line?

Or at least print two separate lines that will fit 80 chars wide screen each?

>  	}
>  	return -EINVAL;
> 

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
