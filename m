Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751449AbaDAHgN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 03:36:13 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:11525 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751061AbaDAHgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 03:36:05 -0400
Message-ID: <533A6C2B.8070801@fb.com>
Date: Tue, 1 Apr 2014 13:05:07 +0530
From: Arun Sharma <asharma@fb.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andi Kleen <andi@firstfloor.org>, Rodrigo Campos <rodrigo@sdfg.com.ar>
Subject: Re: [PATCHSET 00/21] perf tools: Add support to accumulate hist periods
 (v9)
References: <1395293806-25847-1-git-send-email-namhyung@kernel.org> <53397B18.1020004@fb.com> <CAM9d7cjjaj-yeHMOb=8b=iMsBZuEgZhh6x-vTpFA67CQ1Xp=bA@mail.gmail.com>
In-Reply-To: <CAM9d7cjjaj-yeHMOb=8b=iMsBZuEgZhh6x-vTpFA67CQ1Xp=bA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.16.4]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2014-04-01_03:2014-03-31,2014-04-01,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 kscore.is_bulkscore=0
 kscore.compositescore=0 circleOfTrustscore=0
 compositescore=0.0366060980829986 urlsuspect_oldscore=0.366060980705612
 suspectscore=0 recipient_domain_to_sender_totalscore=133 phishscore=0
 bulkscore=0 kscore.is_spamscore=0 recipient_to_sender_totalscore=57
 recipient_domain_to_sender_domain_totalscore=2524143
 rbsscore=0.0366060980829986 spamscore=0
 recipient_to_sender_domain_totalscore=57 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1404010006
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/1/14, 12:58 PM, Namhyung Kim wrote:

>>
>> gdb attributes 0x10370 to a different/known symbol.
>>
>> (gdb) x /i 0x10370
>>     0x10370 <get_cie_encoding+160>:      cmp    $0x4c,%dl
>>
>> Is this known? Could this possibly be caused by stale histogram entries from
>> unmapped/remapped shared libs?
>
> Possibly.
>
> Anyway the addr which perf reported is a mapped address so that it's
> pointless to use the addr directly - it's 7f1b0c963370 in fact.
>

Right - that's the address I'd use if the process in question is still 
running. But gdb <dso name> followed by relative addresses could still 
tell us what the right symbol was?

> What was the exact command line though - did you use any filter
> (--comms, --dsos, --symbols) or event modifiers?  Those are another
> possible culprits since map searching code touched by recent changes.

There were no other filters. The command used was just "perf top".

>
> I'm not able to reproduce the problem on my machine.  It'd be great if
> you could bisect or let me know how to reproduce it easily.
>

I don't have a solid repro either. Involves building a binary, running 
"perf top" and waiting for a few mins until that warning popup appears.

Will try to git bisect and figure out potential culprits.

  -Arun
