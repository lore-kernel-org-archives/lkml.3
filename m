Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753649AbaGUVwc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 17:52:32 -0400
Received: from mail.skyhub.de ([78.46.96.112]:53737 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753019AbaGUVwa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 17:52:30 -0400
Date: Mon, 21 Jul 2014 23:52:25 +0200
From: Borislav Petkov <bp@alien8.de>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, x86-ml <x86@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] x86, TSC: Add a software TSC offset
Message-ID: <20140721215225.GD11555@pd.tnic>
References: <20140719130602.GA5101@pd.tnic>
 <53CD6B50.5010404@mit.edu>
 <20140721213534.GB11555@pd.tnic>
 <CALCETrW91Q=ivYRVFb0WKXgHQO7O+x_HHDy67e90TU6Bte_ecg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CALCETrW91Q=ivYRVFb0WKXgHQO7O+x_HHDy67e90TU6Bte_ecg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 21, 2014 at 02:41:50PM -0700, Andy Lutomirski wrote:
> How will this be compatible with the vdso?

I've never thought about it yet. How compatible would you want it to be
and what do you expect from it?

Remember, this is only attempting to be a hardware workaround for a
smallish number of systems out there. Most of current machines should
have stable and synched TSCs.

> Also, IIRC, rdtscp does not need rdtsc_barrier(), whereas rdtsc does.
> Getting this wrong will be a significant slowdown.

This is too cryptic for me - get_cycles doesn't barrier around the TSC
now either. Again, we will most likely end up not using RDTSCP anyway.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
