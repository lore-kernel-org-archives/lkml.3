Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238AbaBJN3A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 08:29:00 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:49472 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752924AbaBJN25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 08:28:57 -0500
Message-ID: <52F8D417.6020302@cogentembedded.com>
Date: Mon, 10 Feb 2014 17:28:55 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Haiyang Zhang <haiyangz@microsoft.com>, davem@davemloft.net,
        netdev@vger.kernel.org
CC: kys@microsoft.com, olaf@aepfle.de, jasowang@redhat.com,
        linux-kernel@vger.kernel.org, driverdev-devel@linuxdriverproject.org
Subject: Re: [PATCH net] hyperv: Fix the carrier status setting
References: <1391994478-25809-1-git-send-email-haiyangz@microsoft.com>
In-Reply-To: <1391994478-25809-1-git-send-email-haiyangz@microsoft.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 10-02-2014 5:07, Haiyang Zhang wrote:

> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> Reviewed-by: K. Y. Srinivasan <kys@microsoft.com>
> ---
>   drivers/net/hyperv/netvsc_drv.c |   24 +++++++++++++++---------
>   1 files changed, 15 insertions(+), 9 deletions(-)

> diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
> index 7756118..836211c 100644
> --- a/drivers/net/hyperv/netvsc_drv.c
> +++ b/drivers/net/hyperv/netvsc_drv.c
[...]
> @@ -229,15 +238,17 @@ void netvsc_linkstatus_callback(struct hv_device *device_obj,
>   	struct net_device *net;
>   	struct net_device_context *ndev_ctx;
>   	struct netvsc_device *net_device;
> +	struct rndis_device *rdev;
>
>   	net_device = hv_get_drvdata(device_obj);
> +	rdev = net_device->extension;
> +
> +	rdev->link_state = !(status == 1);

    Why not just 'status != 1'?

WBR, Sergei

