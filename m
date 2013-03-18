Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751681Ab3CRHhF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 03:37:05 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:56156 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255Ab3CRHhC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 03:37:02 -0400
Message-ID: <5146C415.7010401@linux.vnet.ibm.com>
Date: Mon, 18 Mar 2013 15:36:53 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 1/5] Revert "KVM: x86: Optimize mmio spte zapping when,
 creating/moving memslot"
References: <51433D98.4050605@linux.vnet.ibm.com> <51433DC3.1070404@linux.vnet.ibm.com> <20130316110747.57fb20e01bcfd890125e2c81@gmail.com>
In-Reply-To: <20130316110747.57fb20e01bcfd890125e2c81@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13031807-3864-0000-0000-0000074FBEAB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/16/2013 10:07 AM, Takuya Yoshikawa wrote:
> On Fri, 15 Mar 2013 23:26:59 +0800
> Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com> wrote:
> 
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index d3c4787..61a5bb6 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -6991,7 +6991,7 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
>>  	 * mmio sptes.
>>  	 */
>>  	if ((change == KVM_MR_CREATE) || (change == KVM_MR_MOVE)) {
>> -		kvm_mmu_zap_mmio_sptes(kvm);
>>
> 
> ???
> + kvm_mmu_zap_all()

Ouch, this is a stupid copy-paste error. It looks like that i should
use git send-mail.

Thank you for pointing this out, Takuya!

