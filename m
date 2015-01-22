Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753332AbbAVPti (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 10:49:38 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:41260 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888AbbAVPtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 10:49:35 -0500
Date: Thu, 22 Jan 2015 07:49:30 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Keith Busch <keith.busch@intel.com>
Cc: Christoph Hellwig <hch@infradead.org>, Yan Liu <yan@purestorage.com>,
        Matthew Wilcox <willy@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-nvme@lists.infradead.org
Subject: Re: [PATCH 1/1] NVMe: Do not take nsid while a passthrough IO
 command is being issued via a block device file descriptor
Message-ID: <20150122154930.GA28027@infradead.org>
References: <1421886503-25276-1-git-send-email-yan@purestorage.com>
 <alpine.LNX.2.00.1501220035170.15481@localhost.lm.intel.com>
 <20150122084517.GA2093@infradead.org>
 <alpine.LNX.2.00.1501221430040.15481@localhost.lm.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1501221430040.15481@localhost.lm.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2015 at 03:21:28PM +0000, Keith Busch wrote:
> The case I considered was the "hidden" attribute in the NVMe LBA Range
> Type feature. It only indicates the storage should be hidden from the OS
> for general use, but the host may still use it for special purposes. In
> truth, the driver doesn't handle the hidden attribute very well and it
> doesn't seem like a well thought out feature in the spec anyway.

At least for Linux we should simply ignore that attribute.

> But if you really need to restrict namespace access, shouldn't that be
> enforced on the target side with reservations or similar mechanism?

Think for example about containers where we give eah container access
to a single nvme namespace, including container root access.  Here you
don't really want container A to be able to submit I/O for another
container.  A similar case exists for virtualization where we had
problems with SCSI passthrough from guests.
