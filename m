Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751786AbaJPIPs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 04:15:48 -0400
Received: from mail-oi0-f50.google.com ([209.85.218.50]:49182 "EHLO
	mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194AbaJPIPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 04:15:45 -0400
MIME-Version: 1.0
In-Reply-To: <1413322689-6195-1-git-send-email-jgeboski@gmail.com>
References: <1413322689-6195-1-git-send-email-jgeboski@gmail.com>
Date: Thu, 16 Oct 2014 13:45:44 +0530
Message-ID: <CAKohpom5fLHc3aFWuxbj4teGiE08cXLMndthaAKBugWUp-_9kA@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: allow powersave governor as the default without
 expert mode
From: Viresh Kumar <viresh.kumar@linaro.org>
To: James Geboski <jgeboski@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 October 2014 03:08, James Geboski <jgeboski@gmail.com> wrote:
> The intel_pstate driver only supports the performance and the powersave
> governors. With the performance governor ensuring the highest possible
> performance settings, userspace tools fail to make any lasting changes.
> In order to allow userspace tools to make modifications to the settings,
> the powersave governor must be in use. This makes having the powersave
> governor as the default convenient for systems where the intel_pstate
> driver is being employed. Having to enable expert mode in the kernel
> configuration is just a headache for such a trivial task.
>
> This patch applies to all kernel versions 2.6.38 or greater after the
> migration from CONFIG_EMBEDDED to CONFIG_EXPERT (6a108a14fa35). Most
> importantly, this applies to kernel versions 3.9 or greater when the
> intel_pstate driver was introduced.
>
> Signed-off-by: James Geboski <jgeboski@gmail.com>
> ---
>  drivers/cpufreq/Kconfig | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/drivers/cpufreq/Kconfig b/drivers/cpufreq/Kconfig
> index 3489f8f..73df7db 100644
> --- a/drivers/cpufreq/Kconfig
> +++ b/drivers/cpufreq/Kconfig
> @@ -63,7 +63,6 @@ config CPU_FREQ_DEFAULT_GOV_PERFORMANCE
>
>  config CPU_FREQ_DEFAULT_GOV_POWERSAVE
>         bool "powersave"
> -       depends on EXPERT
>         select CPU_FREQ_GOV_POWERSAVE
>         help
>           Use the CPUFreq governor 'powersave' as default. This sets

This was the commit which introduced it:

commit 30d221db4439973076953e2ed44344fa92d1d09f
Author: Alessandro Guido <alessandro.guido@gmail.com>
Date:   Fri Apr 18 13:31:13 2008 -0700

    [CPUFREQ] allow use of the powersave governor as the default one

    Allow use of the powersave cpufreq governor as the default one for EMBEDDED
    configs.

    Signed-off-by: Alessandro Guido <alessandro.guido@gmail.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Dave Jones <davej@redhat.com>
---
 drivers/cpufreq/Kconfig             | 9 +++++++++
 drivers/cpufreq/cpufreq_powersave.c | 8 ++++++--
 include/linux/cpufreq.h             | 3 +++
 3 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/Kconfig b/drivers/cpufreq/Kconfig
index c159ae6..5f076ae 100644
--- a/drivers/cpufreq/Kconfig
+++ b/drivers/cpufreq/Kconfig
@@ -69,6 +69,15 @@ config CPU_FREQ_DEFAULT_GOV_PERFORMANCE
          the frequency statically to the highest frequency supported by
          the CPU.

+config CPU_FREQ_DEFAULT_GOV_POWERSAVE
+       bool "powersave"
+       depends on EMBEDDED
+       select CPU_FREQ_GOV_POWERSAVE
+       help
+         Use the CPUFreq governor 'powersave' as default. This sets
+         the frequency statically to the lowest frequency supported by
+         the CPU.
+



And I think it was wrong since ever, it should have been selected by
EMBEDDED instead
of a depends here.

For your patch:

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
