Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127Ab3J2EdZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 00:33:25 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:43603 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750971Ab3J2EdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 00:33:24 -0400
X-Greylist: delayed 1352 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 Oct 2013 00:33:23 EDT
Message-ID: <526F353E.8040607@fb.com>
Date: Mon, 28 Oct 2013 21:10:38 -0700
From: Arun Sharma <asharma@fb.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: Rodrigo Campos <rodrigo@sdfg.com.ar>, <namhyung.kim@lge.com>,
        <linux-kernel@vger.kernel.org>, <acme@ghostprotocols.net>,
        <fweisbec@gmail.com>, Stephane Eranian <eranian@google.com>
Subject: Re: State of "perf: Add a new sort order: SORT_INCLUSIVE"
References: <20131025150721.GA12534@sdfg.com.ar> <8761si9e1u.fsf@sejong.aot.lge.com> <20131028084244.GA7482@sdfg.com.ar> <877gcx92yd.fsf@sejong.aot.lge.com> <20131028092955.GB7482@sdfg.com.ar> <526E9429.20803@fb.com> <87mwls7ouf.fsf@sejong.aot.lge.com>
In-Reply-To: <87mwls7ouf.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.16.4]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8794,1.0.431,0.0.0000
 definitions=2013-10-29_02:2013-10-28,2013-10-29,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 kscore.is_bulkscore=0
 kscore.compositescore=0 circleOfTrustscore=0
 compositescore=0.0579074834569235 urlsuspect_oldscore=0.578432455720742
 suspectscore=0 recipient_domain_to_sender_totalscore=99 phishscore=0
 bulkscore=0 kscore.is_spamscore=0 recipient_to_sender_totalscore=41
 recipient_domain_to_sender_domain_totalscore=1996008
 rbsscore=0.0579074834569235 spamscore=0
 recipient_to_sender_domain_totalscore=40 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1305240000
 definitions=main-1310280274
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28/13 8:11 PM, Namhyung Kim wrote:

Hey Namhyung:

>>
>> Also, what's the reasoning for --cumulate not being an option under
>> perf record -g ..,<order>?
>
> Sorry, I cannot understand you.  The 'perf record' just saves sample
> data (and callchains) from the ring-buffer.  All the processing happens
> in 'perf report'.  I can't see what you expect from the 'perf record
> --cumulate'.  Am I missing something?

Yes - I meant to say perf report -g :)

 > -g [type,min[,limit],order]

Specifically, along with callee, caller, we could have a third option. 
Or we could have a new type (graph, fractal, cumulative).

>> Given that there are clear use cases in production involving complex
>> callgraphs, I'm for getting this support in first and then reconciling
>> the differences with perf record -b later.
>
> I think what Frederic said is that the code de-duplication of 'perf
> report' side.  The branch stack and --cumulate are different - branch
> stack concentrates on the branch itself but --cumulate uses callchains
> to find parents and give some credit to them as side information.

Me too. I brought it up with Stephane at some point in the last year or 
so and there wasn't an obvious way to de-duplicate because of these 
differences.

  -Arun
