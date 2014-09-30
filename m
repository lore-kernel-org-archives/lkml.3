Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753476AbaI3Rat (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 13:30:49 -0400
Received: from homie.mail.dreamhost.com ([208.97.132.208]:38037 "EHLO
	homiemail-a60.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753309AbaI3Raq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 13:30:46 -0400
Message-ID: <1412098223.23497.42.camel@linux-t7sj.site>
Subject: Re: Document POSIX MQ /proc/sys/fs/mqueue files
From: Davidlohr Bueso <dave@stgolabs.net>
To: mtk.manpages@gmail.com
Cc: Doug Ledford <dledford@redhat.com>,
        "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, Madars Vitolins <m@silodev.com>,
        Manfred Spraul <manfred@colorfullife.com>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 30 Sep 2014 10:30:23 -0700
In-Reply-To: <CAKgNAkj9+Z1yO-zrQ_qWFut7BqOkzNtNCruSSRyTKMpXZOcBaw@mail.gmail.com>
References: <542921EA.4050709@gmail.com>
	 <1412011687.15492.39.camel@firewall.xsintricity.com>
	 <CAKgNAkj9+Z1yO-zrQ_qWFut7BqOkzNtNCruSSRyTKMpXZOcBaw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-09-30 at 12:12 +0200, Michael Kerrisk (man-pages) wrote:
> Hi Doug,
> 
> On Mon, Sep 29, 2014 at 7:28 PM, Doug Ledford <dledford@redhat.com> wrote:
> > On Mon, 2014-09-29 at 11:10 +0200, Michael Kerrisk (man-pages) wrote:
> >> Hello Doug, David,
> >>
> >> I think you two were the last ones to make significant
> >> changes to the semantics of the files in /proc/sys/fs/mqueue,
> >> so I wonder if you (or anyone else who is willing) might
> >> take a look at the man page text below that I've written
> >> (for the mq_overview(7) page) to describe past and current
> >> reality, and let me know of improvements of corrections.
> >>
> >> By the way, Doug, your commit ce2d52cc1364 appears to have
> >> changed/broken the semantics of the files in the /dev/mqueue
> >> filesystem. Formerly, the QSIZE field in these files showed
> >> the number of bytes of real user data in all of the queued
> >> messages. After that commit, QSIZE now includes kernel
> >> overhead bytes, which does not seem very useful for user
> >> space. Was that change intentional? I see no mention of the
> >> change in the commit message, so it sounds like it was not
> >> intended.
> >
> > That change didn't come in that commit.  That commit modified it, but
> > didn't introduce it.
> 
> (Which commit was it then? d6629859b36 ?)

By just looking at msg_insert and msg_get, I think so, yeah.

> 
> > Now, was it intentional? Yes.  Is it valuable, useful?  That depends on
> > your perspective.
> 
> Thanks for the detailed explanation below. However, I don't understand
> why the (useful) work that you describe below necessitated a change in
> the QSIZE value that was exposed to user space. Surely the necessary
> changes could have been done internally while still leaving QSIZE to
> expose the same value it ever did? As things stand now (and unless I
> am missing something), QSIZE exposes an implementation-specific
> internal value that has little meaning or value to user space. And,
> it's unfortunate that the commit message made no mention of the fact
> that there was an ABI change here.

Agreed. And this needs to be changed back -- *although* there have been
0 bug reports afaict. Probably similarly to what we did with the
queues_max issue: stable since v3.5. Doug, any thoughts?

Thanks,
Davidlohr

