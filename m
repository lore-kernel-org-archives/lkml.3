Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966820AbaFTUjk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 16:39:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12961 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757046AbaFTUjj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 16:39:39 -0400
Date: Fri, 20 Jun 2014 17:39:03 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Gleb Natapov <gleb@kernel.org>
Cc: Tang Chen <tangchen@cn.fujitsu.com>, pbonzini@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, mgorman@suse.de,
        yinghai@kernel.org, isimatu.yasuaki@jp.fujitsu.com,
        guz.fnst@cn.fujitsu.com, laijs@cn.fujitsu.com, kvm@vger.kernel.org,
        linux-mm@kvack.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        Avi Kivity <avi.kivity@gmail.com>
Subject: Re: [RFC PATCH 1/1] Move two pinned pages to non-movable node in kvm.
Message-ID: <20140620203903.GA7838@amt.cnet>
References: <1403070600-6083-1-git-send-email-tangchen@cn.fujitsu.com>
 <20140618061230.GA10948@minantech.com>
 <53A136C4.5070206@cn.fujitsu.com>
 <20140619092031.GA429@minantech.com>
 <20140619190024.GA3887@amt.cnet>
 <20140620111509.GE20764@minantech.com>
 <20140620125326.GA22283@amt.cnet>
 <20140620142622.GA28698@minantech.com>
 <20140620203146.GA6580@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140620203146.GA6580@amt.cnet>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2014 at 05:31:46PM -0300, Marcelo Tosatti wrote:
> > IIRC your shadow page pinning patch series support flushing of ptes
> > by mmu notifier by forcing MMU reload and, as a result, faulting in of
> > pinned pages during next entry.  Your patch series does not pin pages
> > by elevating their page count.
> 
> No but PEBS series does and its required to stop swap-out
> of the page.

Well actually no because of mmu notifiers.

Tang, can you implement mmu notifiers for the other breaker of 
mem hotplug ?
