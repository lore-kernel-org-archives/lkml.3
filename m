Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753330AbaAVXoR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 18:44:17 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:36123 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752338AbaAVXoQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 18:44:16 -0500
From: Gaurav Jain <gjain@fb.com>
To: Namhyung Kim <namhyung@kernel.org>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] perf tools: Fix JIT profiling on heap
Thread-Topic: [PATCH] perf tools: Fix JIT profiling on heap
Thread-Index: AQHPE1fkV6lP9aISxEm2DlWsTOWtmpqRcOSE
Date: Wed, 22 Jan 2014 23:43:45 +0000
Message-ID: <20B8A056-FE5B-4062-A043-6E34C45B34B8@fb.com>
References: <20140116143749.GA21526@ghostprotocols.net>
	<CEFDA8E4.2D359%gjain@fb.com>,<87sisn6ojf.fsf@sejong.aot.lge.com>
In-Reply-To: <87sisn6ojf.fsf@sejong.aot.lge.com>
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
 definitions=2014-01-22_07:2014-01-22,2014-01-22,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Jan 17, 2014, at 2:44 AM, "Namhyung Kim" <namhyung@kernel.org> wrote:
> 
> Hi Gaurav,
> 
>> On Thu, 16 Jan 2014 20:23:27 +0000, Gaurav Jain wrote:
>> On 1/16/14, 9:37 AM, "Arnaldo Carvalho de Melo" <acme@ghostprotocols.net>
>> wrote:
>> Does perf support data mappings from perf map files? Could you please
>> share an example of how I may be able to use this.
> 
> IIUC there's no difference between function and data mapping.  So you
> can use same perf map file for both - in fact there's no way to use
> different map file in a single task.  I guess perf will use it to find
> only function symbols in function mappings and variables in data
> mapping based on the address it accesses.
> 
> What I wasn't sure is whether JIT program also produces some dynamic data.
> And I think only perf mem command cares about data mappings, no?

I don't think we generate symbols for dynamic data at the moment. There may be uses in the future. I don't know about other JIT programs.

If we can include this behaviour it would be great, but I don't have a way to test it. I'd guess if somebody had a valid use case, they would report the issue. Otherwise, the patch as you've written it works great for me.

Gaurav