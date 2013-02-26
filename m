Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759985Ab3BZBsS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 20:48:18 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:41138 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366Ab3BZBsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 20:48:14 -0500
Date: Mon, 25 Feb 2013 17:48:10 -0800
From: Tejun Heo <tj@kernel.org>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] idr: Don't WARN in idr_find
Message-ID: <20130226014810.GI2679@htj.dyndns.org>
References: <1361842632-29689-1-git-send-email-peter@hurleysoftware.com>
 <20130226014027.GH2679@htj.dyndns.org>
 <1361843171.8053.1.camel@thor.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1361843171.8053.1.camel@thor.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2013 at 08:46:11PM -0500, Peter Hurley wrote:
> On Mon, 2013-02-25 at 17:40 -0800, Tejun Heo wrote:
> > On Mon, Feb 25, 2013 at 08:37:12PM -0500, Peter Hurley wrote:
> > > Since idr is used for syscall apis (to associate 'handles' with
> > > internal structures), don't WARN with invalid input.
> > > 
> > > For example, POSIX timers are identified by timer_t id. These
> > > ids are idr values. If userspace passes a representable timer_t id
> > > value (eg, id < 0) but which was not previous allocated (since the
> > > current idr api does not return negative idr values), then the
> > > syscall properly returns an error; a WARN is unnecessary and
> > > undesirable.
> > 
> > WARN_ON() on negative was intentional.  Because the previous
> > implmentation silently dropped the msb, we at least wanna know who has
> > been passing in negative indices.  Patch for the lock_timer is already
> > in -mm.
> 
> Thanks. Can you share the patch title? It's not in next-20130225.

It's this one.

 http://thread.gmane.org/gmane.linux.kernel/1444883/focus=1445094

Thanks.

-- 
tejun
