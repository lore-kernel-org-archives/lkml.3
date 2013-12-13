Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752362Ab3LMN17 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 08:27:59 -0500
Received: from mail-ea0-f182.google.com ([209.85.215.182]:36185 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856Ab3LMN16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 08:27:58 -0500
Date: Fri, 13 Dec 2013 14:27:53 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Vegard Nossum <vegard.nossum@oracle.com>
Cc: Kees Cook <keescook@chromium.org>, "Theodore Ts'o" <tytso@mit.edu>,
        LKML <linux-kernel@vger.kernel.org>,
        Tommi Rantala <tt.rantala@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        James Morris <james.l.morris@oracle.com>
Subject: Re: [PATCH 1/9] Known exploit detection
Message-ID: <20131213132753.GC10981@gmail.com>
References: <1386867152-24072-1-git-send-email-vegard.nossum@oracle.com>
 <20131212190659.GG13547@thunk.org>
 <CAGXu5jKmrtgH8tAGuYd9-gh5-EXqAsPy+XoRMc9DNLDngNH2ug@mail.gmail.com>
 <52AACF63.2020004@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52AACF63.2020004@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Vegard Nossum <vegard.nossum@oracle.com> wrote:

> On 12/12/2013 10:13 PM, Kees Cook wrote:
>
> > I like it. I like how lightweight it is, and I like that it can be 
> > trivially compiled out. My concerns would be:
> >
> > - how do we avoid bikeshedding about which exploits are "serious
> >   enough" to trigger a report?
> 
> Well, I've already suggested that only bugs that potentially lead to 
> privilege escalation/intrusion (local and remote) would be 
> candidates. This probably includes any kind of buffer overflow or 
> "wild write" bug.

It's also up to the maintainer of the subsystem, so bikeshedding is 
only as effective as the maintainer allows it to be.

> Clearly, a bug should also be present over a complete release cycle 
> before it's worth annotating. [...]

Yes, only bugs present in a released kernel are candiates.

> [...] A bug introduced in -rc1 and fixed in -rc5 is NOT a candidate.

That's generally true, except perhaps in the special case if a bug got 
backported and released in a stable kernel, and some good exploit got 
released for that bug. In that case checking it is useful.

The point is that we want to check things that have a chance to result 
in actual messages: i.e. deterministically triggerable bugs in 
released kernel that are either trivially exploitable or are known to 
be exploited in exploit kits.

Thanks,

	Ingo
