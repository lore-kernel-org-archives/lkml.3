Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756323Ab3IPNwf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 09:52:35 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:55004 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753868Ab3IPNwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 09:52:34 -0400
Message-ID: <52370D1A.8070505@linux.vnet.ibm.com>
Date: Mon, 16 Sep 2013 21:52:26 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v2 09/15] KVM: MMU: introduce pte-list lockless walker
References: <1378376958-27252-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <1378376958-27252-10-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <20130916124213.GR17294@redhat.com>
In-Reply-To: <20130916124213.GR17294@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13091613-6102-0000-0000-000004300329
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gleb,

On 09/16/2013 08:42 PM, Gleb Natapov wrote:

>>  static unsigned long *__gfn_to_rmap(gfn_t gfn, int level,
>>  				    struct kvm_memory_slot *slot)
>>  {
>> @@ -4651,7 +4700,7 @@ int kvm_mmu_module_init(void)
>>  {
>>  	pte_list_desc_cache = kmem_cache_create("pte_list_desc",
>>  					    sizeof(struct pte_list_desc),
>> -					    0, 0, NULL);
>> +					    0, SLAB_DESTROY_BY_RCU, NULL);
> Haven't we agreed that constructor is needed for the cache?

Yes. I've made it as a separate patch:
[PATCH v2 10/15] KVM: MMU: initialize the pointers in pte_list_desc properly


