Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756742Ab3BAQ1G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 11:27:06 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:46525 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756385Ab3BAQ1F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 11:27:05 -0500
Date: Fri, 1 Feb 2013 11:26:58 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: chenggang.qin@gmail.com
Cc: linux-kernel@vger.kernel.org, chenggang <chenggang.qcg@alibaba-inc.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] Tracepoint: Add 'file name' as a parameter of tracepoint
 events ext4:ext4_direct_IO_enter&ext4:ext4_direct_IO_exit
Message-ID: <20130201162657.GB5228@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>, chenggang.qin@gmail.com,
	linux-kernel@vger.kernel.org,
	chenggang <chenggang.qcg@alibaba-inc.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Ingo Molnar <mingo@redhat.com>
References: <y>
 <510be15d.29bf440a.56c6.ffffb82e@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <510be15d.29bf440a.56c6.ffffb82e@mx.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 01, 2013 at 11:37:38PM +0800, chenggang.qin@gmail.com wrote:
> 
> Many database systems use their own page cache subsystems and use
> the direct IO to access the disks. Sometimes, the system engineers
> want to know the misses rate of the database system's page
> cache. They also require to know what files are accessed by the
> target processes with the direct IO method. These requirements can
> be satisfied by recording the database's file access behavior
> through the way of direct IO. So, we add 'file name' as a parameter
> of tracepoint events: ext4:ext4_direct_IO_enter &
> ext4:ext4_direct_IO_exit.

The device and inode number isn't sufficient?  Database files tend to
be long-lasting, so it shouldn't be hard to use the inode number.

My concern with putting the filename into the string buffer is that it
will seriously bloat the size of the event that will end up getting
dropped into the ring buffer.  

Regards,

						- Ted
