Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933667Ab3ECQy5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 12:54:57 -0400
Received: from mail-qc0-f176.google.com ([209.85.216.176]:43417 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759592Ab3ECQyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 12:54:55 -0400
Date: Fri, 3 May 2013 09:54:48 -0700
From: Tejun Heo <tj@kernel.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Colin Cross <ccross@android.com>, Linux PM list <linux-pm@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        Oleg Nesterov <oleg@redhat.com>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, Jeff Layton <jlayton@redhat.com>,
        Mandeep Baines <msb@chromium.org>
Subject: Re: [PATCH v2 03/10] freezer: add new freezable helpers using
 freezer_do_not_count()
Message-ID: <20130503165448.GA22709@mtj.dyndns.org>
References: <20130503040934.GA16968@mtj.dyndns.org>
 <Pine.LNX.4.44L0.1305031017030.1513-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1305031017030.1513-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 03, 2013 at 10:18:17AM -0400, Alan Stern wrote:
> Don't forget about freezable kernel threads.  They never cross the 
> kernel/user boundary.

Doesn't really matter for this purpose.  They first of all can't be
moved into !root cgroups and thus can't be cgroup-frozen and even if
they could they can't be killed or ptraced, so they just don't play
the same game.

Thanks.

-- 
tejun
