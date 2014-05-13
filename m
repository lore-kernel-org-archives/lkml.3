Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760997AbaEMOoF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 10:44:05 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:64003 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760945AbaEMOn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 10:43:59 -0400
Date: Tue, 13 May 2014 16:43:54 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: Christoph Hellwig <hch@infradead.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Stephen Rothwell <sfr@au1.ibm.com>
Subject: Re: [PATCH] vfs: add noreplace_rename2()
Message-ID: <20140513144354.GG17233@tucsk.piliscsaba.szeredi.hu>
References: <20140513135622.GB17233@tucsk.piliscsaba.szeredi.hu>
 <20140513140557.GA30660@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140513140557.GA30660@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2014 at 07:05:57AM -0700, Christoph Hellwig wrote:
> On Tue, May 13, 2014 at 03:56:22PM +0200, Miklos Szeredi wrote:
> > From: Miklos Szeredi <mszeredi@suse.cz>
> > 
> > RENAME_NOREPLACE is trivial to implement for most filesystems.  This adds a
> > helper that can be assigned to ->rename2() and calls ->rename().
> > 
> > Only suitable for local filesystems, i.e. those that cannot have files
> > "spontaneously" appear (like NFS and friends).
> 
> I don't like this approach at all.  Please bite the bullet and rename
> ->rename2 to ->rename and all the proper rejecting of non-supported
> flags intstead of further locking down the duplication.

There was pushback from Stephen Rothwell as well as Al, which is why it ended up
being a separate op.

I was always hoping to merge the two, but until there's clear indication that
it's going to get accepted, there's no point in me preparing and maintaining
such a patch.

Thanks,
Miklos
