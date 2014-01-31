Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932344AbaAaNK6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 08:10:58 -0500
Received: from mail-la0-f54.google.com ([209.85.215.54]:55447 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932249AbaAaNKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 08:10:50 -0500
Message-ID: <52EBA0E2.7050208@cogentembedded.com>
Date: Fri, 31 Jan 2014 17:10:58 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Zoran Markovic <zoran.markovic@linaro.org>, linux-kernel@vger.kernel.org
CC: netdev@vger.kernel.org, Shaibal Dutta <shaibal.dutta@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC PATCH] net: ipv4: move inetpeer garbage collector work to
 power efficient workqueue
References: <1391125213-8119-1-git-send-email-zoran.markovic@linaro.org>
In-Reply-To: <1391125213-8119-1-git-send-email-zoran.markovic@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 31-01-2014 3:40, Zoran Markovic wrote:

> From: Shaibal Dutta <shaibal.dutta@broadcom.com>

> Garbage collector work does not have to be bound to the CPU that scheduled
> it. By moving work to the power-efficient workqueue, the selection of
> CPU executing the work is left to the scheduler. This extends idle
> residency times and conserves power.

> This functionality is enabled when CONFIG_WQ_POWER_EFFICIENT is selected.

> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
> Cc: James Morris <jmorris@namei.org>
> Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
> Cc: Patrick McHardy <kaber@trash.net>
> Signed-off-by: Shaibal Dutta <shaibal.dutta@broadcom.com>
> [zoran.markovic@linaro.org: Rebased to latest kernel version. Added
> commit message.]
> Signed-off-by: Zoran Markovic <zoran.markovic@linaro.org>
> ---
>   net/ipv4/inetpeer.c |    6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)

> diff --git a/net/ipv4/inetpeer.c b/net/ipv4/inetpeer.c
> index 48f4244..87155aa 100644
> --- a/net/ipv4/inetpeer.c
> +++ b/net/ipv4/inetpeer.c
> @@ -161,7 +161,8 @@ static void inetpeer_gc_worker(struct work_struct *work)
>   	list_splice(&list, &gc_list);
>   	spin_unlock_bh(&gc_lock);
>
> -	schedule_delayed_work(&gc_work, gc_delay);
> +	queue_delayed_work(system_power_efficient_wq,
> +		&gc_work, gc_delay);

    Please align the continuation line under the next character after ( on the 
broken up line.

> @@ -576,7 +577,8 @@ static void inetpeer_inval_rcu(struct rcu_head *head)
>   	list_add_tail(&p->gc_list, &gc_list);
>   	spin_unlock_bh(&gc_lock);
>
> -	schedule_delayed_work(&gc_work, gc_delay);
> +	queue_delayed_work(system_power_efficient_wq,
> +		&gc_work, gc_delay);

    Same here. This is according to networking coding style.

WBR, Sergei

