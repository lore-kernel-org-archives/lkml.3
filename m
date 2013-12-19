Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755965Ab3LST7D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 14:59:03 -0500
Received: from mail-ie0-f178.google.com ([209.85.223.178]:42303 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755295Ab3LST7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 14:59:00 -0500
MIME-Version: 1.0
In-Reply-To: <6ee28c6a94e74c958ee96c3547741fb9@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
References: <1387405262-18334-1-git-send-email-haiyangz@microsoft.com>
	<1387475178.1876.29.camel@bwh-desktop.uk.level5networks.com>
	<ff7f7541d0164d408b3a4278569c593a@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
	<52B33EC1.5040901@redhat.com>
	<6ee28c6a94e74c958ee96c3547741fb9@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
Date: Thu, 19 Dec 2013 11:58:59 -0800
Message-ID: <CA+mtBx-BBBQjVTOrnaow=GNc7VM5D2Zj8xr=fPM4b4f_xT7qkQ@mail.gmail.com>
Subject: Re: [PATCH net-next] hyperv: Add support for Virtual Receive Side
 Scaling (vRSS)
From: Tom Herbert <therbert@google.com>
To: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Daniel Borkmann <dborkman@redhat.com>,
        Ben Hutchings <bhutchings@solarflare.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        KY Srinivasan <kys@microsoft.com>, "olaf@aepfle.de" <olaf@aepfle.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I posted an implementation of library functions for Toeplitz (see
[PATCH 1/2] net: Toeplitz library functions).  This includes some
pre-computation of the table to get reasonable performance in the
host. Please take a look.

On the other hand, if you're computing a hash in the host, do you
really need  Toeplitz, flow_dissector already supports a good hash
computation and can parse many more packets than just plain UDP/TCP.
We probably only should be doing Toeplitz in the host if we need to
match HW computed values.


On Thu, Dec 19, 2013 at 11:21 AM, Haiyang Zhang <haiyangz@microsoft.com> wrote:
>
>
>> -----Original Message-----
>> From: Daniel Borkmann [mailto:dborkman@redhat.com]
>> Sent: Thursday, December 19, 2013 1:45 PM
>> To: Haiyang Zhang
>> Cc: Ben Hutchings; davem@davemloft.net; netdev@vger.kernel.org; KY
>> Srinivasan; olaf@aepfle.de; jasowang@redhat.com; linux-
>> kernel@vger.kernel.org; driverdev-devel@linuxdriverproject.org
>> Subject: Re: [PATCH net-next] hyperv: Add support for Virtual Receive Side
>> Scaling (vRSS)
>>
>> On 12/19/2013 07:36 PM, Haiyang Zhang wrote:
>>
>> > Thank you for the suggestions! I will re-write the send queue
>> > selection, enhance the hash calculation, also fix the initialization sequence.
>>
>> Btw, Toeplitz hash function should either go into lib/hash.c as well or
>> include/linux/hash.h to avoid ending up w/ various implementations in multiple
>> places.
>
> Will do.
>
> Thanks,
> - Haiyang
