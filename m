Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023AbaEMP3W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 11:29:22 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:55850 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752845AbaEMP3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 11:29:15 -0400
Date: Tue, 13 May 2014 08:29:11 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Stephen Rothwell <sfr@au1.ibm.com>
Subject: Re: [PATCH] vfs: add noreplace_rename2()
Message-ID: <20140513152911.GB15679@infradead.org>
References: <20140513135622.GB17233@tucsk.piliscsaba.szeredi.hu>
 <20140513140557.GA30660@infradead.org>
 <20140513144354.GG17233@tucsk.piliscsaba.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140513144354.GG17233@tucsk.piliscsaba.szeredi.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2014 at 04:43:54PM +0200, Miklos Szeredi wrote:
> There was pushback from Stephen Rothwell as well as Al, which is why it ended up
> being a separate op.

I can see some reason to not want it for an inintial merged, but having
two parallel methods in the long run is a bad design.

> I was always hoping to merge the two, but until there's clear indication that
> it's going to get accepted, there's no point in me preparing and maintaining
> such a patch.

How about we slowly work towards doing the right thing?

1) make vfs_rename call ->rename2 if it exists instead of ->rename
2) switch all filesystems that you're adding NOREPLACE support for to
   use ->rename2
3) see how many ->rename instances we'll have left after a few
   iterations of 2.

A default method implementation that just calls a slightly more
complicated version of the method is just useless clutter.

