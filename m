Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248Ab3BENFi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 08:05:38 -0500
Received: from 8bytes.org ([85.214.48.195]:35715 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754141Ab3BENFh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 08:05:37 -0500
Date: Tue, 5 Feb 2013 14:05:34 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Sethi Varun-B16395 <B16395@freescale.com>
Cc: Stuart Yoder <b08248@gmail.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Wood Scott-B07421 <B07421@freescale.com>
Subject: Re: [PATCH 5/5] iommu: Add DOMAIN_ATTR_WINDOWS domain attribute
Message-ID: <20130205130534.GS25591@8bytes.org>
References: <1359983924-28952-1-git-send-email-joro@8bytes.org>
 <1359983924-28952-6-git-send-email-joro@8bytes.org>
 <C5ECD7A89D1DC44195F34B25E172658D373D2B@039-SN2MPN1-013.039d.mgd.msft.net>
 <20130205104155.GR25591@8bytes.org>
 <C5ECD7A89D1DC44195F34B25E172658D3752B1@039-SN2MPN1-013.039d.mgd.msft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C5ECD7A89D1DC44195F34B25E172658D3752B1@039-SN2MPN1-013.039d.mgd.msft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Tue Feb  5 14:05:35 2013
X-DSPAM-Confidence: 0.9993
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 5111039f22971165713714
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 05, 2013 at 10:52:03AM +0000, Sethi Varun-B16395 wrote:
> DOMAIN_ATTR_PAMU_ENABLE is required to enable a particular DMA window.
> My point is about the domain geometry, which is incomplete in case of
> PAMU without the number of subwindows. Geometry parameters are used
> for initializing the PAMU window settings. Individual subwindows can
> only be enabled, once the PAMU window has been initialized using the
> geometry settings.

I understand that. What you do is:

	/* Set geometry */
	set_attr(domain, DOMAIN_ATTR_GEOMETRY);

	/* Set number of PAMU subwindows */
	set_attr(domain, DOMAIN_ATTR_WINDOWS);

	/* Commit changes to hardware and enable the window */
	set_attr(domain, DOMAIN_ATTR_PAMU_ENABLE);

And I don't see any problem with that. The domain_attr interface was
introduced to cope with device specifics, we don't change global
interface data structures for that.


	Joerg


