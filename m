Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753291AbaBZANu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 19:13:50 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:52201 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344AbaBZANt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 19:13:49 -0500
Message-ID: <1393373618.2886.26.camel@linux-whg8.site>
Subject: Re: [RFC PATCH for-next 1/4] epoll: struct epoll userspace definiton
From: Nathaniel Yazdani <n1ght.4nd.d4y@gmail.com>
To: Eric Wong <normalperson@yhbt.net>
Cc: linux-kernel@vger.kernel.org
Date: Tue, 25 Feb 2014 16:13:38 -0800
In-Reply-To: <20140225101527.GA9963@dcvr.yhbt.net>
References: <1393206162-18151-1-git-send-email-n1ght.4nd.d4y@gmail.com>
	 <1393206162-18151-2-git-send-email-n1ght.4nd.d4y@gmail.com>
	 <20140224052934.GA7056@dcvr.yhbt.net>
	 <CAJ3m7Bq1y+MLn=HFY3AADnVc2HK31+WANahiYLUcdBw=hh_2pg@mail.gmail.com>
	 <20140225101527.GA9963@dcvr.yhbt.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-02-25 at 10:15 +0000, Eric Wong wrote:
> (Did you intend to Cc LKML on your original reply?)
> 
> Nathaniel Yazdani <n1ght.4nd.d4y@gmail.com> wrote:
> > On Sun, Feb 23, 2014 at 9:29 PM, Eric Wong <normalperson@yhbt.net> wrote:
> > > Nathaniel Yazdani <n1ght.4nd.d4y@gmail.com> wrote:
> > >> +++ b/include/uapi/linux/eventpoll.h
> > >> @@ -61,6 +61,12 @@ struct epoll_event {
> > >>       __u64 data;
> > >>  } EPOLL_PACKED;
> > >>
> > >> +struct epoll {
> > >> +     int ep_fildes; /* file descriptor */
> > >> +     int ep_events; /* triggering events */
> > >> +     long long ep_ident; /* entry ID (cf. epoll_event->data) */
> > >> +} EPOLL_PACKED;
> > >
> > > Why not reuse the existing epoll_event struct?
> > >
> > >         struct epoll {
> > >                 int ep_fildes; /* file descriptor */
> > >                 struct epoll_event event;
> > >         } EPOLL_PACKED;
> > 
> > Well my first instinct was that doing it like that would be too messy,
> > but now that you mention it that'd probably be a much better
> > approach. In fact we could even do something like:
> > 
> > struct epoll {
> >         int ep_fildes; /* file descriptor */
> >         union {
> >                 struct epoll_event event;
> >                 struct {
> >                         int ep_events;
> >                         long long ep_ident;
> >                 } EPOLL_PACKED;
> >         };
> > } EPOLL_PACKED;
> > 
> > In order to keep things looking spiffy while also easing migration
> > from the old struct :)
> 
> I think you miss the point of my question.  What is the point of
> changing:
> 
> 	event.events => ep_events
> 	event.data   => ep_ident
> 
> in the first place?

Whoops, my bad, still haven't gotten my email client totally figured
out. I'll CC this back the mailing list so everyone else can follow
along.

My intent was just to give the struct a more Unix-like style (so
to speak), because when I started, it looked like entirely
different code paths would be needed for this sort of functionality.
Thankfully that wasn't the case, but still a new struct was
necessary. All that to say I don't have an issue embedding an
epoll_event over defining the fields directly, but I'd just
prefer not to.

