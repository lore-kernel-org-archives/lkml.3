Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757731AbaGQVh6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 17:37:58 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:39480 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752397AbaGQVh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 17:37:56 -0400
MIME-Version: 1.0
In-Reply-To: <20140717212806.GV1491@thunk.org>
References: <201407171848.s6HImBb4027900@glazunov.sibelius.xs4all.nl>
 <53C83383.4040507@amacapital.net> <20140717212806.GV1491@thunk.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 17 Jul 2014 14:37:34 -0700
Message-ID: <CALCETrV3pAFk-a+RrLzwQ0ct0dWoBsVdSVrHCMRD1n564YpUmA@mail.gmail.com>
Subject: Re: [PATCH, RFC] random: introduce getrandom(2) system call
To: "Theodore Ts'o" <tytso@mit.edu>, Andy Lutomirski <luto@amacapital.net>,
        Mark Kettenis <mark.kettenis@xs4all.nl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org, beck@openbsd.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2014 at 2:28 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Thu, Jul 17, 2014 at 01:35:15PM -0700, Andy Lutomirski wrote:
>>
>> Can we please have a mode in which getrandom(2) can neither block nor
>> fail?  If that gets added, then this can replace things like AT_RANDOM.
>
> AT_RANDOM has been around for a long time; it's not something we can
> remove.

I'm not suggesting removing AT_RANDOM.  To the contrary, I'm
suggesting that libraries that need to seed some kind of
non-cryptographic, non-security-related RNG could use getrandom(2)
with appropriate flags rather than screwing around with getpid,
clock_gettime, etc.

For example:

unsigned int seed;
getrandom(&seed, sizeof(seed), GRND_BEST_EFFORT); /* Never fails on
new enough kernels */
srand(seed);

No error checking, no weird cases, and if the RNG isn't well seeded,
then I tried my best.

--Andy
