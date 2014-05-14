Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754140AbaENJ31 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 05:29:27 -0400
Received: from 8bytes.org ([85.214.48.195]:45320 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752270AbaENJ3Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 05:29:25 -0400
Date: Wed, 14 May 2014 11:29:21 +0200
From: Joerg Roedel <joro@8bytes.org>
To: suravee.suthikulpanit@amd.com
Cc: iommu@lists.linux-foundation.org, sherry.hurwitz@amd.com, kim.naru@amd.com,
        linux-kernel@vger.kernel.org, Jay Cornwall <jay.cornwall@amd.com>
Subject: Re: [PATCH] iommu/amd: Fix for L2 race with VM invalidation
Message-ID: <20140514092920.GB6026@8bytes.org>
References: <1400049252-4213-1-git-send-email-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400049252-4213-1-git-send-email-suravee.suthikulpanit@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Wed May 14 11:29:24 2014
X-DSPAM-Confidence: 0.9988
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 5373377420861831972919
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2014 at 01:34:12AM -0500, suravee.suthikulpanit@amd.com wrote:
> A low probability race exists with this fix. Translations received
> within the critical section to PTEs which are concurrently being
> invalidated may resolve to stale mappings.

Sorry, no. This patch can cause silent data corruption when the pages in
these stale mappings get reused. I understand that the current way does
not work either and can cause failures in the GPU, but silent data
corruption is worse than that.

How about putting the page-fault requests on hold between
invalidate_range_start/end()? The GPU will not see the failures, just a
longer delay until the page faults are handled.


	Joerg


