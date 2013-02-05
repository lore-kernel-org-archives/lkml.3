Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024Ab3BEKmB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 05:42:01 -0500
Received: from 8bytes.org ([85.214.48.195]:35499 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751156Ab3BEKl6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 05:41:58 -0500
Date: Tue, 5 Feb 2013 11:41:55 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Sethi Varun-B16395 <B16395@freescale.com>
Cc: Stuart Yoder <b08248@gmail.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Wood Scott-B07421 <B07421@freescale.com>
Subject: Re: [PATCH 5/5] iommu: Add DOMAIN_ATTR_WINDOWS domain attribute
Message-ID: <20130205104155.GR25591@8bytes.org>
References: <1359983924-28952-1-git-send-email-joro@8bytes.org>
 <1359983924-28952-6-git-send-email-joro@8bytes.org>
 <C5ECD7A89D1DC44195F34B25E172658D373D2B@039-SN2MPN1-013.039d.mgd.msft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C5ECD7A89D1DC44195F34B25E172658D373D2B@039-SN2MPN1-013.039d.mgd.msft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Tue Feb  5 11:41:56 2013
X-DSPAM-Confidence: 0.9993
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 5110e1f422971979410809
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Feb 05, 2013 at 09:14:40AM +0000, Sethi Varun-B16395 wrote:
> In case of PAMU, geometry would be meaningless without specifying the
> number of subwindows. If the API user specifies a geometry but fails
> to specify the number of required subwindows, we would assume a
> default (max supported) value, which may be incorrect. It's going to
> be really ugly. I think we should add the number of sub windows to the
> domain geometry. This parameter would be used in case of a window
> based iommu. So, a separate set_window API wouldn't be required.

I think this can all be implemented with the interface proposed here
together with a PAMU-specific DOMAIN_ATTR_PAMU_ENABLE attribute. Stuart
outlined in his RFC mail how this can be done. I don't consider this
ugly, it is rather a clean tradeoff between putting functionality into
the generic part of the IOMMU-API and putting it into the PAMU specific
part.

Regards,

	Joerg


