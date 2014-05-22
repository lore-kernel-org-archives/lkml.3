Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751691AbaEVWn4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 18:43:56 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:60371 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923AbaEVWnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 18:43:55 -0400
Message-ID: <537E7DA3.6030705@linux.vnet.ibm.com>
Date: Thu, 22 May 2014 15:43:47 -0700
From: Cody P Schafer <cody@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Ellerman <mpe@ellerman.id.au>, peterz@infradead.org,
        linux-kernel@vger.kernel.org, michael@ellerman.id.au, mingo@redhat.com,
        paulus@samba.org, imunsie@au1.ibm.com, acme@ghostprotocols.net,
        scottwood@freescale.com, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH] powerpc/perf/hv-24x7: use kmem_cache instead of aligned
 stack allocations
References: <537E78AD.1040409@linux.vnet.ibm.com> <1400797756-6057-1-git-send-email-cody@linux.vnet.ibm.com> <20140523083847.4e039ddb@canb.auug.org.au>
In-Reply-To: <20140523083847.4e039ddb@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14052222-9332-0000-0000-000000E0AFA5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2014 03:38 PM, Stephen Rothwell wrote:
> Hi Cody,
>
> On Thu, 22 May 2014 15:29:08 -0700 Cody P Schafer <cody@linux.vnet.ibm.com> wrote:
>>
>> -	*res = be64_to_cpu(result_buffer.result);
>> +	*res = be64_to_cpu(result_buffer->result);
>> +	kfree(result_buffer);
>> +	kfree(request_buffer);
>> +	return ret;
>
> Why not just fall through here by removing the above 3 lines?

No reason except me not noticing it.

>> +
>> +out_hcall:
>> +	kfree(result_buffer);
>> +out_resb:
>> +	kfree(request_buffer);
>> +out_reqb:
>>   	return ret;
>>   }
>

