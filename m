Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755951Ab3G2Vvs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 17:51:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14806 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754613Ab3G2Vvr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 17:51:47 -0400
Date: Mon, 29 Jul 2013 14:51:41 -0700
From: Zach Brown <zab@redhat.com>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Lukas Czerner <lczerner@redhat.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH] truncate: drop 'oldsize' truncate_pagecache() parameter
Message-ID: <20130729215141.GE32145@lenny.home.zabbo.net>
References: <1375099760-7614-1-git-send-email-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375099760-7614-1-git-send-email-kirill.shutemov@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> @@ -50,7 +50,7 @@ static void adfs_write_failed(struct address_space *mapping, loff_t to)
>  	struct inode *inode = mapping->host;
>  
>  	if (to > inode->i_size)
> -		truncate_pagecache(inode, to, inode->i_size);
> +		truncate_pagecache(inode, inode->i_size);
>  }

All these _write_failed() boiler plate functions still technically use
'to', so I *guess* they can stay :).

> @@ -226,7 +226,7 @@ int btrfs_truncate_free_space_cache(struct btrfs_root *root,
>  
>  	oldsize = i_size_read(inode);
>  	btrfs_i_size_write(inode, 0);
> -	truncate_pagecache(inode, oldsize, 0);
> +	truncate_pagecache(inode, 0);

But after this change 'oldsize' is set but never used.  That'll generate
a warning on some versions of gcc.

Can you redo the patch with an eye to removing unused arguments and
variables further up the call stack?

- z
