Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341Ab3F1PPr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 11:15:47 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53601 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755271Ab3F1PPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 11:15:46 -0400
Date: Fri, 28 Jun 2013 17:15:33 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
        Wedson Almeida Filho <wedsonaf@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86: Use asm-goto to implement mutex fast path on x86-64
Message-ID: <20130628151533.GD6626@twins.programming.kicks-ass.net>
References: <1372416851-56830-1-git-send-email-wedsonaf@gmail.com>
 <20130628111948.GA31065@gmail.com>
 <20130628140938.GA24819@pd.tnic>
 <51CD99C2.9040109@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51CD99C2.9040109@zytor.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 28, 2013 at 07:12:18AM -0700, H. Peter Anvin wrote:
> On 06/28/2013 07:09 AM, Borislav Petkov wrote:
> > 
> > Our testing for asm goto otherwise is a bit more, hmm, hands-on in
> > arch/x86/include/asm/cpufeature.h:
> > 
> > #if __GNUC__ > 4 || __GNUC_MINOR__ >= 5
> > 
> > Maybe I should change that to the more explicit CC_HAVE_ASM_GOTO then.
> > 
> 
> We should... we didn't have the asm goto test at the time that code was
> written, but I think the tracing guys added it either because some
> distros backported asm goto or to deal with it on non-x86 architectures.

gcc backport in distro iirc
