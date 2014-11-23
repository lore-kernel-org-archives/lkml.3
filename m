Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751836AbaKWQgd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 11:36:33 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:16575 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751254AbaKWQgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 11:36:32 -0500
Date: Sun, 23 Nov 2014 11:36:06 -0500
From: Chris Mason <clm@fb.com>
Subject: Re: New crashes walking proc with Saturday's git
To: Borislav Petkov <bp@alien8.de>
CC: <torvalds@linux-foundation.org>, <linux-kernel@vger.kernel.org>
Message-ID: <1416760566.24312.14@mail.thefacebook.com>
In-Reply-To: <20141123163258.GB6436@pd.tnic>
References: <20141123010239.GA12691@ret.masoncoding.com>
	<1416758187.24312.12@mail.thefacebook.com> <20141123161120.GB7070@pd.tnic>
	<1416759411.24312.13@mail.thefacebook.com> <20141123163258.GB6436@pd.tnic>
X-Mailer: geary/0.8.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
X-Originating-IP: [192.168.16.4]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.28,0.0.0000
 definitions=2014-11-23_03:2014-11-21,2014-11-23,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=5.55111512312578e-17 kscore.compositescore=0
 circleOfTrustscore=3.22713754331347 compositescore=0.939076664828693
 urlsuspect_oldscore=0.939076664828693 suspectscore=0
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=64355
 rbsscore=0.939076664828693 spamscore=0
 recipient_to_sender_domain_totalscore=4 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1411230139
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 23, 2014 at 11:32 AM, Borislav Petkov <bp@alien8.de> wrote:
> On Sun, Nov 23, 2014 at 11:16:51AM -0500, Chris Mason wrote:
>>  It must be:
>> 
>>  commit 6e998916dfe327e785e7c2447959b2c1a3ea4930
>>  Author: Stanislaw Gruszka <sgruszka@redhat.com>
>>  Date:   Wed Nov 12 16:58:44 2014 +0100
>> 
>>     sched/cputime: Fix clock_nanosleep()/clock_gettime() 
>> inconsistency
>> 
>>  I'll do two runs to confirm, but it's the only related patch 
>> between rc5 and
>>  now.
> 
> Cool, let me know and I'll revert here too to verify. It might take a
> while to confirm as it happens only during resume but I could try the
> fork bomb if I must.
> 
> From looking at it I'm not getting any smarter. We iterate over the
> threads under a rcu_read_lock() so we should be protected. Unless the
> sched changes have somehow effect on RCU grace periods but WTH do I
> know... This is crazy code.

+               p->sched_class->update_curr(rq);

Total guess while I'm waiting for the test, but somehow this is NULL.

-chris



