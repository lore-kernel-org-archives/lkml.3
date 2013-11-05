Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754999Ab3KERBT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 12:01:19 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:13560 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838Ab3KERBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 12:01:18 -0500
X-IronPort-AV: E=Sophos;i="4.93,640,1378857600"; 
   d="scan'208";a="68237900"
Message-ID: <5279245B.6070202@citrix.com>
Date: Tue, 5 Nov 2013 17:01:15 +0000
From: Zoltan Kiss <zoltan.kiss@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Ian Campbell <Ian.Campbell@citrix.com>
CC: <wei.liu2@citrix.com>, <xen-devel@lists.xenproject.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <jonathan.davies@citrix.com>
Subject: Re: [PATCH net-next RFC 0/5] xen-netback: TX grant mapping instead
 of copy
References: <1383094220-14775-1-git-send-email-zoltan.kiss@citrix.com> <1383303035.672.29.camel@kazak.uk.xensource.com> <5273FA37.6020903@citrix.com>
In-Reply-To: <5273FA37.6020903@citrix.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.133]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/11/13 19:00, Zoltan Kiss wrote:
>  >> Based on my investigations the packet get only copied if it is
> delivered to
>  >>Dom0 stack, which is due to this patch:
>  >>https://lkml.org/lkml/2012/7/20/363
>  >>That's a bit unfortunate, but as far as I know for the huge majority
> this use
>  >>case is not too important.
>> Likely to be true, but it would still be interesting to know how badly
>> this use case suffers with this change, and any increase in CPU usage
>> would be interesting to know about as well.
> I can't find my numbers, but as far as I remember it wasn't
> significantly worse than grant copy. I will check that again.
I've measured it now: with my patch it was 5.2 Gbps, without it 5.4. 
Both cases iperf in Dom0 maxed out its CPU, mostly in soft interrupt 
context, based on top.

Zoli

