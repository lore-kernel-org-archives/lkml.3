Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756242Ab3A2DCI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 22:02:08 -0500
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:55934 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386Ab3A2DCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 22:02:05 -0500
Message-ID: <51073BA3.2030901@linux.vnet.ibm.com>
Date: Tue, 29 Jan 2013 11:01:55 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Avi Kivity <avi.kivity@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 10/12] KVM: MMU: unify the code of walking pte list
References: <50FFB5A1.5090708@linux.vnet.ibm.com> <50FFB6DE.8060709@linux.vnet.ibm.com> <20130127132840.GB21650@redhat.com>
In-Reply-To: <20130127132840.GB21650@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012902-5490-0000-0000-000002E396FE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27/2013 09:28 PM, Gleb Natapov wrote:

>>
>> @@ -1256,19 +1243,18 @@ static int kvm_set_pte_rmapp(struct kvm *kvm, unsigned long *rmapp,
>>
>>  		if (pte_write(*ptep)) {
>>  			drop_spte(kvm, sptep);
>> -			sptep = rmap_get_first(*rmapp, &iter);
>> -		} else {
>> -			new_spte = *sptep & ~PT64_BASE_ADDR_MASK;
>> -			new_spte |= (u64)new_pfn << PAGE_SHIFT;
>> +			goto restart;
> I do not like this "goto restart" pattern throughout this patch. Follow up
> patch gets rid of most of them, so they are tolerable as a temporary solution
> here, but this one stays. What about moving pte_write(*ptep) outside
> for_each_spte_in_rmap() loop like that:
> 
> if (pte_write(*ptep))
> 	need_flush = kvm_unmap_rmapp();
> else
> 	for_each_spte_in_rmap() {
> 	}

Nice. Will do.

