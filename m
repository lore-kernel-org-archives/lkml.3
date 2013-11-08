Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758174Ab3KHTgA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 14:36:00 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:36128 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757696Ab3KHTf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 14:35:59 -0500
Date: Fri, 8 Nov 2013 19:35:52 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
Subject: Re: linux-next: Tree for Nov 8 (various vfs)
Message-ID: <20131108193552.GQ13318@ZenIV.linux.org.uk>
References: <20131108194753.c45ecb7db2fdd59e156d8acd@canb.auug.org.au>
 <527D3215.5020909@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <527D3215.5020909@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 08, 2013 at 10:48:53AM -0800, Randy Dunlap wrote:
> vfs build errors:
> 
> fs/open.c:486:3: error: implicit declaration of function 'break_deleg_wait' [-Werror=implicit-function-declaration]
> fs/namei.c:3726:3: error: implicit declaration of function 'break_deleg_wait' [-Werror=implicit-function-declaration]
> fs/utimes.c:110:3: error: implicit declaration of function 'break_deleg_wait' [-Werror=implicit-function-declaration]

... when FILE_LOCKING isn't set.  Yes, break_deleg_wait() is not defined in
that case (and its call sites are unreachable).  Fixed and pushed...
