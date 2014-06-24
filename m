Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753052AbaFXKrR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 06:47:17 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:44269 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407AbaFXKrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 06:47:15 -0400
Date: Tue, 24 Jun 2014 12:47:02 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Waiman.Long@hp.com,
        tglx@linutronix.de, mingo@kernel.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        paolo.bonzini@gmail.com, boris.ostrovsky@oracle.com,
        paulmck@linux.vnet.ibm.com, riel@redhat.com,
        torvalds@linux-foundation.org, raghavendra.kt@linux.vnet.ibm.com,
        david.vrabel@citrix.com, oleg@redhat.com, gleb@redhat.com,
        scott.norton@hp.com, chegu_vinod@hp.com
Subject: Re: [PATCH 04/11] qspinlock: Extract out the exchange of tail code
 word
Message-ID: <20140624104702.GO13930@laptop.programming.kicks-ass.net>
References: <20140615124657.264658593@chello.nl>
 <20140615130153.376621956@chello.nl>
 <20140617205525.GB29634@laptop.dumpdata.com>
 <53A17A09.6010007@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53A17A09.6010007@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2014 at 01:37:45PM +0200, Paolo Bonzini wrote:
> However, I *do* agree with you that it's simpler to just squash this patch
> into 01/11.

So I explicitly broke out these optimizations into separate patches so
that we can see them independently and agree they're idempotent wrt the
state machine.

The initial patches by Waiman were totally unreadable, partly because
the optimizations made the code terribly complex.

Luckily waiman then dropped the most horrible optimizations
(optimization for the very large nr_cpus case, were we cannot have a
pending byte), so the end result isn't quite as complex as it used to
be.
