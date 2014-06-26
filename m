Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751902AbaFZXSW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 19:18:22 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:46177 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306AbaFZXSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 19:18:20 -0400
MIME-Version: 1.0
In-Reply-To: <20140626161055.GX32514@n2100.arm.linux.org.uk>
References: <1403603667-11302-1-git-send-email-acourbot@nvidia.com>
 <1403603667-11302-3-git-send-email-acourbot@nvidia.com> <20140624100220.GK32514@n2100.arm.linux.org.uk>
 <53A953E6.2030503@nvidia.com> <53A95910.20104@nvidia.com> <CAAVeFu+rbCViC87kYCLfxGV18iYq=Pa0ABb+L=iNiYPLn+mR8Q@mail.gmail.com>
 <53A96EC5.3030701@canonical.com> <1403616338.4230.8.camel@weser.hi.pengutronix.de>
 <CACP_E+KECMyusuZd6hpzthL-RpfUOJpWh0EABf1DGAeaXc00aA@mail.gmail.com>
 <CAAVeFuLU04rk1DWMhVJV=ktVCpq4js38p1ipCr1jh1x72b=GZw@mail.gmail.com> <20140626161055.GX32514@n2100.arm.linux.org.uk>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Fri, 27 Jun 2014 08:17:59 +0900
Message-ID: <CAAVeFuK5L9+nCP=KZTBSG9OifJrFKcfQdCYuBEQbZ2+s9FmFdQ@mail.gmail.com>
Subject: Re: [Nouveau] [PATCH v2 2/3] drm/ttm: introduce dma cache sync helpers
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: =?UTF-8?Q?St=C3=A9phane_Marchesin?= <stephane.marchesin@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Ben Skeggs <bskeggs@redhat.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2014 at 1:10 AM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Thu, Jun 26, 2014 at 11:53:20PM +0900, Alexandre Courbot wrote:
>> We don't plan to rely on CMA for too long. IOMMU support is on the way
>> and should make our life easier, although no matter the source of
>> memory, we will still have the issue of the lowmem mappings.
>
> When it comes to DMA memory, talking about lowmem vs highmem is utterly
> meaningless.
>
> The lowmem/highmem split is entirely a software concept and is completely
> adjustable.  An extreme example is that you can boot any platform with
> more than 32MB of memory with 32MB of lowmem and the remainder as
> highmem.

True, but isn't it also the case that all lowmem is already mapped in
the kernel address space, and that re-mapping this memory with
different cache settings (e.g. by creating a WC mapping for user-space
to write into) is undefined on ARM and must be avoided? That is the
issue I was referring to.
