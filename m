Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409AbaHSRyf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 13:54:35 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:38966 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753355AbaHSRye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 13:54:34 -0400
Date: Tue, 19 Aug 2014 10:54:31 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: hare@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        ohering@suse.com, jbottomley@parallels.com, linux-scsi@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 2/2] Drivers: scsi: storvsc: Force discovery of LUNs that
 may have been removed.
Message-ID: <20140819175431.GA4617@infradead.org>
References: <1408244954-27417-1-git-send-email-kys@microsoft.com>
 <1408244988-27456-1-git-send-email-kys@microsoft.com>
 <1408244988-27456-2-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408244988-27456-2-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 16, 2014 at 08:09:48PM -0700, K. Y. Srinivasan wrote:
> The host asks the guest to scan when a LUN is removed or added.
> The only way a guest can identify the removed LUN is when an I/O is
> attempted on a removed LUN - the SRB status code indicates that the LUN
> is invalid. We currently handle this SRB status and remove the device.
> 
> Rather than waiting for an I/O to remove the device, force the discovery of
> LUNs that may have been removed prior to discovering LUNs that may have
> been added.

This looks pretty reasonable to me, but I wonder if we should move this
up to common code so that it happens for any host rescan triggered by
sysfs or other drivers as well.

