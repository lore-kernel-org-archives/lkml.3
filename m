Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932788Ab3CGREx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 12:04:53 -0500
Received: from mail-ob0-f181.google.com ([209.85.214.181]:40197 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756089Ab3CGREv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 12:04:51 -0500
MIME-Version: 1.0
In-Reply-To: <20130307114950.GF17833@n2100.arm.linux.org.uk>
References: <f20e3c5e822c4bd28a3b71264d73143cc1f850b0.1362458878.git.viresh.kumar@linaro.org>
	<20130305105251.GL17833@n2100.arm.linux.org.uk>
	<CAKohpo=cBkHZnSa8ZsM=k7RRN+RZDXFUWDM82EXXBSQcM-8Vhw@mail.gmail.com>
	<20130307005119.GY17833@n2100.arm.linux.org.uk>
	<CAKohpok7aD-J-undUisxaOotbXWimPo46jqOH4ok04kg_hMWHA@mail.gmail.com>
	<20130307114950.GF17833@n2100.arm.linux.org.uk>
Date: Fri, 8 Mar 2013 01:04:51 +0800
Message-ID: <CAKohpomp_DFi3GAJeTUiQowyEvfXcmTeuf9+O0qcXsXtbFkTDg@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: ARM big LITTLE: Add generic cpufreq driver and
 its DT glue
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: rjw@sisk.pl, Steve.Bannister@arm.com, linux-pm@vger.kernel.org,
        Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>,
        Liviu.Dudau@arm.com, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org, robin.randhawa@arm.com,
        linux-arm-kernel@lists.infradead.org, mark.hambleton@broadcom.com,
        linaro-kernel@lists.linaro.org, charles.garcia-tobin@arm.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7 March 2013 19:49, Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
> So how is this different from any other clock which may also return zero
> from its clk_get_rate() ?
>
> If that's the condition you want to check for, call clk_get_rate() after
> a successful clk_get*() and check for the condition.  Don't go treating
> the cookie somehow specially.  You're *assuming* a behaviour that is
> inappropriate for the side of the interface you're working with.

Okay. I will replace the earlier fixup with following:

diff --git a/drivers/cpufreq/Kconfig.arm b/drivers/cpufreq/Kconfig.arm
index fdf54a9..87b7e48 100644
--- a/drivers/cpufreq/Kconfig.arm
+++ b/drivers/cpufreq/Kconfig.arm
@@ -9,8 +9,7 @@ config ARM_BIG_LITTLE_CPUFREQ
 config ARM_DT_BL_CPUFREQ
        tristate "Generic ARM big LITTLE CPUfreq driver probed via DT"
        select ARM_BIG_LITTLE_CPUFREQ
-       depends on OF
-       default n
+       depends on OF && HAVE_CLK
        help
          This enables the Generic CPUfreq driver for ARM big.LITTLE platform.
          This gets frequency tables from DT.
diff --git a/drivers/cpufreq/arm_big_little.c b/drivers/cpufreq/arm_big_little.c
index 2486b9a..a41fd89 100644
--- a/drivers/cpufreq/arm_big_little.c
+++ b/drivers/cpufreq/arm_big_little.c
@@ -147,7 +147,7 @@ static void put_cluster_clk_and_freq_table(u32 cluster)

 static int get_cluster_clk_and_freq_table(u32 cluster)
 {
-       char name[9] = "cluster";
+       char name[9] = "cpu-cluster";
        int count;

        if (atomic_inc_return(&cluster_usage[cluster]) != 1)


For more clarity i will resend this patch now will all updates.
