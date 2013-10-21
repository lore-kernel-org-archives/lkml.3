Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751950Ab3JUR76 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 13:59:58 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:49197 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751463Ab3JUR74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 13:59:56 -0400
MIME-Version: 1.0
Reply-To: mceier+kernel@gmail.com
In-Reply-To: <52656971.3020509@ti.com>
References: <5265640C.4070201@cogentembedded.com>
	<1382377504-24688-1-git-send-email-mceier+kernel@gmail.com>
	<52656971.3020509@ti.com>
Date: Mon, 21 Oct 2013 19:59:54 +0200
X-Google-Sender-Auth: IDwoo3k7hdAR6OpfSozVSckoV3U
Message-ID: <CAJTyqKOAB8yy96sK=jQJv2TbCHn6JVqNSba-16z6RpWbhpM4dg@mail.gmail.com>
Subject: Re: [PATCH] davinci_emac.c: Fix IFF_ALLMULTI setup
From: Mariusz Ceier <mceier+kernel@gmail.com>
To: Mugunthan V N <mugunthanvnm@ti.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        Lad Prabhakar <prabhakar.csengg@gmail.com>,
        Jingoo Han <jg1.han@samsung.com>, Jiri Pirko <jiri@resnulli.us>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes of course ;) This was my first patch for the kernel. I will
remember about v2 tag next time.

Thanks,
Mariusz Ceier

On 21 October 2013 19:50, Mugunthan V N <mugunthanvnm@ti.com> wrote:
> On Monday 21 October 2013 11:15 PM, Mariusz Ceier wrote:
>> When IFF_ALLMULTI flag is set on interface and IFF_PROMISC isn't,
>> emac_dev_mcast_set should only enable RX of multicasts and reset
>> MACHASH registers.
>>
>> It does this, but afterwards it either sets up multicast MACs
>> filtering or disables RX of multicasts and resets MACHASH registers
>> again, rendering IFF_ALLMULTI flag useless.
>>
>> This patch fixes emac_dev_mcast_set, so that multicast MACs filtering and
>> disabling of RX of multicasts are skipped when IFF_ALLMULTI flag is set.
>>
>> Tested with kernel 2.6.37.
>>
>> Signed-off-by: Mariusz Ceier <mceier+kernel@gmail.com>
>> ---
> Can you add [PATCH v2] in your subject in future so that it will be
> easier to the maintainer to pick the latest version of the patch.
>
> Acked-by: Mugunthan V N <mugunthanvnm@ti.com>
>
> Regards
> Mugunthan V N
