Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965191Ab3DRCjJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 22:39:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61308 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965055Ab3DRCix (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 22:38:53 -0400
Date: Wed, 17 Apr 2013 21:08:12 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: gleb@redhat.com, avi.kivity@gmail.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v3 15/15] KVM: MMU: replace kvm_zap_all with
 kvm_mmu_invalid_all_pages
Message-ID: <20130418000812.GF31059@amt.cnet>
References: <1366093973-2617-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
 <1366093973-2617-16-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366093973-2617-16-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 16, 2013 at 02:32:53PM +0800, Xiao Guangrong wrote:
> Use kvm_mmu_invalid_all_pages in kvm_arch_flush_shadow_all and
> rename kvm_zap_all to kvm_free_all which is used to free all
> memmory used by kvm mmu when vm is being destroyed, at this time,
> no vcpu exists and mmu-notify has been unregistered, so we can
> free the shadow pages out of mmu-lock

Since there is no contention for mmu-lock its also not a problem to 
grab the lock right?

Automated verification of locking/srcu might complain.


