Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755316Ab3JYPVp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 11:21:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52387 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754776Ab3JYPVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 11:21:43 -0400
Date: Fri, 25 Oct 2013 16:23:23 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Olof Johansson <olof@lixom.net>
Cc: Joe Perches <joe@perches.com>, Kevin Hilman <khilman@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Sangjung Woo <sangjung.woo@samsung.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH] device: Add kernel standard devm_k.alloc functions
Message-ID: <20131025152323.GA27606@kroah.com>
References: <1381296747.2040.17.camel@joe-AO722>
 <20131011131138.3bc5b2acf60df3a5d79d0d24@linux-foundation.org>
 <CAGa+x864VYoGvOxoK0XnxXH9hKNq9WAZ16XHiFawZY7_2WJttw@mail.gmail.com>
 <CAGa+x86aS+C8iEb1P4ZYxPBix=Anjh4JZoAof=R-i9fGw=bq6w@mail.gmail.com>
 <20131018225702.GA13090@kroah.com>
 <8761stu7rl.fsf@linaro.org>
 <20131020025713.GA22344@kroah.com>
 <1382282566.2041.39.camel@joe-AO722>
 <CAOesGMhHPa+Wb6=bEZ1paUN4-Rw_DFc5rtZQ9miQ=Otg9p39Uw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOesGMhHPa+Wb6=bEZ1paUN4-Rw_DFc5rtZQ9miQ=Otg9p39Uw@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 25, 2013 at 05:59:56AM -0700, Olof Johansson wrote:
> On Sun, Oct 20, 2013 at 8:22 AM, Joe Perches <joe@perches.com> wrote:
> > On Sat, 2013-10-19 at 19:57 -0700, Greg KH wrote:
> >> On Fri, Oct 18, 2013 at 10:52:46PM -0700, Kevin Hilman wrote:
> >> > Greg KH <gregkh@linuxfoundation.org> writes:
> >> >
> >> > > On Fri, Oct 18, 2013 at 10:04:11AM -0700, Kevin Hilman wrote:
> >> > >> > A handful of boot panics on ARM platforms were bisected to point at
> >> > >> > the version of this commit that's in linux-next (commit
> >> > >> > 64c862a839a8db2c02bbaa88b923d13e1208919d).  Reverting this commit
> >> > >> > makes things happy again.
> >> > >> >
> >> > >> > Upon further digging, it seems that users of devres_alloc() are
> >> > >> > relying on the previous behavior of having the memory zero'd which is
> >> > >> > no longer the case after $SUBJECT patch.  The change below on top of
> >> > >> > -next makes these ARM boards happy again.
> >> > >>
> >> > >> Oops, it should've fixed __devres_alloc() also.  Updated patch below.
> >> > >
> >> > > Can you send this in a format that I can apply it in?  It was whitespace
> >> > > damaged.
> >> >
> >> > hmm, sorry about that.  This one should work, though I wonder if Andrew
> >> > should pick this up since I think the patch that causes the breakage
> >> > came through his tree.
> >>
> >> No, the patch is in my tree, not Andrew's.
> >>
> >> Joe, can I get a signed-off-by for this?
> >
> > If you want.
> >
> > Signed-off-by: Joe Perches <joe@perches.com>
> 
> Acked-by: Olof Johansson <olof@lixom.net>
> 
> 
> Greg, would you mind picking this up? It's still broken in -next and I
> don't want it to mask other issues that might be introduced.

I picked it up early this morning already, so it will be in the next
-next whenever it gets created...

thanks,

greg k-h
