Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751800Ab3LMFIM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 00:08:12 -0500
Received: from tundra.namei.org ([65.99.196.166]:46150 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751608Ab3LMFII (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 00:08:08 -0500
Date: Fri, 13 Dec 2013 16:09:06 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: Dave Jones <davej@redhat.com>, Kees Cook <keescook@chromium.org>,
        "Theodore Ts'o" <tytso@mit.edu>, vegard.nossum@oracle.com,
        LKML <linux-kernel@vger.kernel.org>,
        Tommi Rantala <tt.rantala@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Alan Cox <alan@linux.intel.com>, Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        James Morris <james.l.morris@oracle.com>
Subject: Re: [PATCH 1/9] Known exploit detection
In-Reply-To: <20131213014220.GB11068@kroah.com>
Message-ID: <alpine.LRH.2.02.1312131557340.32454@tundra.namei.org>
References: <1386867152-24072-1-git-send-email-vegard.nossum@oracle.com> <20131212190659.GG13547@thunk.org> <CAGXu5jKmrtgH8tAGuYd9-gh5-EXqAsPy+XoRMc9DNLDngNH2ug@mail.gmail.com> <20131213002523.GA20706@redhat.com> <20131213014220.GB11068@kroah.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Dec 2013, Greg Kroah-Hartman wrote:

> On Thu, Dec 12, 2013 at 07:25:23PM -0500, Dave Jones wrote:
> > On Thu, Dec 12, 2013 at 01:13:41PM -0800, Kees Cook wrote:
> > 
> >  > - who will keep adding these triggers going forward?
> > 

I think we'd need to have someone commit to maintaining this long term 
before seriously considering it as part of mainline.  Over time it will 
become increasingly useless if new triggers aren't added.

What happens when code is refactored, who refactors the triggers?


> > also..
> > 
> > - Who will test the existing triggers are doing the right thing when related code changes.
> 
> And:
>   - how do you determine an "expoit attempt" from "userspace program
>     doing something stupid" / "corrupted filesytem mounted"?
> 

Right, and if there are enough false positives, it'll end up being quite 
useless.

I suspect this kind of thing is better done in userspace anti-malware 
scanning.

> I really don't like this, it means that our normal error handling for
> userspace data will suddenly all have CVE entries on them over time.
> How is that helpful to anyone?
> 
> Think ahead in 10-20 years, what is the code paths going to look like
> then?  Horrible...

Agree.

This could make an interesting research project outside of the kernel. It 
doesn't belong in mainline without at least first being proven in the 
field and also properly maintained long term, if at all.


-- 
James Morris
<jmorris@namei.org>
