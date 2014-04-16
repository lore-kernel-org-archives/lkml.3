Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755004AbaDPUIQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 16:08:16 -0400
Received: from smtprelay2.synopsys.com ([198.182.60.111]:55717 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604AbaDPUIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 16:08:13 -0400
From: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
To: sundeep subbaraya <sundeep.lkml@gmail.com>, "balbi@ti.com" <balbi@ti.com>
CC: Subbaraya Sundeep Bhatta <subbaraya.sundeep.bhatta@xilinx.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Michal Simek <michals@xilinx.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Subbaraya Sundeep Bhatta <sbhatta@xilinx.com>
Subject: RE: [PATCH v2 2/2] usb: gadget: Add xilinx axi usb2 device support
Thread-Topic: [PATCH v2 2/2] usb: gadget: Add xilinx axi usb2 device support
Thread-Index: AQHPWWCF5z+pPb9Pf0GlHOqwGhCN35sUq20g
Date: Wed, 16 Apr 2014 20:08:03 +0000
Message-ID: <A2CA0424C0A6F04399FB9E1CD98E03046D18F4A6@US01WEMBX2.internal.synopsys.com>
References: <1396510519-8555-1-git-send-email-sbhatta@xilinx.com>
	<113d0620-4003-417d-806b-0b79ae692829@VA3EHSMHS023.ehs.local>
	<20140403145853.GD14162@saruman.home>
 <CALHRZuoCtEz5-CmU17dUpVS_MjSDdYVLMSvgXq_RwxLj_KJMDA@mail.gmail.com>
In-Reply-To: <CALHRZuoCtEz5-CmU17dUpVS_MjSDdYVLMSvgXq_RwxLj_KJMDA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.9.64.241]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s3GK8SfL008188

> From: linux-usb-owner@vger.kernel.org [mailto:linux-usb-owner@vger.kernel.org] On Behalf Of sundeep subbaraya
> Sent: Wednesday, April 16, 2014 3:39 AM
> 
> Hi Felipe,
> 
> On Thu, Apr 3, 2014 at 8:28 PM, Felipe Balbi <balbi@ti.com> wrote:
> 
> >> +static int start_dma(struct xusb_ep *ep, u32 src, u32 dst, u32 length)
> >
> > please prepend this with xudc_, it makes tracing a lot easier.
> >
> >> +{
> >> +     struct xusb_udc *udc;
> >> +     int rc = 0;
> >> +     unsigned long timeout;
> >> +
> >> +     udc = ep->udc;
> >> +     /*
> >> +      * Set the addresses in the DMA source and
> >> +      * destination registers and then set the length
> >> +      * into the DMA length register.
> >> +      */
> >> +     udc->write_fn(udc->base_address, XUSB_DMA_DSAR_ADDR_OFFSET, src);
> >> +     udc->write_fn(udc->base_address, XUSB_DMA_DDAR_ADDR_OFFSET, dst);
> >> +     udc->write_fn(udc->base_address, XUSB_DMA_LENGTH_OFFSET, length);
> >> +
> >> +     /*
> >> +      * Wait till DMA transaction is complete and
> >> +      * check whether the DMA transaction was
> >> +      * successful.
> >> +     */
> >> +     while ((udc->read_fn(ep->udc->base_address + XUSB_DMA_STATUS_OFFSET) &
> >> +                     XUSB_DMA_DMASR_BUSY) == XUSB_DMA_DMASR_BUSY) {
> >> +             timeout = jiffies + 10000;
> >> +
> >> +             if (time_after(jiffies, timeout)) {
> >> +                     rc = -ETIMEDOUT;
> >> +                     goto clean;
> >> +             }
> >> +     }
> >
> > don't you get an IRQ for DMA completion ? If you do, you could be using
> > wait_for_completion()
> 
> This function is called in interrupt context when buffer is ready or
> free. It initiates
> DMA to transfer data from IP buffer to memory. Hence it waits in busy
> loop till DMA
> completes

If this function is called in interrupt context, then you can't use
jiffies for your timeout, since jiffies may not get updated while in
interrupt context.

-- 
Paul

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
