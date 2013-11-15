Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752984Ab3KOT7k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 14:59:40 -0500
Received: from us02smtp1.synopsys.com ([198.182.60.75]:33857 "EHLO
	vaxjo.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800Ab3KOT7b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 14:59:31 -0500
From: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
To: Julien DELACOU <julien.delacou@st.com>,
        Matthijs Kooijman <matthijs@stdin.nl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Grant Likely" <grant.likely@linaro.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>
Subject: RE: [PATCH] staging: dwc2: do not clear pending interrupts twice
Thread-Topic: [PATCH] staging: dwc2: do not clear pending interrupts twice
Thread-Index: AQHO4e8T/WECxG+b+k6r50u18QwTIpomtgbA
Date: Fri, 15 Nov 2013 19:59:29 +0000
Message-ID: <A2CA0424C0A6F04399FB9E1CD98E030458E26C20@US01WEMBX2.internal.synopsys.com>
References: <1384511978-18770-1-git-send-email-julien.delacou@st.com>
In-Reply-To: <1384511978-18770-1-git-send-email-julien.delacou@st.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.9.64.241]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Julien DELACOU [mailto:julien.delacou@st.com]
> Sent: Friday, November 15, 2013 2:40 AM
> 
> Pending interrupts clearing is done in dwc2_enable_common_interrupts
> so we don't need to do it twice.
> 
> Signed-off-by: Julien Delacou <julien.delacou@st.com>
> ---
>  drivers/staging/dwc2/core.c |    3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/drivers/staging/dwc2/core.c b/drivers/staging/dwc2/core.c
> index c8ff668..8374ec3 100644
> --- a/drivers/staging/dwc2/core.c
> +++ b/drivers/staging/dwc2/core.c
> @@ -533,9 +533,6 @@ void dwc2_enable_host_interrupts(struct dwc2_hsotg *hsotg)
>  	writel(0, hsotg->regs + GINTMSK);
>  	writel(0, hsotg->regs + HAINTMSK);
> 
> -	/* Clear any pending interrupts */
> -	writel(0xffffffff, hsotg->regs + GINTSTS);
> -
>  	/* Enable the common interrupts */
>  	dwc2_enable_common_interrupts(hsotg);
> 
> --

Acked-by: Paul Zimmerman <paulz@synopsys.com>

