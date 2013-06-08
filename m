Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757357Ab3FHAPp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 20:15:45 -0400
Received: from co9ehsobe002.messaging.microsoft.com ([207.46.163.25]:44064
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757096Ab3FHAPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 20:15:44 -0400
X-Forefront-Antispam-Report: CIP:157.56.242.245;KIP:(null);UIP:(null);IPV:NLI;H:BL2PRD0712HT004.namprd07.prod.outlook.com;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: PS-4(zzbb2dI98dI9371I1432Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bhz2dh2a8h668h839h947hd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h19ceh1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1155h)
Message-ID: <51B2779F.3030903@caviumnetworks.com>
Date: Fri, 7 Jun 2013 17:15:27 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
CC: David Daney <ddaney.cavm@gmail.com>, <linux-mips@linux-mips.org>,
        <ralf@linux-mips.org>, <kvm@vger.kernel.org>,
        Sanjay Lal <sanjayl@kymasys.com>, <linux-kernel@vger.kernel.org>,
        David Daney <david.daney@cavium.com>
Subject: Re: [PATCH 20/31] mips/kvm: Hook into TLB fault handlers.
References: <1370646215-6543-1-git-send-email-ddaney.cavm@gmail.com> <1370646215-6543-21-git-send-email-ddaney.cavm@gmail.com> <51B26E02.8070802@cogentembedded.com>
In-Reply-To: <51B26E02.8070802@cogentembedded.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [64.2.3.195]
X-OriginatorOrg: caviumnetworks.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07/2013 04:34 PM, Sergei Shtylyov wrote:
> Hello.
>
> On 06/08/2013 03:03 AM, David Daney wrote:
>
>> From: David Daney <david.daney@cavium.com>
>>
>> If the CPU is operating in guest mode when a TLB related excpetion
>> occurs, give KVM a chance to do emulation.
>>
>> Signed-off-by: David Daney <david.daney@cavium.com>
>> ---
>>   arch/mips/mm/fault.c       | 8 ++++++++
>>   arch/mips/mm/tlbex-fault.S | 6 ++++++
>>   2 files changed, 14 insertions(+)
>>
>> diff --git a/arch/mips/mm/fault.c b/arch/mips/mm/fault.c
>> index 0fead53..9391da49 100644
>> --- a/arch/mips/mm/fault.c
>> +++ b/arch/mips/mm/fault.c
> [...]
>> @@ -50,6 +51,13 @@ asmlinkage void __kprobes do_page_fault(struct
>> pt_regs *regs, unsigned long writ
>>              field, regs->cp0_epc);
>>   #endif
>> +#ifdef CONFIG_KVM_MIPSVZ
>> +    if (test_tsk_thread_flag(current, TIF_GUESTMODE)) {
>> +        if (mipsvz_page_fault(regs, write, address))
>
>     Any reason not to collapse these into single *if*?
>

It makes the conditional call to mipsvz_page_fault() less obvious.

Certainly the same semantics can be achieved several different ways.

David Daney


>> +            return;
>> +    }
>> +#endif
>> +
>>
>
>


