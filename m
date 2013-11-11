Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752390Ab3KKDVH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Nov 2013 22:21:07 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:41036 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003Ab3KKDU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Nov 2013 22:20:59 -0500
Date: Mon, 11 Nov 2013 03:20:52 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Dave Kleikamp <dave.kleikamp@oracle.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the aio-direct tree with the vfs tree
Message-ID: <20131111032052.GV13318@ZenIV.linux.org.uk>
References: <20131111125328.ef8f0641ccdbb28a0d0564da@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131111125328.ef8f0641ccdbb28a0d0564da@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 11, 2013 at 12:53:28PM +1100, Stephen Rothwell wrote:
> Hi Dave,
> 
> Today's linux-next merge of the aio-direct tree got a conflict in
> drivers/mtd/nand/nandsim.c between commit 72c2d5319200 ("file->f_op is
> never NULL...") from the vfs tree and commit dd458300240b ("fs: create
> file_readable() and file_writable() functions") from the aio-direct tree.
> 
> I fixed it up (I just used the aio-direct tree version) and can carry the
> fix as necessary (no action is required).

Hrm...  Pity that this thing sits in the middle of aio-direct; it would
make more sense to take it in vfs.git ;-/  There are several more places
where we get the conflicts of the same sort.

FWIW, I have two nitpicks with these helpers:
	a) checks for NULL argument do not belong there
	b) please, please, do not breed more instances of that stupid
'filp' thing; AFAICS, it's an example of really bad taste on part of
AST - it stands for 'file pointer' and yes, it's a minixism.  Linus has
used that naming convention in 0.01 and it spread when people copied
stuff.  There's a perfectly good identifier - 'file'...
