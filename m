Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540AbaAIW2X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 17:28:23 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:39647 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330AbaAIW2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 17:28:13 -0500
Date: Thu, 9 Jan 2014 22:28:10 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Eric Paris <eparis@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        James Morris <james.l.morris@oracle.com>,
        Paul Moore <paul@paul-moore.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        stable <stable@vger.kernel.org>, selinux@tycho.nsa.gov,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH] SELinux: Fix possible NULL pointer dereference in
 selinux_inode_permission()
Message-ID: <20140109222809.GL10323@ZenIV.linux.org.uk>
References: <20140109101932.0508dec7@gandalf.local.home>
 <CACLa4pv+EUGHO+MKj8ckhmi8YKiTNVL9pSM+DDsjg+0jbjOCcA@mail.gmail.com>
 <20140109105114.5c409fef@gandalf.local.home>
 <1389283030.15209.56.camel@localhost>
 <1389283545.15209.59.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389283545.15209.59.camel@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 09, 2014 at 11:05:45AM -0500, Eric Paris wrote:
> [adding lsm and selinux]
> 
> Am I just crazy, or was this bug discussed (and obviously not fixed)
> some time ago?
> 
> VFS can still use inodes after security_inode_free_security() was
> called...

Unrelated bug.

> > Assuming the VFS guys say that delaying __destroy_inode() is safe like
> > that, I like it better.  It also means that this is fixed for all LSMs,
> > not just SELinux...

Recall what your own code called from __destroy_inode() (fsnotify horrors)
is doing - you can't grab a mutex from RCU callback...
