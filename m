Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933221Ab3GMLLe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jul 2013 07:11:34 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:7143 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756460Ab3GMLLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jul 2013 07:11:32 -0400
X-Authority-Analysis: v=2.0 cv=Du3UCRD+ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=E3gBSPWCDXAA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=zNXoGfytzK0A:10 a=DRT-t2TphQP9IuVFN6cA:9 a=QEXdDO2ut3YA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1373713889.17876.135.camel@gandalf.local.home>
Subject: Re: [ 00/19] 3.10.1-stable review
From: Steven Rostedt <rostedt@goodmis.org>
To: Jochen Striepe <jochen@tolot.escape.de>
Cc: Dave Jones <davej@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Guenter Roeck <linux@roeck-us.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>
Date: Sat, 13 Jul 2013 07:11:29 -0400
In-Reply-To: <20130713004707.GF7609@pompeji.miese-zwerge.org>
References: <20130711224455.GA17222@kroah.com>
	 <20130712141530.GA3629@roeck-us.net>
	 <CA+55aFw7Ti3=51vVzNO5QEmPYP-znM95OqvZV9TX=mRcwaOCrA@mail.gmail.com>
	 <20130712173150.GA5534@roeck-us.net>
	 <CA+55aFwvCVw6xqGLEhUPMYPZ6XcxSTr4sunG3+kB0WPLY0Djgg@mail.gmail.com>
	 <20130712181103.GA6689@roeck-us.net> <20130712193557.GB342@thunk.org>
	 <1373658551.17876.117.camel@gandalf.local.home>
	 <20130712201939.GB15261@redhat.com>
	 <1373660900.17876.124.camel@gandalf.local.home>
	 <20130713004707.GF7609@pompeji.miese-zwerge.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-07-13 at 02:47 +0200, Jochen Striepe wrote:
> 	Hello,
> 
> On Fri, Jul 12, 2013 at 04:28:20PM -0400, Steven Rostedt wrote:
> > I would suspect that machines that allow unprivileged users would be
> > running distro kernels, and not the latest release from Linus, and thus
> > even a bug that "can allow an unprivileged user to crash the kernel" may
> > still be able to sit around for a month before being submitted.
> > 
> > This wouldn't be the case if the bug was in older kernels that are being
> > used.
> 
> On the one hand, you seem to want users with any kind of production
> systems to use distro kernels. On the other hand, developers want
> a broad testing base, with vanilla kernels (or better, rc) as early
> as possible. You cannot get both at the same time, some kinds of bugs
> just appear on production systems.
> 
> Users expect vanilla .0 releases usable as production systems, to
> be updated (meaning, no new features, just stabilizing) with the
> corresponding -stable series.

This really is a case by case basis. An unprivileged user exploit
requires a box that lets other users than the owner of the box to log
in. Most users of .0 releases do not do this.

But this isn't the point anyway. The point I was making is not to let
the fix be worse than the bug it fixes. What happens if the fix to an
unprivileged user exploit inadvertently opens an off by one bug that can
be exploited by external users?

It comes down to each bug itself. If the fix is trivial and fixes a
critical bug, it should be pushed rather quickly to mainline. But if the
fix requires a redesign of some code, it would require more time.
Luckily, most security bugs are quick fixes, and don't need a redesign
of the code.

-- Steve


