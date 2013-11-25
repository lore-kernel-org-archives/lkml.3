Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932285Ab3KYOYq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 09:24:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17583 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756816Ab3KYOYn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 09:24:43 -0500
Date: Mon, 25 Nov 2013 12:23:51 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Avi Kivity <avi.kivity@gmail.com>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Gleb Natapov <gleb@redhat.com>,
        "pbonzini@redhat.com Bonzini" <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org, kvm <kvm@vger.kernel.org>,
        Eric Dumazet <dada1@cosmosbay.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v3 07/15] KVM: MMU: introduce nulls desc
Message-ID: <20131125142351.GA6056@amt.cnet>
References: <1382534973-13197-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
 <1382534973-13197-8-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
 <20131122191429.GA13308@amt.cnet>
 <65EE805B-B5DB-4BD0-A057-E5FF78D96D67@linux.vnet.ibm.com>
 <CAEbWaipqSpf4PdRo6YD=xBjucdWjZrs0Mibfi+jJeF7uj-NaCw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEbWaipqSpf4PdRo6YD=xBjucdWjZrs0Mibfi+jJeF7uj-NaCw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 25, 2013 at 02:48:37PM +0200, Avi Kivity wrote:
> On Mon, Nov 25, 2013 at 8:11 AM, Xiao Guangrong
> <xiaoguangrong@linux.vnet.ibm.com> wrote:
> >
> > On Nov 23, 2013, at 3:14 AM, Marcelo Tosatti <mtosatti@redhat.com> wrote:
> 
> <snip complicated stuff about parent_pte>
> 
> I'm not really following, but note that parent_pte predates EPT (and
> the use of rcu in kvm), so all the complexity that is the result of
> trying to pack as many list entries into a cache line can be dropped.
> Most setups now would have exactly one list entry, which is handled
> specially antyway.
> 
> Alternatively, the trick of storing multiple entries in one list entry
> can be moved to generic code, it may be useful to others.

Yes, can the lockless list walking code be transformed into generic
single-linked list walking? So the correctness can be verified
independently, and KVM becomes a simple user of that interface.

The simpler version is to maintain lockless walk on depth-1 rmap entries
(and grab the lock once depth-2 entry is found).

