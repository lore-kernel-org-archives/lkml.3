Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755520Ab3KXDlr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 22:41:47 -0500
Received: from mail-ob0-f179.google.com ([209.85.214.179]:48814 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113Ab3KXDln convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 22:41:43 -0500
Date: Sat, 23 Nov 2013 17:31:05 -0600
From: Rob Landley <rob@landley.net>
Subject: Re: [PATCH v2] Documentation: gpiolib: document new interface
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Alexandre Courbot <acourbot@nvidia.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>
In-Reply-To: <CACRpkdZc0DWHe6AmawYp=SY=5==SUuJUHDETUTDw-6PbhR3tUg@mail.gmail.com>
	(from linus.walleij@linaro.org on Mon Nov 18 03:34:20 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1385249465.1974.280@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2013 03:34:20 AM, Linus Walleij wrote:
> On Sat, Nov 16, 2013 at 1:34 PM, Alexandre Courbot  
> <acourbot@nvidia.com> wrote:
> 
> > The first version received zero feedback, hopefully this one will  
> get more
> > attention. :) Not much changes, just some more proofreading and the  
> fixes
> > and improvements that came from it. It looks ok as far as I am  
> concerned.
> 
> Sorry I was swamped with other stuff...

I'm 8 gazillion messages behind myself.

Also Balsa's threading mode is broken so I tend to flag users when I'm  
in a hurry (alphabetical sort works) and when they change names  
midconversation I tend not to notice they've posted more on a topic.  
(Switching email clients is on my todo list.)

> > Linus, I hope this can be merged during the -rc cycle of 3.13,  
> since the
> > gpiod_ interface is going to be introduced there. It would not make  
> much
> > sense for it to come without its documentation.
> 
> You're right of course. I'll read through it and apply fixes on top
> (or squash into your patch.)
> 
> Formal stuff:
> Don't we need an 00-INDEX file?
> (Maybe Rob can tell whether this is desirable.)

A 00-INDEX file wouldn't hurt, but it can always be added later. No  
reason to hold up the series for that. (I was using them to generate  
html indexes for kernel.org/doc but after the breakin they eliminated  
all non-git functionality so I haven't been able to update it since.  
They replaced kernel.org/doc/Documentation with a raw git checkout, and  
I expect them to replace kernel.org/doc/menuconfig with a raw git  
checkout any day now.)

That said, a 00-INDEX file would let you know where to start reading to  
find the file with the intro paragraph at the start of the old file,  
the bit explaining what GPIO is. Here the first file alphabetically is  
"board.txt", and I have no idea why it's named that, given how it  
starts. (I was sort of hoping that somebody who already knows the  
subsystem would comment before I do. I have no way of knowing if this  
documentation is _right_.)

Aforementioned first paragraph:

> +This document explains how GPIOs can be assigned to given devices  
> and functions.

> +Note that it only applies to the new descriptor-based interface. For  
> a
> +description of the deprecated integer-based GPIO interface please  
> refer to
> +gpio-legacy.txt (actually, there is no real mapping possible with  
> the old
> +interface; you just fetch an integer from somewhere and request the
> +corresponding GPIO.

Here's how I'd rewrite that:

"This document explains how to assign GPIOs to devices and functions  
using the descriptor-based GPIO interface. (For a description of the  
deprecated integer-based interface see gpio-legacy.txt.)"

Some reasons:

1) The word "given" made me think "assigned to" and "given" were  
alternate ways of saying the same thing. I know what you mean, but had  
to read it twice to follow, and I don't think "given" adds anything  
here but potential confusion.

2) Describing an interface as "new" is problematic; it will stop being  
new long before the documentation is updated to stop calling it that.  
Either say which kernel version it was introduced in or don't.

3) Does the kernel still use the old one? Is it scheduled to be  
removed? Why was it deprecated? Should software that uses it be  
rewritten to use the new one? What kind of timetable are we talking  
about? If you're not going to answer obvious questions, don't open the  
can of worms of comparing them (at least not here).

4) Warnings against the old interface belong in the document describing  
the old interface. (The sentence fragment and unbalanced parentheses  
was just gravy.)

But I really don't have time to go through every paragraph like that,  
and was hoping the gpio guys would (or just sign off on it so I don't  
have to)...

Rob