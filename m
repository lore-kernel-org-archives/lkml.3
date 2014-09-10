Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752869AbaIJSws (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 14:52:48 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:38282 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720AbaIJSwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 14:52:47 -0400
Date: Wed, 10 Sep 2014 20:52:38 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <ak@linux.intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, eranian@google.com, tglx@linutronix.de
Subject: Re: [PATCH] perf, x86: Fall back to vmalloc for BTS buffer allocation
Message-ID: <20140910185238.GS6758@twins.programming.kicks-ass.net>
References: <1410307401-12401-1-git-send-email-andi@firstfloor.org>
 <20140910075722.GL6758@twins.programming.kicks-ass.net>
 <20140910144012.GI4120@two.firstfloor.org>
 <20140910163556.GE4783@worktop.ger.corp.intel.com>
 <20140910165848.GA11901@worktop.ger.corp.intel.com>
 <20140910182744.GJ5387@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140910182744.GJ5387@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2014 at 11:27:44AM -0700, Andi Kleen wrote:
> > Note that since then we have actually fixed the 'cannot fault from NMI
> > context' thing, so we should be able to actually take those faults. I
> > suspect we can simply remove those WARNs from the vmalloc fault path,
> > but it would need double checking to see if there's no other reasons.
> 
> I think we actually need to use vmalloc_sync_all, because the PEBS/DS
> microcode may do the first access, and those lose events when
> the page is not present.

You'll need to convince Linus: https://lkml.org/lkml/2010/7/14/478
