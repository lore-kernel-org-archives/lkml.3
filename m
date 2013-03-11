Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753636Ab3CKA5x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 20:57:53 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:49543 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753448Ab3CKA5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 20:57:51 -0400
MIME-Version: 1.0
In-Reply-To: <513CAD9B.908@gmail.com>
References: <6cba8f153cfd4b0d3075a34a6dfe287bdec2eb06.1362676407.git.viresh.kumar@linaro.org>
	<513CAD9B.908@gmail.com>
Date: Mon, 11 Mar 2013 08:57:49 +0800
Message-ID: <CAKohponV8MR=J8bbNFxGF9JXQB0uadv7iDcbW9D-qr2N53U_kQ@mail.gmail.com>
Subject: Re: [PATCH V2] cpufreq: ARM big LITTLE: Add generic cpufreq driver
 and its DT glue
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Francesco Lavra <francescolavra.fl@gmail.com>
Cc: rjw@sisk.pl, Steve.Bannister@arm.com, linux@arm.linux.org.uk,
        linux-pm@vger.kernel.org,
        Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>,
        devicetree-discuss@lists.ozlabs.org, Liviu.Dudau@arm.com,
        linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
        robin.randhawa@arm.com, linux-arm-kernel@lists.infradead.org,
        mark.hambleton@broadcom.com, linaro-kernel@lists.linaro.org,
        charles.garcia-tobin@arm.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 March 2013 23:58, Francesco Lavra <francescolavra.fl@gmail.com> wrote:
> On 03/07/2013 06:14 PM, Viresh Kumar wrote:
>> +void bL_cpufreq_unregister(struct cpufreq_arm_bL_ops *ops)
>> +{
>> +     if (arm_bL_ops != ops) {
>> +             pr_info("%s: Registered with: %s, can't unregister, exiting\n",
>> +                             __func__, arm_bL_ops->name);
>> +     }
>
> The code is not doing what the info message says.

Yes, following is the improvement:

diff --git a/drivers/cpufreq/arm_big_little.c b/drivers/cpufreq/arm_big_little.c
index 8b8b07e..9d449cf 100644
--- a/drivers/cpufreq/arm_big_little.c
+++ b/drivers/cpufreq/arm_big_little.c
@@ -264,8 +264,9 @@ EXPORT_SYMBOL_GPL(bL_cpufreq_register);
 void bL_cpufreq_unregister(struct cpufreq_arm_bL_ops *ops)
 {
        if (arm_bL_ops != ops) {
-               pr_info("%s: Registered with: %s, can't unregister, exiting\n",
+               pr_err("%s: Registered with: %s, can't unregister, exiting\n",
                                __func__, arm_bL_ops->name);
+               return;
        }
