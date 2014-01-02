Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751249AbaABDQI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jan 2014 22:16:08 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:41888 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750768AbaABDQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jan 2014 22:16:05 -0500
Message-ID: <52C4D9E0.5070501@marvell.com>
Date: Thu, 2 Jan 2014 11:15:44 +0800
From: Jane Li <jiel@marvell.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cpufreq: Fix timer/workqueue corruption by protecting
 reading governor_enabled
References: <1388136651-21883-1-git-send-email-jiel@marvell.com>	<CAKohpokWMgXotgKWFmqOPzdoZME=frBQOjeU1uFJwQ778DHAKg@mail.gmail.com>	<52C112CC.4040306@marvell.com> <CAKohpomwA0PHBvFiK+-i6LDHX8J_s2hfm4-ciKFB9DSS8q0Wdw@mail.gmail.com>
In-Reply-To: <CAKohpomwA0PHBvFiK+-i6LDHX8J_s2hfm4-ciKFB9DSS8q0Wdw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2014-01-02_02:2014-01-01,2014-01-02,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1401010220
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Yes, I test it. After adding cpufreq_governor_lock in gov_queue_work() and
>> running same test, there is no debugobjects warning.
> But it really can't work at all.. There should be a separate copy of lock
> in every file that includes cpufreq.h.. And so this shouldn't have worked.
>
Oh.. I understand what you mean now. My patch is not right and cannot fix this issue.

By default, the debugobjects warning sometimes occurs after five minutes, and sometimes occurs after twenty hours. With this patch, I test more than fifty hours, and warning did not occurs. It shows that my test time is not long enough and miss the right one.


I have updated PATCH v2, please review again. Thanks.

