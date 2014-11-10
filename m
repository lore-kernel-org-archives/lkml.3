Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752313AbaKJPsF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 10:48:05 -0500
Received: from mail-qc0-f179.google.com ([209.85.216.179]:40759 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591AbaKJPsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 10:48:03 -0500
From: Paul Moore <paul@paul-moore.com>
To: David Howells <dhowells@redhat.com>
Cc: linux-unionfs@vger.kernel.org, selinux@tycho.nsa.gov,
        linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/7] SELinux: Stub in copy-up handling
Date: Mon, 10 Nov 2014 10:47:59 -0500
Message-ID: <3673621.p2j5b7B8ca@sifl>
User-Agent: KMail/4.14.2 (Linux/3.16.7-gentoo; KDE/4.14.2; x86_64; ; )
In-Reply-To: <3177.1415398128@warthog.procyon.org.uk>
References: <1791526.rYj1Ea3vWT@sifl> <20141105154248.2555.15813.stgit@warthog.procyon.org.uk> <3177.1415398128@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, November 07, 2014 10:08:48 PM David Howells wrote:
> Paul Moore <paul@paul-moore.com> wrote:
> > > +static int selinux_inode_copy_up_xattr(struct dentry *src, struct
> > > dentry
> > > ...*dst,
> > > +				       const char *name, void *value, size_t *size)
> > > +{
> > > +	if (strcmp(name, XATTR_NAME_SELINUX) == 0)
> > > +		return 1; /* Discard */
> > 
> > I understand that this is just a stub, but I we need to discuss this at
> > some point and I figure better in this patch than elsewhere where it
> > might get lost.
> > 
> > For the docker, context= mount use case (similar to SELinux/sVirt)
> > dropping
> > the SELinux xattr is probably an okay behavior.  However, I would expect
> > that ultimately this is something we would want to control by policy
> > and/or the presence of a context= label.
> 
> The problem is that the label you actually want has already been set and you
> have to be careful not to overwrite it.
> 
> The other hook (->inode_copy_up) is called first to label the destination
> inode - and that has access to the source file also so it can label the
> destination with consideration of the attributes on the source.  Normally,
> the attributes on the source will be in memory attached to the source
> inode, I would imagine.

Hmmm, I guess I need to take a closer look at how overlayfs creates files 
during a copy on write.

-- 
paul moore
www.paul-moore.com

