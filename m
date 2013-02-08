Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1947183Ab3BHWIT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 17:08:19 -0500
Received: from dcvr.yhbt.net ([64.71.152.64]:55460 "EHLO dcvr.yhbt.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1947025Ab3BHWIR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 17:08:17 -0500
Date: Fri, 8 Feb 2013 22:08:17 +0000
From: Eric Wong <normalperson@yhbt.net>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Martin Sustrik <sustrik@250bpm.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sha Zhengju <handai.szj@taobao.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] eventfd: implementation of EFD_MASK flag
Message-ID: <20130208220817.GA4256@dcvr.yhbt.net>
References: <1360219292-19754-1-git-send-email-sustrik@250bpm.com>
 <5113FCA7.4020207@mit.edu>
 <51140A60.4070705@250bpm.com>
 <CALCETrXEy5hLh6i7nTGH607gnc=kd0S+of9i0-nt828MGwbQZQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrXEy5hLh6i7nTGH607gnc=kd0S+of9i0-nt828MGwbQZQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Lutomirski <luto@amacapital.net> wrote:
> On Thu, Feb 7, 2013 at 12:11 PM, Martin Sustrik <sustrik@250bpm.com> wrote:
> > On 07/02/13 20:12, Andy Lutomirski wrote:
> >> On 02/06/2013 10:41 PM, Martin Sustrik wrote:
> >>> The value of 'events' should be any combination of event flags as defined
> >>> by
> >>> poll(2) function (POLLIN, POLLOUT, POLLERR, POLLHUP etc.) Specified
> >>> events will
> >>> be signaled when polling (select, poll, epoll) on the eventfd is done
> >>> later on.
> >>> 'ptr' is an opaque pointer that is not interpreted by eventfd object.
> >>
> >> How does this interact with EPOLLET?
> >
> > That's an interesting question. The original eventfd code doesn't do
> > anything specific to either edge or level mode. Neither does my patch.
> >
> > Inspection of the code seems to suggest that edge vs. level distinction is
> > handled elsewhere (ep_send_events_proc) where there is a separate list of
> > ready events and the function, after returning the event, decides whether to
> > leave the event in the list (level) or delete it from the list (edge).

Right, the edge vs. level distinction is internal to epoll.

> Hmm.  Having looked at the eventpoll.c source again, I remain
> unconvinced that EPOLLET works the way that any userspace developer
> would expect it to.

As as userspace developer, EPOLLET seems to work as expected/documented;
but I realized EPOLLONESHOT is what I want to be using instead.

> > In any case, review from someone with experience with epoll implementation
> > would help.

I'm no expert, but I don't think eventfd (or any file type) needs to
care about what I/O notification scheme/options it's used with.
