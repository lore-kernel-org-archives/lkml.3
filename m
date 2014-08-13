Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752914AbaHMWov (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 18:44:51 -0400
Received: from imap.thunk.org ([74.207.234.97]:59211 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751719AbaHMWos (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 18:44:48 -0400
Date: Wed, 13 Aug 2014 18:44:40 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, hpa@linux.intel.com,
        Amos Kong <akong@redhat.com>, ricardo.neri-calderon@linux.intel.com,
        Amit Shah <amit.shah@redhat.com>
Subject: Re: [PATCH] virtio: rng: add derating factor for use by hwrng core
Message-ID: <20140813224440.GA10808@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Rusty Russell <rusty@rustcorp.com.au>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel@vger.kernel.org, hpa@linux.intel.com,
	Amos Kong <akong@redhat.com>, ricardo.neri-calderon@linux.intel.com,
	Amit Shah <amit.shah@redhat.com>
References: <87zjf88awc.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87zjf88awc.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 14, 2014 at 04:39:07AM +0930, Rusty Russell wrote:
> The khwrngd thread is started when a hwrng device of sufficient
> quality is registered.  The virtio-rng device is backed by the
> hypervisor, and we trust the hypervisor to provide real entropy.
> 
> A malicious hypervisor is a scenario that's irrelevant -- such a setup
> is bound to cause all sorts of badness, and a compromised hwrng is not
> the biggest threat.

s/malicious/malicious or badly implemented/

s/is not the biggest threat/is the least of the user's worries/

> Given this, we are certain the quality of randomness we receive is
> perfectly trustworthy.  Hence, we use 100% for the factor, indicating
> maximum confidence in the source.

s/we are certain/we might as well assume that/

I won't insist on the wording changes, but I think it's a better way
of phrasing things.

Cheers,

						- Ted

