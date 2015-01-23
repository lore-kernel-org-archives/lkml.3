Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429AbbAWH5O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 02:57:14 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:48673 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877AbbAWH5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 02:57:12 -0500
Date: Thu, 22 Jan 2015 23:57:08 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Yan Liu <yan@purestorage.com>
Cc: Matthew Wilcox <willy@linux.intel.com>, linux-nvme@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] NVMe: Do not take nsid while a passthrough IO
 command is being issued via a block device file descriptor
Message-ID: <20150123075708.GA17232@infradead.org>
References: <1421971328-5065-1-git-send-email-yan@purestorage.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421971328-5065-1-git-send-email-yan@purestorage.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2015 at 04:02:08PM -0800, Yan Liu wrote:
> When a passthrough IO command is issued with a specific block device file descriptor. It should be applied at
> the namespace which is associated with that block device file descriptor. This patch makes such passthrough
> command ignore nsid in nvme_passthru_cmd structure. Instead it takes the namespace ID asscoiated with the
> block device descriptor.
> 
> Signed-off-by: Yan Liu <yan@purestorage.com>

Please move the code to find the ns into the caller, or even better a
seaprate helper used by the caller. instead of adding another argument to
nvme_user_cmd.
