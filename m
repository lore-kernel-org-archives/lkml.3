Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751130AbaGUXBY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 19:01:24 -0400
Received: from mail.skyhub.de ([78.46.96.112]:40929 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750777AbaGUXBX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 19:01:23 -0400
Date: Tue, 22 Jul 2014 01:01:17 +0200
From: Borislav Petkov <bp@alien8.de>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, x86-ml <x86@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] x86, TSC: Add a software TSC offset
Message-ID: <20140721230117.GG11555@pd.tnic>
References: <20140719130602.GA5101@pd.tnic>
 <53CD6B50.5010404@mit.edu>
 <20140721213534.GB11555@pd.tnic>
 <CALCETrW91Q=ivYRVFb0WKXgHQO7O+x_HHDy67e90TU6Bte_ecg@mail.gmail.com>
 <20140721215225.GD11555@pd.tnic>
 <CALCETrX1LbZAiPH4x2Uby_cUUj2wgN92wc+5wvf-B3_9XdObWQ@mail.gmail.com>
 <20140721220825.GE11555@pd.tnic>
 <CALCETrXOpcegDp+eUTWqDkO0jWqgJNYhKJW=HbzvT1ga4Ekxog@mail.gmail.com>
 <20140721223009.GF11555@pd.tnic>
 <CALCETrU1BWJ5h=GDRFKg_CXh4pQvB6MyCoRP=H3z8XGirhQDsQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CALCETrU1BWJ5h=GDRFKg_CXh4pQvB6MyCoRP=H3z8XGirhQDsQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 21, 2014 at 03:43:36PM -0700, Andy Lutomirski wrote:
> I have some reason to believe that this is almost an intentional bug
> on the part of the BIOS vendor.

Hiding SMIs or some other dumb, I-know-how-to-do-stuff-better-than-you
BIOS gunk.

> IIRC it was actually quite expensive, at least on Sandy Bridge.

Hmm, strange. So after the first fence and when you get to retire the
second fence, you will have only the RDTSC eligible for retirement
and everything that's coming behind it in program order can still go
out-of-order. Unless the second fence flushes more stuff. I most likely
am missing something.

> Maybe AMD is different.
> 
> Anyway, if some future uarch breaks this, I could resurrect my old
> hack: do a TSC-dependent load prior to returning.  Loads are ordered,
> and the hackish load can't be reordered wrt RDTSC due to
> data-dependency, so we're in business :)

:-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
