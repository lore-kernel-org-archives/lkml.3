Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756649Ab3EGPKm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 11:10:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18295 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753154Ab3EGPKl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 11:10:41 -0400
Date: Tue, 7 May 2013 12:09:29 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Gleb Natapov <gleb@redhat.com>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>, avi.kivity@gmail.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        takuya.yoshikawa@gmail.com
Subject: Re: [PATCH v4 4/6] KVM: MMU: fast invalid all shadow pages
Message-ID: <20130507150929.GA8118@amt.cnet>
References: <518725DF.5090503@linux.vnet.ibm.com>
 <20130506123625.GB12349@redhat.com>
 <5187ABB3.7020403@linux.vnet.ibm.com>
 <20130506172455.GB18963@redhat.com>
 <5187EC50.4030308@linux.vnet.ibm.com>
 <20130507085848.GI12349@redhat.com>
 <5188CC4F.3070306@linux.vnet.ibm.com>
 <20130507100051.GK12349@redhat.com>
 <20130507143329.GB6408@amt.cnet>
 <20130507145608.GB7899@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130507145608.GB7899@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 07, 2013 at 05:56:08PM +0300, Gleb Natapov wrote:
> > > Yes, I am missing what Marcelo means there too. We cannot free memslot
> > > until we unmap its rmap one way or the other.
> > 
> > I do not understand what are you optimizing for, given the four possible
> > cases we discussed at
> > 
> > https://lkml.org/lkml/2013/4/18/280
> > 
> We are optimizing mmu_lock holding time for all of those cases.
> 
> But you cannot just "zap roots + sp gen number increase." on slot
> deletion because you need to transfer access/dirty information from rmap
> that is going to be deleted to actual page before
> kvm_set_memory_region() returns to a caller.
> 
> > That is, why a simple for_each_all_shadow_page(zap_page) is not sufficient.
> With a lock break? It is. We tried to optimize that by zapping only pages
> that reference memslot that is going to be deleted and zap all other
> later when recycling old sps, but if you think this is premature
> optimization I am fine with it.

If it can be shown that its not premature optimization, I am fine with
it.

AFAICS all cases are 1) rare and 2) not latency sensitive (as in there
is no requirement for those cases to finish in a short period of time).

