Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751669AbaATIAT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 03:00:19 -0500
Received: from mail-lb0-f177.google.com ([209.85.217.177]:63399 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750726AbaATIAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 03:00:16 -0500
MIME-Version: 1.0
In-Reply-To: <201401171713.08550.arnd@arndb.de>
References: <1389894803-4147-1-git-send-email-sthokal@xilinx.com>
	<1389894803-4147-2-git-send-email-sthokal@xilinx.com>
	<201401171713.08550.arnd@arndb.de>
Date: Mon, 20 Jan 2014 13:30:14 +0530
X-Google-Sender-Auth: oJBBEi2_OONrQK3kc1n8xqeGy_s
Message-ID: <CA+mB=1L0ZSC8f6eMEuO7MEk6nG5SDahE7AH2F_uUr1TgTCD=cw@mail.gmail.com>
Subject: Re: [PATCH] dma: Add Xilinx AXI Video Direct Memory Access Engine
 driver support
From: Srikanth Thokala <sthokal@xilinx.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
        Srikanth Thokala <sthokal@xilinx.com>, dan.j.williams@intel.com,
        vinod.koul@intel.com, michal.simek@xilinx.com,
        Grant Likely <grant.likely@linaro.org>, robh+dt@kernel.org,
        dmaengine@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On Fri, Jan 17, 2014 at 9:43 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Thursday 16 January 2014, Srikanth Thokala wrote:
>> @@ -0,0 +1,71 @@
>> +Xilinx AXI VDMA engine, it does transfers between memory and video devices.
>> +It can be configured to have one channel or two channels. If configured
>> +as two channels, one is to transmit to the video device and another is
>> +to receive from the video device.
>> +
>> +Required properties:
>> +- compatible: Should be "xlnx,axi-vdma-1.00.a"
>> +- #dma-cells: Should be <1>, see "dmas" property below
>> +- reg: Should contain VDMA registers location and length.
>> +- interrupts: Should contain per channel VDMA interrupts.
>> +- compatible (child node): It should be either "xlnx,axi-vdma-mm2s-channel" or
>> +       "xlnx,axi-vdma-s2mm-channel". It depends on the hardware design and it
>> +       can also have both channels.
>> +- xlnx,device-id: Should contain device number in each channel. It should be
>> +       {0,1,2...so on} to the number of VDMA devices configured in hardware.
>> +- xlnx,num-fstores: Should be the number of framebuffers as configured in h/w.
>> +- xlnx,data-width: Should contain the stream data width, takes {32,64...so on}.
>> +- xlnx,flush-fsync: (Optional) Tells whether which channel to Flush on Fsync.
>> +       It takes following values:
>> +       {1}, flush both channels
>> +       {2}, flush mm2s channel
>> +       {3}, flush s2mm channel
>> +- xlnx,include-sg: (Optional) Tells whether configured for Scatter-mode in
>> +       the hardware.
>> +- xlnx,include-dre: (Optional) Tells whether hardware is configured for Data
>> +       Realignment Engine.
>> +- xlnx,genlock-mode: (Optional) Tells whether Genlock synchornisation is
>> +       enabled/disabled in hardware.
>
> The documentation doesn't seem to match the example, since you don't mention
> the fact that the channels have separate nodes here, or which properties
> are meant for the parent or the child node. Also, some of the "required"
> properties are absent in the example, which makes no sense.
>

I will fix this ambiguity in my v2.

> I also assume that some of the properties should just go away:
>
> * xlnx,device-id should be the argument in the handle from the slave device

We can have multiple instances of this VDMA IP configured in the FPGA and we
need a unique identifier for each VDMA device that is present in the FPGA.
This device-id dt parameter forms the filter mask for the slave devices. As an
example, this can be used to get a channel of specific VDMA device (assuming
multiple instances) using the API dma_request_channel().  Please note this
is an example of a slave device that doesnt have dt node.

> * data width should be a property of the slave driver that is configured
>   through dma_slave_config(), unless you can have dma engines that only
>   support certain a width.

Yes, this VDMA engine soft IP support only certain widths, which is
configurable during IP synthesis.

Srikanth

>
>         Arnd
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
