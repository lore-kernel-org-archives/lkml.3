Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754951Ab3CAAhp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 19:37:45 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:43879 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754737Ab3CAAhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 19:37:43 -0500
Date: Fri, 1 Mar 2013 00:37:41 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Wolfram Sang <wsa@the-dreams.de>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH] shmem: fix build regression
Message-ID: <20130301003740.GS4503@ZenIV.linux.org.uk>
References: <1362093459-24608-1-git-send-email-wsa@the-dreams.de>
 <20130228163111.5d61d391.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130228163111.5d61d391.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2013 at 04:31:11PM -0800, Andrew Morton wrote:

> -#ifndef CONFIG_MMU
> -	error = ramfs_nommu_expand_for_mapping(inode, size);
> -	res = ERR_PTR(error);
> -	if (error)
> +
> +	res = ERR_PTR(ramfs_nommu_expand_for_mapping(inode, size));
> +	if (IS_ERR(res))
>  		goto put_dentry;

My variant of fix leaves #ifndef in place and makes the check if (res) goto...
I'm not opposed to killing the ifndef, but I think it should be a separate
patch.
