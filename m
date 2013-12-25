Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752115Ab3LYObm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Dec 2013 09:31:42 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:62774 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752048Ab3LYObj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Dec 2013 09:31:39 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: [GIT PULL] libata fixes for v3.13-rc5
Date: Wed, 25 Dec 2013 15:45:08 +0100
Message-ID: <38559427.MeFx9E3dcV@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <Pine.LNX.4.44L0.1312241653360.337-100000@netrider.rowland.org>
References: <Pine.LNX.4.44L0.1312241653360.337-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, December 24, 2013 04:55:46 PM Alan Stern wrote:
> On Tue, 24 Dec 2013, Tejun Heo wrote:
> 
> > Hello, Linus.
> > 
> > libata fixes for v3.13-rc5.  There's one interseting commit - "libata,
> > freezer: avoid block device removal while system is frozen".  It's an
> > ugly hack working around a deadlock condition between driver core
> > resume and block layer device removal paths through freezer which was
> > made more reproducible by writeback being converted to workqueue some
> > releases ago.  The bug has nothing to do with libata but it's just an
> > workaround which is easy to backport.  After discussion, Rafael and I
> > seem to agree that we don't really need kernel freezables - both
> > kthread and workqueue.  There are few specific workqueues which
> > constitute PM operations and require freezing, which will be converted
> > to use workqueue_set_max_active() instead.  All other kernel freezer
> > uses are planned to be removed, followed by the removal of kthread and
> > workqueue freezer support, hopefully.
> 
> Wait a minute.  I don't recall anybody mentioning this earlier.  What 
> about khubd?  There isn't any plan to remove _it_.

No, but we are going to replace the freezing of kernel stuff with something
more direct, like "suspend" routines called from the system suspend code path
and causing things to stop (and corresponding "resume" starting them again).

Thanks,
Rafael

