Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587Ab3AKOvF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 09:51:05 -0500
Received: from 8bytes.org ([85.214.48.195]:57681 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753860Ab3AKOvE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 09:51:04 -0500
Date: Fri, 11 Jan 2013 15:50:59 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Shuah Khan <shuahkhan@gmail.com>
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>, Joerg Roedel <joerg.roedel@amd.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        Shuah Khan <shuah.khan@hp.com>
Subject: Re: [PATCH] iommu: moving initialization earlier
Message-ID: <20130111145059.GJ25591@8bytes.org>
References: <1357545112-17375-1-git-send-email-aik@ozlabs.ru>
 <20130110170941.GA2556@8bytes.org>
 <CAKocOOP=V=kZ=4661YSs4b+7GLcNqzVvvhb+ONBO=LiR3txvTA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKocOOP=V=kZ=4661YSs4b+7GLcNqzVvvhb+ONBO=LiR3txvTA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Fri Jan 11 15:51:01 2013
X-DSPAM-Confidence: 0.9989
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 50f026d522971019351938
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10, 2013 at 01:40:17PM -0700, Shuah Khan wrote:
> I am currently debugging IO_PAGE_FAULTS on 3.6.11 (happens on all
> pre-3.7 releases). I root-caused the reason 3.7 works is because in
> 3.7 amd iommu driver moving up the early iommu initialization from
> irq_remap_ops with the irq remapping feature.

Have you investigated the reason for those IO_PAGE_FAULTS? I guess they
come from the USB controlers and happen between the time the IOMMU is
enabled and the USB controlers are taken over by the Linux kernel from
the BIOS.

But I don't see why this patch can have any impact on the IO_PAGE_FAULTS
you are seeing.


	Joerg


