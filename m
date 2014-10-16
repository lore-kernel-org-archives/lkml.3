Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751321AbaJPI0d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 04:26:33 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:37557 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870AbaJPI0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 04:26:31 -0400
Date: Thu, 16 Oct 2014 10:26:24 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Kees Cook <keescook@chromium.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Erik Bosman <ebn310@few.vu.nl>
Subject: Re: [RFC 2/5] x86: Store a per-cpu shadow copy of CR4
Message-ID: <20141016082624.GH7369@worktop.fdxtended.com>
References: <cover.1413323611.git.luto@amacapital.net>
 <808fa43ef6e24d1df47c2666174d997105b9582d.1413323611.git.luto@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <808fa43ef6e24d1df47c2666174d997105b9582d.1413323611.git.luto@amacapital.net>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 14, 2014 at 03:57:36PM -0700, Andy Lutomirski wrote:
> Context switches and TLB flushes can change individual bits of CR4.
> CR4 reads take several cycles, so store a shadow copy of CR4 in a
> per-cpu variable.
> 
> To avoid wasting a cache line, I added the CR4 shadow to
> cpu_tlbstate, which is already touched during context switches.

I'm a little confused. We should be more specific I suppose, context
switches don't always change mm, but CR4 state is per task.

>From a quick look, only switch_mm() pokes at tlb, switch_to() does not.


