Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751669Ab3COEoT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 00:44:19 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:51474 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031Ab3COEoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 00:44:17 -0400
Date: Fri, 15 Mar 2013 04:44:11 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, hch@infradead.org, apw@canonical.com,
        nbd@openwrt.org, neilb@suse.de, jordipujolp@gmail.com,
        ezk@fsl.cs.sunysb.edu, dhowells@redhat.com, sedat.dilek@googlemail.com,
        mszeredi@suse.cz
Subject: Re: [PATCH 0/9] overlay filesystem: request for inclusion (v17)
Message-ID: <20130315044411.GW21522@ZenIV.linux.org.uk>
References: <1363184193-1796-1-git-send-email-miklos@szeredi.hu>
 <20130313160854.54ac0491044371b4db214698@linux-foundation.org>
 <CAJfpeguvhJaoSBDKEXoJFn_C=52aXbC9L2ALJvp6ekwEGyQX_g@mail.gmail.com>
 <20130315012541.GU21522@ZenIV.linux.org.uk>
 <19058.1363320936@jrobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19058.1363320936@jrobl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 15, 2013 at 01:15:36PM +0900, J. R. Okajima wrote:

> +- whiteout is hardlinked in order to reduce the consumption of inodes
> +  on branch

*blink* Whiteouts have no inodes at all.  Filesystem has an additional
kind of directory entries, recognizable as whiteouts.  How they are
done is up to filesystem in question.

> +- kernel thread for removing the dir who has a plenty of whiteouts

Again, implementation detail for individual filesystem.

> +The whiteout in aufs is very similar to Unionfs's. That is represented
> +by its filename. UnionMount takes an approach of a file mode, but I am
> +afraid several utilities (find(1) or something) will have to support it.

Why the devil should find(1) even see them?

I really don't believe that it's a good idea to try making them fs-agnostic;
it's an implementation detail of filesystem, with things like "is this
directory empty?" very much belonging to the fs in question...

I don't know; maybe it's my experience of dealing with umsdos that has badly
soured me on that kind of approach, but IME this kind of schemes tend to
be brittle as hell ;-/
