Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755243Ab3BENbL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 08:31:11 -0500
Received: from 8bytes.org ([85.214.48.195]:35774 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754009Ab3BENbI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 08:31:08 -0500
Date: Tue, 5 Feb 2013 14:31:05 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Shuah Khan <shuah.khan@hp.com>
Cc: LKML <linux-kernel@vger.kernel.org>, stable <stable@vger.kernel.org>,
        iommu@lists.linux-foundation.org, shuahkhan@gmail.com
Subject: Re: IO_PAGE_FAULTs on unity mapped regions during amd_iommu_init()
 in Linux 3.4
Message-ID: <20130205133104.GC2532@8bytes.org>
References: <1359657210.6061.3.camel@lorien2>
 <20130201130035.GE25591@8bytes.org>
 <1359743519.2759.38.camel@lorien2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359743519.2759.38.camel@lorien2>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Tue Feb  5 14:31:06 2013
X-DSPAM-Confidence: 0.9981
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 5111099a22971757182852
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Shuah,

On Fri, Feb 01, 2013 at 11:31:59AM -0700, Shuah Khan wrote:
> Yes, 3.7 has the same window of opportunity for this race condition,
> however I couldn't figure out why it doesn't happen on 3.7. On 3.7 the
> window between amd_iommu_init_hardware() and amd_iommu_init_dma_ops()
> might actually be wider than the window in 3.4.

I think this is highly timing related. IOMMU initialization may have
been moved by a few milliseconds between the kernel versions which might
cause the warnings to appear or disappear. I don't think it has much
value to dive deeper into the differences between the initialization
sequences.

As somethimes with such issues there is a simple and a more complex fix
for that. I'll try to come up with a simple fix for the next merge
window and implement the clean and more complex one for the next one.


	Joerg


