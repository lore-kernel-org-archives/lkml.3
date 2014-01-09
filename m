Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754589AbaAIXZb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 18:25:31 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:48865 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751511AbaAIXZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 18:25:27 -0500
Date: Thu, 9 Jan 2014 18:25:23 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
        James Morris <james.l.morris@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stephen Smalley <sds@tycho.nsa.gov>, "Theodore Ts'o" <tytso@mit.edu>,
        Eric Paris <eparis@parisplace.org>, stable <stable@vger.kernel.org>,
        Paul Moore <paul@paul-moore.com>, LKML <linux-kernel@vger.kernel.org>,
        Matthew Wilcox <matthew@wil.cx>, Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] vfs: Fix possible NULL pointer dereference in
 inode_permission()
Message-ID: <20140109182523.5b50131f@gandalf.local.home>
In-Reply-To: <CA+55aFzCTPYEQCPnLBi1CwmMTocVqCFiCuJ391HkVx1CMw61ug@mail.gmail.com>
References: <20140109162731.12500986@gandalf.local.home>
	<20140109214239.GD29910@parisc-linux.org>
	<20140109165012.391db81e@gandalf.local.home>
	<20140109223127.GM10323@ZenIV.linux.org.uk>
	<CA+55aFzCTPYEQCPnLBi1CwmMTocVqCFiCuJ391HkVx1CMw61ug@mail.gmail.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Jan 2014 06:41:03 +0800
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> I think the sane short term fix is to make the kfree() of the i_security
> member be a rcu free, and not clear the member.

You mean my first patch?

https://lkml.org/lkml/2014/1/9/349

-- Steve

> 
> Not pretty, but should did this case..
> 
