Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757792Ab3HHMRz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 08:17:55 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:47896 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756141Ab3HHMRx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 08:17:53 -0400
Date: Thu, 8 Aug 2013 05:17:47 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Dilger, Andreas" <andreas.dilger@intel.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        Xiong Zhou <jencce.kernel@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peng Tao <bergwolf@gmail.com>, Paul Bolle <pebolle@tiscali.nl>,
        Jiri Kosina <trivial@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>
Subject: Re: [PATCH v2] staging/lustre: lloop depends on BLOCK
Message-ID: <20130808121747.GA5372@infradead.org>
References: <20130802104930.GB1718@infradead.org>
 <CE26E579.5A0ED%andreas.dilger@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CE26E579.5A0ED%andreas.dilger@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 07, 2013 at 07:45:17AM +0000, Dilger, Andreas wrote:
> The problem still remains that the kernel loop driver eventually depends on
> a local block device for the pages/bios to be written.  The Lustre lloop
> driver bypasses the VFS and block layer to generate RPCs from the submitted
> pages to RDMA over the network without a data copy.

No, it doesn't.  It still consumes bios just like the regular loop
driver.

Besides missing all kinds of fixes from years of kernel development the
only difference is that it takes a lustre-specific shortcut into the
direct I/O code instead of going through the pagecache.

The patch series I've pointed you to does exactly that in a generic way
and thus superceeds the lloop driver fully.

In case my previous reference was a bit to vague the series starts at:

	[PATCH V8 00/33] loop: Issue O_DIRECT aio using bio_vec

please take a look and make sure to review it in case you see any
shortcomings.

