Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752639AbaHDT4k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 15:56:40 -0400
Received: from g6t1525.atlanta.hp.com ([15.193.200.68]:51488 "EHLO
	g6t1525.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456AbaHDT4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 15:56:39 -0400
Message-ID: <1407182196.2571.14.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH 1/2] KVM: nVMX: Fix nested vmexit ack intr before load
 vmcs01
From: Davidlohr Bueso <davidlohr@hp.com>
To: Wanpeng Li <wanpeng.li@linux.intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jan Kiszka <jan.kiszka@siemens.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        Bandan Das <bsd@redhat.com>, Zhang Yang <yang.z.zhang@intel.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org, freyes@suse.com
Date: Mon, 04 Aug 2014 12:56:36 -0700
In-Reply-To: <1406880727-60001-1-git-send-email-wanpeng.li@linux.intel.com>
References: <1406880727-60001-1-git-send-email-wanpeng.li@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-08-01 at 16:12 +0800, Wanpeng Li wrote:
> External interrupt will cause L1 vmexit w/ reason external interrupt when L2 is 
> running. Then L1 will pick up the interrupt through vmcs12 if L1 set the ack 
> interrupt bit. Commit 77b0f5d (KVM: nVMX: Ack and write vector info to intr_info
> if L1 asks us to)

So being that 77b0f5d is in 3.15, we need it for -stable.

>  get intr that belongs to L1 before load vmcs01 which is wrong, 
> especially this lead to the obvious L1 ack APICv behavior weired since APICv 
> is for L1 instead of L2. This patch fix it by ack intr after load vmcs01.
> 
> Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>

It strikes me that this fixes Felipe's issue:
http://paste.opensuse.org/view/raw/78752586




