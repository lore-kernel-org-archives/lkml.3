Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749Ab3DREEG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 00:04:06 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:59126 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752417Ab3DREED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 00:04:03 -0400
Message-ID: <516F70A1.7010007@linux.vnet.ibm.com>
Date: Thu, 18 Apr 2013 12:03:45 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: gleb@redhat.com, avi.kivity@gmail.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v3 15/15] KVM: MMU: replace kvm_zap_all with kvm_mmu_invalid_all_pages
References: <1366093973-2617-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <1366093973-2617-16-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <20130418000812.GF31059@amt.cnet>
In-Reply-To: <20130418000812.GF31059@amt.cnet>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041804-2674-0000-0000-000008A44EB3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/18/2013 08:08 AM, Marcelo Tosatti wrote:
> On Tue, Apr 16, 2013 at 02:32:53PM +0800, Xiao Guangrong wrote:
>> Use kvm_mmu_invalid_all_pages in kvm_arch_flush_shadow_all and
>> rename kvm_zap_all to kvm_free_all which is used to free all
>> memmory used by kvm mmu when vm is being destroyed, at this time,
>> no vcpu exists and mmu-notify has been unregistered, so we can
>> free the shadow pages out of mmu-lock
> 
> Since there is no contention for mmu-lock its also not a problem to 
> grab the lock right?

This still has contention. Other mmu-notify can happen when we handle
->release(). On the other handle, spin-lock is not preemptable.

> 
> Automated verification of locking/srcu might complain.

We hold slot-lock to free shadow page out of mmu-lock, it can avoid
the complain. No?



