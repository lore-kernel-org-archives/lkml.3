Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752671AbaKDJxH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 04:53:07 -0500
Received: from verein.lst.de ([213.95.11.211]:51049 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751496AbaKDJxB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 04:53:01 -0500
Date: Tue, 4 Nov 2014 10:52:58 +0100
From: Christoph Hellwig <hch@lst.de>
To: Jan Kara <jack@suse.cz>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, hch@lst.de,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/4] chardev: Increment cdev reference count when
	i_cdev references it
Message-ID: <20141104095258.GB17722@lst.de>
References: <1414008853-13200-1-git-send-email-jack@suse.cz> <1414008853-13200-3-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414008853-13200-3-git-send-email-jack@suse.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2014 at 10:14:11PM +0200, Jan Kara wrote:
> Currently i_cdev reference to a character device isn't accounted in the
> reference count of the character device. This then requires us to track
> all references through a list of all inodes referencing a character
> device which is somewhat clumsy and requires list_head in each inode in
> the system.
> 
> So make i_cdev a reference like any other.

Looks good.

Reviewed-by: Christoph Hellwig <hch@lst.de>

Maybe you can rename the new variable to something like to_put also?
