Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965462AbaGRKOa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 06:14:30 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:49159 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934338AbaGRKO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 06:14:27 -0400
Message-ID: <53C8F332.8010604@gmail.com>
Date: Fri, 18 Jul 2014 15:43:06 +0530
From: Varka Bhadram <varkabhadram@gmail.com>
Organization: CDAC-HYD
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Yue Zhang <yuezha@microsoft.com>, netdev@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, olaf@aepfle.de, jasowang@redhat.com,
        davem@davemloft.net
CC: haiyangz@microsoft.com, kys@microsoft.com, huishao@microsoft.com,
        decui@microsoft.com
Subject: Re: [PATCH] Hyperv: Trigger DHCP renew after host hibernation
References: <1405680903-28176-1-git-send-email-yuezha@microsoft.com>
In-Reply-To: <1405680903-28176-1-git-send-email-yuezha@microsoft.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2014 04:25 PM, Yue Zhang wrote:
> @@ -816,8 +816,21 @@ static void netvsc_link_change(struct work_struct *w)
>   
>   	rtnl_unlock();
>   
> -	if (refresh)
> -		call_usermodehelper(argv[0], argv, envp, UMH_WAIT_EXEC);
> +	if (refresh) {
> +		/*
> +		 * Keep the carrier offline for 10 seconds
> +		 * to notify ifplugd daemon network change
> +		 */

This should be networking comment style..

	/* bla bla..
	 * bla
	 */

-- 
Regards,
Varka Bhadram.

