Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345AbaG2K5f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 06:57:35 -0400
Received: from mail-ig0-f180.google.com ([209.85.213.180]:57459 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753263AbaG2K5c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 06:57:32 -0400
MIME-Version: 1.0
X-Originating-IP: [93.172.8.40]
In-Reply-To: <1404836521-59637-2-git-send-email-s-anna@ti.com>
References: <1404836521-59637-1-git-send-email-s-anna@ti.com> <1404836521-59637-2-git-send-email-s-anna@ti.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Tue, 29 Jul 2014 13:57:10 +0300
Message-ID: <CAK=Wgbawdik3ZB0Zbeaa7eXd7M+9ev9u713GcfOc4Gy0+O80Dg@mail.gmail.com>
Subject: Re: [PATCH 1/2] remoteproc: use a flag to detect the presence of IOMMU
To: Suman Anna <s-anna@ti.com>
Cc: Dave Gerlach <d-gerlach@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        Robert Tivy <rtivy@ti.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Suman,

On Tue, Jul 8, 2014 at 7:22 PM, Suman Anna <s-anna@ti.com> wrote:
> The remoteproc driver core currently relies on iommu_present() on
> the bus the device is on, to perform MMU management. However, this
> logic doesn't scale for multi-arch, especially for processors that
> do not have an IOMMU.

Is there a specific hw/scenario where you need this? Can you please
provide more details about it?

Ideally we should add them to the commit log as well.

> The individual platform implementations are required to set this
> flag appropriately. The default setting is to not have an MMU.

Let's explicitly set the default please so this would be clear for
users reading the code.

> Cc: Sjur Brændeland <sjur.brandeland@stericsson.com>

Sjur is no longer with STE, so no point in cc'ing his old email address.

> +       /*
> +        * All existing OMAP IPU and DSP processors do have an MMU, and
> +        * are expected to use MMU, so this statement suffices.
> +        * XXX: Replace this logic if and when a need arises.

The last XXX comment is always true for any kernel code, so I'd drop it.

Thanks,
Ohad.
