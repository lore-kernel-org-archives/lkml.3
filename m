Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752563AbaBYVZy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 16:25:54 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:37920 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849AbaBYVZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 16:25:53 -0500
Message-ID: <530D0A4E.8030706@linux.vnet.ibm.com>
Date: Tue, 25 Feb 2014 13:25:34 -0800
From: Cody P Schafer <cody@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Michael Ellerman <mpe@ellerman.id.au>,
        Linux PPC <linuxppc-dev@lists.ozlabs.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH v2 08/11] powerpc/perf: add support for the hv gpci (get
 performance counter info) interface
References: <20140225033329.400E22C0331@ozlabs.org>
In-Reply-To: <20140225033329.400E22C0331@ozlabs.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14022521-0928-0000-0000-000006D0190F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/24/2014 07:33 PM, Michael Ellerman wrote:
> On Fri, 2014-14-02 at 22:02:12 UTC, Cody P Schafer wrote:
>> This provides a basic link between perf and hv_gpci. Notably, it does
>> not yet support transactions and does not list any events (they can
>> still be manually composed).
>
> Can you explain how the HV_CAPS stuff ends up looking.
>
> I'm not against adding it, but I'd like to understand how we expect it to be
> used a bit better.

It's just a quick mechanism for me to expose some relevant information 
to userspace via sysfs using the hv_perf_caps_get() function's returned 
data. Documentation for this sysfs interface (and the rest) is in a 
later patch.
I don't expect any more uses to show up unless the firmware decides to 
add another capability bit (in which case I'll want to expose it as well).

>> diff --git a/arch/powerpc/perf/hv-gpci.c b/arch/powerpc/perf/hv-gpci.c
>> new file mode 100644
>> index 0000000..1f5d96d
>> --- /dev/null
>> +++ b/arch/powerpc/perf/hv-gpci.c
>> +
>> +static struct pmu h_gpci_pmu = {
>> +	.task_ctx_nr = perf_invalid_context,
>> +
>> +	.name = "hv_gpci",
>> +	.attr_groups = attr_groups,
>> +	.event_init  = h_gpci_event_init,
>> +	.add         = h_gpci_event_add,
>> +	.del         = h_gpci_event_del,
> 		     = h_gpci_event_stop,
>
>> +	.start       = h_gpci_event_start,
>> +	.stop        = h_gpci_event_stop,
>> +	.read        = h_gpci_event_read,
> 		     = h_gpci_event_update
>
>> +	.event_idx = perf_swevent_event_idx,
>> +};

whoops, thought I had fixed those 2 already.

