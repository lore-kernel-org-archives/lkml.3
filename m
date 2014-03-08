Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752012AbaCHTxt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 14:53:49 -0500
Received: from mail-vc0-f172.google.com ([209.85.220.172]:49301 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530AbaCHTxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 14:53:46 -0500
MIME-Version: 1.0
In-Reply-To: <1394194576-23741-1-git-send-email-r.sricharan@ti.com>
References: <1394194576-23741-1-git-send-email-r.sricharan@ti.com>
Date: Sat, 8 Mar 2014 13:53:45 -0600
Message-ID: <CAL_JsqLF6Ey1t1BV4tnFcFK-KmOU9H2nQE+ZHoZRq2r_nRTxNw@mail.gmail.com>
Subject: Re: [RFC PATCH 0/9] drivers: dma: Add support for dma-channel router
From: Rob Herring <robherring2@gmail.com>
To: Sricharan R <r.sricharan@ti.com>
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-omap <linux-omap@vger.kernel.org>, dmaengine@vger.kernel.org,
        Nishanth Menon <nm@ti.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>, rnayak@ti.com,
        Sekhar Nori <nsekhar@ti.com>, Vinod Koul <vinod.koul@intel.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 7, 2014 at 6:16 AM, Sricharan R <r.sricharan@ti.com> wrote:
> In some SoCs the dma request lines from the peripherals are
> routed to the dma-controller through a crossbar. With this the
> dma controller's available request lines are shared between the
> peripherals.
>
> This adds support to register the crossbar router associated with
> a dma-channel and let the dma-controller driver map/unmap
> the peripheral dma crossbar line to dma-controller's request
> line.

This is not a unique concept and should follow some existing pattern.
Perhaps something like interrupt-map. For the dmas property, the
parent should be the crossbar and then the crossbar block has to
translate that into the DMA controller request. All the DMA ctrlr
request connections should be described in the crossbar node. In
theory, you could have chained crossbars. This should be documented as
part of the generic DMA binding.

There are also other similar IP like CoreSight CTI which are just
signal routers. So there is probably some possibility of common code
here.

Rob
