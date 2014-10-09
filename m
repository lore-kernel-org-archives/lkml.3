Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751008AbaJIFUE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 01:20:04 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:35515 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751AbaJIFT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 01:19:59 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v2.0.1
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-3
Message-ID: <54361AD2.1040307@jp.fujitsu.com>
Date: Thu, 9 Oct 2014 14:19:14 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: Peter Zijlstra <peterz@infradead.org>, <mingo@redhat.com>,
        <linux-kernel@vger.kernel.org>, <tkhai@yandex.ru>
Subject: Re: [PATCH] sched/fair: Care divide error in update_task_scan_period()
References: <5434DCFF.1040208@jp.fujitsu.com> <54356970.7050805@redhat.com> <20141008165402.GO10832@worktop.programming.kicks-ass.net>
In-Reply-To: <20141008165402.GO10832@worktop.programming.kicks-ass.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/10/09 1:54), Peter Zijlstra wrote:
> On Wed, Oct 08, 2014 at 12:42:24PM -0400, Rik van Riel wrote:
>> On 10/08/2014 02:43 AM, Yasuaki Ishimatsu wrote:
>>
>>>    The divide error is rare case because the trigger is node offline.
>>>    By this patch, when both of private and shared are set to 0, diff
>>>    is just set to 0, not calculating the division.
>>
>> How about a simple
>>
>>      if (private + shared) == 0)
>>            return;
>>
>> higher up in the function, to avoid adding an extra
>> layer of indentation and confusion to the main part
>> of the function?
>
> At which point we'll have 3 different return semantics. Should we not
> clear numa_faults_localityp[], even in this case?
>

I'm not familiar with Numa balancing feature. So I want to know it too.
If it's not necessary to clear numa_faults_locality[], I'll apply the idea.

Thanks,
Yasuaki Ishimatsu

