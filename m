Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752244AbaELDhJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 23:37:09 -0400
Received: from mail.eperm.de ([89.247.134.16]:46355 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752076AbaELDhH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 23:37:07 -0400
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, LKML <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org
Subject: Re: arch_random_refill
Date: Mon, 12 May 2014 05:36:48 +0200
Message-ID: <3260147.sUis3H5ONm@myon.chronox.de>
User-Agent: KMail/4.12.5 (Linux/3.14.3-200.fc20.x86_64; KDE/4.12.5; x86_64; ; )
In-Reply-To: <53703E74.9020700@linux.intel.com>
References: <21542339.0lFnPSyGRS@myon.chronox.de> <53703E74.9020700@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, 11. Mai 2014, 20:22:28 schrieb H. Peter Anvin:

Hi Peter,
> 
> > Note, I do not see an issue with the patch that adds RDSEED as part of
> > add_interrupt_randomness outlined in [2]. The reason is that this patch
> > does not monopolizes the noise sources.
> > 
> > I do not want to imply that Intel (or any other chip manufacturer that
> > will
> > hook into arch_random_refill) intentionally provides bad entropy (and this
> > email shall not start a discussion about entropy again), but I would like
> > to be able to only use noise sources that I can fully audit. As it is
> > with hardware, I am not able to see what it is doing.
> 
> I have to point out the irony in this given your previous proposals,
> however...

I guess that is the funny nature of entropy :-)

But in our current predicament, not everybody trusts a few potentially easily 
manipulated gates that have no other purpose than produce white noise which 
are developed by the biggest chip vendor in the US. Gates which have other 
purposes may not be that easily manipulated.
> 
> > Thus, may I ask that arch_random_refill is revised such that it will not
> > monopolize the noise sources? If somebody wants that, he can easily use
> > rngd.
> Feel free to build the kernel without CONFIG_ARCH_RANDOM, or use the
> "nordrand" option to the kernel.  These options are there for a reason.
> 
> Now when you mention it, though, the nordrand option should turn off
> RDSEED as well as RDRAND.  It currently doesn't; that is a bug, plain
> and simple.

Ohh, ok, thanks for fixing that. :-) 

Though what makes me wonder is the following: why are some RNGs forced to use 
the hw_random framework whereas some others are not? What is the driver for 
that?

The current state of random.c vs. drivers/char/hw_random and the strong in-
kernel separation between both makes me wonder. Isn't that all kind of 
inconsistent?

Ciao
Stephan
-- 
| Cui bono? |
