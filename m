Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756094Ab3BEPmF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 10:42:05 -0500
Received: from mail-qc0-f170.google.com ([209.85.216.170]:33674 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755045Ab3BEPmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 10:42:00 -0500
MIME-Version: 1.0
In-Reply-To: <1360057555-10279-1-git-send-email-myungjoo.ham@samsung.com>
References: <1360057555-10279-1-git-send-email-myungjoo.ham@samsung.com>
Date: Tue, 5 Feb 2013 21:11:59 +0530
Message-ID: <CA+Z25wX5a4_NFX0xGTWEcPkB=625m9w=OvDgM6o4WgPo3iHqNw@mail.gmail.com>
Subject: Re: [PATCH] PM / devfreq: add comments and Documentation
From: Rajagopal Venkat <rajagopal.venkat@linaro.org>
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        rafael.j.wysocki@intel.com, nm@ti.com, a.kesavan@samsung.com,
        jonghwa3.lee@samsung.com, sangjung.woo@samsung.com,
        myungjoo.ham@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5 February 2013 15:15, MyungJoo Ham <myungjoo.ham@samsung.com> wrote:
> - Added missing ABI documents
> - Added comments to clarify the objectives of functions
>
> Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Acked-by: Rajagopal Venkat <rajagopal.venkat@linaro.org>

> ---
>  Documentation/ABI/testing/sysfs-class-devfreq |   20 ++++++++++++++++++++
>  drivers/devfreq/devfreq.c                     |   10 ++++++++++
>  include/linux/devfreq.h                       |    2 ++
>  3 files changed, 32 insertions(+), 0 deletions(-)
>
> diff --git a/Documentation/ABI/testing/sysfs-class-devfreq b/Documentation/ABI/testing/sysfs-class-devfreq
> index 0ba6ea2..ee39aca 100644
> --- a/Documentation/ABI/testing/sysfs-class-devfreq
> +++ b/Documentation/ABI/testing/sysfs-class-devfreq
> @@ -78,3 +78,23 @@ Contact:     Nishanth Menon <nm@ti.com>
>  Description:
>                 The /sys/class/devfreq/.../available_governors shows
>                 currently available governors in the system.
> +
> +What:          /sys/class/devfreq/.../min_freq
> +Date:          January 2013
> +Contact:       MyungJoo Ham <myungjoo.ham@samsung.com>
> +Description:
> +               The /sys/class/devfreq/.../min_freq shows and stores
> +               the minimum frequency requested by users. It is 0 if
> +               the user does not care. min_freq overrides the
> +               frequency requested by governors.
> +
> +What:          /sys/class/devfreq/.../max_freq
> +Date:          January 2013
> +Contact:       MyungJoo Ham <myungjoo.ham@samsung.com>
> +Description:
> +               The /sys/class/devfreq/.../max_freq shows and stores
> +               the maximum frequency requested by users. It is 0 if
> +               the user does not care. max_freq overrides the
> +               frequency requested by governors and min_freq.
> +               The max_freq overrides min_freq because max_freq may be
> +               used to throttle devices to avoid overheating.
> diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
> index abfa14d..44c4079 100644
> --- a/drivers/devfreq/devfreq.c
> +++ b/drivers/devfreq/devfreq.c
> @@ -527,6 +527,8 @@ EXPORT_SYMBOL(devfreq_add_device);
>  /**
>   * devfreq_remove_device() - Remove devfreq feature from a device.
>   * @devfreq:   the devfreq instance to be removed
> + *
> + * The opposite of devfreq_add_device().
>   */
>  int devfreq_remove_device(struct devfreq *devfreq)
>  {
> @@ -542,6 +544,10 @@ EXPORT_SYMBOL(devfreq_remove_device);
>  /**
>   * devfreq_suspend_device() - Suspend devfreq of a device.
>   * @devfreq: the devfreq instance to be suspended
> + *
> + * This function is intended to be called by the pm callbacks
> + * (e.g., runtime_suspend, suspend) of the device driver that
> + * holds the devfreq.
>   */
>  int devfreq_suspend_device(struct devfreq *devfreq)
>  {
> @@ -559,6 +565,10 @@ EXPORT_SYMBOL(devfreq_suspend_device);
>  /**
>   * devfreq_resume_device() - Resume devfreq of a device.
>   * @devfreq: the devfreq instance to be resumed
> + *
> + * This function is intended to be called by the pm callbacks
> + * (e.g., runtime_resume, resume) of the device driver that
> + * holds the devfreq.
>   */
>  int devfreq_resume_device(struct devfreq *devfreq)
>  {
> diff --git a/include/linux/devfreq.h b/include/linux/devfreq.h
> index e83ef39..04ad61d 100644
> --- a/include/linux/devfreq.h
> +++ b/include/linux/devfreq.h
> @@ -181,6 +181,8 @@ extern struct devfreq *devfreq_add_device(struct device *dev,
>                                   const char *governor_name,
>                                   void *data);
>  extern int devfreq_remove_device(struct devfreq *devfreq);
> +
> +/* Supposed to be called by PM_SLEEP/PM_RUNTIME callbacks */
>  extern int devfreq_suspend_device(struct devfreq *devfreq);
>  extern int devfreq_resume_device(struct devfreq *devfreq);
>
> --
> 1.7.5.4
>



-- 
Regards,
Rajagopal
