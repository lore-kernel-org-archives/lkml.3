Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693Ab3C2Cs5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 22:48:57 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:61359 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753126Ab3C2Csz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 22:48:55 -0400
MIME-Version: 1.0
In-Reply-To: <1364495057-14939-1-git-send-email-jacob.shin@amd.com>
References: <1364495057-14939-1-git-send-email-jacob.shin@amd.com>
Date: Fri, 29 Mar 2013 08:18:54 +0530
Message-ID: <CAKohpokHs3pxnYx3QraEYhxqGs8KdTiomPpcbEDNgChaZDWK4A@mail.gmail.com>
Subject: Re: [PATCH V2 0/2] cpufreq: ondemand: add AMD specific powersave bias
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Jacob Shin <jacob.shin@amd.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28 March 2013 23:54, Jacob Shin <jacob.shin@amd.com> wrote:
> This patchset adds AMD specific powersave bias function to the ondemand
> governor; which can be used to help ondemand governor make more power conscious
> frequency change decisions based on feedback from hardware (availble on AMD
> Family 16h and above).
>
> Hardware feedback tells software how "sensitive" to frequency changes the
> workloads are. CPU-bound workloads will be more sensitive -- they will
> perform better as frequency increases. Memory/IO-bound workloads will be less
> sensitive -- they will not necessarily perform better as frequnecy increases.
>
> This patchset was compared against ondemand governor without powersave bias
> and did not show any performance degradation on CPU-bound workloads such as
> kernbench and unixbench. While saving power on Memory-bound workloads such as
> stream.
>
> This applies to linux-pm's linux-next branch, on top of Viresh's 'Implement
> per policy instance of governor' V4 patchset:
>
> https://lkml.org/lkml/2013/3/27/348
>
> V2:
> * Added proper include files to amd_freq_sensitivity.c
> * Only register powersave_bias_target function pointer and not the entire
>   od_ops.
>
> Jacob Shin (2):
>   cpufreq: ondemand: allow custom powersave_bias_target function to be
>     registered
>   cpufreq: AMD "frequency sensitivity feedback" powersave bias for
>     ondemand governor
>
>  arch/x86/include/uapi/asm/msr-index.h  |    1 +
>  drivers/cpufreq/Kconfig.x86            |   10 +++
>  drivers/cpufreq/Makefile               |    1 +
>  drivers/cpufreq/amd_freq_sensitivity.c |  147 ++++++++++++++++++++++++++++++++
>  drivers/cpufreq/cpufreq_governor.h     |    3 +
>  drivers/cpufreq/cpufreq_ondemand.c     |   22 ++++-
>  6 files changed, 181 insertions(+), 3 deletions(-)
>  create mode 100644 drivers/cpufreq/amd_freq_sensitivity.c

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
