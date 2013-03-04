Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755228Ab3CDDFD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 22:05:03 -0500
Received: from dcvr.yhbt.net ([64.71.152.64]:42958 "EHLO dcvr.yhbt.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754962Ab3CDDFB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 22:05:01 -0500
Date: Mon, 4 Mar 2013 03:05:00 +0000
From: Eric Wong <normalperson@yhbt.net>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] epoll: preserve ordering of events from ovflist
Message-ID: <20130304030500.GA29365@dcvr.yhbt.net>
References: <20130302072508.GA19297@dcvr.yhbt.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130302072508.GA19297@dcvr.yhbt.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Wong <normalperson@yhbt.net> wrote:
> Events arriving in ovflist are stored in LIFO order, so
> we should account for that when inserting them into rddlist.

Fwiw, I noticed this oddity because I wanted to start tracing epitem
readiness (to detect when my application is not calling epoll_wait()
fast enough).

I have two more patches coming on top of this one:

Eric Wong (2):
      epoll: hoist out duplicated wake up logic
      epoll: add tracepoints for epitem enqueue/dequeue

 fs/eventpoll.c                   |  62 +++++++++++----------
 include/linux/eventpoll.h        |   8 +++
 include/trace/events/eventpoll.h | 113 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 155 insertions(+), 28 deletions(-)
