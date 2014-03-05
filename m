Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754552AbaCEMei (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 07:34:38 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:41419 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752250AbaCEMeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 07:34:08 -0500
Message-ID: <531719C2.3070708@cogentembedded.com>
Date: Wed, 05 Mar 2014 16:34:10 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>, Felipe Balbi <balbi@ti.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH v5 10/14] usb: phy: msm: Use reset framework for LINK
 and PHY resets
References: <1394014430-26485-1-git-send-email-iivanov@mm-sol.com> <1394014430-26485-11-git-send-email-iivanov@mm-sol.com>
In-Reply-To: <1394014430-26485-11-git-send-email-iivanov@mm-sol.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 05-03-2014 14:13, Ivan T. Ivanov wrote:

> From: "Ivan T. Ivanov" <iivanov@mm-sol.com>

> Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
> ---
>   drivers/usb/phy/phy-msm-usb.c |   30 ++++++++++++++++++++++--------
>   include/linux/usb/msm_hsusb.h |    3 +++
>   2 files changed, 25 insertions(+), 8 deletions(-)

> diff --git a/drivers/usb/phy/phy-msm-usb.c b/drivers/usb/phy/phy-msm-usb.c
> index 298820f..7e5c4ab 100644
> --- a/drivers/usb/phy/phy-msm-usb.c
> +++ b/drivers/usb/phy/phy-msm-usb.c
[...]
> @@ -235,12 +236,16 @@ static void ulpi_init(struct msm_otg *motg)
>
>   static int msm_otg_link_clk_reset(struct msm_otg *motg, bool assert)
>   {
> -	int ret = 0;
> +	int ret;
>
> -	if (!motg->pdata->link_clk_reset)
> -		return ret;
> +	if (motg->pdata->link_clk_reset)
> +		ret = motg->pdata->link_clk_reset(motg->clk, assert);
> +	else
> +		if (assert)

    Kernel style assumes:

	else if (assert)

> +			ret = reset_control_assert(motg->link_rst);
> +		else
> +			ret = reset_control_deassert(motg->link_rst);
>
[...]

WBR, Sergei

