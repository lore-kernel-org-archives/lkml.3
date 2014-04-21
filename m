Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752589AbaDUNZv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 09:25:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15721 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751734AbaDUNZt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 09:25:49 -0400
Date: Mon, 21 Apr 2014 15:25:43 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Avi Kivity <avi.kivity@gmail.com>, Gleb Natapov <gleb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc: Dominik Dingel <dingel@linux.vnet.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] KVM: async_pf: use_mm/mm_users fixes
Message-ID: <20140421132543.GA13594@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Completely untested and I know nothing about kvm ;) Please review.

But use_mm() really looks misleading, and the usage of mm_users looks
"obviously wrong". I already sent this change while we were discussing
vmacache, but it was ignored. Since then kvm_async_page_present_sync()
was added into async_pf_execute() into async_pf_execute(), but it seems
to me that use_mm() is still unnecessary.

Oleg.

 virt/kvm/async_pf.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

