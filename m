Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751314Ab3ELSdg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 14:33:36 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:35277 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953Ab3ELSdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 14:33:35 -0400
Message-ID: <518FE07A.9090904@cogentembedded.com>
Date: Sun, 12 May 2013 22:33:30 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Wolfram Sang <wsa@the-dreams.de>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [RFC 17/42] drivers/net/ethernet/renesas: don't check resource
 with devm_ioremap_resource
References: <1368173847-5661-1-git-send-email-wsa@the-dreams.de> <1368173847-5661-18-git-send-email-wsa@the-dreams.de> <518EAB9B.8040106@cogentembedded.com> <20130512094202.GA3039@katana> <518FB49B.7030708@cogentembedded.com> <20130512163246.GA2928@katana>
In-Reply-To: <20130512163246.GA2928@katana>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 05/12/2013 08:32 PM, Wolfram Sang wrote:

>
>>     You can always try to do:
>>
>> $ make drivers/net/ethernet/renesas/sh_eth.o
>>
>> with a .config file you have. It will compile a file regardless of
>> whether it's enabled in your .config or not...
> Been there. This mainly works for platform independent drivers. In this case:
>
>    CC      drivers/net/ethernet/renesas/sh_eth.o
> drivers/net/ethernet/renesas/sh_eth.c: In function 'sh_eth_dev_init':
> drivers/net/ethernet/renesas/sh_eth.c:1274:2: error: implicit declaration of function 'sh_eth_reset' [-Werror=implicit-function-declaration]
> drivers/net/ethernet/renesas/sh_eth.c: In function 'sh_eth_drv_probe':
> drivers/net/ethernet/renesas/sh_eth.c:2724:13: error: 'sh_eth_my_cpu_data' undeclared (first use in this function)
> drivers/net/ethernet/renesas/sh_eth.c:2724:13: note: each undeclared identifier is reported only once for each function it appears in
> drivers/net/ethernet/renesas/sh_eth.c: At top level:
> drivers/net/ethernet/renesas/sh_eth.c:889:12: warning: 'sh_eth_check_reset' defined but not used [-Wunused-function]

     At least you can try to filter out errors/warning caused by your 
patch from
those that are caused by platform dependency. Concerning this driver, 
hopefully
the platform dependencies will go away in 3.11.

> Regards,
>
>     Wolfram
>

WBR, Sergei

