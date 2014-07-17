Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752593AbaGQGNn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 02:13:43 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:36932 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbaGQGNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 02:13:40 -0400
Message-ID: <53C76990.3000304@ti.com>
Date: Thu, 17 Jul 2014 11:43:36 +0530
From: Mugunthan V N <mugunthanvnm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: <netdev@vger.kernel.org>, <linux-api@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [net-next PATCH v2 0/3] Broadcast/Multicast rate limit via Ethtool
 Coalesce
References: <1404890050-4020-1-git-send-email-mugunthanvnm@ti.com> <20140709.164420.157865201153845876.davem@davemloft.net>
In-Reply-To: <20140709.164420.157865201153845876.davem@davemloft.net>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 10 July 2014 05:14 AM, David Miller wrote:
> From: Mugunthan V N <mugunthanvnm@ti.com>
> Date: Wed, 9 Jul 2014 12:44:07 +0530
>
>> A system/cpu can be loaded by a hacker with flooding of broadcast or
>> multicast packets, to prevent this some Ethernet controllers like CPSW
>> provide a mechanism to limit the broadcast/multicast packet rate via
>> hardware limiters. This patch series enables this feature via
>> Ethtool Coalesce.
> This is pretty bogus if you ask me.
>
> What is the difference from accepting a high rate of unicast packets?
> I say it is no different.
>
> Therefore, this feature makes no sense to me at all.

Any packet storm can cause an endpoint some issues. Typically packet
storms will cause the system CPU to thrash resulting is very low system
performance.

Unicast storms only target a single destination end station, it can be
easily mitigated by the host adding a blocking entry in the LUT for each
aggressor.

Broadcast and multicast target multiple end stations, or an entire
network, not only can it cause CPU thrashing, it can result in loss of
other broadcast and multicast services. The rate limiting feature allow
the broadcast and or multicast traffic to be dropped if the rates are
too high. This eliminates the CPU thrashing issue. It also allows the
system to analyze the aggressors and block them for future transgressions.

Regards
Mugunthan V N
