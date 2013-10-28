Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757127Ab3J1R4R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 13:56:17 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:9972 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756796Ab3J1R4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 13:56:15 -0400
X-Greylist: delayed 4225 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Oct 2013 13:56:15 EDT
Message-ID: <526E9429.20803@fb.com>
Date: Mon, 28 Oct 2013 09:43:21 -0700
From: Arun Sharma <asharma@fb.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Rodrigo Campos <rodrigo@sdfg.com.ar>
CC: Namhyung Kim <namhyung@kernel.org>, <namhyung.kim@lge.com>,
        <linux-kernel@vger.kernel.org>, <acme@ghostprotocols.net>,
        <fweisbec@gmail.com>, Stephane Eranian <eranian@google.com>
Subject: Re: State of "perf: Add a new sort order: SORT_INCLUSIVE"
References: <20131025150721.GA12534@sdfg.com.ar> <8761si9e1u.fsf@sejong.aot.lge.com> <20131028084244.GA7482@sdfg.com.ar> <877gcx92yd.fsf@sejong.aot.lge.com> <20131028092955.GB7482@sdfg.com.ar>
In-Reply-To: <20131028092955.GB7482@sdfg.com.ar>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.16.4]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8794,1.0.431,0.0.0000
 definitions=2013-10-28_01:2013-10-28,2013-10-28,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 kscore.is_bulkscore=0
 kscore.compositescore=0 circleOfTrustscore=0
 compositescore=0.0579074834569235 urlsuspect_oldscore=0.578432455720742
 suspectscore=0 recipient_domain_to_sender_totalscore=99 phishscore=0
 bulkscore=0 kscore.is_spamscore=0 recipient_to_sender_totalscore=41
 recipient_domain_to_sender_domain_totalscore=1996008
 rbsscore=0.0579074834569235 spamscore=0
 recipient_to_sender_domain_totalscore=40 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1305240000
 definitions=main-1310280120
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28/13 2:29 AM, Rodrigo Campos wrote:
> On Mon, Oct 28, 2013 at 06:09:30PM +0900, Namhyung Kim wrote:
>> On Mon, 28 Oct 2013 08:42:44 +0000, Rodrigo Campos wrote:
>>> On Mon, Oct 28, 2013 at 02:09:49PM +0900, Namhyung Kim wrote:
>>>> Anyway, You can find the series and discussion on the link below:
>>>>
>>>>    https://lkml.org/lkml/2012/9/13/81
>>>
>>> I've read the cover letter for that series and probably because I don't know
>>> about perf internals I have a question: How will "--culumate" interact with
>>> "--sort=dso" for example ?
>>>
>>> I mean, is it possible for that to show more than 100% ? (if you add all the
>>> 93.35% in your example in the cover letter, or something similar). Or
>>> "--culumate --sort=dso" will just group together all entries that have a dso in
>>> the call chain ?
>>
>> Hmm.. I think --cumulate option is only meaningful when sort order
>> includes symbol.  Maybe I can add support for --sort=dso case as well
>> but not sure it's worth.  Do you think it's really needed?
>
> I don't know if it is *needed*, but that was what I need :)

I suspect that users will find creative ways of using these options to 
solve real world problems and we shouldn't restrict usage any more than 
we need to to protect against obvious bugs/crashes.

Also, what's the reasoning for --cumulate not being an option under perf 
record -g ..,<order>?

In order to integrate perf record -b and --cumulate, we'll have to sort 
out the underlying infrastructure for processing callgraphs and branch 
stacks. I think the main roadblock here is that one is statistical and 
on many CPUs incomplete (only top N branches are reported).

Given that there are clear use cases in production involving complex 
callgraphs, I'm for getting this support in first and then reconciling 
the differences with perf record -b later.

  -Arun
