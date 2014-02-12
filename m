Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751820AbaBLH5r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 02:57:47 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:53726 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055AbaBLH5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 02:57:45 -0500
Date: Tue, 11 Feb 2014 23:57:43 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] scsi_sysfs: Implement 'is_visible' callback
Message-ID: <20140212075743.GA13498@infradead.org>
References: <1392129294-55235-1-git-send-email-hare@suse.de>
 <1392129294-55235-2-git-send-email-hare@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392129294-55235-2-git-send-email-hare@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 03:34:53PM +0100, Hannes Reinecke wrote:
> Instead of modifying attributes after the device has been created
> we should be using the 'is_visible' callback to avoid races.

Can't say I like the fact that the is_visible function needs is
per-group and not per attribute and thus needs to explicitly check
which attribute we call it for, but that seems to be a design issue in
the driver core and not the patch.

Otherwise looks good with the minor nitpick that it would have looked
cleaner in the patch if you had left the queue_type store function
in the location it previously was.

Reviewed-by: Christoph Hellwig <hch@lst.de>
