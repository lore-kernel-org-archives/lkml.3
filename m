Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756013AbaD2XGc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 19:06:32 -0400
Received: from imap.thunk.org ([74.207.234.97]:40635 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755874AbaD2XGb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 19:06:31 -0400
Date: Tue, 29 Apr 2014 19:06:24 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Serge Hallyn <serge.hallyn@ubuntu.com>, Marian Marinov <mm@1h.com>,
        containers@lists.linux-foundation.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        lxc-devel <lxc-devel@lists.sourceforge.net>
Subject: Re: ioctl CAP_LINUX_IMMUTABLE is checked in the wrong namespace
Message-ID: <20140429230624.GA28966@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Andy Lutomirski <luto@amacapital.net>,
	Serge Hallyn <serge.hallyn@ubuntu.com>, Marian Marinov <mm@1h.com>,
	containers@lists.linux-foundation.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	lxc-devel <lxc-devel@lists.sourceforge.net>
References: <535FADDA.2070803@1h.com>
 <20140429183534.GB19325@thunk.org>
 <20140429185251.GA27969@ubuntumail>
 <53601E5B.5050004@1h.com>
 <20140429220234.GC28410@ubuntumail>
 <536026B3.1020905@1h.com>
 <20140429222913.GD28410@ubuntumail>
 <53602B84.1020304@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53602B84.1020304@mit.edu>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2014 at 03:45:24PM -0700, Andy Lutomirski wrote:
> 
> Wait, what?
> 
> Inodes aren't owned by user namespaces; they're owned by users.  And any
> user can arrange to have a user namespace in which they pass an
> inode_capable check on any inode that they own.
> 
> Presumably there's a reason that CAP_SYS_IMMUTABLE is needed.  If this
> gets merged, then it would be better to just drop CAP_SYS_IMMUTABLE
> entirely.
> 
> Nacked-by: Andy Lutomirski <luto@amacapital.net>

Right, but you can't set a mapping in a child namespace unless you
have CAP_SETUID in the parent namespace, right?  Otherwise user
namespaces are completely broken from a security perspective, since
inode_capable() could never do the right thing.

Personally, reading how user namespaces work, it makes the hair rise
on the back of my neck.  I'm not sure the concept works at all from a
security perspective, but hey, I'm not using user namespaces, and some
fool thought it was worth merging.  :-)

						- Ted


