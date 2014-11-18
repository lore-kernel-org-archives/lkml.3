Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259AbaKRCjl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 21:39:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40829 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752483AbaKRCjj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 21:39:39 -0500
Date: Mon, 17 Nov 2014 21:39:30 -0500
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141118023930.GA2871@redhat.com>
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
 <20141118020959.GA2091@redhat.com>
 <CA+55aFy65SmGXFeosNqvrgx+P6JQLrzpEYuwXdyeWtZwZsKxZg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFy65SmGXFeosNqvrgx+P6JQLrzpEYuwXdyeWtZwZsKxZg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17, 2014 at 06:21:08PM -0800, Linus Torvalds wrote:
 > On Mon, Nov 17, 2014 at 6:09 PM, Dave Jones <davej@redhat.com> wrote:
 > >
 > > After wasting countless hours rolling back to Fedora 20 and gcc 4.8.1,
 > > I saw the exact same trace on 3.17, so now I don't know what to think.
 > 
 > Uhhuh.
 > 
 > Has anything else changed? New trinity tests? If it has happened in as
 > little as ten minutes, and you don't recall having seen this until
 > about a week ago, it does sound like something changed.

Looking at the trinity commits over the last month or so, there's a few
new things, but nothing that sounds like it would trip up a bug like
this. "generate random ascii strings" and "mess with fcntl's after
opening fd's on startup" being the stand-outs. Everything else is pretty
much cleanups and code-motion. There was a lot of work on the code
that tracks mmaps about a month ago, but that shouldn't have had any
visible runtime differences.

<runs git diff>

hm, something I changed not that long ago, which I didn't commit yet,
was that it now runs more child processes than it used to (was 64, now 256)
I've been running like that for a while though. I want to say that was
before .17, but I'm not 100% sure.

So it could be that I'm just generating a lot more load now.
I could drop that back down and see if it 'goes away' or at least
happens less, but it strikes me that there's something here that needs
fixing regardless.

	Dave

