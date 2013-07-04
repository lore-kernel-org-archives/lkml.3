Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933623Ab3GDHtU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 03:49:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55310 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932202Ab3GDHtR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 03:49:17 -0400
Date: Thu, 4 Jul 2013 03:49:02 -0400
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Anvin <hpa@zytor.com>
Subject: Re: scheduling while atomic & hang.
Message-ID: <20130704074902.GA32211@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Ingo Molnar <mingo@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>, Peter Anvin <hpa@zytor.com>
References: <20130704015525.GA8486@redhat.com>
 <CA+55aFykwkTVtZuoCEvwpF+5q1LUscw1shkWNPtGdHu+1DgDJA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFykwkTVtZuoCEvwpF+5q1LUscw1shkWNPtGdHu+1DgDJA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 03, 2013 at 07:49:18PM -0700, Linus Torvalds wrote:
 > On Wed, Jul 3, 2013 at 6:55 PM, Dave Jones <davej@redhat.com> wrote:
 > > This is a pretty context free trace. What the hell happened here?
 > 
 > That lack of call trace looks like it happened at the final stage of
 > an interrupt or page fault or other trap that is about to return to
 > user space.
 > 
 > My guess would be that the trap/irq/whatever handler for some odd
 > reason ended up with an unbalanced spinlock or something. But since
 > there is no trace of it, I can't even begin to guess what it would be.
 > 
 > Does trinity save enough pseudo-random state that it can be
 > repeatable, because if it's something repeatable it might be
 > interesting to see what the last few system calls and traps were...
 
It should, but I'll have to see if anything useful hit the disk before
it wedged.

 > >From the " 3.10.0+" I assume this is from the merge window, and
 > possibly a new failure. Do you have an actual git ID? I can heartily
 > recommend CONFIG_LOCALVERSION_AUTO=y as a way to get commit ID's
 > encoded in the version string (which is obviously more useful if you
 > end up running mainly kernels without extra commits of your own on top
 > of them - if you have your own local commits you'd still need to
 > translate it into "your kernel XYZ with commits of mine on top")

top of tree was 0b0585c3e192967cb2ef0ac0816eb8a8c8d99840 I think.
(That's what it is on my local box that I pull all my test trees from,
and I don't think it changed after I started that run, but I'll
double check on Friday)

I don't use the auto config, because I end up filling up /boot
unless I go through and clean them out by hand every time I install
a new one (which I do probably a dozen or so times a day).
Is there some easy way to prune old builds I'm missing ?

	Dave

