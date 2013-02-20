Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935283Ab3BTLOl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 06:14:41 -0500
Received: from 8bytes.org ([85.214.48.195]:55307 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935012Ab3BTLM6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 06:12:58 -0500
Date: Wed, 20 Feb 2013 12:12:55 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] x86/platform changes for v3.9
Message-ID: <20130220111255.GB26252@8bytes.org>
References: <20130219154128.GA15608@gmail.com>
 <CA+55aFxn=xFGhF8L2pJYP8wOe3VdCpGtaibB0bbRuH8FAKkCNg@mail.gmail.com>
 <20130220090238.GA18213@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130220090238.GA18213@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Wed Feb 20 12:12:56 2013
X-DSPAM-Confidence: 0.9993
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 5124afb822971438219857
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2013 at 10:02:38AM +0100, Ingo Molnar wrote:
> Timers and APIC would be my leading suspect - but scheduler and 
> hotplug changes might be the culprits as well.
> 
> Yesterday, while preparing the trees I wanted to mention this 
> x86/apic commit:
> 
>   336224ba5e4f x86, apic: Mask IO-APIC and PIC unconditionally on LAPIC resume
> 
> ... as a change that needs monitored because it changes the 
> suspend and shutdown sequence but then skipped mentioning it 
> because it seemed relatively old and proven.

Hmm, this commit only touches the resume-path. I would wonder if this
has something to do with reboot, can't rule it out, though.

> But there are other potentially dangerous commits as well - I 
> suspect we won't be able to avoid a bisection :-/

Yes, I think a bisection would be best if the problem is reproducible.


	Joerg


