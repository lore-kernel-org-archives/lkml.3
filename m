Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782AbaFJF32 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 01:29:28 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:63782 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113AbaFJF30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 01:29:26 -0400
MIME-Version: 1.0
In-Reply-To: <53962087.8000706@semaphore.gr>
References: <53962087.8000706@semaphore.gr>
Date: Tue, 10 Jun 2014 10:59:25 +0530
Message-ID: <CAKohpokJfS=wFFFuqc26tnojTViuejVQMXGn18DAqrN+j0Zihw@mail.gmail.com>
Subject: Re: [PATCH 5/7] cpufreq: intel_pstate: Remove redundant includes
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Stratos Karafotis <stratosk@semaphore.gr>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Dirk Brandewie <dirk.j.brandewie@intel.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 June 2014 02:30, Stratos Karafotis <stratosk@semaphore.gr> wrote:
> Also put them in alphabetical order.
>
> Signed-off-by: Stratos Karafotis <stratosk@semaphore.gr>
> ---
>  drivers/cpufreq/intel_pstate.c | 17 ++---------------
>  1 file changed, 2 insertions(+), 15 deletions(-)
>
> diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
> index 26a0262..d4f0518 100644
> --- a/drivers/cpufreq/intel_pstate.c
> +++ b/drivers/cpufreq/intel_pstate.c
> @@ -10,26 +10,13 @@
>   * of the License.
>   */
>
> -#include <linux/kernel.h>
> -#include <linux/kernel_stat.h>
> -#include <linux/module.h>
> -#include <linux/ktime.h>
> -#include <linux/hrtimer.h>
> -#include <linux/tick.h>
> -#include <linux/slab.h>
> -#include <linux/sched.h>
> -#include <linux/list.h>
> +#include <linux/acpi.h>
>  #include <linux/cpu.h>
>  #include <linux/cpufreq.h>
> -#include <linux/sysfs.h>
> -#include <linux/types.h>
> -#include <linux/fs.h>
>  #include <linux/debugfs.h>
> -#include <linux/acpi.h>
> +#include <linux/module.h>
>  #include <trace/events/power.h>
>
> -#include <asm/div64.h>
> -#include <asm/msr.h>
>  #include <asm/cpu_device_id.h>

As a rule, header files for all the symbols directly used by a file must
be included directly by the file and must not depend on indirect inclusions.

So even if it compiles, its the wrong thing to do. Though you can obviously
remove the headers which aren't used.
