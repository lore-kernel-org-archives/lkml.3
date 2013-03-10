Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752364Ab3CJLjI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 07:39:08 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:17570 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768Ab3CJLjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 07:39:06 -0400
Date: Sun, 10 Mar 2013 14:38:42 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Christopher Li <sparse@chrisli.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linux-Sparse <linux-sparse@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Suggestion for fixing the variable length array used in the
 kernel.
Message-ID: <20130310113842.GA9138@mwanda>
References: <CANeU7Qn-5b5U_64QzFt-beP-PyAJgzz=z1100F0v5WbWqZwZOQ@mail.gmail.com>
 <20130308162922.88ad40997d01099949008452@linux-foundation.org>
 <20130309053859.GY9138@mwanda>
 <CANeU7QnhB566ZJqjcaLkn7o701EeVbJcB=8VHW_33nwK=FZRhg@mail.gmail.com>
 <20130309223403.GZ9138@mwanda>
 <CANeU7Qk2axG8wUFt9JgHt3UpJZTiF50Ug9Udt3BAv99cBR9HPw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANeU7Qk2axG8wUFt9JgHt3UpJZTiF50Ug9Udt3BAv99cBR9HPw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 09, 2013 at 03:00:54PM -0800, Christopher Li wrote:
> On Sat, Mar 9, 2013 at 2:34 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> > The problems is if we go over the 8k stack.  So big arrays are bad.
> > Also if the dynamically sized array is inside a loop then normally
> > GCC frees it after each iteration, but on some arches it didn't free
> > it until after the last iteration.
> 
> So it seems that you agree those variable array usage should be
> better change to use kmalloc or some thing.
> 
> > Btw, I've Smatch has cross function analysis, and I'd like to use
> > it here to figure out if the max size for dynamically sized arrays.
> > I ran into a problem:
> >
> > The code looks like this:
> >         char buf[a];
> > The size expression should be an EXPR_SYMBOL, but smatch gets:
> >         char buf[*a];
> 
> Sparse currently does not deal with the dynamic array size right now.
> It only want to get constant value from the array size.
> 
> The part that evaluate the array size is actually correct. Remember
> the EXPR_SYMBOL
> actually contain the *address* of symbol "a". So the proper
> sizeof(buf) is actually
> the content of "*a". That part is fine.

It's evaluating it correctly, but Smatch normally expects
expressions which haven't been evaluated yet.

I can probably hack my own Sparse tree for what I need.  It's not a
big deal.

regards,
dan carpenter
