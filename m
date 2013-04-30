Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760885Ab3D3PVw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 11:21:52 -0400
Received: from 8bytes.org ([85.214.48.195]:35235 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760836Ab3D3PVq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 11:21:46 -0400
Date: Tue, 30 Apr 2013 17:21:43 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Suravee Suthikulanit <suravee.suthikulpanit@amd.com>
Cc: Don Dutile <ddutile@redhat.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: RFC: IOMMU/AMD: Error Handling
Message-ID: <20130430152143.GB25163@8bytes.org>
References: <517ECDDA.3000606@amd.com>
 <517ED3A9.2050508@redhat.com>
 <BA42942F2D0DED45AFB0A6216D1E951D44CBE1F9@sausexdag01.amd.com>
 <517EE940.8010005@redhat.com>
 <517FDB96.7060602@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <517FDB96.7060602@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Tue Apr 30 17:21:44 2013
X-DSPAM-Confidence: 0.9985
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 517fe18823671358478724
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 30, 2013 at 09:56:22AM -0500, Suthikulpanit, Suravee wrote:

> This sounds more like issue with the order of how things are
> initialized in the system.

No, the problem is that almost all BIOS-provided IVRS tables are buggy
because they do not define a unity-mapped region for devices that need
one (like USB controllers). So there is a time window from iommu driver
initialization to where the usb driver takes over the controller where
these io-page-faults can happen.


	Joerg


