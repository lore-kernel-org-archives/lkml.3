Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932126AbaAaAbt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 19:31:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59546 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751997AbaAaAbs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 19:31:48 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <3301.1391128114@warthog.procyon.org.uk>
References: <3301.1391128114@warthog.procyon.org.uk> <3255.1391127686@warthog.procyon.org.uk> <CA+55aFwrBQJ=kVBXoo2GnBP4xoa3==6WDZfbt-u4OSxz8iQUoA@mail.gmail.com> <20140126122729.32113.19659.stgit@warthog.procyon.org.uk> <8761p1m98f.fsf@xmission.com>
Cc: dhowells@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-afs@lists.infradead.org,
        =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: Re: [PATCH] afs: proc cells and rootcell are writeable
Date: Fri, 31 Jan 2014 00:31:21 +0000
Message-ID: <3349.1391128281@warthog.procyon.org.uk>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells <dhowells@redhat.com> wrote:

> > > I think this is a pretty strong argument. Counter-arguments, anybody?
> > 
> > Yes.  CAP_DAC_READ_SEARCH.
> 
> No, it would seem unlikely it's that, but I guess there's another capability
> override because the process is owned by root.

CAP_DAC_OVERRIDE, I think.

	int generic_permission(struct inode *inode, int mask)
	{
	...
		/*
		 * Read/write DACs are always overridable.
		 * Executable DACs are overridable when there is
		 * at least one exec bit set.
		 */
		if (!(mask & MAY_EXEC) || (inode->i_mode & S_IXUGO))
			if (inode_capable(inode, CAP_DAC_OVERRIDE))
				return 0;
	...
	}

David
