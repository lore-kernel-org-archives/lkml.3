Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752500AbaETIEQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 04:04:16 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:50229 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158AbaETIEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 04:04:08 -0400
Message-ID: <537B0C6E.4030501@linux.vnet.ibm.com>
Date: Tue, 20 May 2014 13:33:58 +0530
From: Madhavan Srinivasan <maddy@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-mm@kvack.org, linux-arch@vger.kernel.org, x86@kernel.org,
        benh@kernel.crashing.org, paulus@samba.org,
        kirill.shutemov@linux.intel.com, rusty@rustcorp.com.au,
        riel@redhat.com, mgorman@suse.de, ak@linux.intel.com,
        peterz@infradead.org, mingo@kernel.org, dave.hansen@intel.com
Subject: Re: [PATCH V4 2/2] powerpc/pseries: init fault_around_order for pseries
References: <1399541296-18810-1-git-send-email-maddy@linux.vnet.ibm.com> <1399541296-18810-3-git-send-email-maddy@linux.vnet.ibm.com> <20140520002834.aefb5a90.akpm@linux-foundation.org>
In-Reply-To: <20140520002834.aefb5a90.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14052008-8256-0000-0000-00000D368101
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 May 2014 12:58 PM, Andrew Morton wrote:
> On Thu,  8 May 2014 14:58:16 +0530 Madhavan Srinivasan <maddy@linux.vnet.ibm.com> wrote:
> 
>> --- a/arch/powerpc/platforms/pseries/pseries.h
>> +++ b/arch/powerpc/platforms/pseries/pseries.h
>> @@ -17,6 +17,8 @@ struct device_node;
>>  extern void request_event_sources_irqs(struct device_node *np,
>>  				       irq_handler_t handler, const char *name);
>>  
>> +extern unsigned int fault_around_order;
> 
> This isn't an appropriate header file for exporting something from core
> mm - what happens if arch/mn10300 wants it?.
>
> I guess include/linux/mm.h is the place.
> 

Rusty already suggested this. My bad.  Reason for adding it here was
that, I did the performance test for this platform. Will change and send
it out.

Thanks for review
Regards
Maddy

