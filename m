Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756560Ab3DWQ5v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 12:57:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20453 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756256Ab3DWQ5u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 12:57:50 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20130403144857.22351.67546.stgit@rabbit.intern.cm-ag>
References: <20130403144857.22351.67546.stgit@rabbit.intern.cm-ag>
To: Max Kellermann <mk@cm4all.com>
Cc: dhowells@redhat.com, linux-cachefs@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fscache: extended "dying" check before emitting EV_INVALIDATE
Date: Tue, 23 Apr 2013 17:57:46 +0100
Message-ID: <5827.1366736266@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Max Kellermann <mk@cm4all.com> wrote:

> Before emitting an FSCACHE_OBJECT_EV_INVALIDATE event, the function
> __fscache_invalidate() checks whether the fscache_object is currently
> "dying".  This checks only the current state, not the queued events
> that will very soon lead to the object's death.

This should not be a problem, I think.  EV_RETIRE and EV_RELEASE should only be
set by fscache_relinquish_cookie().  If you (the netfs) call that to dispose of
a cookie to fscache, you shouldn't thereafter be calling fscache_invalidate()
on it.  The only case in which __fscache_invalidate() should see a dying object
is if the caching backend withdraws it (ie. EV_WITHDRAW is set).

Do you have a backtrace?

David
