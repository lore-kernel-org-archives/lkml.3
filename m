Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756208AbaGIONO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 10:13:14 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:65439 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755470AbaGIONM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 10:13:12 -0400
Message-ID: <53BD4DFD.6070805@cogentembedded.com>
Date: Wed, 09 Jul 2014 18:13:17 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Richard Weinberger <richard@nod.at>, kys@microsoft.com,
        haiyangz@microsoft.com
CC: romieu@fr.zoreil.com, devel@linuxdriverproject.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] hyperv: Add netpoll support
References: <1404892702-11094-1-git-send-email-richard@nod.at>
In-Reply-To: <1404892702-11094-1-git-send-email-richard@nod.at>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 07/09/2014 11:58 AM, Richard Weinberger wrote:

> In order to have at least a netconsole to debug kernel issues on
> Windows Azure this patch implements netpoll support.
> Sending packets is easy, netvsc_start_xmit() does already everything
> needed.

> Signed-off-by: Richard Weinberger <richard@nod.at>
> ---
>   drivers/net/hyperv/netvsc_drv.c | 11 +++++++++++
>   1 file changed, 11 insertions(+)

> diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
> index 4fd71b7..45218d5 100644
> --- a/drivers/net/hyperv/netvsc_drv.c
> +++ b/drivers/net/hyperv/netvsc_drv.c
> @@ -736,6 +736,14 @@ static int netvsc_set_mac_addr(struct net_device *ndev, void *p)
>   	return err;
>   }
>
> +#ifdef CONFIG_NET_POLL_CONTROLLER
> +static void netvsc_poll_controller(struct net_device *net)
> +{
> +	/* As netvsc_start_xmit() works synchronous we don't have to
> +	   trigger anything here. */

    The multi-line comment style in the networking code is this:

/* bla
  * bla
  */

> +	return;

    Not needed.

> +}
> +#endif
[...]

WBR, Sergei

