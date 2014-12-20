Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752114AbaLTGBi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 01:01:38 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:60775 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbaLTGBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 01:01:36 -0500
Date: Sat, 20 Dec 2014 06:01:30 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Omar Sandoval <osandov@osandov.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Trond Myklebust <trond.myklebust@primarydata.com>,
        Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-nfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ming Lei <ming.lei@canonical.com>
Subject: Re: [PATCH v2 2/5] direct-io: don't dirty ITER_BVEC pages on read
Message-ID: <20141220060130.GA22149@ZenIV.linux.org.uk>
References: <cover.1419044605.git.osandov@osandov.com>
 <f9b69250ba0598807d96857e9b736d57e6841ba3.1419044605.git.osandov@osandov.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f9b69250ba0598807d96857e9b736d57e6841ba3.1419044605.git.osandov@osandov.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 19, 2014 at 07:18:26PM -0800, Omar Sandoval wrote:
> Reads through the iov_iter infrastructure for kernel pages shouldn't be
> dirtied by the direct I/O code.
> 
> This is based on Dave Kleikamp's and Ming Lei's previously posted
> patches.

Umm...  

> +	dio->should_dirty = !iov_iter_is_bvec(iter);

	dio->should_dirty = iter_is_iovec(iter);

perhaps?
