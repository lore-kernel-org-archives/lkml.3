Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966783Ab3DQU5I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 16:57:08 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:55129 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755404Ab3DQU5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 16:57:05 -0400
Date: Wed, 17 Apr 2013 16:57:03 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Arnd Bergmann <arnd@arndb.de>
cc: Greg KH <greg@kroah.com>, <linux-usb@vger.kernel.org>,
        Manjunath Goudar <manjunath.goudar@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V5 6/6] USB: OHCI: avoid conflicting platform drivers
In-Reply-To: <1364919844-1726-7-git-send-email-arnd@arndb.de>
Message-ID: <Pine.LNX.4.44L0.1304171655170.1623-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Apr 2013, Arnd Bergmann wrote:

> Like the EHCI driver, OHCI supports a large number of different platform
> glue drivers by directly including them, which causes problems with
> conflicting macro definitions in some cases. As more ARM architecture
> specific back-ends are required to coexist in a single build, we should
> split those out into separate drivers. Unfortunately, the infrastructure
> for that is still under development, so to give us more time, this uses
> a separate *_PLATFORM_DRIVER macro for each ARM specific OHCI backend,
> just like we already do on PowerPC and some of the other ARM platforms.
> 
> In linux-3.10, only the SPEAr and CNS3xxx back-ends would actually conflict
> without this patch, but over time we would get more of them, so this
> is a way to avoid having to patch the driver every time it breaks. We
> should still split out all back-ends into separate loadable modules,
> but that work is only needed to improve code size and cleanliness after
> this patch, not for correctness.
> 
> While we're here, this fixes the incorrectly sorted error path
> for the OMAP1 and OMAP3 backends to ensure we always unregister
> the exact set of drivers that were registered before erroring out.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

I finally had a chance to look through this carefully.  It is fine.

Acked-by: Alan Stern <stern@rowland.harvard.edu>

