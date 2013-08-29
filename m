Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756276Ab3H2KQD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 06:16:03 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:65077 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756058Ab3H2KP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 06:15:59 -0400
MIME-Version: 1.0
Date: Thu, 29 Aug 2013 15:45:58 +0530
Message-ID: <CAKohponWn-RN7-6sdhghd6RGCOd357G+TKLsxHfqnSCuMD7xxw@mail.gmail.com>
Subject: [Query] CPUFreq: Does these machines have separate clock domains for CPUs?
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Miller <davem@davemloft.net>, Eric Miao <eric.y.miao@gmail.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        John Crispin <blogic@openwrt.org>, linux-cris-kernel@axis.com,
        linux-sh@vger.kernel.org, Mikael Starvik <starvik@axis.com>,
        Paul Mundt <lethal@linux-sh.org>, Sekhar Nori <nsekhar@ti.com>,
        sparclinux@vger.kernel.org, Miao Steven <realmz6@gmail.com>,
        Dave Jones <davej@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have been doing some CPUFreq cleanup work and
wanted to know if the below mentioned machines have separate
clock domains for their CPUs or all share the same domain?

So, that we can use some generic routines for these drivers which
would eventually do:

cpumask_setall(policy->cpus);

And I wanted to make sure that this doesn't break them.. :)

......

The drivers are:

drivers/cpufreq/at32ap-cpufreq.c
drivers/cpufreq/blackfin-cpufreq.c
drivers/cpufreq/cris-artpec3-cpufreq.c
drivers/cpufreq/cris-etraxfs-cpufreq.c
drivers/cpufreq/davinci-cpufreq.c
drivers/cpufreq/e_powersaver.c
drivers/cpufreq/elanfreq.c
drivers/cpufreq/longhaul.c
drivers/cpufreq/loongson2_cpufreq.c
drivers/cpufreq/pmac32-cpufreq.c
drivers/cpufreq/powernow-k6.c
drivers/cpufreq/powernow-k7.c
drivers/cpufreq/pxa2xx-cpufreq.c
drivers/cpufreq/pxa3xx-cpufreq.c
drivers/cpufreq/sc520_freq.c
drivers/cpufreq/sh-cpufreq.c
drivers/cpufreq/sparc-us2e-cpufreq.c
drivers/cpufreq/sparc-us3-cpufreq.c

--
Viresh
