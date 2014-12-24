Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751850AbaLXXlr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 18:41:47 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:48329 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512AbaLXXlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 18:41:46 -0500
Date: Thu, 25 Dec 2014 00:41:44 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Mark Seaborn <mseaborn@chromium.org>,
        kernel list <linux-kernel@vger.kernel.org>
Cc: luto@amacapital.net
Subject: Re: DRAM unreliable under specific access patern
Message-ID: <20141224234144.GA19262@amd>
References: <CAL82V5NN8U4PyiSjLxgpTrgsgkbM7rRCbVF5P-HHyEqphLOy+g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL82V5NN8U4PyiSjLxgpTrgsgkbM7rRCbVF5P-HHyEqphLOy+g@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!
> 
> Try this test program: https://github.com/mseaborn/rowhammer-test
> 
> It has reproduced bit flips on various machines.
> 
> Your program won't be an effective test because you're just hammering
> addresses x and x+64, which will typically be in the same row of DRAM.
> 
> For the test to be effective, you have to pick addresses that are in
> different rows but in the same bank.  A good way of doing that is just to
> pick random pairs of addresses (as the test program above does).  If the
> machine has 16 banks of DRAM (as many of the machines I've tested on do),
> there will be a 1/16 chance that the two addresses are in the same
> bank.

Ok. Row size is something like 8MB, right?

So we have a program that corrupts basically random memory on many
machines. That is not good. That means that unpriviledged user can
crash processes of other users. 

I relies on hammering DRAM rows so fast that refresh is unable to keep
data consistent in adjacent rows. It relies on clflush: without that,
it would likely not be possible to force fast enough row switches.

Unfortunately, clflush is not a priviledged instruction. Bad Intel.

Flushing cache seems to be priviledged on ARM (mcr p15). That means it
is probably impossible to exploit on ARM based machines.

We could make DRAM refresh faster. That will incur performance
penalty (<10%?), and is probably chipset-specific...?

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
