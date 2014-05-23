Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229AbaEWOtq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 10:49:46 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:47388 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752141AbaEWOtn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 10:49:43 -0400
Date: Fri, 23 May 2014 15:46:04 +0100
From: Will Deacon <will.deacon@arm.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>, "monstr@monstr.eu" <monstr@monstr.eu>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        "broonie@linaro.org" <broonie@linaro.org>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH v2 16/18] x86: io: implement dummy relaxed accessor
 macros for writes
Message-ID: <20140523144604.GF21319@arm.com>
References: <1400777250-17335-1-git-send-email-will.deacon@arm.com>
 <1400777250-17335-17-git-send-email-will.deacon@arm.com>
 <537E30AF.4070501@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <537E30AF.4070501@zytor.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Thu, May 22, 2014 at 06:15:27PM +0100, H. Peter Anvin wrote:
> On 05/22/2014 09:47 AM, Will Deacon wrote:
> > write{b,w,l,q}_relaxed are implemented by some architectures in order to
> > permit memory-mapped I/O accesses with weaker barrier semantics than the
> > non-relaxed variants.
> > 
> > This patch adds dummy macros for the read and write accessors to x86,
> > which simply expand to the non-relaxed variants. Note that this
> > strengthens the relaxed read accessors, since they are now ordered with
> > respect to each other by way of a compiler barrier.
> 
> OK, do we want/need that compiler barrier?  And you say "strengthens" -
> strengthens with respect to what if we didn't have them before?

Actually, x86 does already implement the relaxed read accessors:

	#define readb_relaxed(a) __readb(a)
	#define readw_relaxed(a) __readw(a)
	#define readl_relaxed(a) __readl(a)

where __read* don't have "memory" clobbers, unlike the read* implementations.

I would like the relaxed accessors to be ordered with respect to each other
but, looking again, that is already achieved through the use of volatile asm
so I've come full circle and decided that we don't need the clobbers after
all.

What do you think?

Will
