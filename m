Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756512AbaAIXqD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 18:46:03 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:26533 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755859AbaAIXqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 18:46:00 -0500
Date: Thu, 9 Jan 2014 18:45:54 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Eric Paris <eparis@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
        James Morris <james.l.morris@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stephen Smalley <sds@tycho.nsa.gov>, "Theodore Ts'o" <tytso@mit.edu>,
        stable <stable@vger.kernel.org>, Paul Moore <paul@paul-moore.com>,
        LKML <linux-kernel@vger.kernel.org>, Matthew Wilcox <matthew@wil.cx>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] vfs: Fix possible NULL pointer dereference in
 inode_permission()
Message-ID: <20140109184554.54524159@gandalf.local.home>
In-Reply-To: <1389310626.15209.92.camel@localhost>
References: <20140109162731.12500986@gandalf.local.home>
	<20140109214239.GD29910@parisc-linux.org>
	<20140109165012.391db81e@gandalf.local.home>
	<20140109223127.GM10323@ZenIV.linux.org.uk>
	<CA+55aFzCTPYEQCPnLBi1CwmMTocVqCFiCuJ391HkVx1CMw61ug@mail.gmail.com>
	<20140109182523.5b50131f@gandalf.local.home>
	<20140109182756.17abaaa8@gandalf.local.home>
	<1389310626.15209.92.camel@localhost>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 09 Jan 2014 18:37:06 -0500
Eric Paris <eparis@redhat.com> wrote:


> > Oh wait, you said not to clear the member. Thus, the patch would look
> > like this:
> > 
> > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> 
> SMACK also needs this change somehow in smack_inode_free_security()
> 
> but at least from an SELinux PoV, I think it's quick and easy, but wrong
> for maintainability...

I agree, but for this late in the -rc window, this may be the best
thing for now. We can think of a better solution for the future.

-- Steve
