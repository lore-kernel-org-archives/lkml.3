Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751873AbaAPUYH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 15:24:07 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:12343 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750750AbaAPUYE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 15:24:04 -0500
From: Gaurav Jain <gjain@fb.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Namhyung Kim <namhyung@kernel.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] perf tools: Fix JIT profiling on heap
Thread-Topic: [PATCH] perf tools: Fix JIT profiling on heap
Thread-Index: AQHPEl02V6lP9aISxEm2DlWsTOWtmpqH8nCAgAAMvwA=
Date: Thu, 16 Jan 2014 20:23:27 +0000
Message-ID: <CEFDA8E4.2D359%gjain@fb.com>
In-Reply-To: <20140116143749.GA21526@ghostprotocols.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.168.16.4]
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <FD37586F183A824B942FDC360AFF2E4B@fb.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2014-01-16_07:2014-01-16,2014-01-16,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 kscore.is_bulkscore=0
 kscore.compositescore=0 circleOfTrustscore=0
 compositescore=0.502552658695225 urlsuspect_oldscore=0.502552658695225
 suspectscore=0 recipient_domain_to_sender_totalscore=0 phishscore=0
 bulkscore=0 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=1996008
 rbsscore=0.502552658695225 spamscore=0
 recipient_to_sender_domain_totalscore=53 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1305240000
 definitions=main-1401160130
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/16/14, 9:37 AM, "Arnaldo Carvalho de Melo" <acme@ghostprotocols.net>
wrote:

>Em Thu, Jan 16, 2014 at 10:49:31AM +0900, Namhyung Kim escreveu:
>> Gaurav reported that perf cannot profile JIT program if it executes
>> the code on heap.  This was because current map__new() only handle JIT
>> on anon mappings - extends it to handle no_dso (heap, stack) case too.
>> 
>> This patch assumes JIT profiling only provides dynamic function
>> symbols so check the mapping type to distinguish the case.  It'd
>> provide no symbols for data mapping - if we need to support symbols on
>> data mappings later it should be changed.
>
>But we do support symbols in data mappings, that is why we have
>MAP__VARIABLE, etc, can you elaborate?

Does perf support data mappings from perf map files? Could you please
share an example of how I may be able to use this.

>Gaurav, do this fixes the problem you reported? Can I have your
>Tested-by: tag?

Yep, I¹ve tested this version of the patch and it works great for me.

Thanks,

Gaurav

