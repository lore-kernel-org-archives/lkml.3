Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751433Ab3LXVzt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Dec 2013 16:55:49 -0500
Received: from netrider.rowland.org ([192.131.102.5]:40718 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751258Ab3LXVzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Dec 2013 16:55:47 -0500
Date: Tue, 24 Dec 2013 16:55:46 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Tejun Heo <tj@kernel.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-ide@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, <linux-pm@vger.kernel.org>
Subject: Re: [GIT PULL] libata fixes for v3.13-rc5
In-Reply-To: <20131224142104.GA3512@htj.dyndns.org>
Message-ID: <Pine.LNX.4.44L0.1312241653360.337-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Dec 2013, Tejun Heo wrote:

> Hello, Linus.
> 
> libata fixes for v3.13-rc5.  There's one interseting commit - "libata,
> freezer: avoid block device removal while system is frozen".  It's an
> ugly hack working around a deadlock condition between driver core
> resume and block layer device removal paths through freezer which was
> made more reproducible by writeback being converted to workqueue some
> releases ago.  The bug has nothing to do with libata but it's just an
> workaround which is easy to backport.  After discussion, Rafael and I
> seem to agree that we don't really need kernel freezables - both
> kthread and workqueue.  There are few specific workqueues which
> constitute PM operations and require freezing, which will be converted
> to use workqueue_set_max_active() instead.  All other kernel freezer
> uses are planned to be removed, followed by the removal of kthread and
> workqueue freezer support, hopefully.

Wait a minute.  I don't recall anybody mentioning this earlier.  What 
about khubd?  There isn't any plan to remove _it_.

Alan Stern

