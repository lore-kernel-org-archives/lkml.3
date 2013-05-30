Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759732Ab3E3AyO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 20:54:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61460 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757728Ab3E3AyE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 20:54:04 -0400
Date: Thu, 30 May 2013 03:53:38 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, avi.kivity@gmail.com,
        pbonzini@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v7 10/11] KVM: MMU: collapse TLB flushes when zap all
 pages
Message-ID: <20130530005338.GC19294@redhat.com>
References: <1369252560-11611-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
 <1369252560-11611-11-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
 <20130528003611.GA1958@amt.cnet>
 <51A4CAED.7060608@linux.vnet.ibm.com>
 <51A56FF7.2000907@linux.vnet.ibm.com>
 <20130529123959.GC5931@amt.cnet>
 <51A6006D.5060601@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51A6006D.5060601@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 29, 2013 at 09:19:41PM +0800, Xiao Guangrong wrote:
> On 05/29/2013 08:39 PM, Marcelo Tosatti wrote:
> > On Wed, May 29, 2013 at 11:03:19AM +0800, Xiao Guangrong wrote:
> >>>>> the pages since other vcpus may be doing locklessly shadow
> >>>>> page walking
> >>>
> >>> Ah, yes, i agree with you.
> >>>
> >>> We can introduce a list, say kvm->arch.obsolte_pages, to link all of the
> >>> zapped-page, the page-shrink will free the page on that list first.
> >>>
> >>> Marcelo, if you do not have objection on  patch 1 ~ 8 and 11, could you please
> >>> let them merged first, and do add some comments and tlb optimization later?
> >>
> >> Exclude patch 11 please, since it depends on the "collapse" optimization.
> > 
> > I'm fine with patch 1 being merged. I think the remaining patches need better
> > understanding or explanation. The problems i see are:
> > 
> > 1) The magic number "10" to zap before considering reschedule is
> > annoying. It would be good to understand why it is needed at all.
> 
> ......
> 
> > 
> > But then again, the testcase is measuring kvm_mmu_zap_all performance
> > alone which we know is not a common operation, so perhaps there is
> > no need for that minimum-pages-to-zap-before-reschedule.
> 
> Well. Although, this is not the common operation, but this operation
> can be triggered by VCPU - it one VCPU take long time on zap-all-pages,
> other vcpus is missing IPI-synce, or missing IO. This is easily cause
> soft lockups if the vcpu is doing memslot-releated things.
> 
+1. If it is trigarable by a guest it may slow down the guest, but we
should not allow for it to slow down a host.

--
			Gleb.
