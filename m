Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933092AbaGWSZy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 14:25:54 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:54538 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932740AbaGWSZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 14:25:53 -0400
Date: Wed, 23 Jul 2014 20:25:48 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Michel =?iso-8859-1?Q?D=E4nzer?= <michel@daenzer.net>,
        Ingo Molnar <mingo@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Random panic in load_balance() with 3.16-rc
Message-ID: <20140723182548.GE3935@laptop>
References: <53CF80EE.5050702@daenzer.net>
 <53CF844A.5050106@arm.com>
 <20140723111110.GT3935@laptop>
 <20140723113021.GP12054@laptop.lan>
 <20140723142454.GQ12054@laptop.lan>
 <CA+55aFwZ7kAqqhaE4g89CJLkpJOwGxcN4u+cc0ODfqjQ0rVMiA@mail.gmail.com>
 <20140723155526.GW3935@laptop>
 <CA+55aFzSU5u8MiGqRZ6BVojQPnxbd1hxmFY_BA=UuCAygxR8WQ@mail.gmail.com>
 <20140723170446.GA3935@laptop>
 <CA+55aFxH=zWYmyfudWD4HWQFrGD9N6+ELbm130_tqEfzjMavAg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxH=zWYmyfudWD4HWQFrGD9N6+ELbm130_tqEfzjMavAg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 10:15:23AM -0700, Linus Torvalds wrote:
> On Wed, Jul 23, 2014 at 10:04 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Wed, Jul 23, 2014 at 09:54:23AM -0700, Linus Torvalds wrote:
> >
> >> So the length is fine, and the disassembly shows that it is fixed (16
> >> 32-bit words - why the heck does it use "movsl" rather than "movsq",
> >> whatever).
> >
> > Which is exactly right btw, he's got CONFIG_NR_CPUS=512 and 8*4*16=512.
> 
> That's not my point. Why the f*ck does it use "movsl", when "movsq"
> should work as well or better.

Agreed, big question there. I was merely pointing out that the value is
consistent with his .config.
