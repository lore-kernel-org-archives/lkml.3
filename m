Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754540Ab3JLD2n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 23:28:43 -0400
Received: from imap.thunk.org ([74.207.234.97]:45092 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751591Ab3JLD2m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 23:28:42 -0400
Date: Fri, 11 Oct 2013 23:28:35 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Sandy Harris <sandyinchina@gmail.com>
Cc: Stephan Mueller <smueller@chronox.de>, LKML <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH] CPU Jitter RNG: inclusion into kernel crypto API and
 /dev/random
Message-ID: <20131012032835.GC30680@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Sandy Harris <sandyinchina@gmail.com>,
	Stephan Mueller <smueller@chronox.de>,
	LKML <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org
References: <2579337.FPgJGgHYdz@tauon>
 <CACXcFm=qdv9ktjYDGo+L=ssh+tCs7vVniznNpXyWVTBSB1CMRg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACXcFm=qdv9ktjYDGo+L=ssh+tCs7vVniznNpXyWVTBSB1CMRg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephan,

I haven't had a chance to look at your paper in detail, yet, but a
quick scan has found a huge red flag for me that puts the rest of your
analysis in severe doubt for me.

You say that you got really good results and perfect statistical
entropy on a number of platforms, including on an MIPS embedded
system.  You also say that you are harvesting jitter by using
get_cycles() yes?

Well, on the MIPS platform, here is the definition of get_cycles:

static inline cycles_t get_cycles(void)
{
	return 0;
}

So if you are getting great entropy results when in effect you
couldn't possibly be harvesting any jitter at all, then something is
really, Really, REALLY wrong with your tests.

One might be that you are just getting great statistical results
because of the whitening step.  This is why I have very little faith
in statistical tests of randomness, given that they will return
perfect results for the following "random number generator"

	AES_ENCRYPT(i++, NSA_KEY)

Regards,

					- Ted
