Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367Ab3BENEd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 08:04:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53677 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754912Ab3BENEa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 08:04:30 -0500
Date: Tue, 5 Feb 2013 15:04:27 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 0/5] KVM: MMU: unify and cleanup the code of walking
 pte list
Message-ID: <20130205130427.GI23213@redhat.com>
References: <5110C853.4080705@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5110C853.4080705@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 05, 2013 at 04:52:35PM +0800, Xiao Guangrong wrote:
> Current code has two ways to walk pte_list, the one is pte_list_walk and
> the another way is rmap_get_first and rmap_get_next, they have the same logic.
> This patchset tries to unify the code and also make the code more tidy.
> 
> Patch 1: KVM: MMU: introduce mmu_spte_establish, which tries to eliminates
> the different between walking parent pte list and rmap, prepare for the
> later patch.
> 
> Patch 2: KVM: MMU: clarify the logic in kvm_set_pte_rmapp, which prepares for
> the next patch, no logic changed.
> 
> Patch 3: KVM: MMU: unify the code of walking pte list, unify the walking code.
> 
> Patch 4: KVM: MMU: fix spte assertion, fix a minor bug and remove the duplicate
> code.
> 
> Patch 5: KVM: MMU: fast drop all spte on the pte_list, optimize for dropping
> all sptes on rmap and remove all the "goto restart" pattern introduced by
> the Patch 3.
> 
> Marcelo, Gleb, please apply them after applying the patchset of
> [PATCH v3 0/3] KVM: MMU: simple cleanups.
> 
> Changelog:
> v3:
> - address Gleb's comments, remove the remained "goto restart" in
>   kvm_set_pte_rmapp
> - improve the changelog
> 
Reviewed-by: Gleb Natapov <gleb@redhat.com>

--
			Gleb.
