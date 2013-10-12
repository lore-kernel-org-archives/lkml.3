Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407Ab3JLU30 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Oct 2013 16:29:26 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:51008 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752732Ab3JLU3Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Oct 2013 16:29:25 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpufreq: acpi: Add comment under ACPI_ADR_SPACE_SYSTEM_IO case
Date: Sat, 12 Oct 2013 22:41:08 +0200
Message-ID: <1402816.XYNGOIhCWR@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <CAKohpokJkcsNN_vnQOuu2=arsiQCGPaCxpRL_TRAQYFg+LmR+w@mail.gmail.com>
References: <6334c0aed4840857944d1b267871ada4d7014d57.1381541632.git.viresh.kumar@linaro.org> <1922770.iubCDBg3Zg@vostro.rjw.lan> <CAKohpokJkcsNN_vnQOuu2=arsiQCGPaCxpRL_TRAQYFg+LmR+w@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, October 12, 2013 08:58:10 PM Viresh Kumar wrote:
> On 12/10/2013, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > Well, please merge it with the existing comment and use the usual format
> > for comments that are longer than two lines.
> 
> I thought these are separate comments and so keeping them separate
> might be better,

No, comments that go like

	/* Comment 1. */
	/* Comment 2. */

do not even *look* separate.

In general you can do something like

	/*
	 * Comment 1.
	 *
	 * Comment 2.
	 */

in such cases, but again in this particular case the comments aren't even
logically separate in my opinion. ->

> so that this one doesn't get deleted in case somebody
> is removing the other one.. and vice versa..
> 
> Anyway its fixed in attached commit now :)
> 
> commit ecb9ef81b50eb5e8559f7d132ef46803c8272091
> Author: Viresh Kumar <viresh.kumar@linaro.org>
> Date:   Sat Oct 12 07:00:01 2013 +0530
> 
>     cpufreq: acpi: Add comment under ACPI_ADR_SPACE_SYSTEM_IO case
> 
>     policy->cur is now set by cpufreq core when cpufreq_driver->get()
> is defined and
>     so drivers aren't required to set it. When space_id is
> ACPI_ADR_SPACE_SYSTEM_IO
>     for acpi cpufreq driver it doesn't set ->get to a valid function
> pointer and so
>     policy->cur is required to be set by driver.
> 
>     This is already followed in acpi-cpufreq driver. This patch adds a comment
>     describing why we need to set policy->cur from driver.
> 
>     Suggested-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>     Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>  drivers/cpufreq/acpi-cpufreq.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/cpufreq/acpi-cpufreq.c b/drivers/cpufreq/acpi-cpufreq.c
> index a8dac7b..d2df543 100644
> --- a/drivers/cpufreq/acpi-cpufreq.c
> +++ b/drivers/cpufreq/acpi-cpufreq.c
> @@ -837,7 +837,12 @@ static int acpi_cpufreq_cpu_init(struct
> cpufreq_policy *policy)
> 
>         switch (perf->control_register.space_id) {
>         case ACPI_ADR_SPACE_SYSTEM_IO:
> -               /* Current speed is unknown and not detectable by IO port */
> +               /*
> +                * Current speed is unknown and not detectable by IO port.
> +                * policy->cur wouldn't be set by core as cpufreq_driver->get()
> +                * is NULL for this space_id and so we need to set policy->cur
> +                * here.
> +                */

-> What about this:

	/*
	 * The core will not set policy->cur, because cpufreq_driver->get is NULL,
	 * so we need to set it here.  However, we have to guess it, because the
	 * current speed is unknown and not detectable via IO ports.
	 */

>                 policy->cur = acpi_cpufreq_guess_freq(data, policy->cpu);
>                 break;
>         case ACPI_ADR_SPACE_FIXED_HARDWARE:

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
