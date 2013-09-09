Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751221Ab3IIItR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 04:49:17 -0400
Received: from [204.155.152.216] ([204.155.152.216]:45427 "EHLO shutemov.name"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750946Ab3IIItQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 04:49:16 -0400
Date: Mon, 9 Sep 2013 10:51:22 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Hillf Danton <dhillf@sina.com>
Cc: linux-mm <linux-mm@kvack.org>, linux-kernel <linux-kernel@vger.kernel.org>,
        Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Hillf Danton <dhillf@gmail.com>
Subject: Re: [patch] filemap: add missing unlock_page
Message-ID: <20130909075121.GA21419@shutemov.name>
References: <20130909081822.8D4DF428001@webmail.sinamail.sina.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130909081822.8D4DF428001@webmail.sinamail.sina.com.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 09, 2013 at 04:18:22PM +0800, Hillf Danton wrote:
> Unlock and release page before returning error.
> 
> Signed-off-by: Hillf Danton <dhillf@gmail.com>
> ---
> 
> --- a/mm/filemap.c	Mon Sep  9 15:51:28 2013
> +++ b/mm/filemap.c	Mon Sep  9 15:52:54 2013
> @@ -1844,6 +1844,7 @@ retry:
>  	}
>  	err = filler(data, page);
>  	if (err < 0) {
> +		unlock_page(page);
>  		page_cache_release(page);
>  		return ERR_PTR(err);
>  	}

NAK. filler() should unlock the page.

-- 
 Kirill A. Shutemov
