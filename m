Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967355Ab3E3C4i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 22:56:38 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:44275 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756978Ab3E3C4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 22:56:31 -0400
MIME-Version: 1.0
In-Reply-To: <20130529235507.GA23190@arwen.pp.htv.fi>
References: <1369852310-8687-1-git-send-email-yhchen@faraday-tech.com>
	<20130529235507.GA23190@arwen.pp.htv.fi>
Date: Thu, 30 May 2013 10:56:29 +0800
Message-ID: <CADB-GoLuw+voV6cbMSa68Yzhow78k6h82-m1VFa1V4v2_nUv0A@mail.gmail.com>
Subject: Re: [PATCH] usb: gadget: add Faraday fotg210_udc driver
From: Yuan-Hsin Chen <yuanlmm@gmail.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Yuan-Hsin Chen <yhchen@faraday-tech.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        USB list <linux-usb@vger.kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, May 30, 2013 at 7:55 AM, Felipe Balbi <balbi@ti.com> wrote:
> Hi,
>
> On Wed, May 29, 2013 at 06:31:50PM +0000, Yuan-Hsin Chen wrote:
>> Faraday fotg210 udc driver supports only Bulk transfer so far.
>> fotg210 could be configured as an USB2.0 peripheral.
>>
>> This driver is tested with mass storage gadget driver on Faraday
>> EVB a369.
>>
>> Signed-off-by: Yuan-Hsin Chen <yhchen@faraday-tech.com>
>
> Run through checkpatch.pl --strict and fix all errors, warnings and all
> checks which make sense.
>
> WARNING: please write a paragraph that describes the config symbol fully
> #81: FILE: drivers/usb/gadget/Kconfig:196:
> +config USB_FOTG210_UDC
>
> CHECK: braces {} should be used on all arms of this statement
> #183: FILE: drivers/usb/gadget/fotg210-udc.c:76:
> +       if (ep->epnum) {
> [...]
> +       } else
> [...]
>
> WARNING: line over 80 characters
> #190: FILE: drivers/usb/gadget/fotg210-udc.c:83:
> +static void fotg210_fifo_ep_mapping(struct fotg210_ep *ep, u32 epnum, u32 dir_in)
>
> WARNING: line over 80 characters
> #237: FILE: drivers/usb/gadget/fotg210-udc.c:130:
> +static void fotg210_set_mps(struct fotg210_ep *ep, u32 epnum, u32 mps, u32 dir_in)
>
> WARNING: line over 80 characters
> #241: FILE: drivers/usb/gadget/fotg210-udc.c:134:
> +       u32 offset = dir_in ? FOTG210_INEPMPSR(epnum) : FOTG210_OUTEPMPSR(epnum);
>
> WARNING: line over 80 characters
> #349: FILE: drivers/usb/gadget/fotg210-udc.c:242:
> +static void fotg210_ep_free_request(struct usb_ep *_ep, struct usb_request *_req)
>
> WARNING: Avoid CamelCase: <DMATFNR_ACC_Fn>
> #372: FILE: drivers/usb/gadget/fotg210-udc.c:265:
> +               value |= DMATFNR_ACC_Fn(ep->epnum - 1);
>
> WARNING: line over 80 characters
> #418: FILE: drivers/usb/gadget/fotg210-udc.c:311:
> +               value = ioread32(ep->fotg210->reg + FOTG210_FIBCR(ep->epnum - 1));
>
> WARNING: line over 80 characters
> #420: FILE: drivers/usb/gadget/fotg210-udc.c:313:
> +               iowrite32(value, ep->fotg210->reg + FOTG210_FIBCR(ep->epnum - 1));
>
> WARNING: line over 80 characters
> #441: FILE: drivers/usb/gadget/fotg210-udc.c:334:
> +                       length = ioread32(ep->fotg210->reg + FOTG210_FIBCR(ep->epnum - 1));
>
> WARNING: Avoid CamelCase: <FIBCR_BCFx>
> #442: FILE: drivers/usb/gadget/fotg210-udc.c:335:
> +                       length &= FIBCR_BCFx;
>
> WARNING: Prefer netdev_dbg(netdev, ... then dev_dbg(dev, ... then pr_debug(...  to printk(KERN_DEBUG ...
> #456: FILE: drivers/usb/gadget/fotg210-udc.c:349:
> +               printk(KERN_DEBUG "dma_mapping_error\n");
>
> CHECK: Alignment should match open parenthesis
> #461: FILE: drivers/usb/gadget/fotg210-udc.c:354:
> +       dma_sync_single_for_device(NULL, d, length,
> +                       ep->dir_in ? DMA_TO_DEVICE : DMA_FROM_DEVICE);
>
> WARNING: line over 80 characters
> #476: FILE: drivers/usb/gadget/fotg210-udc.c:369:
> +static void fotg210_ep0_queue(struct fotg210_ep *ep, struct fotg210_request *req)
>
> CHECK: braces {} should be used on all arms of this statement
> #483: FILE: drivers/usb/gadget/fotg210-udc.c:376:
> +               if (req->req.length) {
> [...]
> +               } else
> [...]
>
> WARNING: Prefer netdev_dbg(netdev, ... then dev_dbg(dev, ... then pr_debug(...  to printk(KERN_DEBUG ...
> #486: FILE: drivers/usb/gadget/fotg210-udc.c:379:
> +                       printk(KERN_DEBUG "%s : req->req.length = 0x%x\n",
>
> CHECK: Alignment should match open parenthesis
> #487: FILE: drivers/usb/gadget/fotg210-udc.c:380:
> +                       printk(KERN_DEBUG "%s : req->req.length = 0x%x\n",
> +                               __func__, req->req.length);
>
> CHECK: braces {} should be used on all arms of this statement
> #492: FILE: drivers/usb/gadget/fotg210-udc.c:385:
> +               if (!req->req.length)
> [...]
> +               else {
> [...]
>
> WARNING: line over 80 characters
> #495: FILE: drivers/usb/gadget/fotg210-udc.c:388:
> +                       u32 value = ioread32(ep->fotg210->reg + FOTG210_DMISGR0);
>
> WARNING: Prefer netdev_dbg(netdev, ... then dev_dbg(dev, ... then pr_debug(...  to printk(KERN_DEBUG ...
> #680: FILE: drivers/usb/gadget/fotg210-udc.c:573:
> +               printk(KERN_DEBUG "    0x%x\n", data);
>
> WARNING: Prefer netdev_dbg(netdev, ... then dev_dbg(dev, ... then pr_debug(...  to printk(KERN_DEBUG ...
> #691: FILE: drivers/usb/gadget/fotg210-udc.c:584:
> +               printk(KERN_DEBUG "    0x%x\n", data);
>
> WARNING: Prefer netdev_dbg(netdev, ... then dev_dbg(dev, ... then pr_debug(...  to printk(KERN_DEBUG ...
> #696: FILE: drivers/usb/gadget/fotg210-udc.c:589:
> +               printk(KERN_DEBUG "    0x%x\n", data);
>
> WARNING: Prefer netdev_dbg(netdev, ... then dev_dbg(dev, ... then pr_debug(...  to printk(KERN_DEBUG ...
> #702: FILE: drivers/usb/gadget/fotg210-udc.c:595:
> +               printk(KERN_DEBUG "    0x%x\n", data);
>
> WARNING: Prefer netdev_dbg(netdev, ... then dev_dbg(dev, ... then pr_debug(...  to printk(KERN_DEBUG ...
> #741: FILE: drivers/usb/gadget/fotg210-udc.c:634:
> +       printk(KERN_DEBUG "request error!!\n");
>
> WARNING: line over 80 characters
> #744: FILE: drivers/usb/gadget/fotg210-udc.c:637:
> +static void fotg210_set_address(struct fotg210_udc *fotg210, struct usb_ctrlrequest *ctrl)
>
> WARNING: Avoid CamelCase: <ctrl->wValue>
> #746: FILE: drivers/usb/gadget/fotg210-udc.c:639:
> +       if (ctrl->wValue >= 0x0100)
>
> CHECK: braces {} should be used on all arms of this statement
> #746: FILE: drivers/usb/gadget/fotg210-udc.c:639:
> +       if (ctrl->wValue >= 0x0100)
> [...]
> +       else {
> [...]
>
> WARNING: line over 80 characters
> #754: FILE: drivers/usb/gadget/fotg210-udc.c:647:
> +static void fotg210_set_feature(struct fotg210_udc *fotg210, struct usb_ctrlrequest *ctrl)
>
> WARNING: Avoid CamelCase: <ctrl->bRequestType>
> #756: FILE: drivers/usb/gadget/fotg210-udc.c:649:
> +       switch (ctrl->bRequestType & USB_RECIP_MASK) {
>
> WARNING: Avoid CamelCase: <ctrl->wIndex>
> #765: FILE: drivers/usb/gadget/fotg210-udc.c:658:
> +               epnum = le16_to_cpu(ctrl->wIndex) & USB_ENDPOINT_NUMBER_MASK;
>
> WARNING: line over 80 characters
> #779: FILE: drivers/usb/gadget/fotg210-udc.c:672:
> +static void fotg210_clear_feature(struct fotg210_udc *fotg210, struct usb_ctrlrequest *ctrl)
>
> WARNING: line over 80 characters
> #821: FILE: drivers/usb/gadget/fotg210-udc.c:714:
> +static void fotg210_get_status(struct fotg210_udc *fotg210, struct usb_ctrlrequest *ctrl)
>
> WARNING: line over 80 characters
> #836: FILE: drivers/usb/gadget/fotg210-udc.c:729:
> +                               fotg210_is_epnstall(fotg210->ep[epnum]) << USB_ENDPOINT_HALT;
>
> WARNING: line over 80 characters
> #854: FILE: drivers/usb/gadget/fotg210-udc.c:747:
> +static int fotg210_setup_packet(struct fotg210_udc *fotg210, struct usb_ctrlrequest *ctrl)
>
> CHECK: braces {} should be used on all arms of this statement
> #870: FILE: drivers/usb/gadget/fotg210-udc.c:763:
> +       if ((ctrl->bRequestType & USB_TYPE_MASK) == USB_TYPE_STANDARD) {
> [...]
> +       } else
> [...]
>
> WARNING: Avoid CamelCase: <ctrl->bRequest>
> #871: FILE: drivers/usb/gadget/fotg210-udc.c:764:
> +               switch (ctrl->bRequest) {
>
> CHECK: braces {} should be used on all arms of this statement
> #902: FILE: drivers/usb/gadget/fotg210-udc.c:795:
> +       if (!list_empty(&ep->queue) && !ep->dir_in) {
> [...]
> +       } else
> [...]
>
> CHECK: braces {} should be used on all arms of this statement
> #921: FILE: drivers/usb/gadget/fotg210-udc.c:814:
> +       if ((!list_empty(&ep->queue)) && (ep->dir_in)) {
> [...]
> +       } else
> [...]
>
> WARNING: Prefer netdev_info(netdev, ... then dev_info(dev, ... then pr_info(...  to printk(KERN_INFO ...
> #989: FILE: drivers/usb/gadget/fotg210-udc.c:882:
> +                       printk(KERN_INFO"fotg210 udc reset\n");
>
> WARNING: Prefer netdev_info(netdev, ... then dev_info(dev, ... then pr_info(...  to printk(KERN_INFO ...
> #995: FILE: drivers/usb/gadget/fotg210-udc.c:888:
> +                       printk(KERN_INFO"fotg210 udc suspend\n");
>
> WARNING: Prefer netdev_info(netdev, ... then dev_info(dev, ... then pr_info(...  to printk(KERN_INFO ...
> #1001: FILE: drivers/usb/gadget/fotg210-udc.c:894:
> +                       printk(KERN_INFO"fotg210 udc resume\n");
>
> WARNING: Prefer netdev_info(netdev, ... then dev_info(dev, ... then pr_info(...  to printk(KERN_INFO ...
> #1007: FILE: drivers/usb/gadget/fotg210-udc.c:900:
> +                       printk(KERN_INFO"fotg210 iso sequence error\n");
>
> WARNING: Prefer netdev_info(netdev, ... then dev_info(dev, ... then pr_info(...  to printk(KERN_INFO ...
> #1013: FILE: drivers/usb/gadget/fotg210-udc.c:906:
> +                       printk(KERN_INFO"fotg210 iso sequence abort\n");
>
> WARNING: Prefer netdev_info(netdev, ... then dev_info(dev, ... then pr_info(...  to printk(KERN_INFO ...
> #1020: FILE: drivers/usb/gadget/fotg210-udc.c:913:
> +                       printk(KERN_INFO"fotg210 transferred 0 byte\n");
>
> WARNING: Prefer netdev_info(netdev, ... then dev_info(dev, ... then pr_info(...  to printk(KERN_INFO ...
> #1027: FILE: drivers/usb/gadget/fotg210-udc.c:920:
> +                       printk(KERN_INFO"fotg210 received 0 byte\n");
>
> WARNING: Prefer netdev_info(netdev, ... then dev_info(dev, ... then pr_info(...  to printk(KERN_INFO ...
> #1047: FILE: drivers/usb/gadget/fotg210-udc.c:940:
> +                       printk(KERN_INFO "fotg210 CX command abort\n");
>
> WARNING: Prefer netdev_info(netdev, ... then dev_info(dev, ... then pr_info(...  to printk(KERN_INFO ...
> #1051: FILE: drivers/usb/gadget/fotg210-udc.c:944:
> +                       printk(KERN_INFO "fotg210 ep0 setup\n");
>
> WARNING: line over 80 characters
> #1054: FILE: drivers/usb/gadget/fotg210-udc.c:947:
> +                               if (fotg210->driver->setup(&fotg210->gadget, &ctrl) < 0)
>
> WARNING: Prefer netdev_info(netdev, ... then dev_info(dev, ... then pr_info(...  to printk(KERN_INFO ...
> #1060: FILE: drivers/usb/gadget/fotg210-udc.c:953:
> +                       printk(KERN_INFO "fotg210 cmd end\n");
>
> WARNING: Prefer netdev_info(netdev, ... then dev_info(dev, ... then pr_info(...  to printk(KERN_INFO ...
> #1070: FILE: drivers/usb/gadget/fotg210-udc.c:963:
> +                       printk(KERN_INFO "fotg210 ep0 fail\n");
>
> CHECK: Alignment should match open parenthesis
> #1129: FILE: drivers/usb/gadget/fotg210-udc.c:1022:
> +       iowrite32(GMIR_MHC_INT | GMIR_MOTG_INT | GMIR_INT_POLARITY,
> +               fotg210->reg + FOTG210_GMIR);
>
> WARNING: space prohibited before semicolon
> #1237: FILE: drivers/usb/gadget/fotg210-udc.c:1130:
> +       for (i = 0; i < FOTG210_MAX_NUM_EP ; i++) {
>
> CHECK: Alignment should match open parenthesis
> #1243: FILE: drivers/usb/gadget/fotg210-udc.c:1136:
> +                       list_add_tail(&fotg210->ep[i]->ep.ep_list,
> +                                    &fotg210->gadget.ep_list);
>
> WARNING: kfree(NULL) is safe this check is probably not required
> #1291: FILE: drivers/usb/gadget/fotg210-udc.c:1184:
> +       if (fotg210)
> +               kfree(fotg210);
>
> CHECK: No space is necessary after a cast
> #1298: FILE: drivers/usb/gadget/fotg210-udc.c:1191:
> +       .driver         = {
> +               .name = (char *) udc_name,
>
> WARNING: line over 80 characters
> #1477: FILE: drivers/usb/gadget/fotg210.h:162:
> +#define EPMAP_FIFONO(ep, dir)  ((((ep) - 1) << ((ep) - 1) * 8) << ((dir) ? 0 : 4))
>
> WARNING: line over 80 characters
> #1478: FILE: drivers/usb/gadget/fotg210.h:163:
> +#define EPMAP_FIFONOMSK(ep, dir)       ((3 << ((ep) - 1) * 8) << ((dir) ? 0 : 4))
>
> CHECK: spinlock_t definition without comment
> #1549: FILE: drivers/usb/gadget/fotg210.h:234:
> +       spinlock_t              lock;
>
> total: 0 errors, 45 warnings, 13 checks, 1472 lines checked
>
> Your patch has style problems, please review.
>
> If any of these errors are false positives, please report
> them to the maintainer, see CHECKPATCH in MAINTAINERS.
>

Sorry about my negligence. I'll fix and resend it later.
Thanks for your time.

Yuan-Hsin

> --
> balbi
