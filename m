Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756422AbbAZXCK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 18:02:10 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:41977 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753521AbbAZXCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 18:02:07 -0500
Date: Mon, 26 Jan 2015 23:02:03 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 00/16 v3] tracing: Add new file system tracefs
Message-ID: <20150126230203.GT29656@ZenIV.linux.org.uk>
References: <20150126150913.653681560@goodmis.org>
 <20150126193049.GN29656@ZenIV.linux.org.uk>
 <20150126154259.5e650d32@gandalf.local.home>
 <20150126214658.GQ29656@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150126214658.GQ29656@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 26, 2015 at 09:46:58PM +0000, Al Viro wrote:
> On Mon, Jan 26, 2015 at 03:42:59PM -0500, Steven Rostedt wrote:
> > On Mon, 26 Jan 2015 19:30:49 +0000
> > Al Viro <viro@ZenIV.linux.org.uk> wrote:
> > 
> > > You are still fighting an inconvenient API, but now it's not debugfs one -
> > > it's your copy thereof.  Why not give your instances/ an inode_operations
> > > of its own?  One with ->mkdir() and ->rmdir(), leaving all other directories
> > > as-is.  That way you don't need the secondary methods at all.  And sure,
> > > debugfs_create_dir() grabs ->i_mutex on parent, making you drop that in
> > > your ->mkdir() if you want to call it.  But now you are not talking to it -
> > > just to your own code, where you are free to change the calling conventions,
> > > making it caller's responsibility to get that ->i_mutex.  The same goes for
> > > the rmdir side...
> > 
> > The vfs layer grabs the i_mutex, which needs to be dropped.
> 
> What for?  Just keep it through your instance_mkdir/instance_rmdir and be
> done with that.  Sure, it means that you need variants of file/directory
> creation/removal primitives that would assume that parent is already locked
> by caller (and would leave unlocking to the caller as well).  So add them...

BTW, could you merge vfs.git#debugfs_automount, rather than copy the commits
into your branch?  Bloody inconvenient as it is...
