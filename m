Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753687Ab3LFHY3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 02:24:29 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:37103 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752870Ab3LFHY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 02:24:28 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v2.0.1
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-3
Message-ID: <52A17B83.8060601@jp.fujitsu.com>
Date: Fri, 6 Dec 2013 16:23:47 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Toshi Kani <toshi.kani@hp.com>
CC: <akpm@linux-foundation.org>, <mingo@kernel.org>, <hpa@zytor.com>,
        <tglx@linutronix.de>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <x86@kernel.org>
Subject: Re: [PATCH] mm, x86: Skip NUMA_NO_NODE while parsing SLIT
References: <1386191348-4696-1-git-send-email-toshi.kani@hp.com>  <52A054A0.6060108@jp.fujitsu.com> <1386256309.1791.253.camel@misato.fc.hp.com>
In-Reply-To: <1386256309.1791.253.camel@misato.fc.hp.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/12/06 0:11), Toshi Kani wrote:
> On Thu, 2013-12-05 at 19:25 +0900, Yasuaki Ishimatsu wrote:
>> (2013/12/05 6:09), Toshi Kani wrote:
>>> When ACPI SLIT table has an I/O locality (i.e. a locality unique
>>> to an I/O device), numa_set_distance() emits the warning message
>>> below.
>>>
>>>    NUMA: Warning: node ids are out of bound, from=-1 to=-1 distance=10
>>>
>>> acpi_numa_slit_init() calls numa_set_distance() with pxm_to_node(),
>>> which assumes that all localities have been parsed with SRAT previously.
>>> SRAT does not list I/O localities, where as SLIT lists all localities
>>
>>> including I/Os.  Hence, pxm_to_node() returns NUMA_NO_NODE (-1) for
>>> an I/O locality.  I/O localities are not supported and are ignored
>>> today, but emitting such warning message leads unnecessary confusion.
>>
>> In this case, the warning message should not be shown. But if SLIT table
>> is really broken, the message should be shown. Your patch seems to not care
>> for second case.
>
> In the second case, I assume you are worrying about the case of SLIT
> table with bad locality numbers.  Since SLIT is a matrix of the number
> of localities, it is only possible by making the table bigger than
> necessary.  Such excessive localities are safe to ignore (as they are
> ignored today) and regular users have nothing to concern about them.
> The warning message in this case may be helpful for platform vendors to
> test their firmware, but they have plenty of other methods to verify
> their SLIT table.

I understood it. So,

Reviewed-by : Yasuaki Ishimatsu

Thanks,
Yasuaki Ishimatsu


> Thanks,
> -Toshi
>
>
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
>


