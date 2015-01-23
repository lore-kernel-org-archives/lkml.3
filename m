Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755847AbbAWR1u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 12:27:50 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:51834 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755525AbbAWR1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 12:27:47 -0500
Date: Fri, 23 Jan 2015 09:27:46 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Keith Busch <keith.busch@intel.com>
Cc: Matthew Wilcox <willy@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-nvme@lists.infradead.org, Yan Liu <yan@purestorage.com>
Subject: Re: [PATCH 1/1] NVMe: Do not take nsid while a passthrough IO
 command is being issued via a block device file descriptor
Message-ID: <20150123172745.GA28005@infradead.org>
References: <1421971328-5065-1-git-send-email-yan@purestorage.com>
 <20150123075708.GA17232@infradead.org>
 <alpine.LNX.2.00.1501231451380.15481@localhost.lm.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1501231451380.15481@localhost.lm.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 23, 2015 at 04:22:02PM +0000, Keith Busch wrote:
> The namespace id should be enforced on block devices, but is there a
> problem allowing arbitrary commands through the management char device?
> I have a need for a pure passthrough, but the proposed patch requires
> a matching namespace id all the time.
> 
> I wrote and tested the one below to override nsid on block devices,
> but doesn't require a visible namespace through the management device.

Allowing requests to differetn namespaces through the admin interface
doesn't sound too horrible in general, but I still don't like your patch
below.  Instead of allocating another queue that allows arbitrary nsids
we should simply look up the namespace when sent through the admin device,
and still reject it if the namespace isn't valid.  If a namespaces
is marked hidden we should still create a device for it in Linux,
as that whole concept of hiding a namespace is silly.
