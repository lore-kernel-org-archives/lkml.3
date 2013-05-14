Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756248Ab3ENGsq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 02:48:46 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:62625 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932067Ab3ENGsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 02:48:43 -0400
Date: Tue, 14 May 2013 15:06:28 +0800
From: Zheng Liu <gnehzuil.liu@gmail.com>
To: Alexey Khoroshilov <khoroshilov@ispras.ru>, Jan Kara <jack@suse.cz>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        spruce-project@linuxtesting.org
Subject: Re: [PATCH 0/2] ext4: deadlocks after allocation failure in
 ext4_init_io_end()
Message-ID: <20130514070627.GA3025@gmail.com>
Mail-Followup-To: Alexey Khoroshilov <khoroshilov@ispras.ru>,
	Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	spruce-project@linuxtesting.org
References: <1368472093-16997-1-git-send-email-khoroshilov@ispras.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368472093-16997-1-git-send-email-khoroshilov@ispras.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 13, 2013 at 11:08:11PM +0400, Alexey Khoroshilov wrote:
> Hi, Ted!
> 
> Our tests for ext4 with targeted fault injection were stalled in Uninterruptible Sleep State 
> when they simulate a memory allocation failure in ext4_init_io_end() while it is called from 
> mpage_da_submit_io() or ext4_writepage().
> 
> It looks like the problems are that pages left locked after failure handling.
> 
> I am not completely sure that my patches take into account all required aspects, 
> but the tests are passed if the patches are applied.
> 
> Please find below syslog excerpt for the first issue.
> 
> Found by Linux File System Verification project (linuxtesting.org/spruce). 

Hi Alexey,

Thanks for fixing this.  The patch series looks good to me.  But the
commit (ext4: use io_end for multiple bios) has been reverted in dev
branch of ext4 tree.  I forward the mail to Jan to let him know your
fixes.

Regards,
                                                - Zheng
