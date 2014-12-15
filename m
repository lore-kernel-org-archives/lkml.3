Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751078AbaLOShN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 13:37:13 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:65090 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750818AbaLOShK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 13:37:10 -0500
Date: Mon, 15 Dec 2014 13:36:53 -0500
From: Chris Mason <clm@fb.com>
Subject: Re: [PATCH 3/3] X86: Add a thread cpu time implementation to vDSO
To: Ingo Molnar <mingo@kernel.org>
CC: Andy Lutomirski <luto@amacapital.net>, Shaohua Li <shli@fb.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, <kernel-team@fb.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>
Message-ID: <1418668613.4200.4@mail.thefacebook.com>
In-Reply-To: <20141211063621.GC5059@gmail.com>
References: <f0f3eab5f68f74bfabf42d745ccf1e2ecf642683.1418006970.git.shli@fb.com>
	<862cbb2ab71a9f71d1123b5512605350a4b61846.1418006970.git.shli@fb.com>
	<CALCETrUU-vb34550mbE-yqoWYrzVNarVf++Logt0gmSTh_Cg2w@mail.gmail.com>
	<20141210215713.GA30230@devbig257.prn2.facebook.com>
	<CALCETrUi--fmZLBUB=tjmGt_D3y+HJ+MtJTRZ0=JUKFgAvxyuA@mail.gmail.com>
	<20141210225627.GA11754@devbig257.prn2.facebook.com>
	<CALCETrXpVUVY6paKJq0Uq8VeHG2A0E3qc4b_H+5ZT-QJApkaJw@mail.gmail.com>
	<20141211063621.GC5059@gmail.com>
X-Mailer: geary/0.8.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
X-Originating-IP: [192.168.16.4]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2014-12-15_04:2014-12-15,2014-12-15,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 kscore.is_bulkscore=0
 kscore.compositescore=0 circleOfTrustscore=36.6837327782468
 compositescore=0.923639739835017 urlsuspect_oldscore=0.923639739835017
 suspectscore=0 recipient_domain_to_sender_totalscore=0 phishscore=0
 bulkscore=0 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=62764
 rbsscore=0.923639739835017 spamscore=0
 recipient_to_sender_domain_totalscore=35 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1412150176
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, Dec 11, 2014 at 1:36 AM, Ingo Molnar <mingo@kernel.org> wrote:
> 
> * Andy Lutomirski <luto@amacapital.net> wrote:
> 
>>  On Wed, Dec 10, 2014 at 2:56 PM, Shaohua Li <shli@fb.com> wrote:
>>  > On Wed, Dec 10, 2014 at 02:13:23PM -0800, Andy Lutomirski wrote:
>>  >> On Wed, Dec 10, 2014 at 1:57 PM, Shaohua Li <shli@fb.com> wrote:
>>  >> > On Wed, Dec 10, 2014 at 11:10:52AM -0800, Andy Lutomirski 
>> wrote:
>>  >> >> On Sun, Dec 7, 2014 at 7:03 PM, Shaohua Li <shli@fb.com> 
>> wrote:
>>  >> >> > This primarily speeds up 
>> clock_gettime(CLOCK_THREAD_CPUTIME_ID, ..). We
>>  >> >> > use the following method to compute the thread cpu time:
>>  >> >>
>>  >> >> I like the idea, and I like making this type of profiling 
>> fast.  I
>>  >> >> don't love the implementation because it's an information 
>> leak (maybe
>>  >> >> we don't care) and it's ugly.
>>  >> >>
>>  >> >> The info leak could be fixed completely by having a 
>> per-process array
>>  >> >> instead of a global array.  That's currently tricky without 
>> wasting
>>  >> >> memory, but it could be created on demand if we wanted to do 
>> that,
>>  >> >> once my vvar .fault patches go in (assuming they do -- I need 
>> to ping
>>  >> >> the linux-mm people).
>>  >> >
>>  >> > those info leak really doesn't matter.
>>  >>
>>  >> Why not?
>>  >
>>  > Ofcourse I can't make sure completely, but how could this
>>  > info be used as attack?
>> 
>>  It may leak interesting timing info, even from cpus that are
>>  outside your affinity mask / cpuset.  I don't know how much
>>  anyone actually cares.
> 
> Finegraned timing information has been successfully used to
> recover secret keys (and sometimes even coarse timing
> information), so it can be a security issue in certain setups.

Trying to nail this down a little more clearly.  Are you worried about 
the context switch count being exported or the clock_gettime data?

-chris



