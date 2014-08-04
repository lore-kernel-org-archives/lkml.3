Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752536AbaHDLIq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 07:08:46 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:44411 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752339AbaHDLIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 07:08:44 -0400
Date: Mon, 4 Aug 2014 04:08:44 -0700
From: Christoph Hellwig <hch@infradead.org>
To: jgross@suse.com
Cc: James.Bottomley@HansenPartnership.com, hch@infradead.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3] Save command pool address of Scsi_Host
Message-ID: <20140804110844.GC19109@infradead.org>
References: <1407126369-16543-1-git-send-email-jgross@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407126369-16543-1-git-send-email-jgross@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 04, 2014 at 06:26:09AM +0200, jgross@suse.com wrote:
> From: Juergen Gross <jgross@suse.com>
> 
> If a scsi host driver specifies .cmd_len in it's scsi_host_template, a driver's
> private command pool is needed. scsi_find_host_cmd_pool() will locate it, but
> scsi_alloc_host_cmd_pool() isn't saving the pool address in the host template.
> 
> This will result in an access error when the host is removed.
> 
> Avoid the problem by saving the address of a new allocated command pool where
> it is expected and delete it again when the pool is destroyed.

I don't really like the double pointer passing - just NULLing out the
pointer in the caller where needed seems cleaner.

Otherwise this looks good to me.

