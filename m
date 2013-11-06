Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932555Ab3KFNZF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 08:25:05 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:43992 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932158Ab3KFNZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 08:25:03 -0500
Date: Wed, 6 Nov 2013 14:24:59 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Theodore Ts'o" <tytso@mit.edu>, Stephan Mueller <smueller@chronox.de>,
        sandy harris <sandyinchina@gmail.com>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, Nicholas Mc Guire <der.herr@hofr.at>
Subject: Re: [PATCH] CPU Jitter RNG: inclusion into kernel crypto API and
 /dev/random
Message-ID: <20131106132457.GA13852@amd.pavel.ucw.cz>
References: <2579337.FPgJGgHYdz@tauon>
 <4306229.ErfOL470s2@tauon>
 <20131106124354.GJ14235@thunk.org>
 <9172761.DO0L6FkY0c@tauon>
 <20131106130432.GK14235@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131106130432.GK14235@thunk.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Of course, some of the state in the CPU may not be unknown to the
> attacker, if it is derived by external events that are not visible to
> the attacker, such as a network interrupt.  But if that's the case,
> why not measure network interrupts directly?  We're much less likely
> to overestimate the amount of entropy we can extract the system in
> that case.

Actually, I believe Stephan is up to something here.

We _can't_ measure network interrupts directly, because we do not have
TSC. (And TSC-less machines are the ones that are problematic, right?)

Extracting entropy from the CPU will allow us to pick up entropy from
network packets (and timer interrupt jitter) even on machines that
lack TSC. And that counts like very cool feature.

(And yes, we could just increment variable to get tsc emulation in
idle loop, and then extract entropy from that. But we would not be
able to enter low power states at that point, and it would not work
when cpu is busy computing.)

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
