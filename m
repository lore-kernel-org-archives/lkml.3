Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756106Ab3J2NYy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 09:24:54 -0400
Received: from imap.thunk.org ([74.207.234.97]:52040 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753241Ab3J2NYx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 09:24:53 -0400
Date: Tue, 29 Oct 2013 09:24:48 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Stephan Mueller <smueller@chronox.de>
Cc: sandy harris <sandyinchina@gmail.com>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH] CPU Jitter RNG: inclusion into kernel crypto API and
 /dev/random
Message-ID: <20131029132448.GB691@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Stephan Mueller <smueller@chronox.de>,
	sandy harris <sandyinchina@gmail.com>, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
References: <2579337.FPgJGgHYdz@tauon>
 <2049321.gMV6JUDze7@tauon>
 <20131028214549.GA31746@thunk.org>
 <3160817.9DcncHidey@tauon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3160817.9DcncHidey@tauon>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 29, 2013 at 09:42:30AM +0100, Stephan Mueller wrote:
> Based on this suggestion, I now added the tests in Appendix F.46.8 where 
> I disable the caches and the tests in Appendix F.46.9 where I disable 
> the caches and interrupts.

What you've added in F.46 is a good start, but as a suggestiom,
instead of disabling one thing at a time, try disabling *everything*
and then see what you get, and then enabling one thing at a time.  The
best thing is if you can get to the point where the amount of entropy
is close to zero.  Then as you add things back, there's a much better
sense of where the unpredictability might be coming from, and whether
the unpredictability is coming from something which is fundamentally
arising from something which is chaotic or quantum effect, or just
because we don't have a good way of modelling the behavior of the
L1/L2 cache (for example) and that is spoofing your entropy estimator.

Regards,

						- Ted
