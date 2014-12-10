Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933234AbaLJVt3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 16:49:29 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:26954 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932582AbaLJVt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 16:49:28 -0500
Message-ID: <5488BFC5.3080001@fb.com>
Date: Wed, 10 Dec 2014 16:48:53 -0500
From: Josef Bacik <jbacik@fb.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Mike Galbraith <umgwanakikbuti@gmail.com>
CC: <bmaurer@fb.com>, <rkroll@fb.com>, <kernel-team@fb.com>,
        <mingo@redhat.com>, <peterz@infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched/fair: change where we report sched stats
References: <1418149315-30173-1-git-send-email-jbacik@fb.com> <1418192604.5312.28.camel@marge.simpson.net>
In-Reply-To: <1418192604.5312.28.camel@marge.simpson.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.16.4]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2014-12-10_08:2014-12-10,2014-12-10,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 kscore.is_bulkscore=0
 kscore.compositescore=0 circleOfTrustscore=121.849647738959
 compositescore=0.182402046397986 urlsuspect_oldscore=0.182402046397986
 suspectscore=0 recipient_domain_to_sender_totalscore=0 phishscore=0
 bulkscore=0 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=1996008
 rbsscore=0.182402046397986 spamscore=0
 recipient_to_sender_domain_totalscore=7 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1412100205
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2014 01:23 AM, Mike Galbraith wrote:
> On Tue, 2014-12-09 at 13:21 -0500, Josef Bacik wrote:
>
>> This patch moves stat stuff to after the schedule, right as we are waking up,
>
> But sleep/block ends when the task is awakened/enqueued, not when it
> gets the CPU.  You're adding scheduling latency, breaking accounting.
>

Yes I'm aware of that.  I don't care if the delay time is slightly 
higher than normal, I care about knowing exactly why we were sleeping to 
begin with.  I suppose I could leave the accounting part where it is and 
then just fire the tracepoint when it's put on the CPU so we get the 
best of both worlds, but honestly I don't feel like adding the extra 
scheduling latency into the accounting is that big of a deal.  Thanks,

Josef

