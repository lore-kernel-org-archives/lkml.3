Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185Ab3EVRzl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 13:55:41 -0400
Received: from mail-db8lp0184.outbound.messaging.microsoft.com ([213.199.154.184]:38196
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751456Ab3EVRzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 13:55:39 -0400
X-Forefront-Antispam-Report: CIP:132.245.2.69;KIP:(null);UIP:(null);IPV:NLI;H:BN1PRD0712HT004.namprd07.prod.outlook.com;RD:none;EFVD:NLI
X-SpamScore: -1
X-BigFish: PS-1(z37d5kzbb2dI98dI9371I1432Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bhz2dh2a8h668h839h947hd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h190ch1946h19b4h19c3h19ceh1ad9h1b0ah1d0ch1d2eh1d3fh1155h)
Message-ID: <519D0688.40007@caviumnetworks.com>
Date: Wed, 22 May 2013 10:55:20 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Sanjay Lal <sanjayl@kymasys.com>
CC: David Daney <ddaney.cavm@gmail.com>, <linux-mips@linux-mips.org>,
        <ralf@linux-mips.org>, <kvm@vger.kernel.org>,
        Gleb Natapov <gleb@redhat.com>, <linux-kernel@vger.kernel.org>,
        David Daney <david.daney@cavium.com>
Subject: Re: [PATCH v4 5/6] mips/kvm: Fix ABI by moving manipulation of CP0
 registers to KVM_{G,S}ET_ONE_REG
References: <1369169695-10444-1-git-send-email-ddaney.cavm@gmail.com> <1369169695-10444-6-git-send-email-ddaney.cavm@gmail.com> <16CE6694-CEAE-48F1-9F8E-723A657CE470@kymasys.com>
In-Reply-To: <16CE6694-CEAE-48F1-9F8E-723A657CE470@kymasys.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [64.2.3.195]
X-OriginatorOrg: caviumnetworks.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2013 10:44 AM, Sanjay Lal wrote:
>
> On May 21, 2013, at 1:54 PM, David Daney wrote:
>
>> From: David Daney <david.daney@cavium.com>
>>
>> Because not all 256 CP0 registers are ever implemented, we need a
>> different method of manipulating them.  Use the
>> KVM_SET_ONE_REG/KVM_GET_ONE_REG mechanism.
>>
>> Code related to implementing KVM_SET_ONE_REG/KVM_GET_ONE_REG is
>> consolidated in to kvm_trap_emul.c, now unused code and definitions
>> are removed.
>>
>> Signed-off-by: David Daney <david.daney@cavium.com>
>> ---
>> arch/mips/include/asm/kvm.h      |  91 +++++++++--
>> arch/mips/include/asm/kvm_host.h |   4 -
>> arch/mips/kvm/kvm_mips.c         |  90 +----------
>> arch/mips/kvm/kvm_trap_emul.c    | 338 ++++++++++++++++++++++++++++++++++-----
>> 4 files changed, 383 insertions(+), 140 deletions(-)
[...]
>>
>
> Most of the functions that have been relocated to kvm_trap_emul.c should stay in kvm_mips.c. They are/will shared between the trap and emulate and VZ modes.  They include kvm_mips_reset_vcpu(), kvm_vcpu_ioctl_interrupt(), kvm_arch_vcpu_ioctl().
>
> kvm_mips_get_reg() and kvm_mips_set_reg() should be in kvm_mips.c as they will be shared by the trap and emulate and VZ code.
>

OK, I will revise the patch set to rearrange things in a manner that 
leaves these in kvm_mips.c.  However, this is of secondary importance to 
the question of the suitability of the ABI.


> If you plan on defining specific versions of these functions for Cavium's implementation of KVM, please make them callbacks.
>

There will soon be follow on patches that do exactly that.



