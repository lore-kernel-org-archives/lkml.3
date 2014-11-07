Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752838AbaKGVXG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 16:23:06 -0500
Received: from mail-qg0-f51.google.com ([209.85.192.51]:45526 "EHLO
	mail-qg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751766AbaKGVXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 16:23:01 -0500
From: Paul Moore <paul@paul-moore.com>
To: David Howells <dhowells@redhat.com>
Cc: linux-unionfs@vger.kernel.org, selinux@tycho.nsa.gov,
        linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] Security: Provide copy-up security hooks for unioned files
Date: Fri, 07 Nov 2014 16:22:58 -0500
Message-ID: <2455443.WUExuKDC0I@sifl>
User-Agent: KMail/4.14.2 (Linux/3.16.7-gentoo; KDE/4.14.2; x86_64; ; )
In-Reply-To: <20141105154228.2555.55814.stgit@warthog.procyon.org.uk>
References: <20141105154217.2555.578.stgit@warthog.procyon.org.uk> <20141105154228.2555.55814.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, November 05, 2014 03:42:28 PM David Howells wrote:
> Provide two new security hooks for use with security files that are used
> when a file is copied up between layers:
> 
>  (1) security_inode_copy_up().  This is called so that the security label on
> the destination file can be set appropriately.
> 
>  (2) security_inode_copy_up_xattr().  This is called so that each xattr
> being copied up can be vetted - including modification and discard.

This didn't occur to me earlier, but we may want to pick a different phrase to 
use instead of "copy_up" as that has a special meaning for some security/MLS 
folks (although strangely enough, I suspect most of these copy-on-write 
operations will be "copy up" in the MLS sense of the word).

How about "security_inode_copy_overlay" or something like that?

> + * @inode_copy_up_xattr:
> + *	Filter/modify the xattrs being copied up when a unioned file is 
> ...copied
> + *	up from a lower layer to the union/overlay layer.
> + *	@src indicates the file that is being copied up.
> + *	@dst indicates the file that has being created by the copy up.
> + *	@name indicates the name of the xattr.
> + *	@value, *@size indicate the payload of the xattr.
> + *	Returns 0 to accept the xattr, 1 to discard the xattr or a negative
> + *	error code to abort the copy up.  The xattr buffer must be at least
> + *	XATTR_SIZE_MAX in capacity and the contents may be modified and 
> ....*@size
> + *	changed appropriately.

Just so I'm clean, if the LSM wanted to modify the xattr it would modify 
@value/@size and return 0?

-- 
paul moore
www.paul-moore.com

