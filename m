Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751693AbaACJUj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 04:20:39 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:28371 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751621AbaACJUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 04:20:34 -0500
Message-ID: <52C68097.7070508@marvell.com>
Date: Fri, 3 Jan 2014 17:19:19 +0800
From: Jane Li <jiel@marvell.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] cpufreq: Fix timer/workqueue corruption by protecting
 reading governor_enabled
References: <1388731451-10963-1-git-send-email-jiel@marvell.com> <CAKohpomWCpxCSFfG601Pc_FKcbZ3J7G2nsBABMb8qqQJ38h1cg@mail.gmail.com>
In-Reply-To: <CAKohpomWCpxCSFfG601Pc_FKcbZ3J7G2nsBABMb8qqQJ38h1cg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2014-01-03_03:2014-01-02,2014-01-03,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1401030005
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 01/03/2014 02:50 PM, Viresh Kumar wrote:
> On 3 January 2014 12:14,  <jiel@marvell.com> wrote:
>> diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
>> index dc196bb..15c62df 100644
>> --- a/include/linux/cpufreq.h
>> +++ b/include/linux/cpufreq.h
>> @@ -389,6 +389,7 @@ int __cpufreq_driver_target(struct cpufreq_policy *policy,
>>                                     unsigned int relation);
>>   int cpufreq_register_governor(struct cpufreq_governor *governor);
>>   void cpufreq_unregister_governor(struct cpufreq_governor *governor);
>> +extern struct mutex cpufreq_governor_lock;
>>
>>   /* CPUFREQ DEFAULT GOVERNOR */
>>   /*
> Move this to cpufreq_governor.h instead. I don't want this to be available
> for everybody to use it.

OK. Have pushed PATCH v4. Please review again.

Thanks!

