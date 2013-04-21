Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753615Ab3DUXmR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Apr 2013 19:42:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13495 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752573Ab3DUXmQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Apr 2013 19:42:16 -0400
Date: Sun, 21 Apr 2013 12:27:51 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Gleb Natapov <gleb@redhat.com>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>, avi.kivity@gmail.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v3 00/15] KVM: MMU: fast zap all shadow pages
Message-ID: <20130421152751.GB28437@amt.cnet>
References: <1366093973-2617-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
 <20130421130346.GE8997@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130421130346.GE8997@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 21, 2013 at 04:03:46PM +0300, Gleb Natapov wrote:
> On Tue, Apr 16, 2013 at 02:32:38PM +0800, Xiao Guangrong wrote:
> > This patchset is based on my previous two patchset:
> > [PATCH 0/2] KVM: x86: avoid potential soft lockup and unneeded mmu reload
> > (https://lkml.org/lkml/2013/4/1/2)
> > 
> > [PATCH v2 0/6] KVM: MMU: fast invalid all mmio sptes
> > (https://lkml.org/lkml/2013/4/1/134)
> > 
> > Changlog:
> > V3:
> >   completely redesign the algorithm, please see below.
> > 
> This looks pretty complicated. Is it still needed in order to avoid soft
> lockups after "avoid potential soft lockup and unneeded mmu reload" patch?

Do not want kvm_set_memory (cases: DELETE/MOVE/CREATES) to be
suspectible to:

vcpu 1    		|	kvm_set_memory
create shadow page 		
				nuke shadow page
create shadow page
				nuke shadow page

Which is guest triggerable behavior with spinlock preemption algorithm.

