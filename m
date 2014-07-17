Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751479AbaGQRkH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 13:40:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56609 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751100AbaGQRkF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 13:40:05 -0400
Message-ID: <53C80A6D.5010201@zytor.com>
Date: Thu, 17 Jul 2014 10:39:57 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>
CC: linux-crypto@vger.kernel.org
Subject: Re: [PATCH] random: limit the contribution of the hw rng to at most
 half
References: <1405591436-15445-1-git-send-email-tytso@mit.edu>
In-Reply-To: <1405591436-15445-1-git-send-email-tytso@mit.edu>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/2014 03:03 AM, Theodore Ts'o wrote:
> For people who don't trust a hardware RNG which can not be audited,
> the changes to add support for RDSEED can be troubling since 97% or
> more of the entropy will be contributed from the in-CPU hardware RNG.
> 
> We now have a in-kernel khwrngd, so for those people who do want to
> implicitly trust the CPU-based system, we could create an arch-rng
> hw_random driver, and allow khwrng refill the entropy pool.  This
> allows system administrator whether or not they trust the CPU (I
> assume the NSA will trust RDRAND/RDSEED implicitly :-), and if so,
> what level of entropy derating they want to use.
> 
> The reason why this is a really good idea is that if different people
> use different levels of entropy derating, it will make it much more
> difficult to design a backdoor'ed hwrng that can be generally
> exploited in terms of the output of /dev/random when different attack
> targets are using differing levels of entropy derating.
> 
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>

I saw exactly one complaint to that nature, but that was from someone
who really wanted the "nordrand" option (at which point I observed that
it had inadvertently left RDSEED enabled which quickly got rectified.)
The implication was that this was a request from a specific customer who
presumably have their own "audited" hardware RNG.

There may have been other complaints (justified or not) but if so I
haven't seen them.  I'm wondering if we are overgeneralizing here and if
so if it wouldn't be better to defer this until the hwrng supplier for
this is ready, which probably won't happen in time for 3.17 just given
the current timeline.

	-hpa

