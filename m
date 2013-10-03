Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755017Ab3JCGQ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 02:16:57 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:55544 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754777Ab3JCGQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 02:16:56 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: [PATCH v2 02/15] KVM: MMU: properly check last spte in fast_page_fault()
From: Xiao Guangrong <xiaoguangrong.eric@gmail.com>
In-Reply-To: <20130930212308.GA31805@amt.cnet>
Date: Thu, 3 Oct 2013 14:16:49 +0800
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>, gleb@redhat.com,
        avi.kivity@gmail.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <D2A918AA-2D5F-41D6-8366-35661E2D223D@gmail.com>
References: <1378376958-27252-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <1378376958-27252-3-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <20130930212308.GA31805@amt.cnet>
To: Marcelo Tosatti <mtosatti@redhat.com>
X-Mailer: Apple Mail (2.1510)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 1, 2013, at 5:23 AM, Marcelo Tosatti <mtosatti@redhat.com> wrote:

>> 
> 
> Unrelated to this patch:
> 
> If vcpu->mode = OUTSIDE_GUEST_MODE, no IPI is sent
> by kvm_flush_remote_tlbs.

Yes.

> 
> So how is this supposed to work again?
> 
>        /*
>         * Wait for all vcpus to exit guest mode and/or lockless shadow
>         * page table walks.
>         */

On the lockless walking path, we change the vcpu->mode to
READING_SHADOW_PAGE_TABLES, so that IPI is needed.
Or i missed your question?


>        kvm_flush_remote_tlbs(kvm);
> 
> Patch looks fine.

Thank you, Marcelo!

