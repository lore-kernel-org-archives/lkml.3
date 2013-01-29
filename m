Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753059Ab3A2Xiz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 18:38:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18216 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751657Ab3A2Xiu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 18:38:50 -0500
Date: Tue, 29 Jan 2013 19:53:45 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Avi Kivity <avi.kivity@gmail.com>, Gleb Natapov <gleb@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 03/12] KVM: MMU: simplify mmu_set_spte
Message-ID: <20130129215345.GA27735@amt.cnet>
References: <50FFB5A1.5090708@linux.vnet.ibm.com>
 <50FFB5E9.2010500@linux.vnet.ibm.com>
 <20130129002151.GB10814@amt.cnet>
 <51073A1C.1050600@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51073A1C.1050600@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29, 2013 at 10:55:24AM +0800, Xiao Guangrong wrote:
> On 01/29/2013 08:21 AM, Marcelo Tosatti wrote:
> > On Wed, Jan 23, 2013 at 06:05:29PM +0800, Xiao Guangrong wrote:
> >> In order to detecting spte remapping, we can simply check whether the
> >> spte has already been pointing to the pfn even if the spte is not the
> >> last spte, for middle spte is pointing to the kernel pfn which can not
> >> be mapped to userspace
> > 
> > This check is detecting spte overwrite, when a large spte is replaced by 
> > pointer to spte table.
> > 
> > Can't see why check for different pfn is safe: only 'int level' can
> > differ, and pfn be equivalent, for example.
> 
> The 'u64 *sptep' must on the "int level" we want to set, that means:
>  page_header(__pa(sptep)).role.level == "int level".

Right, then stick a comment there noting which cases that condition handles.
Keep the current comment and add more.

> We discussed this before :), the discussion can be found at:
> http://marc.info/?l=kvm&m=135345057329427&w=2.

Note http://marc.info/?l=kvm&m=135345059929436&w=2, please take into
account in the future.

