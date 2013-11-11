Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755039Ab3KKSpA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 13:45:00 -0500
Received: from awesome.dsw2k3.info ([217.188.63.246]:37264 "EHLO
	awesome.dsw2k3.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753975Ab3KKSow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 13:44:52 -0500
Date: Mon, 11 Nov 2013 19:44:47 +0100
From: Matthias Schniedermeyer <ms@citd.de>
To: Shahbaz Youssefi <shabbyx@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Partially Privileged Applications
Message-ID: <20131111184447.GA24530@citd.de>
References: <CALeOzZ_K0o_h4gJ4w-twL5=-0QjC1XWb=m948wXWwjndr4q_Kw@mail.gmail.com>
 <20131110190633.GA18073@citd.de>
 <CALeOzZ_TpR7UxevNZET=ZFu8qL=646pWDwebNT6FH5Jvhv4-GA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALeOzZ_TpR7UxevNZET=ZFu8qL=646pWDwebNT6FH5Jvhv4-GA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11.11.2013 14:05, Shahbaz Youssefi wrote:
> On Sun, Nov 10, 2013 at 8:06 PM, Matthias Schniedermeyer <ms@citd.de> wrote:
> > I don't see a way around "borders" (Papers please), otherwise you can't
> > reject things you don't want, you have to check if that something that
> > is to be done is allowed. For e.g. you would get around every
> > permission-check, because the code you called is allowed to do
> > everything.
> 
> You're right actually. Proper linking solves the issue for "good people",
> but I can't think of a not-dirty way for preventing bad calls from
> "bad people". I may get back here if I do find a solution.

After thinking a bit about this.

It depends on the samantics of when the processor switches privileges. 
IF the processor only ever switches privileges for jmp/call/ret(...) you 
could place a privileged page with nothing but NOPs before the function 
that you actually want to call with elevated privileges, but whose page 
is NOT marked as privileged.

You then call/jump to the last NOP and let the CPU "slide" over into the 
next page. This way you could be sure that the necessary check-part of 
the function can't be circumvented and still have the higher privileges. 
But then what about functions the function might have to call, they 
would need to be in a privileged page or you would need a "keep 
privileges, regardless of page attribute" jmp/call. In the case of that 
functions being in a privileged page, you would have to make sure that 
you can't call them directly as "bad people" would just do that.

You would then need this kind auf NOP-Page before each function you want 
to be able to call, which wastes a certain amount of memory and also 
forces you to align each function to the beginning of a page (which also 
wastes memory). But what is a megabyte or so of wasted memory with 
gigabytes of memory. :-)

But essentially it would still be similar to the mentioned call gates.

All in all it still sounds like a nightmare to "get right".



-- 

Matthias
