Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755861Ab3APO7U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 09:59:20 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:41931 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753149Ab3APO7T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 09:59:19 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-acpi@vger.kernel.org, Len Brown <lenb@kernel.org>,
        linux-kernel@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: Re: [PATCH] ACPI: add support for CSRT table
Date: Wed, 16 Jan 2013 16:05:13 +0100
Message-ID: <52251733.O8Fi4oih4J@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc3+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130116044216.GP13897@intel.com>
References: <1358157111-26510-1-git-send-email-mika.westerberg@linux.intel.com> <2369015.SBxXlM67PJ@vostro.rjw.lan> <20130116044216.GP13897@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, January 16, 2013 06:42:16 AM Mika Westerberg wrote:
> On Wed, Jan 16, 2013 at 12:35:56AM +0100, Rafael J. Wysocki wrote:
> > On Monday, January 14, 2013 11:51:51 AM Mika Westerberg wrote:
> > > Core System Resources Table (CSRT) is a proprietary ACPI table that
> > > contains resources for certain devices that are not found in the DSDT
> > > table. Typically a shared DMA controller might be found here.
> > > 
> > > This patch adds support for this table. We go through all entries in the
> > > table and make platform devices of them. The resources from the table are
> > > passed with the platform device.
> > > 
> > > There is one special resource in the table and it is the DMA request line
> > > base and number of request lines. This information might be needed by the
> > > DMA controller driver as it needs to map the ACPI DMA request line number
> > > to the actual request line understood by the hardware. This range is passed
> > > as IORESOURCE_DMA resource.
> > 
> > I have a question: Who's going to bind to those platform devices created
> > by the code in this patch and how exactly this is going to happen?
> 
> Typically it is the DMA driver (but not limited to that). It is supposed to
> work so that either the driver name (in the platform driver struct) matches
> the device name in the CSRT or like with the dw_dmac case we do something
> like:
> 
> /* The platform device created is "INTL9C60.0.auto" */
> 
> static const struct platform_device_id dw_dma_ids[] = {
>         { "INTL9C60", 0 },
> 	{ }
> }
> 
> static struct platform_driver dw_driver = {
> 	...
> 	.id_table = dw_dma_ids,
> };

OK, that's fine by me.  Will apply.

Do you want it to go to any particular branch (eg. along with the acpi-scan
changes)?

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
