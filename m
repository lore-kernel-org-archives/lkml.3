Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751853Ab3FYXAk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 19:00:40 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:50971 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751005Ab3FYXAi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 19:00:38 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: pavel@ucw.cz, len.brown@intel.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, shuahkhan@gmail.com
Subject: Re: [PATCH v2] power: Add warning message about incorrect system date and time after resume when pm_trace is enabled
Date: Wed, 26 Jun 2013 01:10:05 +0200
Message-ID: <2689226.oQ0T3XLPmT@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1372116318-10824-1-git-send-email-shuah.kh@samsung.com>
References: <1372116318-10824-1-git-send-email-shuah.kh@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, June 24, 2013 05:25:18 PM Shuah Khan wrote:
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
>  kernel/power/main.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/kernel/power/main.c b/kernel/power/main.c
> index d77663b..fd744d1 100644
> --- a/kernel/power/main.c
> +++ b/kernel/power/main.c
> @@ -528,6 +528,8 @@ pm_trace_store(struct kobject *kobj, struct kobj_attribute *attr,
>  
>  	if (sscanf(buf, "%d", &val) == 1) {
>  		pm_trace_enabled = !!val;
> +		pr_warn("PM: Enabling pm_trace changes system date and time after resume.\n");
> +		pr_cont("PM: Remember to set correct time after resume\n");

You can do it like this:

+	pr_warn("PM: Enabling pm_trace changes system date and time after resume.\n"
+		  "PM: Remember to set correct time after resume\n");

No need to use pr_cont(). :-)

And I'd say "during" instead of "after" in the first sentence.

I'd also say something like "Correct system time has to be restored manually after resume."
instead of the second one.

>  		return n;
>  	}
>  	return -EINVAL;

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
