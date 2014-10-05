Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751471AbaJEDsK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2014 23:48:10 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:40042 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010AbaJEDsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2014 23:48:08 -0400
Date: Sun, 5 Oct 2014 04:48:06 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: John de la Garza <john@jjdev.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs: use kfree_rcu instead of i_callback
Message-ID: <20141005034806.GX7996@ZenIV.linux.org.uk>
References: <20141005030040.GA830@vega.jjdev.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141005030040.GA830@vega.jjdev.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 04, 2014 at 11:00:42PM -0400, John de la Garza wrote:
> Since the callback is doing nothing more than calling kfree() we can
> use kfree_rcu() instead of having to use a callback.

Except that this

> -	kmem_cache_free(inode_cachep, inode);

isn't kfree()...
