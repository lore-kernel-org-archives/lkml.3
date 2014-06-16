Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932284AbaFPUxL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 16:53:11 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:23475 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755559AbaFPUxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 16:53:09 -0400
Date: Mon, 16 Jun 2014 16:52:21 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Waiman.Long@hp.com, tglx@linutronix.de, mingo@kernel.org,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        paolo.bonzini@gmail.com, boris.ostrovsky@oracle.com,
        paulmck@linux.vnet.ibm.com, riel@redhat.com,
        torvalds@linux-foundation.org, raghavendra.kt@linux.vnet.ibm.com,
        david.vrabel@citrix.com, oleg@redhat.com, gleb@redhat.com,
        scott.norton@hp.com, chegu_vinod@hp.com,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 00/11] qspinlock with paravirt support
Message-ID: <20140616205221.GB26140@laptop.dumpdata.com>
References: <20140615124657.264658593@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140615124657.264658593@chello.nl>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 15, 2014 at 02:46:57PM +0200, Peter Zijlstra wrote:
> Since Waiman seems incapable of doing simple things; here's my take on the
> paravirt crap.
> 
> The first few patches are taken from Waiman's latest series, but the virt
> support is completely new. Its primary aim is to not mess up the native code.

OK. I finally cleared some time to look over this and are reading the code
in details to make sure I have it clear in mind. I will most likely ask
some questions that are naive - hopefully they will lead to the code being
self-explanatory for anybody else taking a stab at understanding them when
bugs appear.
> 
> I've not stress tested it, but the virt and paravirt (kvm) cases boot on simple
> smp guests. I've not done Xen, but the patch should be simple and similar.

Looking forward to seeing it. Glancing over the KVM one and comparing it
to the original version that Waiman posted it should be fairly simple. Perhaps
even some of the code could be shared?

> 
> I ripped out all the unfair nonsense as its not at all required for paravirt
> and optimizations that make paravirt better at the cost of code clarity and/or
> native performance are just not worth it.
> 
> Also; if we were to ever add some of that unfair nonsense you do so _after_ you
> got the simple things working.
> 
> The thing I'm least sure about is the head tracking, I chose to do something
> different from what Waiman did, because his is O(nr_cpus) and had the
> assumption that guests have small nr_cpus. AFAIK this is not at all true. The
> biggest problem I have with what I did is that it contains wait loops itself.
> 
> 
> 
