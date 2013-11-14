Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044Ab3KNOKS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 09:10:18 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:49212 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753650Ab3KNOKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 09:10:14 -0500
Date: Thu, 14 Nov 2013 14:10:07 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Axel Lin <axel.lin@ingics.com>
Cc: Rob Landley <rob@landley.net>, Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ramfs: Fix memory leak on ramfs_fill_super error paths
Message-ID: <20131114141007.GH13318@ZenIV.linux.org.uk>
References: <1384412359.28992.3.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384412359.28992.3.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 14, 2013 at 02:59:19PM +0800, Axel Lin wrote:
> The memory leak was introduced by commit 318ceed0884
> "tidy up after d_make_root() conversion".

No memory leaks there.  Note that ->kill_sb() is called in *all*
cases, so that kfree() will be done by it just fine.

It's *not* ->put_super() - that would've been called only for superblocks
that had passed mount.  ->kill_sb() is called for *all* of them and
that often simplifies cleanup on failure exits quite nicely.
