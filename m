Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715Ab3C0Kb0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 06:31:26 -0400
Received: from 8bytes.org ([85.214.48.195]:47219 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750716Ab3C0KbZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 06:31:25 -0400
Date: Wed, 27 Mar 2013 11:31:22 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Takao Indoh <indou.takao@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        dwmw2@infradead.org, kexec@lists.infradead.org
Subject: Re: [PATCH] intel-iommu: Synchronize gcmd value with global command
 register
Message-ID: <20130327103122.GK30540@8bytes.org>
References: <1363829556-2128-1-git-send-email-indou.takao@jp.fujitsu.com>
 <20130326144629.GB2727@8bytes.org>
 <51527D74.9080209@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51527D74.9080209@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Wed Mar 27 11:31:23 2013
X-DSPAM-Confidence: 0.9985
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 5152ca7b23673325315251
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 27, 2013 at 02:02:44PM +0900, Takao Indoh wrote:
> The root cause of this problem is mismatch between iommu->gcmd and
> global command register in the case of kdump. At boot time, initial
> value of iommu->gcmd is zero as I wrote above, but actual global command
> register is *not* zero because some bits like IRE/TE/QIE are already set
> in *first* kernel. Therefore this patch synchronize them to fix this
> problem.

Ok, I understand, but I still don't see why this is a problem. There is
no point for the kdump kernel to preserve hardware state from the
previous kernel. So I think the way it is implemented is correct.


	Joerg


