Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752640AbaAPClD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 21:41:03 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:6014 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752435AbaAPClB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 21:41:01 -0500
From: Gaurav Jain <gjain@fb.com>
To: Namhyung Kim <namhyung@kernel.org>
CC: Don Zickus <dzickus@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Arun Sharma <asharma@fb.com>
Subject: Re: [PATCH] perf tools: Synthesize anon MMAP records on the heap
Thread-Topic: [PATCH] perf tools: Synthesize anon MMAP records on the heap
Thread-Index: AQHPD09bvhY6ouXu+ki8ciwGSba3HpqDZ8uAgAF/04CAAGQLRIAAQoUAgAEAKdaAABvGqw==
Date: Thu, 16 Jan 2014 02:40:49 +0000
Message-ID: <5EB282DB-CB9D-498B-B36F-4899D954630F@fb.com>
References: <87a9exajbg.fsf@sejong.aot.lge.com>
 <CEFB97C1.2CC71%gjain@fb.com>,<87lhyg91um.fsf@sejong.aot.lge.com>
In-Reply-To: <87lhyg91um.fsf@sejong.aot.lge.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Spam-Reason: safe
X-FB-Internal: Safe
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2014-01-16_01:2014-01-15,2014-01-16,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Namhyung,

> On Jan 15, 2014, at 8:01 PM, "Namhyung Kim" <namhyung@kernel.org> wrote:
> 
> Hi Gaurav,
> 
>> On Wed, 15 Jan 2014 06:44:39 +0000, Gaurav Jain wrote:
>> Hi Namhyung,
>> 
>> 
>>> On 1/15/14, 12:46 AM, "Namhyung Kim" <namhyung@kernel.org> wrote:
>>> diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
>>> index 9b9bd719aa19..d52387fe83f1 100644
>>> --- a/tools/perf/util/map.c
>>> +++ b/tools/perf/util/map.c
>>> @@ -69,7 +69,7 @@ struct map *map__new(struct list_head *dsos__list, u64
>>> start, u64 len,
>>>        map->ino = ino;
>>>        map->ino_generation = ino_gen;
>>> 
>>> -        if (anon) {
>>> +        if (anon || (no_dso && type == MAP__FUNCTION)) {
> 
> Hmm.. I think it should check type of anon mapping too (assuming JIT
> interface only provides function symbols, no?):
> 
>        if ((anon || no_dso) && type == MAP__FUNCTION)) {

In that case, shouldn't we filter out all mappings that are not executable as I had intended to do in my original patch?

>>>            snprintf(newfilename, sizeof(newfilename), "/tmp/perf-%d.map", pid);
>>>            filename = newfilename;
>>>        }
>>> @@ -93,7 +93,7 @@ struct map *map__new(struct list_head *dsos__list, u64
>>> start, u64 len,
>>>             * functions still return NULL, and we avoid the
>>>             * unnecessary map__load warning.
>>>             */
>>> -            if (no_dso)
>>> +            if (no_dso && type != MAP__FUNCTION)
> 
> And it should be simply:
> 
>            if (type != MAP__FUNCTION)
> 
> 
>>>                dso__set_loaded(dso, map->type);
>>>        }
>>>    }
> 
> I'll update this and send a formal patch soon.  Could you please test it with
> the new patch then?

Sure I'll test the new patch, though please note my previous suggestion.

Gaurav