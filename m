Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161567Ab3DELGU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 07:06:20 -0400
Received: from 8bytes.org ([85.214.48.195]:58970 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756626Ab3DELGT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 07:06:19 -0400
Date: Fri, 5 Apr 2013 13:06:16 +0200
From: Joerg Roedel <joro@8bytes.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Takao Indoh <indou.takao@jp.fujitsu.com>, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org, kexec@lists.infradead.org
Subject: Re: [PATCH] intel-iommu: Synchronize gcmd value with global command
 register
Message-ID: <20130405110616.GB6858@8bytes.org>
References: <1363829556-2128-1-git-send-email-indou.takao@jp.fujitsu.com>
 <20130326144629.GB2727@8bytes.org>
 <51527D74.9080209@jp.fujitsu.com>
 <20130327103122.GK30540@8bytes.org>
 <51591EEE.60401@jp.fujitsu.com>
 <20130402140546.GA15687@8bytes.org>
 <515BD638.8070307@jp.fujitsu.com>
 <1364977479.28127.15.camel@i7.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364977479.28127.15.camel@i7.infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Fri Apr  5 13:06:17 2013
X-DSPAM-Confidence: 0.9988
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 515eb02923671406512840
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 03, 2013 at 09:24:39AM +0100, David Woodhouse wrote:
> On Wed, 2013-04-03 at 16:11 +0900, Takao Indoh wrote:
> > Yeah, you are right. I forgot such a case.
> 
> If you disable translation and there's some device still doing DMA, it's
> going to scribble over random areas of memory. You really want to have
> translation enabled and all the page tables *cleared*, during kexec. I
> think it's fair to insist that the secondary kernel should use the IOMMU
> if the first one did.

Do we really need to insist on that? The IOMMU initialization on x86
happens after the kernel scanned and enumerated the PCI bus. While doing
this the kernel (at least it should) disables all devices it finds. So
when the IOMMU init code runs we should be safe from any in-flight DMA
and can either disable translation or re-initialize it for the kdump
kernel. Until then translation needs to stay enabled of course, so that
the old page-tables are still used and in-flight DMA doesn't corrupt
any data.


	Joerg


