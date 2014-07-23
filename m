Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758145AbaGWPXP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 11:23:15 -0400
Received: from mail.skyhub.de ([78.46.96.112]:59759 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752877AbaGWPXO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 11:23:14 -0400
Date: Wed, 23 Jul 2014 17:23:11 +0200
From: Borislav Petkov <bp@alien8.de>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>
Subject: Re: STI architectural question (and lretq -- I'm not even kidding)
Message-ID: <20140723152311.GC21707@pd.tnic>
References: <CALCETrVx=cLZjgALizYKWATSjOvhmwPHQvOJRkMgdb=iNRNf8w@mail.gmail.com>
 <CA+55aFyefnFjmOs-QZhFn68-6+tWO30VqU6ipP6BzAra=xOaFg@mail.gmail.com>
 <CALCETrUjKXfwbWkUytMXLSmKROLBVY7tRYWPHnEC01Fj=aiTkQ@mail.gmail.com>
 <20140723104917.GB23102@pd.tnic>
 <CALCETrVzKJZiEmxuVNv8_7dybh-4AQYRA5Yb5ms+vK9CKYEorA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CALCETrVzKJZiEmxuVNv8_7dybh-4AQYRA5Yb5ms+vK9CKYEorA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 08:12:32AM -0700, Andy Lutomirski wrote:
> How are we supposed to survive two machine checks in rapid succession?
> The second will fire as soon as the first one is acked, I imagine.
> Unless we switch stacks before acking the MCE, the return address of
> the first one will be lost.

Oh, that might not fly but in that case the box probably deserves to die
anyway.

I was adressing what you said earlier: "But here's the problem: what
happens if an NMI or MCE happens between the sti and the lretq? I think
an MCE just might be okay -- it's not really recoverable anyway."

An MC Exception can be recoverable and we can recover. The fact that we
raise an exception doesn't always mean we die.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
