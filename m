Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752098Ab3IZFxq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 01:53:46 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:19902 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751185Ab3IZFxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 01:53:45 -0400
X-IronPort-AV: E=Sophos;i="4.90,982,1371074400"; 
   d="scan'208";a="34379047"
Date: Thu, 26 Sep 2013 07:53:40 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: Alexander Holler <holler@ahsoftware.de>
cc: Al Viro <viro@ZenIV.linux.org.uk>, Bjorn Helgaas <bhelgaas@google.com>,
        Peter Senna Tschudin <peter.senna@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        kernel-janitors@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: checkpatch guide for newbies
In-Reply-To: <5243A993.9070108@ahsoftware.de>
Message-ID: <alpine.DEB.2.02.1309260749580.1984@localhost6.localdomain6>
References: <20130923090100.GE6192@mwanda> <CAErSpo5XgvuG=75nExa7yCa7C+Bxhk+1LwruxY8pv2DU+r-_aA@mail.gmail.com> <5241CB44.8080004@ahsoftware.de> <CA+MoWDpnNjeEN+Crzh2kQ7DPJ_DqEOP4z-9n3=EqP7hiPgZRXg@mail.gmail.com> <CAErSpo4X0-PEYtZrY2r4GKmzTJhHK3eKdXrbccJhB7wVkVCYLA@mail.gmail.com>
 <52420DF1.7060108@ahsoftware.de> <20130926021130.GD13318@ZenIV.linux.org.uk> <5243A165.2060204@ahsoftware.de> <5243A29C.6080009@ahsoftware.de> <20130926030448.GG13318@ZenIV.linux.org.uk> <5243A993.9070108@ahsoftware.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Sep 2013, Alexander Holler wrote:

> Am 26.09.2013 05:04, schrieb Al Viro:
> > On Thu, Sep 26, 2013 at 04:57:32AM +0200, Alexander Holler wrote:
> > > Am 26.09.2013 04:52, schrieb Alexander Holler:
> > > 
> > > > I'm aware of people which do nest 8 levels deep just to avoid a return,
> > > > break or goto.
> > > > 
> > > > But trying to limit that by limiting the line length is like ...
> > > > (choose your own own misguided comparison, it's too late for me I
> > > > currently only meorize some of those which don't make sense in english)
> > > 
> > > But I'm still able to offer a solution: ;)
> > > 
> > > limit the number of tabs, not the line length (at least not to 80).
> > 
> > With that limited (and it's visually harder to keep track of), what's
> > the problem with 80-column limit on line length?  Just how long do
> > you want those "descriptive names" to be?
> 
> Oh, personally I don't have any limit there. ;) I like descriptive function
> and variable names whenever they make sense. And often they make comments
> uneccessary and therefor prevent errors because those descriptive names are
> visible whenever the function or variable is used, and comments usually appear
> only once and get forgotten when scrolled out of the screen.
> 
> But just take a function like
> 
> void get_xtime_and_monotonic_and_sleep_offset(struct timespec *xtim,
>                                 struct timespec *wtom, struct timespec
> *sleep);
> 
> I like such function names ;) (ok I wouldn't have use those and), but it's
> hard to press this into 80 characters, especially when the arguments should
> have some meaning too (e.g. what does wtom stand for?)
> 
> If you use that somewhere you get
> 
>         get_xtime_and_monotonic_and_sleep_offset(a, b, c)
> 
> using silly names and that already is a 58 characters long. So only 22 are
> left to distribute over 3 variable names. And now think what happens if that
> wouldn't be a void function.

Personally, I prefer to use my screen real estate for multiple 80-column 
windows, so I can see different parts of the code at once.  Anything that 
goes over 80 columns is very hard to read.

Perhaps it is a bad example, but I don't even find this very long name 
very understandable.  Monotonic is an adjective and xtime and sleep are 
nouns, so I don't understand how it all fits together.  Maybe cramming a 
lot of information into a variable name is not always so successful... 
Actually, I really appreciate comments on functions, that explain the 
purpose of the function, and the constraints on its usage.

julia
