Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756801AbaJXNmQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 09:42:16 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:60138 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756787AbaJXNmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 09:42:13 -0400
Date: Fri, 24 Oct 2014 15:42:05 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Daniel Borkmann <dborkman@redhat.com>,
        Andrey Ryabinin <a.ryabinin@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Michal Marek <mmarek@suse.cz>,
        x86@kernel.org, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Dmitry Vyukov <dvyukov@google.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>
Subject: Re: drivers: random: Shift out-of-bounds in _mix_pool_bytes
Message-ID: <20141024134205.GB21513@worktop.programming.kicks-ass.net>
References: <1413802499-17928-1-git-send-email-a.ryabinin@samsung.com>
 <5444EBFA.5030103@samsung.com>
 <20141020124929.GA23177@thunk.org>
 <54451501.2070700@samsung.com>
 <5445179A.4080804@redhat.com>
 <20141020141635.GA4499@thunk.org>
 <20141024100108.GF12706@worktop.programming.kicks-ass.net>
 <544A52D7.6000202@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <544A52D7.6000202@oracle.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24, 2014 at 09:23:35AM -0400, Sasha Levin wrote:
> 
> i >> 32 may happen to be "i", but is there anything that prevents the compiler
> from returning, let's say, 42?

Not really, although gcc seems to opt for the 'sane' option and emit the
instruction and let the arch figure out how to deal with it. Hence the
'fun' difference between x86 and ARM.


