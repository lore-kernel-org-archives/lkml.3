Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752734AbbAIUfY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 15:35:24 -0500
Received: from smtprelay.synopsys.com ([198.182.60.111]:38071 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137AbbAIUfV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 15:35:21 -0500
From: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>,
        Mian Yousaf Kaukab <yousaf.kaukab@intel.com>
CC: "gregory.herrero@intel.com" <gregory.herrero@intel.com>,
        "sergei.shtylyov@cogentembedded.com" 
	<sergei.shtylyov@cogentembedded.com>,
        "r.baldyga@samsung.com" <r.baldyga@samsung.com>,
        "dinguyen@opensource.altera.com" <dinguyen@opensource.altera.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "balbi@ti.com" <balbi@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>
Subject: RE: [PATCH v3 00/30] usb: updates for dwc2 gadget driver
Thread-Topic: [PATCH v3 00/30] usb: updates for dwc2 gadget driver
Thread-Index: AQHQLAk/1fJWIjVioUqLRXNqP3WmEZy4Ot5g
Date: Fri, 9 Jan 2015 20:35:19 +0000
Message-ID: <A2CA0424C0A6F04399FB9E1CD98E0304845066AC@US01WEMBX2.internal.synopsys.com>
References: <1420807150-27022-1-git-send-email-yousaf.kaukab@intel.com>
In-Reply-To: <1420807150-27022-1-git-send-email-yousaf.kaukab@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.13.184.20]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CCing more of the Samsung folks and linux-kernel.

Robert, Marek, can you test this series on your platform, please? If
I don't hear from you soon, I'll just ack it and we can deal with any
breakage later.

-- 
Paul

> From: Mian Yousaf Kaukab [mailto:yousaf.kaukab@intel.com]
> Sent: Friday, January 09, 2015 4:39 AM
> 
> Hi,
> This patchset consists of various bug fixes and feature enhancements for the
> dwc2 gadget driver. All the patches are verified on dwc2 v3.0a with dedicated
> fifos. Main focus of testing was with dma enabled. Although basic testing
> without dma was also done.
> 
> It is based on testing/next branch in Felipe's git and
> 
> Tested-by: Dinh Nguyen <dinguyen@opensource.altera.com>
> 
> Thank you,
> 
> Best regards,
> Yousaf
> 
> History:
> v3:
>  - Fixed comment from Sergei Shtylyov
>  - Updated "usb: dwc2: gadget: don't process XferCompl on setup packet" to
>    apply the check on endpoint 0 only.
>  - Fixed regression in "usb: dwc2: gadget: manage ep0 state in software" for
>    dwc2 ip v2.93a, found by Dinh Nguyen.
> 
> v2:
>  - Rebased to Felipe's testing/next with https://lkml.org/lkml/2014/12/16/135
>    applied on top.
>  - Fixed comments from  Robert Baldyga
>  - Some cosmetic changes
>  - Replaced usb: dwc2: gadget: process setup packet on transfer complete
>    with
>    usb: dwc2: gadget: don't process XferCompl on setup packet
>  - Updated usb: dwc2: gadget: provide gadget handle to the phy
>    so that otg_set_peripheral is called in both udc_start and udc_stop.
> 
> v1:
>  - Addressed comments from Sergei Shtylyov
> 
> Gregory Herrero (13):
>   usb: dwc2: gadget: register gadget handle to the phy
>   usb: dwc2: gadget: write correct value in ahbcfg register
>   usb: dwc2: gadget: don't erase gahbcfg register when enabling dma
>   usb: dwc2: gadget: add device tree property to enable dma
>   Documentation: dt-bindings: add dt binding info for dwc2 g-use-dma
>   usb: dwc2: gadget: configure fifos from device tree
>   Documentation: dt-bindings: add dt binding info for dwc2 fifo resizing
>   usb: dwc2: gadget: don't block after fifo flush timeout
>   usb: dwc2: gadget: add vbus_session support
>   usb: dwc2: gadget: reset fifo_map when initializing fifos
>   usb: dwc2: gadget: fix pullup handling
>   usb: dwc2: gadget: add vbus_draw support
>   usb: dwc2: gadget: force gadget initialization in dev mode
> 
> Mian Yousaf Kaukab (17):
>   usb: dwc2: gadget: mask fifo empty irq with dma
>   usb: dwc2: gadget: don't process XferCompl on setup packet
>   usb: dwc2: gadget: don't embed ep0 buffers
>   usb: dwc2: gadget: fix error path in dwc2_gadget_init
>   usb: dwc2: gadget: add bi-directional endpoint support
>   usb: dwc2: gadget: check interrupts for all endpoints
>   usb: dwc2: gadget: remove unused members from hsotg_req
>   usb: dwc2: gadget: fix debug loop limits
>   usb: dwc2: gadget: consider all tx fifos
>   usb: dwc2: gadget: kill requests after disabling ep
>   usb: dwc2: gadget: manage ep0 state in software
>   usb: dwc2: gadget: fix zero length packet transfers
>   usb: dwc2: gadget: dont warn if endpoint is not enabled
>   usb: dwc2: gadget: rename sent_zlp to send_zlp
>   usb: dwc2: gadget: pick smallest acceptable fifo
>   usb: dwc2: gadget: fix fifo allocation leak
>   usb: dwc2: gadget: report disconnection after reset
> 
>  Documentation/devicetree/bindings/usb/dwc2.txt |   4 +
>  drivers/usb/dwc2/core.h                        |  46 +-
>  drivers/usb/dwc2/gadget.c                      | 792 ++++++++++++++++---------
>  drivers/usb/dwc2/hw.h                          |   1 +
>  4 files changed, 556 insertions(+), 287 deletions(-)
> 
> --
> 1.9.1

