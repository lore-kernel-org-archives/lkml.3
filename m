Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935892Ab3DIJtc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 05:49:32 -0400
Received: from 8bytes.org ([85.214.48.195]:35274 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933110Ab3DIJtb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 05:49:31 -0400
Date: Tue, 9 Apr 2013 11:49:29 +0200
From: Joerg Roedel <joro@8bytes.org>
To: suravee.suthikulpanit@amd.com
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iommu/amd: Add workaround to propery clearing IOMMU
 status register
Message-ID: <20130409094929.GE6858@8bytes.org>
References: <1365031144-2543-1-git-send-email-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365031144-2543-1-git-send-email-suravee.suthikulpanit@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Tue Apr  9 11:49:30 2013
X-DSPAM-Confidence: 0.9988
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 5163e42a23671478413373
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 03, 2013 at 06:19:04PM -0500, Suthikulpanit, Suravee wrote:
> In the system with multiple IOMMU,this handling scheme complicates the
> synchronization of the IOMMU data structures and status registers as
> there could be multiple threads competing for the same IOMMU while
> the other IOMMU could be left unhandled.

I really like that change in the interrupt handling code to pull the
different IOMMUs independently. But its problematic to change that in
the same patch that adds an erratum workaround.

Please move that erratum fix into a seperate small patch that we can
backport to -stable and resend.


	Joerg


