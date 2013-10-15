Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759571Ab3JORbO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 13:31:14 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:56780 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758955Ab3JORbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 13:31:12 -0400
Message-ID: <525D7BCD.7080303@linux.vnet.ibm.com>
Date: Tue, 15 Oct 2013 23:00:53 +0530
From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: "Chen, Gong" <gong.chen@linux.intel.com>, tony.luck@intel.com,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        m.chehab@samsung.com
Subject: Re: [PATCH 8/8] ACPI / trace: Add trace interface for eMCA driver
References: <1381473166-29303-1-git-send-email-gong.chen@linux.intel.com> <1381473166-29303-9-git-send-email-gong.chen@linux.intel.com> <20131015165435.GA2777@naverao1-tp.ibm.com> <20131015170039.GF7908@pd.tnic>
In-Reply-To: <20131015170039.GF7908@pd.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13101517-4790-0000-0000-00000AD0C1F5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15/2013 10:30 PM, Borislav Petkov wrote:
> On Tue, Oct 15, 2013 at 10:24:35PM +0530, Naveen N. Rao wrote:
>> On 2013/10/11 02:32AM, Chen Gong wrote:
>>> Use trace interface to elaborate all H/W error related
>>> information.
>>>
>>> Signed-off-by: Chen, Gong <gong.chen@linux.intel.com>
>>> ---
>> <snip>
>>> +TRACE_EVENT(extlog_mem_event,
>>> +	TP_PROTO(u32 etype,
>>> +		char *dimm_loc,
>>> +		const uuid_le *fru_id,
>>> +		char *fru_text,
>>> +		u64 error_count,
>>> +		u32 severity,
>>> +		u64 phy_addr,
>>> +		char *mem_loc),
>>
>> [Adding Mauro...]
>>
>> This looks very similar to the trace event I wrote a while back,
>> which was similar to the one provided by ghes_edac:
>> http://thread.gmane.org/gmane.linux.kernel.pci/24616
>>
>> Seems to me this has the same issues we previously discussed w.r.t
>> EDAC conflicts...
>
> Right, I'm inclined to leave this trace_mc_event in ras_event.h to edac
> use alone because of all those layers which don't mean whit for GHES and
> eMCA error sources.
>
> And maybe define a trace_mem_event which is shared by GHES and eMCA and
> not use the edac tracepoint there not load ghes_edac on such systems
> which have sufficient decoding capability in firmware.
>
> Thoughts?

I thought the primary problem was the conflict with edac core itself. 
So, if I'm not mistaken, we would have to prevent all edac drivers from 
loading.

Thanks,
Naveen

