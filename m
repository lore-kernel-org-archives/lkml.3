Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753941AbaCJOAA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 10:00:00 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:53522 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752651AbaCJN76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 09:59:58 -0400
Message-ID: <531DC51F.50309@ti.com>
Date: Mon, 10 Mar 2014 19:28:55 +0530
From: Sricharan R <r.sricharan@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>
CC: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-omap <linux-omap@vger.kernel.org>, <dmaengine@vger.kernel.org>,
        Nishanth Menon <nm@ti.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>, <rnayak@ti.com>,
        Sekhar Nori <nsekhar@ti.com>, Vinod Koul <vinod.koul@intel.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: Re: [RFC PATCH 0/9] drivers: dma: Add support for dma-channel router
References: <1394194576-23741-1-git-send-email-r.sricharan@ti.com> <CAL_JsqLF6Ey1t1BV4tnFcFK-KmOU9H2nQE+ZHoZRq2r_nRTxNw@mail.gmail.com>
In-Reply-To: <CAL_JsqLF6Ey1t1BV4tnFcFK-KmOU9H2nQE+ZHoZRq2r_nRTxNw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rob,

On Sunday 09 March 2014 01:23 AM, Rob Herring wrote:
> On Fri, Mar 7, 2014 at 6:16 AM, Sricharan R <r.sricharan@ti.com> wrote:
>> In some SoCs the dma request lines from the peripherals are
>> routed to the dma-controller through a crossbar. With this the
>> dma controller's available request lines are shared between the
>> peripherals.
>>
>> This adds support to register the crossbar router associated with
>> a dma-channel and let the dma-controller driver map/unmap
>> the peripheral dma crossbar line to dma-controller's request
>> line.
> This is not a unique concept and should follow some existing pattern.
> Perhaps something like interrupt-map. For the dmas property, the
> parent should be the crossbar and then the crossbar block has to
> translate that into the DMA controller request. All the DMA ctrlr
> request connections should be described in the crossbar node. In
> theory, you could have chained crossbars. This should be documented as
> part of the generic DMA binding.
  The idea here was to do the map/unmap crossbar<->dma-request
 from the  dma-controller at runtime just like any other resource, unlike
  interrupt-map fixed in DTS. I did not think about the chained
  crossbars case. I will add this here. And as you have suggested will
  make it work like irq_parse_and_map.

Regards,
 Sricharan
> There are also other similar IP like CoreSight CTI which are just
> signal routers. So there is probably some possibility of common code
> here.
>
> Rob

