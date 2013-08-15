Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751933Ab3HOU6u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 16:58:50 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:44384 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067Ab3HOU6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 16:58:49 -0400
X-IronPort-AV: E=Sophos;i="4.89,888,1367971200"; 
   d="scan'208";a="42596177"
Message-ID: <1376600325.9273.223.camel@hastur.hellion.org.uk>
Subject: Re: [PATCH v4 10/10] xen/arm,arm64: enable SWIOTLB_XEN
From: Ian Campbell <ian.campbell@citrix.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: <xen-devel@lists.xensource.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <konrad.wilk@oracle.com>
Date: Thu, 15 Aug 2013 21:58:45 +0100
In-Reply-To: <1376565054-24153-10-git-send-email-stefano.stabellini@eu.citrix.com>
References: <alpine.DEB.2.02.1308151200580.4470@kaball.uk.xensource.com>
	 <1376565054-24153-10-git-send-email-stefano.stabellini@eu.citrix.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-08-15 at 12:10 +0100, Stefano Stabellini wrote:
> At the moment always rely on swiotlb-xen, but when Xen starts supporting
> hardware IOMMUs we'll be able to avoid it conditionally on the presence
> of an IOMMU on the platform.

Do we have any idea how we are going to do this?

It's extra complicated if you consider that on some systems on some of
the devices are behind an IOMMU :-/

I wonder if we can enumerate which devices have an IOMMU at boot time
and force a ludicrous dma mask (such as 0) if one isn't present in order
to force us to always take the exchange_and_pin path?

Ian.

