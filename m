Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756237AbaCDHBn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 02:01:43 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:59675 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751870AbaCDHBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 02:01:42 -0500
Message-ID: <53157A45.4080600@linux.vnet.ibm.com>
Date: Mon, 03 Mar 2014 23:01:25 -0800
From: Cody P Schafer <cody@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Michael Ellerman <mpe@ellerman.id.au>,
        Linux PPC <linuxppc-dev@lists.ozlabs.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        scottwood@freescale.com
Subject: Re: [PATCH v3 03/11] perf: provide a common perf_event_nop_0() for
 use with .event_idx
References: <20140304051936.97CBF2C020A@ozlabs.org>
In-Reply-To: <20140304051936.97CBF2C020A@ozlabs.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14030407-0928-0000-0000-0000001D7B61
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/03/2014 09:19 PM, Michael Ellerman wrote:
> On Thu, 2014-27-02 at 21:04:56 UTC, Cody P Schafer wrote:
>> Rather an having every pmu that needs a function that just returns 0 for
>> .event_idx define their own copy, reuse the one in kernel/events/core.c.
>>
>> Rename from perf_swevent_event_idx() because we're no longer using it
>> for just software events. Naming is based on the perf_pmu_nop_*()
>> functions.
>
> You could just use perf_pmu_nop_int() directly.

No, .event_idx needs something that takes a (struct perf_event *), 
perf_pmu_nop_int() takes a (struct pmu *).

