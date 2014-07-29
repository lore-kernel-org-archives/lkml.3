Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752906AbaG2I7h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 04:59:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40959 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752808AbaG2I7e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 04:59:34 -0400
Date: Tue, 29 Jul 2014 10:58:59 +0200
From: Jakub Jelinek <jakub@redhat.com>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Alexei Starovoitov <ast@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Michel =?iso-8859-1?Q?D=E4nzer?= <michel@daenzer.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Debian GCC Maintainers <debian-gcc@lists.debian.org>,
        Debian Kernel Team <debian-kernel@lists.debian.org>
Subject: Re: Random panic in load_balance() with 3.16-rc
Message-ID: <20140729085859.GS2397@laptop.redhat.com>
Reply-To: Jakub Jelinek <jakub@redhat.com>
References: <CA+55aFyHU4Gwk6ASTuOgh3eFPshkgy1s5zc4p7f01DwrYddFOw@mail.gmail.com>
 <CA+55aFxaXPqyDJv-SNu6Giy3eKCu_SY1wof1NaNnPTbtF9RbXQ@mail.gmail.com>
 <20140726193557.GA21842@x4>
 <CA+55aFyo=HVZGEYNmz9GHqLatFHiJYTviKz_dXjqCv8b_gGxBA@mail.gmail.com>
 <20140726201914.GB21842@x4>
 <CA+55aFyCh8B4kuc66_+wr8eM+kP7-hJ9utdtpLih661Xf8YGgQ@mail.gmail.com>
 <y0m7g2xk6ss.fsf@fche.csb>
 <CA+55aFwz+stjg5L7aKuPjLym3u4FPS_ugSZiCcJwOYCGMSFGVQ@mail.gmail.com>
 <20140728172737.GA17598@pg-vmw-gw1>
 <20140728180902.GA22904@x4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140728180902.GA22904@x4>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2014 at 08:09:02PM +0200, Markus Trippelsdorf wrote:
> Here's the testcase:
> 
> int a, b, c;
> void fn1 ()
> {
>   int d;
>   if (fn2 () && !0)
>     {
>       b = (
>            {
>            int e;
>            fn3 ();
>            switch (0)
>            default:
>            asm volatile("" : "=a"(e) : "0"(a), "i"(0));
>            e;
>            });
>       d = b;
>     }
>   c = d;
> }

int a, c;
int bar (void);
void baz (void);

void
foo (void)
{
  int d;
  if (bar ())
    {
      int e;
      baz ();
      asm volatile ("" : "=a" (e) : "0" (a), "i" (0));
      d = e;
    }
  c = d;
}

fails the same way and has more creduce cruft removed.
Fails also with 4.7 at -O2 -fcompare-debug.

	Jakub
