Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754966Ab3BDNCS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 08:02:18 -0500
Received: from 8bytes.org ([85.214.48.195]:33752 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754547Ab3BDNCR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 08:02:17 -0500
Date: Mon, 4 Feb 2013 14:02:14 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Sethi Varun-B16395 <B16395@freescale.com>
Cc: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Wood Scott-B07421 <B07421@freescale.com>,
        Yoder Stuart-B08248 <B08248@freescale.com>
Subject: Re: [PATCH 4/4] iommu: Add domain window handling functions
Message-ID: <20130204130214.GN25591@8bytes.org>
References: <1359582228-21552-1-git-send-email-joro@8bytes.org>
 <1359582228-21552-5-git-send-email-joro@8bytes.org>
 <C5ECD7A89D1DC44195F34B25E172658D3670ED@039-SN2MPN1-013.039d.mgd.msft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C5ECD7A89D1DC44195F34B25E172658D3670ED@039-SN2MPN1-013.039d.mgd.msft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Mon Feb  4 14:02:15 2013
X-DSPAM-Confidence: 0.9994
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 510fb15722971699272620
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31, 2013 at 09:32:26AM +0000, Sethi Varun-B16395 wrote:
> We need a mechanism to determine the maximum number of subwindows supported by PAMU. How about representing it in the iommu_domain structure:
> struct  iommu_domain {
> 	struct iommu_ops *ops;
> 	void *priv;
> 	iommu_fault_handler_t handler;
> 	void *handler_token;
> 	struct iommu_domain_geometry geometry;
> 	u32 max_sub_windows; -----> maximum number of sub windows supported by the hardware.
> }

I`ll leave that flag to the private-data of the IOMMU domain. Instead I
added a DOMAIN_ATTR_WINDOWS attribute to get/set the number of
subwindows. I'll post the updated patch-set soon.


	Joerg


