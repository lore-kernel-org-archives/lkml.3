Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723AbaBNQBm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 11:01:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3615 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751921AbaBNQBj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 11:01:39 -0500
Date: Fri, 14 Feb 2014 11:01:23 -0500
From: Dave Jones <davej@redhat.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Eric Sandeen <sandeen@sandeen.net>,
        Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
Subject: Re: 3.14-rc2 XFS backtrace because irqs_disabled.
Message-ID: <20140214160123.GA28125@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Dave Chinner <david@fromorbit.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Eric Sandeen <sandeen@sandeen.net>,
	Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
References: <52FA9ADA.9040803@sandeen.net>
 <20140212004403.GA17129@redhat.com>
 <20140212010941.GM18016@ZenIV.linux.org.uk>
 <CA+55aFwoWT-0A_KTkXMkNqOy8hc=YmouTMBgWUD_z+8qYPphjA@mail.gmail.com>
 <20140212040358.GA25327@redhat.com>
 <20140212042215.GN18016@ZenIV.linux.org.uk>
 <20140212054043.GB13997@dastard>
 <CA+55aFxy2t7bnCUc-DhhxYxsZ0+GwL9GuQXRYtE_VzqZusmB9A@mail.gmail.com>
 <20140212071829.GE13997@dastard>
 <20140214002427.GN13997@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140214002427.GN13997@dastard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 14, 2014 at 11:24:27AM +1100, Dave Chinner wrote:
 
 > > I can fix this one easily - we already have a workqueue for doing
 > > async log pushes (will split the stack between xlog_cil_force_lsn
 > > and xlog_cil_push), but the reason we haven't used it for synchronous
 > > log forces is that screws up fsync performance on CFQ. We don't
 > > recommend CFQ with XFS anyway, so I think I'll make this change
 > > anyway.
 > 
 > Dave, the patch below should chop off the stack usage from
 > xfs_log_force_lsn() issuing IO by deferring it to the CIL workqueue.
 > Can you given this a run?

Looks like it's survived an overnight run..

	Dave
