Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756868Ab3IPPEb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 11:04:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28602 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754026Ab3IPPE2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 11:04:28 -0400
Date: Mon, 16 Sep 2013 18:04:22 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v2 09/15] KVM: MMU: introduce pte-list lockless walker
Message-ID: <20130916150422.GC906@redhat.com>
References: <1378376958-27252-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
 <1378376958-27252-10-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
 <20130916124213.GR17294@redhat.com>
 <52370D1A.8070505@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52370D1A.8070505@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 16, 2013 at 09:52:26PM +0800, Xiao Guangrong wrote:
> Hi Gleb,
> 
> On 09/16/2013 08:42 PM, Gleb Natapov wrote:
> 
> >>  static unsigned long *__gfn_to_rmap(gfn_t gfn, int level,
> >>  				    struct kvm_memory_slot *slot)
> >>  {
> >> @@ -4651,7 +4700,7 @@ int kvm_mmu_module_init(void)
> >>  {
> >>  	pte_list_desc_cache = kmem_cache_create("pte_list_desc",
> >>  					    sizeof(struct pte_list_desc),
> >> -					    0, 0, NULL);
> >> +					    0, SLAB_DESTROY_BY_RCU, NULL);
> > Haven't we agreed that constructor is needed for the cache?
> 
> Yes. I've made it as a separate patch:
> [PATCH v2 10/15] KVM: MMU: initialize the pointers in pte_list_desc properly
> 
Ah, I haven't got there yet :)

--
			Gleb.
