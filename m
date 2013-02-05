Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755574Ab3BEIwp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 03:52:45 -0500
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:44764 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754230Ab3BEIwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 03:52:44 -0500
Message-ID: <5110C853.4080705@linux.vnet.ibm.com>
Date: Tue, 05 Feb 2013 16:52:35 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Gleb Natapov <gleb@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH v3 0/5] KVM: MMU: unify and cleanup the code of walking pte
 list
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13020508-5564-0000-0000-0000067D2177
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current code has two ways to walk pte_list, the one is pte_list_walk and
the another way is rmap_get_first and rmap_get_next, they have the same logic.
This patchset tries to unify the code and also make the code more tidy.

Patch 1: KVM: MMU: introduce mmu_spte_establish, which tries to eliminates
the different between walking parent pte list and rmap, prepare for the
later patch.

Patch 2: KVM: MMU: clarify the logic in kvm_set_pte_rmapp, which prepares for
the next patch, no logic changed.

Patch 3: KVM: MMU: unify the code of walking pte list, unify the walking code.

Patch 4: KVM: MMU: fix spte assertion, fix a minor bug and remove the duplicate
code.

Patch 5: KVM: MMU: fast drop all spte on the pte_list, optimize for dropping
all sptes on rmap and remove all the "goto restart" pattern introduced by
the Patch 3.

Marcelo, Gleb, please apply them after applying the patchset of
[PATCH v3 0/3] KVM: MMU: simple cleanups.

Changelog:
v3:
- address Gleb's comments, remove the remained "goto restart" in
  kvm_set_pte_rmapp
- improve the changelog

Thanks!

