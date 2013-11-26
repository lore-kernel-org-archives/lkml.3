Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755347Ab3KZKQW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 05:16:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3634 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755227Ab3KZKQU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 05:16:20 -0500
Date: Tue, 26 Nov 2013 12:15:55 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, Avi Kivity <avi.kivity@gmail.com>,
        "pbonzini@redhat.com Bonzini" <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org, kvm <kvm@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v3 07/15] KVM: MMU: introduce nulls desc
Message-ID: <20131126101555.GI959@redhat.com>
References: <1382534973-13197-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
 <1382534973-13197-8-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
 <20131122191429.GA13308@amt.cnet>
 <65EE805B-B5DB-4BD0-A057-E5FF78D96D67@linux.vnet.ibm.com>
 <CAEbWaipqSpf4PdRo6YD=xBjucdWjZrs0Mibfi+jJeF7uj-NaCw@mail.gmail.com>
 <20131125142351.GA6056@amt.cnet>
 <5294111B.5040905@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5294111B.5040905@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 26, 2013 at 11:10:19AM +0800, Xiao Guangrong wrote:
> On 11/25/2013 10:23 PM, Marcelo Tosatti wrote:
> > On Mon, Nov 25, 2013 at 02:48:37PM +0200, Avi Kivity wrote:
> >> On Mon, Nov 25, 2013 at 8:11 AM, Xiao Guangrong
> >> <xiaoguangrong@linux.vnet.ibm.com> wrote:
> >>>
> >>> On Nov 23, 2013, at 3:14 AM, Marcelo Tosatti <mtosatti@redhat.com> wrote:
> >>
> >> <snip complicated stuff about parent_pte>
> >>
> >> I'm not really following, but note that parent_pte predates EPT (and
> >> the use of rcu in kvm), so all the complexity that is the result of
> >> trying to pack as many list entries into a cache line can be dropped.
> >> Most setups now would have exactly one list entry, which is handled
> >> specially antyway.
> >>
> >> Alternatively, the trick of storing multiple entries in one list entry
> >> can be moved to generic code, it may be useful to others.
> > 
> > Yes, can the lockless list walking code be transformed into generic
> > single-linked list walking? So the correctness can be verified
> > independently, and KVM becomes a simple user of that interface.
> 
> I'am afraid the signle-entry list is not so good as we expected. In my
> experience, there're too many entries on rmap, more than 300 sometimes.
> (consider a case that a lib shared by all processes).
> 
This is without EPT though and non EPT HW is not performance king
anyway. Nested EPT uses shadow paging too, but VMs hardly share any
pages. With KSM they may though.

--
			Gleb.
