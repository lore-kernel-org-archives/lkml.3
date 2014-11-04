Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817AbaKDJmU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 04:42:20 -0500
Received: from verein.lst.de ([213.95.11.211]:50969 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751649AbaKDJmS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 04:42:18 -0500
Date: Tue, 4 Nov 2014 10:42:15 +0100
From: Christoph Hellwig <hch@lst.de>
To: Jan Kara <jack@suse.cz>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, hch@lst.de,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] blockdev: Don't use i_devices inode field
Message-ID: <20141104094215.GA17722@lst.de>
References: <1414008853-13200-1-git-send-email-jack@suse.cz> <1414008853-13200-2-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414008853-13200-2-git-send-email-jack@suse.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2014 at 10:14:10PM +0200, Jan Kara wrote:
> Block devices use i_devices inode field to track all inodes that
> reference a particular block device (through i_bdev field) so that this
> reference can be removed when block device inode is being evicted from
> memory. However we get a reference to the block device (in fact an inode
> holding the block device structure) when setting up i_bdev in
> bd_acquire() and we drop the reference only in bd_forget() when clearing
> i_bdev. Thus inode holding block device structure can be evicted only
> after all inodes referencing it are evicted and the whole excercise with
> i_devices is pointless. Remove the i_devices handling.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
