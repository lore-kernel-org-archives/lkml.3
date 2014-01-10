Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755293AbaAJAJ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 19:09:27 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:40168 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754203AbaAJAJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 19:09:24 -0500
Date: Fri, 10 Jan 2014 00:09:18 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Eric Paris <eparis@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Dave Chinner <david@fromorbit.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        James Morris <james.l.morris@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stephen Smalley <sds@tycho.nsa.gov>, "Theodore Ts'o" <tytso@mit.edu>,
        stable <stable@vger.kernel.org>, Paul Moore <paul@paul-moore.com>,
        LKML <linux-kernel@vger.kernel.org>, Matthew Wilcox <matthew@wil.cx>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] vfs: Fix possible NULL pointer dereference in
 inode_permission()
Message-ID: <20140110000918.GO10323@ZenIV.linux.org.uk>
References: <20140109162731.12500986@gandalf.local.home>
 <20140109214239.GD29910@parisc-linux.org>
 <20140109165012.391db81e@gandalf.local.home>
 <20140109223127.GM10323@ZenIV.linux.org.uk>
 <CA+55aFzCTPYEQCPnLBi1CwmMTocVqCFiCuJ391HkVx1CMw61ug@mail.gmail.com>
 <20140109182523.5b50131f@gandalf.local.home>
 <20140109182756.17abaaa8@gandalf.local.home>
 <1389310626.15209.92.camel@localhost>
 <CA+55aFzd2nw=JU4s0u=PJbATK0bwhm0kot3zRH=anLLT6THRFQ@mail.gmail.com>
 <20140110000642.GN10323@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140110000642.GN10323@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 10, 2014 at 12:06:42AM +0000, Al Viro wrote:

> and hit it whenever full ->free_inode is there and ->destroy_inode isn't.

Grr... "whenever ->free_inode is there and full ->destroy_inode isn't".
Apologies for sloppy editing...
