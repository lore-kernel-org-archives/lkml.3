Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023Ab3KQO1n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 09:27:43 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:56222 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752639Ab3KQO1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 09:27:36 -0500
Date: Sun, 17 Nov 2013 09:27:31 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Michal Marek <mmarek@suse.cz>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Yang Bai <hamo.by@gmail.com>, Stephen Boyd <sboyd@codeaurora.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] scripts: Have make TAGS not include structure members
Message-ID: <20131117092731.75b091bd@gandalf.local.home>
In-Reply-To: <CAMuHMdXSBSOkfd2MGbn=rpXQRZYw5TKLsR=3SoeSyrcD2CzunA@mail.gmail.com>
References: <20131115093645.6dc03918@gandalf.local.home>
	<CAMuHMdXSBSOkfd2MGbn=rpXQRZYw5TKLsR=3SoeSyrcD2CzunA@mail.gmail.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Nov 2013 10:14:46 +0100
Geert Uytterhoeven <geert@linux-m68k.org> wrote:

> On Fri, Nov 15, 2013 at 3:36 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> > It is really annoying when I use emacs TAGS to search for something
> > like "dev_name" and have to go through 12 iterations before I find the
> > function "dev_name". I really do not care about structures that include
> > "dev_name" as one of its fields, and I'm sure pretty much all other
> > developers do not care either.
> 
> While I'm also annoyed by this (although with vim/tags), I regularly do search
> for struct members, so losing this ability would hurt, too.
> 
> Is there a solution, without throwing out the baby with the bath water?
> 

Or perhaps make it only do it for TAGS. vim gives you a list of
locations that you can go to, and even marks if it is a member of a
structure or a function or whatever. With emacs, you have to iterate
over each location. That is, with my devname example, I had to hit M^.
then Ctrl^U M^. another 12 times before I got to the function name.
It makes it absolutely worthless, that after two or three misses, I
give up and just grep for it.

I don't think there's a single emacs users that would not like this
change.

Thus, I'll make it for emacs only, and I think that will be a good
compromise.

-- Steve
