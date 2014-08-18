Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752458AbaHRXXb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 19:23:31 -0400
Received: from 8bytes.org ([81.169.241.247]:40880 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752170AbaHRXXa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 19:23:30 -0400
Date: Tue, 19 Aug 2014 01:23:28 +0200
From: Joerg Roedel <joro@8bytes.org>
To: "Li, Zhen-Hua" <zhen-hual@hp.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] iommu/vt-d : clear old root entry for dump kernel
Message-ID: <20140818232328.GK9809@8bytes.org>
References: <1408352352-14449-1-git-send-email-zhen-hual@hp.com>
 <1267BB84A242B24E81E0C0C8955CFFC061A4BA26@G9W0343.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267BB84A242B24E81E0C0C8955CFFC061A4BA26@G9W0343.americas.hpqcorp.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 18, 2014 at 11:01:56PM +0000, Li, Zhen-Hua wrote:
> There is a bug when Linux running on an HP large system: 
> 	when kdump kernel runs, the hardware is still using the old 
> root entry. This causes error message when iommu not finished initialization.

What error message are you seeing? When the kdump kernel boots the iommu
should be still enabled from the old kernel with the old root-entry. So
any in-flight DMA initiated from the old kernel can still pass and there
should be no error messages.

When you clear the root-entry that in-flight DMA might go to another
random location in system memory or just fail, no?


	Joerg

