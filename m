Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752425AbaAFAyG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 19:54:06 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:64986 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752389AbaAFAyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 19:54:04 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Ramkumar Ramachandra <artagnon@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Dirk Brandewie <dirk.brandewie@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Linux PM <linux-pm@vger.kernel.org>
Subject: Re: [PATCH v3] Documentation/cpu-freq: add intel-pstate.txt
Date: Mon, 06 Jan 2014 02:07:49 +0100
Message-ID: <1574366.rBToHPL5dG@vostro.rjw.lan>
User-Agent: KMail/4.11.3 (Linux/3.13.0-rc6+; KDE/4.11.3; x86_64; ; )
In-Reply-To: <1388917274-19241-1-git-send-email-artagnon@gmail.com>
References: <1388917274-19241-1-git-send-email-artagnon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, January 05, 2014 03:51:14 PM Ramkumar Ramachandra wrote:
> The Intel P-state driver is currently undocumented. Add some
> documentation based on the cover-letter sent with the original series.
> 
> Cc: Dirk Brandewie <dirk.brandewie@gmail.com>
> Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
> Cc: Randy Dunlap <rdunlap@infradead.org>
> Cc: Linux PM <linux-pm@vger.kernel.org>
> Acked-by: Randy Dunlap <rdunlap@infradead.org>
> Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>

Queued up for 3.14, thanks!

> ---
>  Documentation/cpu-freq/intel-pstate.txt | 40 +++++++++++++++++++++++++++++++++
>  1 file changed, 40 insertions(+)
>  create mode 100644 Documentation/cpu-freq/intel-pstate.txt
> 
> diff --git a/Documentation/cpu-freq/intel-pstate.txt b/Documentation/cpu-freq/intel-pstate.txt
> new file mode 100644
> index 0000000..e742d21
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
> +assumed to implement internal governors by the cpufreq core. All the
> +logic for selecting the current P state is contained within the
> +driver; no external governor is used by the cpufreq core.
> +
> +Intel SandyBridge+ processors are supported.
> +
> +New sysfs files for controlling P state selection have been added to
> +/sys/devices/system/cpu/intel_pstate/
> +
> +      max_perf_pct: limits the maximum P state that will be requested by
> +      the driver stated as a percentage of the available performance.
> +
> +      min_perf_pct: limits the minimum P state that will be  requested by
> +      the driver stated as a percentage of the available performance.
> +
> +      no_turbo: limits the driver to selecting P states below the turbo
> +      frequency range.
> +
> +For contemporary Intel processors, the frequency is controlled by the
> +processor itself and the P-states exposed to software are related to
> +performance levels.  The idea that frequency can be set to a single
> +frequency is fiction for Intel Core processors. Even if the scaling
> +driver selects a single P state the actual frequency the processor
> +will run at is selected by the processor itself.
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
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
