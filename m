Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752105AbaLQSxF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 13:53:05 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:35184 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323AbaLQSxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 13:53:01 -0500
Date: Wed, 17 Dec 2014 10:52:56 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Omar Sandoval <osandov@osandov.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Jan Kara <jack@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Trond Myklebust <trond.myklebust@primarydata.com>,
        David Sterba <dsterba@suse.cz>, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-nfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/8] swap: lock i_mutex for swap_writepage direct_IO
Message-ID: <20141217185256.GA5657@infradead.org>
References: <a59510f4552a5d3557958cdb0ce1b23b3abfc75b.1418618044.git.osandov@osandov.com>
 <20141215162705.GA23887@quack.suse.cz>
 <20141215165615.GA19041@infradead.org>
 <20141215221100.GA4637@mew>
 <20141216083543.GA32425@infradead.org>
 <20141216085624.GA25256@mew>
 <20141217080610.GA20335@infradead.org>
 <20141217082020.GH22149@ZenIV.linux.org.uk>
 <20141217082437.GA9301@infradead.org>
 <20141217145832.GA3497@mew>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141217145832.GA3497@mew>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2014 at 06:58:32AM -0800, Omar Sandoval wrote:
> See my previous message. If we use O_DIRECT on the original open, then
> filesystems that implement bmap but not direct_IO will no longer work.
> These are the ones that I found in my tree:

In the long run I don't think they are worth keeping.  But to keep you
out of that discussion you can just try an open without O_DIRECT if the
open with the flag failed.
