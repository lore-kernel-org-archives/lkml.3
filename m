Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932798AbaLAWMx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 17:12:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58772 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932160AbaLAWMv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 17:12:51 -0500
Message-ID: <547CE7D6.4030601@redhat.com>
Date: Mon, 01 Dec 2014 23:12:38 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>, gleb@kernel.org,
        kvm@vger.kernel.org
CC: bp@suse.de, x86@kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, david.vrabel@citrix.com
Subject: Re: [PATCH] x86, microcode: Don't initialize microcode code on paravirt
References: <1417469264-31470-1-git-send-email-boris.ostrovsky@oracle.com> <20141201215725.GG24289@laptop.dumpdata.com>
In-Reply-To: <20141201215725.GG24289@laptop.dumpdata.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 01/12/2014 22:57, Konrad Rzeszutek Wilk wrote:
> On Mon, Dec 01, 2014 at 04:27:44PM -0500, Boris Ostrovsky wrote:
>> Paravirtual guests are not expected to load microcode into processors
>> and therefore it is not necessary to initialize microcode loading
>> logic.
> 
> CC-ing the KVM folks since they use the paravirt interface too.

We also do not want to load microcode. :)  Thanks for the heads-up.

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

Paolo

>> In fact, under certain circumstances initializing this logic may cause
>> the guest to crash. Specifically, 32-bit kernels use __pa_nodebug()
>> macro which does not work in Xen (the code path that leads to this macro
>> happens during resume when we call mc_bp_resume()->load_ucode_ap()
>> ->check_loader_disabled_ap())
>>
>> Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
>> ---
>>  arch/x86/kernel/cpu/microcode/core.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/arch/x86/kernel/cpu/microcode/core.c b/arch/x86/kernel/cpu/microcode/core.c
>> index 2ce9051..ebd232d 100644
>> --- a/arch/x86/kernel/cpu/microcode/core.c
>> +++ b/arch/x86/kernel/cpu/microcode/core.c
>> @@ -557,7 +557,7 @@ static int __init microcode_init(void)
>>  	struct cpuinfo_x86 *c = &cpu_data(0);
>>  	int error;
>>  
>> -	if (dis_ucode_ldr)
>> +	if (paravirt_enabled() || dis_ucode_ldr)
>>  		return 0;
>>  
>>  	if (c->x86_vendor == X86_VENDOR_INTEL)
>> -- 
>> 1.7.1
>>
