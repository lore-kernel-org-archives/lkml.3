Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753919Ab3KTNik (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 08:38:40 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:46221 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727Ab3KTNih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 08:38:37 -0500
Date: Wed, 20 Nov 2013 05:38:33 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Chinmay V S <cvs268@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        Stefan Priebe - Profihost AG <s.priebe@profihost.ag>,
        linux-fsdevel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        LKML <linux-kernel@vger.kernel.org>, matthew@wil.cx
Subject: Re: Why is O_DSYNC on linux so slow / what's wrong with my SSD?
Message-ID: <20131120133833.GA16034@infradead.org>
References: <528CA73B.9070604@profihost.ag>
 <20131120125446.GA6284@infradead.org>
 <CAK-9PRAManphkxT3ub0DfW8hx=xbq+ZeqUB0E0CEnFTfF7AQuw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK-9PRAManphkxT3ub0DfW8hx=xbq+ZeqUB0E0CEnFTfF7AQuw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 20, 2013 at 07:04:15PM +0530, Chinmay V S wrote:
> Note that SYNC/DSYNC on a filesystem(eg. ext2/3/4) does NOT issue a
> CMD_FLUSH. The "SYNC" via filesystem, simply guarantees that the data
> is sent to the disk and not really flushed to the disk.

While this used to be the case for ext2 and ext3 this has never been
true for the modern filesystem, and has been fixed for ext3 quite
a while ago.

