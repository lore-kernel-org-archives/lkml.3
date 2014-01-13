Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751280AbaAMFyB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 00:54:01 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:53540 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131AbaAMFx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 00:53:57 -0500
X-Originating-IP: 50.43.14.201
Date: Sun, 12 Jan 2014 21:53:45 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Patrick Palka <patrick@parcs.ath.cx>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Michal Marek <mmarek@suse.cz>, Sam Ravnborg <sam@ravnborg.org>,
        Rashika Kheria <rashika.kheria@gmail.com>
Subject: Re: #pragma once?
Message-ID: <20140113055344.GA12319@leaf>
References: <20140106204706.GA16924@leaf>
 <CA+C-WL_Z6TuWTO00gzgJo3+D-kHfjFBrfACqpaDCNxP23-LN_g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+C-WL_Z6TuWTO00gzgJo3+D-kHfjFBrfACqpaDCNxP23-LN_g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 12, 2014 at 11:14:56AM -0500, Patrick Palka wrote:
> On Mon, Jan 6, 2014 at 3:47 PM, Josh Triplett <josh@joshtriplett.org> wrote:
> > Does anyone have any objection to the use of "#pragma once" instead of
> > the usual #ifndef-#define-...-#endif include guard?  GCC, LLVM/clang,
> > and the latest Sparse all support either method just fine.  (I added
> > support to Sparse myself.)  Both have equivalent performance.  "#pragma
> > once" is simpler, and avoids the possibility of a typo in the defined
> > guard symbol.
> 
> Unfortunately in GCC #pragma once is slower and slightly buggier than
> regular include guards:
> 
> http://gcc.gnu.org/bugzilla/show_bug.cgi?id=52566
> http://gcc.gnu.org/bugzilla/show_bug.cgi?id=58770

The bug in question doesn't seem to apply to any likely use in the Linux
kernel.

As for performance, that benchmark seems somewhat odd to me, and I'm not
entirely convinced that it's representative of real-world projects,
which don't typically include ten thousand include files in one
compilation.  I've benchmarked the case of a single main.c including a
single guarded.h with both types of guards, and found the two guard
types indistinguishable in performance.  Beyond that, I'd say real-world
benchmarks would be preferable to artificial ones before declaring a
performance difference between the two types of guards.

- Josh Trpilett
