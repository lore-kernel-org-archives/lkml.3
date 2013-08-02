Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755747Ab3HBKsg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 06:48:36 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:48743 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755693Ab3HBKse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 06:48:34 -0400
Date: Fri, 2 Aug 2013 03:48:32 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>,
        Zach Brown <zab@zabbo.net>
Subject: Re: [PATCH V8 00/33] loop: Issue O_DIRECT aio using bio_vec
Message-ID: <20130802104832.GA1718@infradead.org>
References: <1374774659-13121-1-git-send-email-dave.kleikamp@oracle.com>
 <20130801085831.GA21552@infradead.org>
 <51FA5CD8.2090807@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51FA5CD8.2090807@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 01, 2013 at 08:04:24AM -0500, Dave Kleikamp wrote:
> On 08/01/2013 03:58 AM, Christoph Hellwig wrote:
> > What should be added to this support is to move the swap over nfs code
> > over to this interface instead of the utterly bogus
> > KERNEL_READ/KERNEL_WRITE hacks that were added for it.
> 
> That's patch 24/33 nfs: simplify swap

Sorry, missed it somehow.  Thanks for doing this work, and removing that
wart alone is absolutely worth merging this patchset.

For the future we should look into enabling this for swap in general
and removing the slightly less cludge currently used for swapfiles.

Especially btrfs should benefit greatly from that.
