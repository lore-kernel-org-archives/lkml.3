Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753273Ab3KANit (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 09:38:49 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:53807 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752916Ab3KANir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 09:38:47 -0400
Message-ID: <5273AEE2.2010005@cogentembedded.com>
Date: Fri, 01 Nov 2013 17:38:42 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Duan Jiong <duanj.fnst@cn.fujitsu.com>, acme@ghostprotocols.net
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/net: replace IS_ERR and PTR_ERR with PTR_ERR_OR_ZERO
References: <1383300016-5947-1-git-send-email-duanj.fnst@cn.fujitsu.com>
In-Reply-To: <1383300016-5947-1-git-send-email-duanj.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 01-11-2013 14:00, Duan Jiong wrote:

> This patch fixes coccinelle error regarding usage of IS_ERR and
> PTR_ERR instead of PTR_ERR_OR_ZERO.

> Signed-off-by: Duan Jiong <duanj.fnst@cn.fujitsu.com>
> ---
>   drivers/net/appletalk/ipddp.c | 4 +---
>   1 file changed, 1 insertion(+), 3 deletions(-)

> diff --git a/drivers/net/appletalk/ipddp.c b/drivers/net/appletalk/ipddp.c
> index 10d0dba..78f06cb 100644
> --- a/drivers/net/appletalk/ipddp.c
> +++ b/drivers/net/appletalk/ipddp.c
> @@ -312,9 +312,7 @@ module_param(ipddp_mode, int, 0);
>   static int __init ipddp_init_module(void)
>   {
>   	dev_ipddp = ipddp_init();
> -        if (IS_ERR(dev_ipddp))
> -                return PTR_ERR(dev_ipddp);
> -	return 0;
> +        return PTR_ERR_OR_ZERO(dev_ipddp);

    Indent with a tab, please.

WBR, Sergei

