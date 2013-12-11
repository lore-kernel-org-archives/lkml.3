Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751827Ab3LKRsi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 12:48:38 -0500
Received: from a9-46.smtp-out.amazonses.com ([54.240.9.46]:59790 "EHLO
	a9-46.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751407Ab3LKRse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 12:48:34 -0500
Date: Wed, 11 Dec 2013 17:48:32 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Ingo Molnar <mingo@kernel.org>
cc: Tejun Heo <tj@kernel.org>, akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 13/41] percpu: Add raw_cpu_ops
In-Reply-To: <20131211151220.GB11048@gmail.com>
Message-ID: <00000142e2c64102-07168d96-fb2f-4eeb-9b49-c3298bc81192-000000@email.amazonses.com>
References: <20131203233232.928771708@linux.com> <20131203233251.745099192@linux.com> <20131210153445.GE4610@htj.dyndns.org> <20131210154506.GA1884@gmail.com> <20131210154951.GF4610@htj.dyndns.org> <20131210155546.GD1995@gmail.com>
 <00000142ddb6d07d-f77cfa15-55a5-4806-891e-2d57894fc46b-000000@email.amazonses.com> <20131210183133.GC20770@gmail.com> <00000142de1ac9a3-d2b5b7fb-25c5-4bec-acbe-8be30a951bbc-000000@email.amazonses.com> <20131211151220.GB11048@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.12.11-54.240.9.46
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Dec 2013, Ingo Molnar wrote:

> > Well this is how the x86 portions came from Peter. [...]
>
> That's an interesting piece of information, in particular because you
> lost From: PeterZ authorship there, don't do that!

Ok will add that. There is a signoff there. Is that ok with you Peter?

Thinking about this some more: Separating these two issues would make it
impossible to build x86 since the hackery in x86/include/asm/preempt.h
depends on having the right names in x86/include/asm/percpu.h. Changing
the names first would result in preempt.h not being usable.
