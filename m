Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755AbaAKLKw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 06:10:52 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:44103 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195AbaAKLKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 06:10:50 -0500
Date: Sat, 11 Jan 2014 03:10:45 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Jeff Liu <jeff.liu@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, fengguang.wu@intel.com,
        LKML <linux-kernel@vger.kernel.org>,
        "xfs@oss.sgi.com" <xfs@oss.sgi.com>
Subject: Re: [xfs] c91c46c12: xfstests generic/313 regression
Message-ID: <20140111111045.GA29380@infradead.org>
References: <20140110122700.GA12624@localhost>
 <52CFF402.5080409@oracle.com>
 <20140110133306.GA22918@infradead.org>
 <52CFFD1C.7050005@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52CFFD1C.7050005@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 10, 2014 at 10:01:00PM +0800, Jeff Liu wrote:
> I also thought to fix this problem in this way, however I'm not sure
> if those flags can be set back to iattr->ia_valid internally...
> 
> Otherwise, this fix looks good to me.

Nothing in the truncate or open code path (or non-size setattr for that
matter) looks at ia_valid after calling the filesystem, and they really
have no business to.

In the meantime this has passed xfstests, so I'll send it along.  Thanks
for the first fix, btw!

