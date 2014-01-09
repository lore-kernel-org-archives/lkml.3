Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755496AbaAIXLH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 18:11:07 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:36975 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752382AbaAIXLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 18:11:04 -0500
Date: Thu, 9 Jan 2014 15:10:53 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Dave Chinner <david@fromorbit.com>,
        linux-fsdevel@vger.kernel.org,
        James Morris <james.l.morris@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stephen Smalley <sds@tycho.nsa.gov>, "Theodore Ts'o" <tytso@mit.edu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Eric Paris <eparis@parisplace.org>, stable <stable@vger.kernel.org>,
        Paul Moore <paul@paul-moore.com>, LKML <linux-kernel@vger.kernel.org>,
        Matthew Wilcox <matthew@wil.cx>, Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] vfs: Fix possible NULL pointer dereference in
 inode_permission()
Message-ID: <20140109231053.GP10038@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140109162731.12500986@gandalf.local.home>
 <20140109214239.GD29910@parisc-linux.org>
 <20140109165012.391db81e@gandalf.local.home>
 <20140109223127.GM10323@ZenIV.linux.org.uk>
 <CA+55aFzCTPYEQCPnLBi1CwmMTocVqCFiCuJ391HkVx1CMw61ug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzCTPYEQCPnLBi1CwmMTocVqCFiCuJ391HkVx1CMw61ug@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14010923-6688-0000-0000-0000055F6C00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 10, 2014 at 06:41:03AM +0800, Linus Torvalds wrote:
> I think the sane short term fix is to make the kfree() of the i_security
> member be a rcu free, and not clear the member.

Interesting use case.  ;-)

							Thanx, Paul

> Not pretty, but should did this case..
> 
>      Linus
> 
> On Jan 10, 2014 6:31 AM, "Al Viro" <viro@zeniv.linux.org.uk> wrote:
> >
> > iput() definitely can sleep (that's when actual truncation and inode
> > freeing is done for opened-and-unlinked files - on the final iput() after
> > close()), but that' irrelevant here - fsnotify_delete_inode() grabs
> > a bunch of mutexes, which makes calling it from rcu callback no-go.

