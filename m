Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932157AbaFZQLJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 12:11:09 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:44185 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751759AbaFZQLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 12:11:07 -0400
Date: Thu, 26 Jun 2014 17:10:55 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Alexandre Courbot <gnurou@gmail.com>
Cc: =?iso-8859-1?Q?St=E9phane?= Marchesin 
	<stephane.marchesin@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Ben Skeggs <bskeggs@redhat.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [Nouveau] [PATCH v2 2/3] drm/ttm: introduce dma cache sync
	helpers
Message-ID: <20140626161055.GX32514@n2100.arm.linux.org.uk>
References: <1403603667-11302-1-git-send-email-acourbot@nvidia.com> <1403603667-11302-3-git-send-email-acourbot@nvidia.com> <20140624100220.GK32514@n2100.arm.linux.org.uk> <53A953E6.2030503@nvidia.com> <53A95910.20104@nvidia.com> <CAAVeFu+rbCViC87kYCLfxGV18iYq=Pa0ABb+L=iNiYPLn+mR8Q@mail.gmail.com> <53A96EC5.3030701@canonical.com> <1403616338.4230.8.camel@weser.hi.pengutronix.de> <CACP_E+KECMyusuZd6hpzthL-RpfUOJpWh0EABf1DGAeaXc00aA@mail.gmail.com> <CAAVeFuLU04rk1DWMhVJV=ktVCpq4js38p1ipCr1jh1x72b=GZw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAVeFuLU04rk1DWMhVJV=ktVCpq4js38p1ipCr1jh1x72b=GZw@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2014 at 11:53:20PM +0900, Alexandre Courbot wrote:
> We don't plan to rely on CMA for too long. IOMMU support is on the way
> and should make our life easier, although no matter the source of
> memory, we will still have the issue of the lowmem mappings.

When it comes to DMA memory, talking about lowmem vs highmem is utterly
meaningless.

The lowmem/highmem split is entirely a software concept and is completely
adjustable.  An extreme example is that you can boot any platform with
more than 32MB of memory with 32MB of lowmem and the remainder as
highmem.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
