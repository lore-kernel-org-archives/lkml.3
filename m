Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752141AbaGaVBL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 17:01:11 -0400
Received: from mail.orcon.net.nz ([219.88.242.52]:49581 "EHLO
	mail.orcon.net.nz" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750945AbaGaVBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 17:01:09 -0400
Date: Fri, 1 Aug 2014 09:00:23 +1200
From: Michael Cree <mcree@orcon.net.nz>
To: Richard Henderson <rth@twiddle.net>
Cc: linux-kernel@vger.kernel.org, linux-alpha@vger.kernel.org
Subject: Re: [PATCH 1/2] alpha: Remove "strange" OSF/1 fork semantics
Message-ID: <20140731210023.GC12601@stolen.phys.waikato.ac.nz>
References: <1406756552-23864-1-git-send-email-rth@twiddle.net>
 <1406756552-23864-2-git-send-email-rth@twiddle.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406756552-23864-2-git-send-email-rth@twiddle.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Bayes-Prob: 0.0001 (Score 0: No Bayes scoring rules defined, tokens from: outbound)
X-Spam-Score: -3.00 () [Hold at 3.00] FREEMAIL_FROM:0.001,CC(NZ:-3)
X-CanIt-Geo: ip=130.217.188.11; country=NZ; latitude=-41.0000; longitude=174.0000; http://maps.google.com/maps?q=-41.0000,174.0000&z=6
X-CanItPRO-Stream: base:outbound
X-Canit-Stats-ID: 02Mx90xvH - e5e2ddcd0d42 - 20140801
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2014 at 11:42:31AM -1000, Richard Henderson wrote:
> The assignment to regs->r20 kills the original tls_val input
> to the clone syscall, which means that clone can no longer be
> restarted with the original inputs.
> 
> We could, perhaps, retain this result for true fork, but OSF/1
> compatibility is no longer important.  Note that glibc has never
> used the r20 result value, instead always testing r0 vs 0 to
> determine the child/parent status.
> 
> This failure can be seen in the glibc nptl/tst-eintr* tests.
> 
> Reported-by: Michael Cree <mcree@orcon.net.nz>
> Signed-off-by: Richard Henderson <rth@twiddle.net>

The glibc nptl/tst-eintr3 test now works successfully on the SMP
system with the patched kernel.

In addition builds of openjdk-6 or openjdk-7 use to always fail
because javac would randomly lock up at some point.  A test build of
openjdk-6 has just built successfully to completion with the patched
kernel.

I am not able to test whether OSF/1 compatibility is adversely
affected.

Tested-by: Michael Cree <mcree@orcon.net.nz>

Cheers
Michael.
