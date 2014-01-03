Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751318AbaACGpG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 01:45:06 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:1625 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750995AbaACGo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 01:44:59 -0500
Message-ID: <52C65C4F.1060804@marvell.com>
Date: Fri, 3 Jan 2014 14:44:31 +0800
From: Jane Li <jiel@marvell.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "viresh.kumar@linaro.org" <viresh.kumar@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] cpufreq: Fix timer/workqueue corruption by protecting
 reading governor_enabled
References: <1388632482-16921-1-git-send-email-jiel@marvell.com> <20140102232638.GA21548@core.coreip.homeip.net>
In-Reply-To: <20140102232638.GA21548@core.coreip.homeip.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2014-01-03_03:2014-01-02,2014-01-03,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1401020249
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 01/03/2014 07:26 AM, Dmitry Torokhov wrote
> Unlocking in different branches is not the best practice IMO, I'd
> recommend doing:
>
> 	mutex_lock(&cpufreq_governor_lock);
>
> 	if (!policy->governor_enabled)
> 		goto out_unlock;
>
> 	...
>
> out_unlock:
> 	mutex_unlock(&cpufreq_governor_lock);
>
> Thanks!
>
OK. I have pushed PATCH v3. Please review again.

Besides, I use checkpatch.pl to check this patch, and find there is warning. PATCH v3 also move cpufreq_governor_lock declaration to cpufreq.h.

WARNING: externs should be avoided in .c files
#106: FILE: drivers/cpufreq/cpufreq_governor.c:25:
+extern struct mutex cpufreq_governor_lock;

Thanks!

