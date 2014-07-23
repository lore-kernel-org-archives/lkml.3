Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757861AbaGWJkm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 05:40:42 -0400
Received: from mail.skyhub.de ([78.46.96.112]:38101 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757745AbaGWJkl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 05:40:41 -0400
Date: Wed, 23 Jul 2014 11:40:38 +0200
From: Borislav Petkov <bp@alien8.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andy Lutomirski <luto@amacapital.net>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>
Subject: Re: STI architectural question (and lretq -- I'm not even kidding)
Message-ID: <20140723094038.GA23102@pd.tnic>
References: <CALCETrVx=cLZjgALizYKWATSjOvhmwPHQvOJRkMgdb=iNRNf8w@mail.gmail.com>
 <CA+55aFyefnFjmOs-QZhFn68-6+tWO30VqU6ipP6BzAra=xOaFg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CA+55aFyefnFjmOs-QZhFn68-6+tWO30VqU6ipP6BzAra=xOaFg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 06:03:35PM -0700, Linus Torvalds wrote:
> So I'm afraid that "sti; lret" is not guaranteed to be architecturally
> NMI-safe. But it *might* be safe on certain micro-architectures, and
> maybe somebody inside Intel or AMD can give us a hint about when it is
> safe and when it isn't.

>From AMD's APM, STI section:

"Sets the interrupt flag (IF) in the rFLAGS register to 1, thereby
allowing external interrupts received on the INTR input. Interrupts
received on the non-maskable interrupt (NMI) input are not affected by
this instruction."

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
