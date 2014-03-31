Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753044AbaCaO2w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 10:28:52 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:9955 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752381AbaCaO2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 10:28:50 -0400
Message-ID: <53397B18.1020004@fb.com>
Date: Mon, 31 Mar 2014 19:56:32 +0530
From: Arun Sharma <asharma@fb.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andi Kleen <andi@firstfloor.org>, Rodrigo Campos <rodrigo@sdfg.com.ar>
Subject: Re: [PATCHSET 00/21] perf tools: Add support to accumulate hist periods
 (v9)
References: <1395293806-25847-1-git-send-email-namhyung@kernel.org>
In-Reply-To: <1395293806-25847-1-git-send-email-namhyung@kernel.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.16.4]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2014-03-31_02:2014-03-31,2014-03-31,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 kscore.is_bulkscore=0
 kscore.compositescore=0 circleOfTrustscore=0
 compositescore=0.0366060980829986 urlsuspect_oldscore=0.366060980705612
 suspectscore=0 recipient_domain_to_sender_totalscore=133 phishscore=0
 bulkscore=0 kscore.is_spamscore=0 recipient_to_sender_totalscore=57
 recipient_domain_to_sender_domain_totalscore=2524143
 rbsscore=0.0366060980829986 spamscore=0
 recipient_to_sender_domain_totalscore=57 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1403310061
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/20/14, 11:06 AM, Namhyung Kim wrote:
> Hello,
>
> This is a new attempt to implement cumulative hist period report.
> This work begins from Arun's SORT_INCLUSIVE patch [1] but I completely
> rewrote it from scratch.

While testing this patch series, we found error messages which look like 
this:

Out of bounds address found:

Addr:   10370
DSO:    /usr/local/lib/libgcc_s.so.1 d
Map:    7f1b0c953000-7f1b0c968000
Symbol: 102d0-102e9 g _Unwind_DeleteException
Arch:   x86_64
Kernel: 3.10.23+
Tools:  3.13.rc1.g374a4d

Not all samples will be on the annotation output.

Please report to linux-kernel@vger.kernel.org

I first suspected it to be caused by this patch series, but I'm able to 
reproduce without these patches as of this commit:

a51e87c perf tools: Remove unused simple_strtoul() function

gdb attributes 0x10370 to a different/known symbol.

(gdb) x /i 0x10370
    0x10370 <get_cie_encoding+160>:      cmp    $0x4c,%dl

Is this known? Could this possibly be caused by stale histogram entries 
from unmapped/remapped shared libs?

  -Arun
