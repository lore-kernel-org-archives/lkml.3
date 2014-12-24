Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751755AbaLXW1E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 17:27:04 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:40567 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542AbaLXW1C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 17:27:02 -0500
Date: Wed, 24 Dec 2014 23:27:00 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Mark Seaborn <mseaborn@chromium.org>,
        kernel list <linux-kernel@vger.kernel.org>
Cc: luto@amacapital.net
Subject: Re: DRAM unreliable under specific access patern
Message-ID: <20141224222700.GA19513@amd>
References: <CAL82V5NN8U4PyiSjLxgpTrgsgkbM7rRCbVF5P-HHyEqphLOy+g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAL82V5NN8U4PyiSjLxgpTrgsgkbM7rRCbVF5P-HHyEqphLOy+g@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2014-12-24 11:47:50, Mark Seaborn wrote:
> Hi Pavel,
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
> there will be a 1/16 chance that the two addresses are in the same bank.
> 
> [Replying off-list just because I'm not subscribed to lkml and only saw
> this thread via the web, but feel free to reply on the list. :-) ]

Ok, so I thought my machine is too old to be affected. Apparently, it
is not :-(. (With rowhammer-test).

Iteration 140 (after 328.76s)
  48.805 nanosec per iteration: 2.1084 sec for 43200000 iterations
  check
  error at 0x890f1118: got 0xfeffffffffffffff
    (check took 0.244179s)
    ** exited with status 256 (0x100)

processor     : 1
vendor_id     : GenuineIntel
cpu family    : 6
model	      	: 23
model name	: Intel(R) Core(TM)2 Duo CPU     E7400  @ 2.80GHz
stepping	: 10
microcode	: 0xa07
cpu MHz		  : 1596.000
cache size	  : 3072 KB

								Pavel

> Cheers,
> Mark
> 
> Pavel Machek <pavel <at> ucw.cz> wrote:
> > On Wed 2014-12-24 09:13:32, Andy Lutomirski wrote:
> > > On Wed, Dec 24, 2014 at 8:38 AM, Pavel Machek <pavel <at> ucw.cz> wrote:
> > > > Hi!
> > > >
> > > > It seems that it is easy to induce DRAM bit errors by doing repeated
> > > > reads from adjacent memory cells on common hw. Details are at
> > > >
> > > > https://www.ece.cmu.edu/~safari/pubs/kim-isca14.pdf
> > > >
> > > > . Older memory modules seem to work better, and ECC should detect
> > > > this. Paper has inner loop that should trigger this.
> > > >
> > > > Workarounds seem to be at hardware level, and tricky, too.
> > >
> > > One mostly-effective solution would be to stop buying computers
> > > without ECC.  Unfortunately, no one seems to sell non-server chips
> > > that can do ECC.
> >
> > Or keep using old computers ￼.
> >
> > > > Does anyone have implementation of detector? Any ideas how to work
> > > > around it in software?
> > > >
> > >
> > > Platform-dependent page coloring with very strict, and impossible to
> > > implement fully correctly, page allocation constraints?
> >
> > This seems to be at cacheline level, not at page level, if I
> > understand it correctly.
> >
> > So the problem would is: I have something mapped read-only, and I can
> > still cause bitflips in it.
> >
> > Hmm. So it is pretty obviously a security problem, no need for
> > java. Just do some bit flips in binary root is going to run, and it
> > will crash for him. You can map binaries read-only, so you have enough
> > access.
> >
> > As far as I understand it, attached program could reproduce it on
> > affected machines?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
