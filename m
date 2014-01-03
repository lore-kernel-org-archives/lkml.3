Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752534AbaACR3L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 12:29:11 -0500
Received: from merlin.infradead.org ([205.233.59.134]:51647 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055AbaACR3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 12:29:10 -0500
Message-ID: <52C6F362.20703@infradead.org>
Date: Fri, 03 Jan 2014 09:29:06 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Ramkumar Ramachandra <artagnon@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
CC: Dirk Brandewie <dirk.brandewie@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH] Documentation/cpu-freq: add intel-pstate.txt
References: <1388748673-11032-1-git-send-email-artagnon@gmail.com>
In-Reply-To: <1388748673-11032-1-git-send-email-artagnon@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/03/14 03:31, Ramkumar Ramachandra wrote:
> The Intel P-state driver is currently undocumented. Add some
> documentation based on the cover-letter sent with the original series.
> 
> Cc: Dirk Brandewie <dirk.brandewie@gmail.com>
> Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
> Cc: Viresh Kumar <viresh.kumar@linaro.org>
> Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
> ---
> 
>  Documentation/cpu-freq/intel-pstate.txt | 40 +++++++++++++++++++++++++++++++++
>  1 file changed, 40 insertions(+)
>  create mode 100644 Documentation/cpu-freq/intel-pstate.txt
> 
> diff --git a/Documentation/cpu-freq/intel-pstate.txt b/Documentation/cpu-freq/intel-pstate.txt
> new file mode 100644
> index 0000000..fda74ab
> --- /dev/null
> +++ b/Documentation/cpu-freq/intel-pstate.txt
> @@ -0,0 +1,40 @@
> +Intel P-state driver
> +--------------------
> +
> +This driver implements a scaling driver with an internal governor for
> +Intel Core processors.  The driver follows the same model as the
> +Transmeta scaling driver (longrun.c) and implements the setpolicy()
> +instead of target().  Scaling drivers that implement setpolicy() are
> +assmuned to implement internal governors by the cpufreq core. All the

   assumed

> +logic for selecting the current P state is contained within the driver

                                                                   driver;

> +no external governor is used by the cpufreq core.
> +
> +Only Intel SandyBridge+ processors are supported.
> +
> +New sysfs files for controlling P state selection have been added to
> +/sys/devices/system/cpu/intel_pstate/
> +
> +      max_perf_pct: limits the maximum P state that will be requested by
> +      the driver stated as a percentage of the avail performance.

                                                  available

> +
> +      min_perf_pct: limits the minimum P state that will be  requested by
> +      the driver stated as a percentage of the avail performance.

                                                  available

> +
> +      no_turbo: limits the driver to selecting P states below the turbo
> +      frequency range.
> +
> +The units for these for these files are purposely abstract and stated

                       drop duplicate "for these"

> +in terms of available performance and not frequency.  In idea that

                                                         The idea

> +frequency can be set to a single frequency is a fiction for Intel Core

                                              is fiction

> +processors. Even if the scaling driver selects a single P state the
> +actual frequency the processor will run at is selected by the
> +processor itself.
> +
> +New debugfs files have also been added to /sys/kernel/debug/pstate_snb/
> +
> +      deadband
> +      d_gain_pct
> +      i_gain_pct
> +      p_gain_pct
> +      sample_rate_ms
> +      setpoint
> 


-- 
~Randy
