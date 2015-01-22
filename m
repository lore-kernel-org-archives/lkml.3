Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752865AbbAVIpb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 03:45:31 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:54052 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752307AbbAVIpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 03:45:24 -0500
Date: Thu, 22 Jan 2015 00:45:17 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Keith Busch <keith.busch@intel.com>
Cc: Yan Liu <yan@purestorage.com>, Matthew Wilcox <willy@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org
Subject: Re: [PATCH 1/1] NVMe: Do not take nsid while a passthrough IO
 command is being issued via a block device file descriptor
Message-ID: <20150122084517.GA2093@infradead.org>
References: <1421886503-25276-1-git-send-email-yan@purestorage.com>
 <alpine.LNX.2.00.1501220035170.15481@localhost.lm.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1501220035170.15481@localhost.lm.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2015 at 12:47:24AM +0000, Keith Busch wrote:
> The IOCTL's purpose was to let someone submit completely arbitrary
> commands on IO queues. This technically shouldn't even need a namespace
> handle, but we don't have a request_queue associated to IO queues without
> one like the admin queue has. In fact, we ought to fix that so we can
> issue IO commands without namespaces.

Honestly, this sounds like a horrible idea.  As namespaces aren't really
any different from SCSI LUNs they should only be accessible through
the device associated with the namespaces, and admin commands should
only be allowed through the character device (if at all).

For these security and usability reasons we did get rid of the
SG_FLAG_LUN_INHIBIT flag in the SCSI passthrough interface, which
allowed for similar horrible things in the distant past.
