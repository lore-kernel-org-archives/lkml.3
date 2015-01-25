Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753782AbbAYOmX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 09:42:23 -0500
Received: from [198.137.202.9] ([198.137.202.9]:57055 "EHLO
	bombadil.infradead.org" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751953AbbAYOmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 09:42:19 -0500
Date: Sun, 25 Jan 2015 06:41:46 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Keith Busch <keith.busch@intel.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        Matthew Wilcox <willy@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-nvme@lists.infradead.org, Yan Liu <yan@purestorage.com>
Subject: Re: [PATCH 1/1] NVMe: Do not take nsid while a passthrough IO
 command is being issued via a block device file descriptor
Message-ID: <20150125144146.GA23199@infradead.org>
References: <1421971328-5065-1-git-send-email-yan@purestorage.com>
 <20150123075708.GA17232@infradead.org>
 <alpine.LNX.2.00.1501231451380.15481@localhost.lm.intel.com>
 <20150123172745.GA28005@infradead.org>
 <alpine.LNX.2.00.1501231737070.15481@localhost.lm.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1501231737070.15481@localhost.lm.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 23, 2015 at 05:50:33PM +0000, Keith Busch wrote:
> No argument against removing the hidden attribute handling, but there
> are unadvertised NSID's that have special meaning. Like NSID 0xffffffff
> means to apply a command to all namespaces. Vendor specific commands
> may have other special NSID meanings as well.

What is the practical use of those?  Just because something is
theoretically possible we don't really need to support it.

(and yes, it's a really bad design - I wish the NVME designers had spent a
little more time with existing designs instead of applying the full NIH
mantra)
