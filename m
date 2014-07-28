Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751728AbaG1SJK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 14:09:10 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:58442 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681AbaG1SJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 14:09:05 -0400
Date: Mon, 28 Jul 2014 20:09:02 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Alexei Starovoitov <ast@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Michel =?iso-8859-1?Q?D=E4nzer?= <michel@daenzer.net>,
        Jakub Jelinek <jakub@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Debian GCC Maintainers <debian-gcc@lists.debian.org>,
        Debian Kernel Team <debian-kernel@lists.debian.org>
Subject: Re: Random panic in load_balance() with 3.16-rc
Message-ID: <20140728180902.GA22904@x4>
References: <CA+55aFzOoJzqJ=4RVPEBfscA8oRdr5Nv7fKx9aXYw2+frkuhwA@mail.gmail.com>
 <CA+55aFyHU4Gwk6ASTuOgh3eFPshkgy1s5zc4p7f01DwrYddFOw@mail.gmail.com>
 <CA+55aFxaXPqyDJv-SNu6Giy3eKCu_SY1wof1NaNnPTbtF9RbXQ@mail.gmail.com>
 <20140726193557.GA21842@x4>
 <CA+55aFyo=HVZGEYNmz9GHqLatFHiJYTviKz_dXjqCv8b_gGxBA@mail.gmail.com>
 <20140726201914.GB21842@x4>
 <CA+55aFyCh8B4kuc66_+wr8eM+kP7-hJ9utdtpLih661Xf8YGgQ@mail.gmail.com>
 <y0m7g2xk6ss.fsf@fche.csb>
 <CA+55aFwz+stjg5L7aKuPjLym3u4FPS_ugSZiCcJwOYCGMSFGVQ@mail.gmail.com>
 <20140728172737.GA17598@pg-vmw-gw1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140728172737.GA17598@pg-vmw-gw1>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014.07.28 at 10:27 -0700, Alexei Starovoitov wrote:
> On Mon, Jul 28, 2014 at 09:45:45AM -0700, Linus Torvalds wrote:
> > On Mon, Jul 28, 2014 at 5:26 AM, Frank Ch. Eigler <fche@redhat.com> wrote:
> > >
> > > Please note that the data produced by "-g -fvar-tracking" is consumed
> > > by tools like systemtap, perf, crash, and makes a significant
> > > difference to the observability of debug AND non-debug kernels.
> > 
> > Yeah, and compared to having a buggy kernel, I care exactly this much: "".
> 
> It's not pretty, but adding it unconditionally was the right thing to do.
> Black listing compiler versions is too fragile.
> Look at the flip side: now size of build dir will be much smaller :)

It shouldn't be too hard to implement a simple check for the bug in the
next release. Just compile the gcc/testsuite/gcc.target/i386/pr61801.c
testcase with -fcompare-debug. If gcc returns 0 then
-fvar-tracking-assignments could safely be enabled again.

Here's the testcase:

int a, b, c;
void fn1 ()
{
  int d;
  if (fn2 () && !0)
    {
      b = (
           {
           int e;
           fn3 ();
           switch (0)
           default:
           asm volatile("" : "=a"(e) : "0"(a), "i"(0));
           e;
           });
      d = b;
    }
  c = d;
}

-- 
Markus
