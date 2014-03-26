Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755655AbaCZTdX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 15:33:23 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:53120 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753126AbaCZTdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 15:33:22 -0400
Message-ID: <53332B6D.9090300@fb.com>
Date: Wed, 26 Mar 2014 15:33:01 -0400
From: Josef Bacik <jbacik@fb.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: David Ahern <dsahern@gmail.com>, <linux-kernel@vger.kernel.org>,
        <a.p.zijlstra@chello.nl>, <mingo@redhat.com>,
        <acme@ghostprotocols.net>
Subject: Re: [PATCH] perf: make perf script actually spit out backtraces for
 events
References: <1395860245-12418-1-git-send-email-jbacik@fb.com> <53332A28.70306@gmail.com>
In-Reply-To: <53332A28.70306@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2014-03-26_05:2014-03-26,2014-03-26,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=2.54241072639161e-14 kscore.compositescore=0
 circleOfTrustscore=0 compositescore=0.511309651175795
 urlsuspect_oldscore=0.511309651175795 suspectscore=0
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=1996008
 rbsscore=0.511309651175795 spamscore=0
 recipient_to_sender_domain_totalscore=7 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1403260106
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/26/2014 03:27 PM, David Ahern wrote:
> On 3/26/14, 12:57 PM, Josef Bacik wrote:
>> We are trying to debug a problem internally and noticed that if we use
>> perf
>> record -g -e <tracepoint> and then try to use perf script to get the
>> events and
>> their backtraces that we weren't getting the backtraces, even though
>> they were
>> collected and would show up with perf report.  For some reason the
>> tracepoint
>> print stuff didn't have the right things set in order to print out
>> backtraces.
>> I have no idea why this is as adding them in there makes the
>> backtraces come out
>> properly, and if we don't use the -g option perf script still acts
>> properly with
>> those options set.  Hopefully this is the correct fix, it has fixed
>> the problem
>> for us.  Thanks,
>
> You can manually request fields using the -f option.
>
> That said ...
>
>>
>> Signed-off-by: Josef Bacik <jbacik@fb.com>
>> ---
>> NOTE: I looked at MAINTAINERS to see if there was a perf list and it
>> didn't look
>> like there was one, sorry if this is the wrong place to send patches to.
>>
>>   tools/perf/builtin-script.c | 4 +++-
>>   1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
>> index baf1798..6d14c06 100644
>> --- a/tools/perf/builtin-script.c
>> +++ b/tools/perf/builtin-script.c
>> @@ -99,7 +99,9 @@ static struct {
>>
>>           .fields = PERF_OUTPUT_COMM | PERF_OUTPUT_TID |
>>                     PERF_OUTPUT_CPU | PERF_OUTPUT_TIME |
>> -                  PERF_OUTPUT_EVNAME | PERF_OUTPUT_TRACE,
>> +                  PERF_OUTPUT_EVNAME | PERF_OUTPUT_TRACE |
>> +                  PERF_OUTPUT_IP | PERF_OUTPUT_SYM |
>> +                  PERF_OUTPUT_DSO,
>
> A change has been applied to upstream:
> https://urldefense.proofpoint.com/v1/url?u=https://lkml.org/lkml/2013/11/30/63&k=ZVNjlDMF0FElm4dQtryO4A%3D%3D%0A&r=cKCbChRKsMpTX8ybrSkonQ%3D%3D%0A&m=kB8XhiqkBzGE%2BTCnMhkJQP%2BjerKZ5bWPi%2BqGVVwGKPg%3D%0A&s=c232c9e9ea4eb35f56ba43dd8e7e70589e016430a7b4a5a89f7c938d05bd7b7a
>

Argh sorry I was testing on my tree but I'm still 3.13 based.  Thanks,

Josef

