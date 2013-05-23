Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758661Ab3EWOVq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 10:21:46 -0400
Received: from mga03.intel.com ([143.182.124.21]:15205 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757502Ab3EWOVp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 10:21:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,728,1363158000"; 
   d="scan'208";a="306839361"
Message-ID: <519E25F8.8020905@intel.com>
Date: Thu, 23 May 2013 07:21:44 -0700
From: Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: Wei Yongjun <weiyj.lk@gmail.com>
CC: forest@alittletooquiet.net, gregkh@linuxfoundation.org, joe@perches.com,
        hemaklnce@gmail.com, marcos.souza.org@gmail.com,
        yongjun_wei@trendmicro.com.cn, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] Staging: vt6655: add missing free_netdev() on error
 in hostap_enable_hostapd()
References: <CAPgLHd_qqOWWnWFXYbAks3LmhCcH3hGaqCw9KT+bkLwZazSCbA@mail.gmail.com>
In-Reply-To: <CAPgLHd_qqOWWnWFXYbAks3LmhCcH3hGaqCw9KT+bkLwZazSCbA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/2013 02:28 AM, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>
> Add the missing free_netdev() before return from function
> hostap_enable_hostapd() in the error handling case.
>
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>   drivers/staging/vt6655/hostap.c | 2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/drivers/staging/vt6655/hostap.c b/drivers/staging/vt6655/hostap.c
> index 46f097d..57a08c5 100644
> --- a/drivers/staging/vt6655/hostap.c
> +++ b/drivers/staging/vt6655/hostap.c
> @@ -104,6 +104,8 @@ static int hostap_enable_hostapd(PSDevice pDevice, int rtnl_locked)
>   	if (ret) {
>   		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "%s: register_netdevice(AP) failed!\n",
>   			dev->name);
> +		free_netdev(pDevice->apdev);
> +		pDevice->apdev = NULL;
>   		return -1;
>   	}
>   
>
This looks good to me.

-PJ
