Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933847AbaCTP1a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 11:27:30 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:43690 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932796AbaCTP11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 11:27:27 -0400
Date: Thu, 20 Mar 2014 15:26:57 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: David Herrmann <dh.herrmann@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Hugh Dickins <hughd@google.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Karol Lewandowski <k.lewandowsk@samsung.com>,
        Kay Sievers <kay@vrfy.org>, Daniel Mack <zonque@gmail.com>,
        Lennart Poettering <lennart@poettering.net>,
        Kristian =?UTF-8?B?SMO4Z3NiZXJn?= <krh@bitplanet.net>,
        John Stultz <john.stultz@linaro.org>,
        Greg Kroah-Hartman <greg@kroah.com>, Tejun Heo <tj@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        DRI <dri-devel@lists.freedesktop.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ryan Lortie <desrt@desrt.ca>,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Re: [PATCH 0/6] File Sealing & memfd_create()
Message-ID: <20140320152657.381956ff@alan.etchedpixels.co.uk>
In-Reply-To: <CANq1E4Ro8bsgp1QS_Qf9KKBAMZH+joMW5DmfyZ4OBJuTxdXCZA@mail.gmail.com>
References: <1395256011-2423-1-git-send-email-dh.herrmann@gmail.com>
	<CA+55aFyNORiS2XidhWoDBVyO6foZuPJTg_BOP3aLtvVhY1R6mw@mail.gmail.com>
	<CANq1E4TuiU6_J=N0WoPav=0AxOJ9G1w+FGvO15kmGP76i+-caw@mail.gmail.com>
	<20140320144127.1d411f26@alan.etchedpixels.co.uk>
	<CANq1E4Ro8bsgp1QS_Qf9KKBAMZH+joMW5DmfyZ4OBJuTxdXCZA@mail.gmail.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Mar 2014 16:12:54 +0100
David Herrmann <dh.herrmann@gmail.com> wrote:

> Hi
> 
> On Thu, Mar 20, 2014 at 3:41 PM, One Thousand Gnomes
> <gnomes@lxorguk.ukuu.org.uk> wrote:
> > I think you want two things at minimum
> >
> > owner to seal
> > root can always override
> 
> Why should root be allowed to override?

Because root can already override it by say mmapping the kernel memory
and patching. It also tends to be valuable for debugging horrible
problems with complex systems.

Imposing fake restrictions on root just causes annoyance when doing stuff
like debugging but doesn't actually change the security situation.
> 
> I'm fine with F_SET/GET_SEALS. But given you suggested requiring
> MFD_ALLOW_SEALS for sealing, I don't see why we couldn't limit this
> interface entirely to memfd_create().

But if someone does find a non memfd use for it then it's useful not to
have to go "this fnctl for memfd, that fnctl for the other"

Just planning ahead.


> > Whether you want some way to undo a seal without an exclusive reference as
> > the file owner is another question.
> 
> No. You are never allowed to undo a seal but with an exclusive
> reference. This interface was created for situations _without_ any
> trust relationship. So if the owner is allowed to undo seals, the
> interface doesn't make any sense. The only options I see is to not
> allow un-sealing at all (which I'm fine with) or tracking users (which
> is way too much overhead).

Ok - that makes sense
