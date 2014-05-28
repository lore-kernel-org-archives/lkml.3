Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754066AbaE1HgY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 03:36:24 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:52085 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004AbaE1HgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 03:36:23 -0400
Date: Wed, 28 May 2014 09:36:18 +0200
From: Seth Forshee <seth.forshee@canonical.com>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-kernel@vger.kernel.org, lxc-devel@lists.linuxcontainers.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        "Michael H. Warfield" <mhw@wittsend.com>, Marian Marinov <mm@1h.com>,
        Eric Biederman <ebiederm@xmission.com>,
        Richard Weinberger <richard.weinberger@gmail.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Michael J Coss <michael.coss@alcatel-lucent.com>
Subject: Re: [RFC PATCH 1/2] loop: Add loop filesystem
Message-ID: <20140528073618.GB19433@ubuntu-mba51>
Mail-Followup-To: Randy Dunlap <rdunlap@infradead.org>,
	linux-kernel@vger.kernel.org, lxc-devel@lists.linuxcontainers.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	James Bottomley <James.Bottomley@HansenPartnership.com>,
	Serge Hallyn <serge.hallyn@ubuntu.com>,
	"Michael H. Warfield" <mhw@wittsend.com>,
	Marian Marinov <mm@1h.com>, Eric Biederman <ebiederm@xmission.com>,
	Richard Weinberger <richard.weinberger@gmail.com>,
	Andy Lutomirski <luto@amacapital.net>,
	Michael J Coss <michael.coss@alcatel-lucent.com>
References: <1401227936-15698-1-git-send-email-seth.forshee@canonical.com>
 <1401227936-15698-2-git-send-email-seth.forshee@canonical.com>
 <53851835.3060706@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53851835.3060706@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2014 at 03:56:53PM -0700, Randy Dunlap wrote:
> On 05/27/2014 02:58 PM, Seth Forshee wrote:
> > Add limited capability for use of loop devices in containers via
> > a loopfs psuedo fs. When mounted this filesystem will contain
> > only a loop-control device node. This can be used to request free
> > loop devices which will be "owned" by that mount. Device nodes
> > appear automatically for these devices, and the same device will
> > not be given to another loopfs mount. Privileged loop ioctls
> > (for encrypted loop) will be allowed within the namespace which
> > mounted the loopfs.
> > 
> > Privileged block ioctls are not permitted, so features such as
> > partitions are not supported for unprivileged users.
> > 
> > Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
> > ---
> >  drivers/block/loop.c       | 110 +++++++++++---
> >  drivers/block/loop.h       |   2 +
> >  fs/Makefile                |   1 +
> >  fs/loopfs/Makefile         |   6 +
> >  fs/loopfs/inode.c          | 349 +++++++++++++++++++++++++++++++++++++++++++++
> >  include/linux/loopfs.h     |  46 ++++++
> >  include/uapi/linux/magic.h |   1 +
> >  7 files changed, 495 insertions(+), 20 deletions(-)
> >  create mode 100644 fs/loopfs/Makefile
> >  create mode 100644 fs/loopfs/inode.c
> >  create mode 100644 include/linux/loopfs.h
> > 
> 
> > diff --git a/fs/loopfs/Makefile b/fs/loopfs/Makefile
> > new file mode 100644
> > index 000000000000..01aedfb2f841
> > --- /dev/null
> > +++ b/fs/loopfs/Makefile
> > @@ -0,0 +1,6 @@
> > +#
> > +# Makefile for the loopfs virtual filesystem
> > +#
> > +
> > +obj-$(CONFIG_BLK_DEV_LOOP)		+= loopfs.o
> > +loopfs-$(CONFIG_BLK_DEV_LOOP)		:= inode.o
> 
> I guess that you need to update the BLK_DEV_LOOP entry in
> drivers/block/Kconfig to mention this?

Sure, I'll do that.

