Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757873Ab3GRJWP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 05:22:15 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:52201 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753486Ab3GRJWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 05:22:14 -0400
Date: Thu, 18 Jul 2013 10:22:12 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [PATCH] f2fs: update file name in the inode block during
 f2fs_rename
Message-ID: <20130718092211.GA4165@ZenIV.linux.org.uk>
References: <1374138684-28520-1-git-send-email-jaegeuk.kim@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374138684-28520-1-git-send-email-jaegeuk.kim@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 18, 2013 at 06:11:23PM +0900, Jaegeuk Kim wrote:
> The error is reproducible by:
> 
> After this, when we retrieve the inode->i_name of test2 by dump.f2fs, we get
> test1 instead of test2.
> This is because f2fs didn't update the file name during the f2fs_rename.

Er...  Correct me if I'm wrong, but f2fs appears to support link(2) and
if rename(2) creates some problem for dump.f2fs, I would expect an
equivalent link()+unlink() combination to do the same...
