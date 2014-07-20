Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753028AbaGTRDK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 13:03:10 -0400
Received: from ns.horizon.com ([71.41.210.147]:34953 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751509AbaGTRDI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 13:03:08 -0400
Date: 20 Jul 2014 13:03:06 -0400
Message-ID: <20140720170306.15274.qmail@ns.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: hannes@stressinduktion.org
Subject: Re: [PATCH, RFC] random: introduce getrandom(2) system call
Cc: linux@horizon.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, tytso@mit.edu
In-Reply-To: <20140720162622.29664.qmail@ns.horizon.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> In the end people would just recall getentropy in a loop and fetch 256
> bytes each time. I don't think the artificial limit does make any sense.
> I agree that this allows a potential misuse of the interface, but
> doesn't a warning in dmesg suffice?

It makes their code not work, so they can are forced to think about
fixing it before adding the obvious workaround.

> It also makes it easier to port applications from open("/dev/*random"),
> read(...) to getentropy() by reusing the same limits.

But such an application *is broken*.  Making it easier to port is
an anti-goal.  The goal is to make it enough of a hassle that
people will *fix* their code.

There's a *reason* that the /dev/random man page explicitly tells
people not to trust software that reads more than 32 bytes at a time
from /dev/random:

> While some safety margin above that minimum is reasonable, as a guard
> against flaws in the CPRNG algorithm, no cryptographic primitive avail-
> able today can hope to promise more than 256 bits of security, so if
> any program reads more than 256 bits (32 bytes) from the kernel random
> pool per invocation, or per reasonable reseed interval (not less than
> one minute), that should be taken as a sign that its cryptography is
> *not* skillfully implemented.

("not skilfuly implemented" was the phrase chosen after some discussion to
convey "either a quick hack or something you dhouldn't trust.")

To expand on what I said in my mail to Ted, 256 is too high.
I'd go with OpenBSD's 128 bytes or even drop it to 64.
