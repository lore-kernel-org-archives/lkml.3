Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752968AbaE0RwB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 13:52:01 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:50672 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823AbaE0RwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 13:52:00 -0400
Date: Tue, 27 May 2014 18:51:57 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] vfs: fix vmplice_to_user()
Message-ID: <20140527175157.GU18016@ZenIV.linux.org.uk>
References: <20140527144116.GK17233@tucsk.piliscsaba.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140527144116.GK17233@tucsk.piliscsaba.szeredi.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2014 at 04:41:16PM +0200, Miklos Szeredi wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> Commit 6130f5315ee8 "switch vmsplice_to_user() to copy_page_to_iter()" in
> v3.15-rc1 broke vmsplice(2).
> 
> This patch fixes two bugs:
> 
>  - count is not initialized to a proper value, which resulted in no data
>    being copied
> 
>  - if rw_copy_check_uvector() returns negative then the iov might be leaked.
> 
> Tested OK.

Applied, will push tonight.
