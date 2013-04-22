Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754191Ab3DVRdV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 13:33:21 -0400
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:32900
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753244Ab3DVRdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 13:33:19 -0400
X-Forefront-Antispam-Report: CIP:157.56.242.245;KIP:(null);UIP:(null);IPV:NLI;H:BL2PRD0712HT002.namprd07.prod.outlook.com;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: PS-4(zzbb2dI98dI9371I1432Izz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzz17326ah8275bh8275dhz2dh2a8h668h839h947hd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h19ceh1ad9h1b0ah1155h)
Message-ID: <5175744D.5020404@caviumnetworks.com>
Date: Mon, 22 Apr 2013 10:33:01 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Ralf Baechle <ralf@linux-mips.org>
CC: EUNBONG SONG <eunb.song@samsung.com>, <linux-mips@linux-mips.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mips: Fix invalid interrupt name in cavium-octeon
References: <2202498.1401366325451851.JavaMail.weblogic@epv6ml11> <20130422132203.GB31642@linux-mips.org>
In-Reply-To: <20130422132203.GB31642@linux-mips.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [64.2.3.195]
X-OriginatorOrg: caviumnetworks.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/22/2013 06:22 AM, Ralf Baechle wrote:
> On Thu, Apr 18, 2013 at 10:50:52PM +0000, EUNBONG SONG wrote:
>
>> Change interrupt name from "RML/RSL" to "RMLRSL".
>> This fixes following warning message.
>>
>> [   24.938793] WARNING: at fs/proc/generic.c:307 __xlate_proc_name+0x124/0x160()
>> [   24.945926] name 'RML/RSL'
>> [   24.948642] Modules linked in:
>> [   24.951707] Call Trace:
>> [   24.954157] [<ffffffff8069fe18>] dump_stack+0x8/0x34
>> [   24.959136] [<ffffffff80290d90>] warn_slowpath_common+0x78/0xa8
>> [   24.965056] [<ffffffff80290e60>] warn_slowpath_fmt+0x38/0x48
>> [   24.970723] [<ffffffff803cbc8c>] __xlate_proc_name+0x124/0x160
>> [   24.976556] [<ffffffff803cbe78>] __proc_create+0x78/0x128
>> [   24.981963] [<ffffffff803cd044>] proc_mkdir_mode+0x2c/0x70
>> [   24.987451] [<ffffffff80302418>] register_handler_proc+0x108/0x130
>> [   24.993642] [<ffffffff802fd078>] __setup_irq+0x210/0x540
>> [   24.998963] [<ffffffff802fd67c>] request_threaded_irq+0x114/0x1a0
>> [   25.005060] [<ffffffff80262e0c>] prom_free_prom_memory+0xd4/0x588
>> [   25.011164] [<ffffffff80691820>] free_initmem+0x10/0xc0
>> [   25.016390] [<ffffffff80691720>] kernel_init+0x20/0x100
>> [   25.021624] [<ffffffff8026c7e0>] ret_from_kernel_thread+0x10/0x18
>>
>> Signed-off-by: Eunbong Song <eunb.song@samsung.com>
>> ---
>>   arch/mips/cavium-octeon/setup.c |    2 +-
>>   1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/arch/mips/cavium-octeon/setup.c b/arch/mips/cavium-octeon/setup.c
>> index b0baa29..92c3150 100644
>> --- a/arch/mips/cavium-octeon/setup.c
>> +++ b/arch/mips/cavium-octeon/setup.c
>> @@ -1066,7 +1066,7 @@ void prom_free_prom_memory(void)
>>
>>   	/* Add an interrupt handler for general failures. */
>>   	if (request_irq(OCTEON_IRQ_RML, octeon_rlm_interrupt, IRQF_SHARED,
>> -			"RML/RSL", octeon_rlm_interrupt)) {
>> +			"RMLRSL", octeon_rlm_interrupt)) {
>>   		panic("Unable to request_irq(OCTEON_IRQ_RML)");
>>   	}
>>   #endif
>
> Interesting.  While your patch certainly is correct, you seem to have
> further modifications in your tree.
>
> David, Above code is wrapped by #ifdef CONFIG_CAVIUM_DECODE_RSL but doesn't
> seem to get defined anywhere.  What shall we do about this?

It seems to be a vestige of the out-of-tree version.  I was going to 
send a patch to remove it all, and perhaps another to replace it with 
something better.

David Daney


>
>    Ralf
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>


