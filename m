Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755057AbaFBOXP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 10:23:15 -0400
Received: from eu1sys200aog111.obsmtp.com ([207.126.144.131]:42276 "EHLO
	eu1sys200aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753301AbaFBOXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 10:23:13 -0400
X-Greylist: delayed 424 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 Jun 2014 10:23:12 EDT
Message-ID: <538C8554.8070109@mellanox.com>
Date: Mon, 2 Jun 2014 17:08:20 +0300
From: Amir Vadai <amirv@mellanox.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>, David Miller <davem@davemloft.net>
CC: <ogerlitz@mellanox.com>, <netdev@vger.kernel.org>, <yevgenyp@mellanox.com>,
        <yuvala@mellanox.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next V6 2/2] net/mlx4_en: Use affinity hint
References: <1401029247-15196-3-git-send-email-amirv@mellanox.com>	 <1401682610.3645.166.camel@edumazet-glaptop2.roam.corp.google.com>	 <1401683831.3645.169.camel@edumazet-glaptop2.roam.corp.google.com>	 <20140601.215650.2131746246978305213.davem@davemloft.net> <1401685992.3645.173.camel@edumazet-glaptop2.roam.corp.google.com>
In-Reply-To: <1401685992.3645.173.camel@edumazet-glaptop2.roam.corp.google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.0.13.1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/2/2014 8:13 AM, Eric Dumazet wrote:
> On Sun, 2014-06-01 at 21:56 -0700, David Miller wrote:
>
>> Indeed you have to provide a dummy version for a non-SMP build etc.
>>
>> I'm reverting.
>>
>
> Hi David. I think your revert took one wrong commit.
>
>
> # git show ee39facbf82e73e468c504d2b40e83e2d223c28c | diffstat -p1 -w70
>   drivers/net/ethernet/micrel/ks8851.c |   50 ++++++++++---------
>   include/linux/cpumask.h              |    2
>   lib/cpumask.c                        |   64 -------------------------
>   3 files changed, 28 insertions(+), 88 deletions(-)
>
>
>

Hi,

Yeh, Eric is right and it seems that 2a82e40 "net: ks8851: Don't use 
regulator_get_optional()" was reverted by mistake instead of 70a640d: 
"net/mlx4_en: Use affinity hint"

I'm working on a fixed version of the affinity patches - this time I 
will double check the CONFIG_SMP/CONFIG_CPUMASK_OFFSTACK combinations.

I'm preparing a public git with Mellanox updates, so that Mellanox 
drivers patches will pass 0-DAY kernel build testing, before landing in 
net-next.

Amir
