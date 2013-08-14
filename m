Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933391Ab3HNVmE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 17:42:04 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:64750 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933276Ab3HNVmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 17:42:01 -0400
Message-ID: <520BF9B0.80104@cogentembedded.com>
Date: Thu, 15 Aug 2013 01:42:08 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Julia Lawall <Julia.Lawall@lip6.fr>
CC: Francois Romieu <romieu@fr.zoreil.com>, roszenrami@gmail.com,
        dshwatrz@gmail.com, kernel-janitors@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        grant.likely@linaro.org, rob.herring@calxeda.com
Subject: Re: [PATCH] drivers/net/ethernet/via/via-velocity.c: update napi
 implementation
References: <1376490413-12067-1-git-send-email-Julia.Lawall@lip6.fr>
In-Reply-To: <1376490413-12067-1-git-send-email-Julia.Lawall@lip6.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 08/14/2013 06:26 PM, Julia Lawall wrote:

> From: Julia Lawall <Julia.Lawall@lip6.fr>

> Drivers supporting NAPI should use a NAPI-specific function for receiving
> packets.  Hence netif_rx is changed to netif_receive_skb.

> Furthermore netif_napi_del should be used in the probe and remove function
> to clean up the NAPI resource information.

> Thanks to Francois Romieu, David Shwatrz and Rami Rosen for their help on
> this patch.

> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

> ---
> I still don't understand the reason for choosing netif_receive_skb,
> specifically.  This patch is not tested.

    This driver is not the only one with the netif_rx() used with NAPI issue. 
I also overlooked this when converting drivers/net/ethernet/renesas/sh_eth.c 
to NAPI. I'll try to change the call and see if netperf would behave better...

WBR, Sergei

