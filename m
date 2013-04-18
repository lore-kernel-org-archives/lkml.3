Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753824Ab3DRSfl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 14:35:41 -0400
Received: from 8bytes.org ([85.214.48.195]:49367 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751419Ab3DRSfk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 14:35:40 -0400
Date: Thu, 18 Apr 2013 20:35:38 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Suravee Suthikulanit <suravee.suthikulpanit@amd.com>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2 V2] iommu/amd: Add workaround for ERBT1312
Message-ID: <20130418183538.GA17148@8bytes.org>
References: <1366009666-44792-1-git-send-email-suravee.suthikulpanit@amd.com>
 <20130418160220.GA4153@8bytes.org>
 <51701B9F.10003@amd.com>
 <20130418162856.GA13891@8bytes.org>
 <5170268E.8080706@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5170268E.8080706@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Thu Apr 18 20:35:39 2013
X-DSPAM-Confidence: 0.9984
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 51703cfb23671398511609
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 18, 2013 at 11:59:58AM -0500, Suthikulpanit, Suravee wrote:
> One last concern I have for this patch is the case when we re-enable
> the interrupt, then another interrupt happens while we processing
> the log and set the bit.  If the interrupt thread doesn't check this
> right before the thread exits the handler.  We could still end up
> leaving the interrupt disabled.

That can't happen, the patch checks whether the bit is really 0 and then
it processes the event/ppr-log entries. If any new entry is queued while
we process the logs another interrupt will be fired and the irq-thread
will run again. So we will not miss any log entry.


	Joerg


