Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753090AbaKRCKQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 21:10:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46799 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752917AbaKRCKJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 21:10:09 -0500
Date: Mon, 17 Nov 2014 21:09:59 -0500
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141118020959.GA2091@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	the arch/x86 maintainers <x86@kernel.org>
References: <20141114213124.GB3344@redhat.com>
 <CA+55aFx16ks_azU0eAcx+qZ5-o8Xo0zzP6aNjrskai8rqp+eMg@mail.gmail.com>
 <20141115213405.GA31971@redhat.com>
 <20141116014006.GA5016@redhat.com>
 <CA+55aFwLH6zGf7O=o2+H0Z8=8nW4zwUbw3Q4bJGttHACv9g+FQ@mail.gmail.com>
 <20141117170359.GA1382@redhat.com>
 <CA+55aFy9dWtS5qh=-HT9M7hQPeWDMvdxEynr0p4aRkiGkV6gyQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFy9dWtS5qh=-HT9M7hQPeWDMvdxEynr0p4aRkiGkV6gyQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17, 2014 at 11:59:34AM -0800, Linus Torvalds wrote:
 > On Mon, Nov 17, 2014 at 9:03 AM, Dave Jones <davej@redhat.com> wrote:
 > >
 > > It could a completely different cause for lockup, but seeing this now
 > > has me wondering if perhaps it's something unrelated to the kernel.
 > > I have recollection of running late .17rc's for days without incident,
 > > and I'm pretty sure .17 was ok too.  But a few weeks ago I did upgrade
 > > that test box to the Fedora 21 beta.  Which means I have a new gcc.
 > > I'm not sure I really trust 4.9.1 yet, so maybe I'll see if I can
 > > get 4.8 back on there and see if that's any better.
 > 
 > I'm not sure if I should be relieved or horrified.
 > 
 > Horrified, I think.
 > 
 > It really would be a wonderful thing to have some kind of "compiler
 > bisection" with mixed object files to see exactly which file it
 > miscompiles (and by "miscompiles" it might just be a kernel bug where
 > we are missing a barrier or something, and older gcc's just happened
 > to not show it - so it could still easily be a kernel problem).

After wasting countless hours rolling back to Fedora 20 and gcc 4.8.1,
I saw the exact same trace on 3.17, so now I don't know what to think.

So it's great that it's not a regression vs .17, but otoh, who knows
how far back this goes. This looks like a nightmarish bisect case, and
I've no idea why it's now happening so often.

I'll give Don's softlockup_all_cpu_backtrace=1 idea a try on 3.18rc5
and see if that shines any more light on this.

Deeply puzzling.

	Dave

