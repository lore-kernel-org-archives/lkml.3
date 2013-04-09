Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761256Ab3DIRae (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 13:30:34 -0400
Received: from 8bytes.org ([85.214.48.195]:36161 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759207Ab3DIRad (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 13:30:33 -0400
Date: Tue, 9 Apr 2013 19:30:30 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Suravee Suthikulanit <suravee.suthikulpanit@amd.com>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iommu/amd: Add workaround to propery clearing IOMMU
 status register
Message-ID: <20130409173030.GH6858@8bytes.org>
References: <1365031144-2543-1-git-send-email-suravee.suthikulpanit@amd.com>
 <20130409094929.GE6858@8bytes.org>
 <51642442.7090908@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51642442.7090908@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Tue Apr  9 19:30:31 2013
X-DSPAM-Confidence: 0.9985
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 5164503723672001218969
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 09, 2013 at 09:22:58AM -0500, Suthikulpanit, Suravee wrote:
> The reason I implemented the "per-thread IOMMU handling" and the
> "workaround" together in one patch
> is because it simplifies the synchronization of clearing and
> checking the interrupt enabling bits.
> In the previous implementation, we could end up having multiple
> threads trying to access the status register
> at the same time.

This is the reason for the iommu->lock spinlock in this code at the
moment.


	Joerg


