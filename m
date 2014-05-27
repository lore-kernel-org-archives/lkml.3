Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752501AbaE0RZY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 13:25:24 -0400
Received: from mail-ve0-f169.google.com ([209.85.128.169]:53494 "EHLO
	mail-ve0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984AbaE0RZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 13:25:23 -0400
MIME-Version: 1.0
Date: Tue, 27 May 2014 12:25:22 -0500
Message-ID: <CAAih0NjG4gC-7fkD5vOvF0CQks+DhqVZLeycsju-8RMVP6dbBw@mail.gmail.com>
Subject: inotify_rm_watch() user-space safety requirements?
From: Jeff Smith <jsmith.lkml@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

inotify's behavior concerning events from removed watches (they do
happen) and watch descriptor reuse (beyond my knowledge) is currently
undocumented.

Although it mimics a standard multiplexing interface in most regards,
writing a robust user-space handler is comparatively more complex due
to the atypical delivery of "stale" wd events preceding an IN_IGNORE
event and a lack of guarantees about how quickly a wd can be reused
via inotify_add_watch(). Not being familiar with inotify/fsnotify
internals, it's not trivially obvious to me how the fsnotify_group
management is being done. Up to the present, I've maintained queues of
"dead" wd wrappers (or at least a counter) to filter stale events, but
I am clueless whether or not this is overkill.

If removed descriptors are reserved until the IN_IGNORE event is
drained from the read queue, could that be formally guaranteed? If
it's not, is it functionality that could ever reasonably be expected
to be added, short of some other form of new (optional?)
queue-filter-on-rm functionality? It's my experience that the
asynchronous handling of watch removals is a cost that seldom serves
much user benefit.

Regards,
Jeff
