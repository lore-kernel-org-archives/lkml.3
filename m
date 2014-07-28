Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751311AbaG1R1q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 13:27:46 -0400
Received: from mail.kernel.org ([198.145.19.201]:37223 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751162AbaG1R1o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 13:27:44 -0400
Date: Mon, 28 Jul 2014 10:27:39 -0700
From: Alexei Starovoitov <ast@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Frank Ch. Eigler" <fche@redhat.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Michel =?iso-8859-1?Q?D=E4nzer?= <michel@daenzer.net>,
        Jakub Jelinek <jakub@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Debian GCC Maintainers <debian-gcc@lists.debian.org>,
        Debian Kernel Team <debian-kernel@lists.debian.org>
Subject: Re: Random panic in load_balance() with 3.16-rc
Message-ID: <20140728172737.GA17598@pg-vmw-gw1>
References: <20140725140237.GB32669@home.goodmis.org>
 <CA+55aFzOoJzqJ=4RVPEBfscA8oRdr5Nv7fKx9aXYw2+frkuhwA@mail.gmail.com>
 <CA+55aFyHU4Gwk6ASTuOgh3eFPshkgy1s5zc4p7f01DwrYddFOw@mail.gmail.com>
 <CA+55aFxaXPqyDJv-SNu6Giy3eKCu_SY1wof1NaNnPTbtF9RbXQ@mail.gmail.com>
 <20140726193557.GA21842@x4>
 <CA+55aFyo=HVZGEYNmz9GHqLatFHiJYTviKz_dXjqCv8b_gGxBA@mail.gmail.com>
 <20140726201914.GB21842@x4>
 <CA+55aFyCh8B4kuc66_+wr8eM+kP7-hJ9utdtpLih661Xf8YGgQ@mail.gmail.com>
 <y0m7g2xk6ss.fsf@fche.csb>
 <CA+55aFwz+stjg5L7aKuPjLym3u4FPS_ugSZiCcJwOYCGMSFGVQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwz+stjg5L7aKuPjLym3u4FPS_ugSZiCcJwOYCGMSFGVQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2014 at 09:45:45AM -0700, Linus Torvalds wrote:
> On Mon, Jul 28, 2014 at 5:26 AM, Frank Ch. Eigler <fche@redhat.com> wrote:
> >
> > Please note that the data produced by "-g -fvar-tracking" is consumed
> > by tools like systemtap, perf, crash, and makes a significant
> > difference to the observability of debug AND non-debug kernels.
> 
> Yeah, and compared to having a buggy kernel, I care exactly this much: "".
> 
> Besides, "significant difference" is very debatable indeed. It may be
> noticeable, it's likely not actually significant.

as far as I can see in gcc code, -fno-var-tracking-assignments is the main
switch for 'vartrack' pass. So -fno-var-tracking-assignments is pretty
much equivalent to -fno-var-tracking
Both kill majority of debug info for local variables and function arguments.
The end effect for perf/systemtap will be quite noticeable.

It's not pretty, but adding it unconditionally was the right thing to do.
Black listing compiler versions is too fragile.
Look at the flip side: now size of build dir will be much smaller :)

For gcc it's obviously a big blow. Now 10k lines pass developed
over 10+ years will not be used :(

