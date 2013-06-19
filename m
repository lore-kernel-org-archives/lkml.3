Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756810Ab3FSNrs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 09:47:48 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:39913 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756623Ab3FSNrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 09:47:46 -0400
Message-ID: <51C1B684.6010700@cogentembedded.com>
Date: Wed, 19 Jun 2013 17:47:48 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Stephen Moorby <steve.moorby@ntlworld.com>
CC: davem@davemloft.net, jiri@resnulli.us, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] drivers/net: param for lapbether for specific ethernet
 device
References: <51C16A07.3070903@ntlworld.com>
In-Reply-To: <51C16A07.3070903@ntlworld.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 19-06-2013 12:21, Stephen Moorby wrote:

>  From 35607dd0607bca5322860703143c31cb04377764 Mon Sep 17 00:00:00 2001
> From: Stephen Moorby <steve.moorby@ntlworld.com>
> Date: Wed, 19 Jun 2013 08:22:51 +0100
> Subject: [PATCH 1/1] drivers/net: param for lapbether for specific ethernet
>   device

    No need for this header.

> The lapbether driver binds to the first ethernet device that comes up.
> This causes problems in hardware with multiple ethernet interfaces,
> potentially resulting in the LAPB traffic on the wrong interface.
> Have added a module parameter 'eth_dev' to specify the ethernet
> interface over which lapbether should operate.  The module behaves
> as before if no device is specified.
>
> Patch created on linux-next 18-Jun-2013.
> Tested on 2.6.32-45-generic.
>
> Signed-off-by: Stephen Moorby <steve.moorby@ntlworld.com>
> ---
>   drivers/net/wan/lapbether.c | 15 +++++++++++++--
>   1 file changed, 13 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wan/lapbether.c b/drivers/net/wan/lapbether.c
> index a33a46f..510fc4a 100644
> --- a/drivers/net/wan/lapbether.c
> +++ b/drivers/net/wan/lapbether.c
[...]
> @@ -381,8 +382,14 @@ static int lapbeth_device_event(struct
> notifier_block *this,

    Your patch is line-wrapped.

>       switch (event) {
>       case NETDEV_UP:
>           /* New ethernet device -> new LAPB interface     */
> -        if (lapbeth_get_x25_dev(dev) == NULL)
> -            lapbeth_new_device(dev);
> +        if (lapbeth_get_x25_dev(dev) == NULL) {
> +            if (NULL != eth_dev) {
> +                if (0 == strcmp(dev->name, eth_dev))
> +                    lapbeth_new_device(dev);
> +            } else {
> +                lapbeth_new_device(dev);
> +            }
> +        }

    It seems the patch is also white space damaged, i.e. tabs converted 
to spaces.

WBR, Sergei

