Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932761AbaFPWAq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 18:00:46 -0400
Received: from smtprelay4.synopsys.com ([198.182.44.111]:52482 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932726AbaFPWAo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 18:00:44 -0400
From: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
To: Joe Perches <joe@perches.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: RE: [PATCH -next 24/26] usb: Use dma_zalloc_coherent
Thread-Topic: [PATCH -next 24/26] usb: Use dma_zalloc_coherent
Thread-Index: AQHPiNng6lvdxePV1UasNtVfaYRxiJt0SizA
Date: Mon, 16 Jun 2014 22:00:42 +0000
Message-ID: <A2CA0424C0A6F04399FB9E1CD98E0304844B776A@US01WEMBX2.internal.synopsys.com>
References: <cover.1402863904.git.joe@perches.com>
 <1816dd87707535b6442e5c75fde9f799821c457a.1402863905.git.joe@perches.com>
In-Reply-To: <1816dd87707535b6442e5c75fde9f799821c457a.1402863905.git.joe@perches.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.9.64.240]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Joe Perches [mailto:joe@perches.com]
> Sent: Sunday, June 15, 2014 1:38 PM
> 
> Use the zeroing function instead of dma_alloc_coherent & memset(,0,)
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/usb/dwc2/hcd_ddma.c | 20 +++++++-------------
>  drivers/usb/host/uhci-hcd.c |  7 +++----
>  2 files changed, 10 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/usb/dwc2/hcd_ddma.c b/drivers/usb/dwc2/hcd_ddma.c
> index 3376177..ab8d7fc 100644
> --- a/drivers/usb/dwc2/hcd_ddma.c
> +++ b/drivers/usb/dwc2/hcd_ddma.c
> @@ -87,17 +87,12 @@ static u16 dwc2_frame_incr_val(struct dwc2_qh *qh)
>  static int dwc2_desc_list_alloc(struct dwc2_hsotg *hsotg, struct dwc2_qh *qh,
>  				gfp_t flags)
>  {
> -	qh->desc_list = dma_alloc_coherent(hsotg->dev,
> -				sizeof(struct dwc2_hcd_dma_desc) *
> -				dwc2_max_desc_num(qh), &qh->desc_list_dma,
> -				flags);
> -
> +	qh->desc_list = dma_zalloc_coherent(hsotg->dev,
> +					    sizeof(struct dwc2_hcd_dma_desc) * dwc2_max_desc_num(qh),
> +					    &qh->desc_list_dma, flags);

This will cause checkpatch to complain about a too-long line, surely?
If you fix that, you can add my acked-by for the dwc2 parts.

-- 
Paul

