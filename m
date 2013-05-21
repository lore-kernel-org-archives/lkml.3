Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754897Ab3EUQec (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 12:34:32 -0400
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:59279
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754787Ab3EUQe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 12:34:29 -0400
X-Forefront-Antispam-Report: CIP:132.245.1.197;KIP:(null);UIP:(null);IPV:NLI;H:BLUPRD0712HT003.namprd07.prod.outlook.com;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: PS-3(z37d5kzbb2dI98dI9371I1432I168aJzz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bhz2dh2a8h668h839h947hd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h19ceh1ad9h1b0ah1d0ch1d2eh1d3fh1155h)
Message-ID: <519BA20E.6080101@caviumnetworks.com>
Date: Tue, 21 May 2013 09:34:22 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: David Daney <ddaney.cavm@gmail.com>, <linux-mips@linux-mips.org>,
        <ralf@linux-mips.org>, <kvm@vger.kernel.org>,
        Sanjay Lal <sanjayl@kymasys.com>, <linux-kernel@vger.kernel.org>,
        David Daney <david.daney@cavium.com>
Subject: Re: [PATCH v3 5/5] mips/kvm: Fix ABI by moving manipulation of CP0
 registers to KVM_{G,S}ET_MSRS
References: <1369083686-27524-1-git-send-email-ddaney.cavm@gmail.com> <1369083686-27524-6-git-send-email-ddaney.cavm@gmail.com> <20130521153752.GD14287@redhat.com> <519B9EF2.8020107@caviumnetworks.com> <20130521162811.GE14287@redhat.com>
In-Reply-To: <20130521162811.GE14287@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [64.2.3.195]
X-OriginatorOrg: caviumnetworks.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/21/2013 09:28 AM, Gleb Natapov wrote:
> On Tue, May 21, 2013 at 09:21:06AM -0700, David Daney wrote:
>> On 05/21/2013 08:37 AM, Gleb Natapov wrote:
>>> On Mon, May 20, 2013 at 02:01:26PM -0700, David Daney wrote:
>>>> From: David Daney <david.daney@cavium.com>
>>>>
>>>> Because not all 256 CP0 registers are ever implemented, we need a
>>>> different method of manipulating them.  Use the
>>>> KVM_GET_MSRS/KVM_SET_MSRS mechanism as x86 does for its MSRs.
>>>>
>>> Have you looked at KVM_(GET|SET)_ONE_REG interface (not used by x86, but is
>>> used bu arm/ppc/s390). It looks like it is more suitable for your case.
>>> Actually you can use it instead of KVM_(GET|SET)_REGS for all registers.
>>
>> Yes, I suppose it could be used.  One problem it has is that there
>> is no way to query the set of supported registers.
> KVM_GET_REG_LIST

OK, I guess we can switch to KVM_GET_REG_LIST/KVM_(GET|SET)_ONE_REG.

I will revise this patch.

Thanks.

>
>>                                                      Also you have to
>> make multiple calls to set multiple registers, which involves
>> vcpu_{load,put} for each register.
>>
> How often this happens on the fast path on mips?

Rarely, if ever once, the VCPU is running.

Only when initializing the VCPU do we need to set a bunch of registers.


> On x86 this never
> happens on the fast path so it uses KVM_(GET|SET)_REGS mostly for
> historical reasons.
>
>> We will definitely implement it for all the FP and General Purpose
>> registers.
>>
>>>
>>>> Code related to implementing KVM_GET_MSRS/KVM_SET_MSRS is consolidated
>>
>
> --
> 			Gleb.
>


