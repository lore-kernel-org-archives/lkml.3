Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351AbaGHSka (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 14:40:30 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:65276 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754747AbaGHSk3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 14:40:29 -0400
Message-ID: <53BC3B1A.4000009@nod.at>
Date: Tue, 08 Jul 2014 20:40:26 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Haiyang Zhang <haiyangz@microsoft.com>, KY Srinivasan <kys@microsoft.com>
CC: "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] hyperv: Add netpoll support
References: <1404811947-5174-1-git-send-email-richard@nod.at> <6869a7dec43b4ba6b38692874f67279a@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
In-Reply-To: <6869a7dec43b4ba6b38692874f67279a@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 08.07.2014 19:55, schrieb Haiyang Zhang:
> 
> 
>> -----Original Message-----
>> From: Richard Weinberger [mailto:richard@nod.at]
>> Sent: Tuesday, July 8, 2014 5:32 AM
>> To: KY Srinivasan; Haiyang Zhang
>> Cc: devel@linuxdriverproject.org; netdev@vger.kernel.org; linux-
>> kernel@vger.kernel.org; Richard Weinberger
>> Subject: [PATCH] hyperv: Add netpoll support
>>
>> In order to have at least a netconsole to debug kernel issues on
>> Windows Azure this patch implements netpoll support.
>> Sending packets is easy, netvsc_start_xmit() does already everything
>> needed.
>> To receive we need to trigger the channel callback which is usally
>> called via tasklet_schedule().
>>
>> Signed-off-by: Richard Weinberger <richard@nod.at>
>> ---
>>  drivers/net/hyperv/netvsc_drv.c | 14 ++++++++++++++
>>  1 file changed, 14 insertions(+)
>>
>> diff --git a/drivers/net/hyperv/netvsc_drv.c
>> b/drivers/net/hyperv/netvsc_drv.c
>> index 4fd71b7..367b71e 100644
>> --- a/drivers/net/hyperv/netvsc_drv.c
>> +++ b/drivers/net/hyperv/netvsc_drv.c
>> @@ -736,6 +736,17 @@ static int netvsc_set_mac_addr(struct net_device
>> *ndev, void *p)
>>  	return err;
>>  }
>>
>> +#ifdef CONFIG_NET_POLL_CONTROLLER
>> +static void netvsc_poll_controller(struct net_device *net)
>> +{
>> +	struct net_device_context *net_device_ctx = netdev_priv(net);
>> +	struct hv_device *dev = net_device_ctx->device_ctx;
>> +
>> +	local_bh_disable();
>> +	netvsc_channel_cb(dev->channel);
> 
> This can only poll the primary channel not the sub channels.

Sub channels in terms of one channel per VCPU as KY said?

*confused*,
//richard
