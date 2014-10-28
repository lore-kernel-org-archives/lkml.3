Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592AbaJ1WzT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 18:55:19 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:46936 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255AbaJ1WzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 18:55:16 -0400
Date: Tue, 28 Oct 2014 22:55:13 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-unionfs@vger.kernel.org
Subject: Re: [GIT PULL] overlay filesystem v25
Message-ID: <20141028225512.GD7996@ZenIV.linux.org.uk>
References: <CAJfpegt-X_Cd8B5H65keshhhuwH2-HPpaBC30atKeS3QjaariA@mail.gmail.com>
 <20141025081845.GJ7996@ZenIV.linux.org.uk>
 <CAJfpegvM8d-cizf=3KmTSFVgAYPBDp_0fQAh+G2Q87u=taXm3A@mail.gmail.com>
 <20141025170609.GK7996@ZenIV.linux.org.uk>
 <CAJfpegucroRzo0NHTz=4N0WcrB2oDC0eDiZXk=aKSjc8vdYDjw@mail.gmail.com>
 <20141027155901.GE5718@linux.vnet.ibm.com>
 <20141027172800.GW7996@ZenIV.linux.org.uk>
 <20141027173621.GG5718@linux.vnet.ibm.com>
 <20141028011214.GZ7996@ZenIV.linux.org.uk>
 <20141028041127.GM5718@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141028041127.GM5718@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 27, 2014 at 09:11:27PM -0700, Paul E. McKenney wrote:
> On Tue, Oct 28, 2014 at 01:12:14AM +0000, Al Viro wrote:
> > On Mon, Oct 27, 2014 at 10:36:21AM -0700, Paul E. McKenney wrote:
> > > Code making direct use of smp_read_barrier_depends() is harder to read,
> > > in my experience, but good point on the sparse noise.  Maybe a new
> > > lockless_dereference() primitive?  Maybe something like the following?
> > > (Untested, probably does not even build.)
> > > 
> > > #define lockless_dereference(p) \
> > > ({ \
> > > 	typeof(*p) *_________p1 = ACCESS_ONCE(p); \
> > > 	smp_read_barrier_depends(); /* Dependency order vs. p above. */ \
> > > 	_________p1; \
> > > })
> > 
> > Hmm...  Where would you prefer to put it?  rcupdate.h?
> 
> Good a place as any, I guess.  Please see patch below.  Left to myself,
> I would send this along for the next merge window, but please let me
> know if you would like it sooner.

It's needed sooner, unfortunately.  Guys, could you take a look at
vfs.git#for-linus and comment?
