Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934559Ab3CZOqe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 10:46:34 -0400
Received: from 8bytes.org ([85.214.48.195]:45259 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933497Ab3CZOqd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 10:46:33 -0400
Date: Tue, 26 Mar 2013 15:46:30 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Takao Indoh <indou.takao@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        dwmw2@infradead.org, kexec@lists.infradead.org
Subject: Re: [PATCH] intel-iommu: Synchronize gcmd value with global command
 register
Message-ID: <20130326144629.GB2727@8bytes.org>
References: <1363829556-2128-1-git-send-email-indou.takao@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363829556-2128-1-git-send-email-indou.takao@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Tue Mar 26 15:46:31 2013
X-DSPAM-Confidence: 0.9989
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 5151b4c723671020098153
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 10:32:36AM +0900, Takao Indoh wrote:
> In this function, clearing IRE bit in iommu->gcmd and writing it to
> global command register. But initial value of iommu->gcmd is zero, so
> this writel means clearing all bits in global command register.

Seems weird. Why is the value of gcmd zero in your case? The usage of
this register is well encapsulated by the different parts of the VT-d
driver. There are other places which enable/disable translation and qpi
the same way it is done with interrupt remapping. So it looks to me that
it is unlikely that gcmd is really zero in your case.

Can you explain that more and also describe what the actual misbehavior
is you are trying to fix here?

Thanks,

	Joerg


