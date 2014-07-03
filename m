Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754399AbaGCCLh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 22:11:37 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:41944 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754004AbaGCCLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 22:11:35 -0400
MIME-Version: 1.0
In-Reply-To: <53B4A718.3050702@codeaurora.org>
References: <cover.1404231535.git.viresh.kumar@linaro.org>
	<b26946cc4573904cd1ef0212ad053a983b547c23.1404231535.git.viresh.kumar@linaro.org>
	<53B4A718.3050702@codeaurora.org>
Date: Thu, 3 Jul 2014 07:41:34 +0530
Message-ID: <CAKohpomqE5dw2OJMjQmWswHmKXsKmyw0LtjtQopd0ttOA6=hhQ@mail.gmail.com>
Subject: Re: [PATCH 09/14] cpufreq: cpu0: Move per-cluster initialization code
 to ->init()
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Shawn Guo <shawn.guo@linaro.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arvind Chauhan <arvind.chauhan@arm.com>, linux-arm-msm@vger.kernel.org,
        Sachin Kamat <spk.linux@gmail.com>,
        Thomas P Abraham <thomas.ab@samsung.com>, Nishanth Menon <nm@ti.com>,
        Tomasz Figa <t.figa@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3 July 2014 06:13, Stephen Boyd <sboyd@codeaurora.org> wrote:
> drivers/cpufreq/cpufreq-generic.c:313:13: warning: 'cdev' may be used
> uninitialized in this function [-Wmaybe-uninitialized]
>
> So I guess we should initialize it to NULL?

I somehow didn't got this, I checked again. I have fixed it this way:

diff --git a/drivers/cpufreq/cpufreq-cpu0.c b/drivers/cpufreq/cpufreq-cpu0.c
index e6dc8ea..05a18bd 100644
--- a/drivers/cpufreq/cpufreq-cpu0.c
+++ b/drivers/cpufreq/cpufreq-cpu0.c
@@ -240,10 +240,11 @@ static int cpu0_cpufreq_init(struct
cpufreq_policy *policy)
                        dev_err(cpu_dev,
                                "running cpufreq without cooling device: %ld\n",
                                PTR_ERR(cdev));
+               else
+                       priv->cdev = cdev;
        }
        of_node_put(np);

-       priv->cdev = cdev;
        priv->cpu_dev = cpu_dev;
        priv->cpu_reg = cpu_reg;
        policy->driver_data = priv;
