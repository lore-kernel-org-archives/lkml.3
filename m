Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444AbaA0Jle (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 04:41:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13138 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750990AbaA0Jld (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 04:41:33 -0500
Message-ID: <52E629A8.5010302@redhat.com>
Date: Mon, 27 Jan 2014 17:40:56 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: kys@microsoft.com, haiyangz@microsoft.com, devel@linuxdriverproject.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: hyperv: initialize link status correctly
References: <1390807854-4469-1-git-send-email-jasowang@redhat.com> <20140127.003559.2290408024387922847.davem@davemloft.net>
In-Reply-To: <20140127.003559.2290408024387922847.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27/2014 04:35 PM, David Miller wrote:
> From: Jason Wang <jasowang@redhat.com>
> Date: Mon, 27 Jan 2014 15:30:54 +0800
>
>> Call netif_carrier_on() after register_device(). Otherwise it won't work since
>> the device was still in NETREG_UNINITIALIZED state.
>>
>> Fixes a68f9614614749727286f675d15f1e09d13cb54a
>> (hyperv: Fix race between probe and open calls)
>>
>> Cc: Haiyang Zhang <haiyangz@microsoft.com>
>> Cc: K. Y. Srinivasan <kys@microsoft.com>
>> Reported-by: Di Nie <dnie@redhat.com>
>> Tested-by: Di Nie <dnie@redhat.com>
>> Signed-off-by: Jason Wang <jasowang@redhat.com>
> A device up can occur at the moment you call register_netdevice(),
> therefore that up call can see the carrier as down and fail or
> similar.  So you really cannot resolve the carrier to be on in this
> way.

True, we need a workqueue to synchronize them.
