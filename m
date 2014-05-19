Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911AbaESLGC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 07:06:02 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:44954 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138AbaESLF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 07:05:59 -0400
Message-ID: <5379E596.7010308@cogentembedded.com>
Date: Mon, 19 May 2014 15:05:58 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: George Cherian <george.cherian@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-usb@vger.kernel.org
CC: gregkh@linuxfoundation.org, balbi@ti.com
Subject: Re: [PATCH v2 1/6] usb: dwc3: dwc3-omap: Remove x_major calculation
 from revision register
References: <1400488377-10605-1-git-send-email-george.cherian@ti.com> <1400488377-10605-2-git-send-email-george.cherian@ti.com>
In-Reply-To: <1400488377-10605-2-git-send-email-george.cherian@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 19-05-2014 12:32, George Cherian wrote:

> Remove the x_major calculation logic from the wrapper revision register
> to differentiate between OMAP5 and AM437x. This was done to find the
> register offsets of wrapper register. Now that We do it using dt
> compatible, remove the whole logic.

> Signed-off-by: George Cherian <george.cherian@ti.com>
> ---
>   drivers/usb/dwc3/dwc3-omap.c | 35 +++--------------------------------
>   1 file changed, 3 insertions(+), 32 deletions(-)

> diff --git a/drivers/usb/dwc3/dwc3-omap.c b/drivers/usb/dwc3/dwc3-omap.c
> index 1160ff4..53f6490 100644
> --- a/drivers/usb/dwc3/dwc3-omap.c
> +++ b/drivers/usb/dwc3/dwc3-omap.c
[...]
> @@ -448,32 +442,9 @@ static int dwc3_omap_probe(struct platform_device *pdev)
[...]
> -	/* For OMAP5(ES2.0) and AM437x x_major is 2 even though there are
> -	 * changes in wrapper registers, Using dt compatible for aegis
> +	/* Differentiate between OMAP5 and AM437x
> +	 * For OMAP5(ES2.0) and AM437x x_major is 2 even though there are
> +	 * changes in wrapper registers, Using dt compatible for AM437x

    This sentence doesn't look complete...

>   	 */
>
>   	if (of_device_is_compatible(node, "ti,am437x-dwc3")) {

WBR, Sergei

