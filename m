Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024AbbANTDl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 14:03:41 -0500
Received: from smtprelay4.synopsys.com ([198.182.47.9]:59872 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004AbbANTDj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 14:03:39 -0500
From: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
To: Robert Baldyga <r.baldyga@samsung.com>, "balbi@ti.com" <balbi@ti.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dinguyen@opensource.altera.com" <dinguyen@opensource.altera.com>,
        "yousaf.kaukab@intel.com" <yousaf.kaukab@intel.com>,
        "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>
Subject: RE: [PATCH v2] usb: dwc2: call dwc2_is_controller_alive() under
 spinlock
Thread-Topic: [PATCH v2] usb: dwc2: call dwc2_is_controller_alive() under
 spinlock
Thread-Index: AQHQL8W5lMCdaYrjlUuC2oTfEkhvI5y/95kg
Date: Wed, 14 Jan 2015 19:03:37 +0000
Message-ID: <A2CA0424C0A6F04399FB9E1CD98E030484507633@US01WEMBX2.internal.synopsys.com>
References: <1421217931-23722-1-git-send-email-r.baldyga@samsung.com>
In-Reply-To: <1421217931-23722-1-git-send-email-r.baldyga@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.13.184.19]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Robert Baldyga [mailto:r.baldyga@samsung.com]
> Sent: Tuesday, January 13, 2015 10:46 PM
> 
> This patch fixes bug described here:
> https://lkml.org/lkml/2014/12/22/185
> 
> Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>

Although I don't understand *why* this fixes Robert's issue, it's
certainly a harmless patch, so

Acked-by: Paul Zimmerman <paulz@synopsys.com>

But I suspect Felipe will want a better changelog, I don't think just
a URL is good enough.

-- 
Paul

> ---
> 
> Changelog:
> 
> v2:
> - fixed comment from Paul Zimmerman
> 
> v1: https://lkml.org/lkml/2015/1/13/186
> 
>  drivers/usb/dwc2/core_intr.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/usb/dwc2/core_intr.c b/drivers/usb/dwc2/core_intr.c
> index ad43c5b..02e3e2d 100644
> --- a/drivers/usb/dwc2/core_intr.c
> +++ b/drivers/usb/dwc2/core_intr.c
> @@ -476,13 +476,13 @@ irqreturn_t dwc2_handle_common_intr(int irq, void *dev)
>  	u32 gintsts;
>  	irqreturn_t retval = IRQ_NONE;
> 
> +	spin_lock(&hsotg->lock);
> +
>  	if (!dwc2_is_controller_alive(hsotg)) {
>  		dev_warn(hsotg->dev, "Controller is dead\n");
>  		goto out;
>  	}
> 
> -	spin_lock(&hsotg->lock);
> -
>  	gintsts = dwc2_read_common_intr(hsotg);
>  	if (gintsts & ~GINTSTS_PRTINT)
>  		retval = IRQ_HANDLED;
> @@ -515,8 +515,8 @@ irqreturn_t dwc2_handle_common_intr(int irq, void *dev)
>  		}
>  	}
> 
> -	spin_unlock(&hsotg->lock);
>  out:
> +	spin_unlock(&hsotg->lock);
>  	return retval;
>  }
>  EXPORT_SYMBOL_GPL(dwc2_handle_common_intr);
> --
> 1.9.1

