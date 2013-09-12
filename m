Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757587Ab3ILAnF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 20:43:05 -0400
Received: from mga11.intel.com ([192.55.52.93]:10475 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751464Ab3ILAnC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 20:43:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,887,1371106800"; 
   d="scan'208";a="400276793"
Message-ID: <52310EFA.6060509@linux.intel.com>
Date: Wed, 11 Sep 2013 17:46:50 -0700
From: David Cohen <david.a.cohen@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130821 Icedove/17.0.8
MIME-Version: 1.0
To: balbi@ti.com
CC: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: dwc3: gadget: avoid memory leak when failing to
 allocate all eps
References: <1378946310-28421-1-git-send-email-david.a.cohen@linux.intel.com>
In-Reply-To: <1378946310-28421-1-git-send-email-david.a.cohen@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mr. Balbi, :)

On 09/11/2013 05:38 PM, David Cohen wrote:
> If dwc3_gadget_init_endpoint() fails after allocate some of the eps, we
> need to free their memory to avoid leak.
>
> Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
> ---
>   drivers/usb/dwc3/gadget.c | 13 ++++++++-----
>   1 file changed, 8 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
> index f168eae..611bdba 100644
> --- a/drivers/usb/dwc3/gadget.c
> +++ b/drivers/usb/dwc3/gadget.c
> @@ -1707,8 +1707,13 @@ static void dwc3_gadget_free_endpoints(struct dwc3 *dwc)
>   
>   	for (epnum = 0; epnum < DWC3_ENDPOINTS_NUM; epnum++) {
>   		dep = dwc->eps[epnum];
> +		/*
> +		 * Because dwc was allocated by kzalloc() and eps are set
> +		 * in ascending order, we can assume no extra one was
> +		 * allocated after first dep == NULL.
> +		 */

Wrong assumption here. Please consider patch v2 instead.

BR, David Cohen

