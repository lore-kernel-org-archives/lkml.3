Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752903AbaCFQxY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 11:53:24 -0500
Received: from usmamail.tilera.com ([12.216.194.151]:26959 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577AbaCFQxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 11:53:20 -0500
Message-ID: <5318A7FF.8010502@tilera.com>
Date: Thu, 6 Mar 2014 11:53:19 -0500
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Henrik Austad <henrik@austad.us>
CC: LKML <linux-kernel@vger.kernel.org>, John Stultz <johnstul@us.ibm.com>,
        Mike Galbraith <bitbucket@online.de>, Salman Qazi <sqazi@google.com>
Subject: Re: [PATCH] tile: avoid overflow in ns2cycles
References: <1393921253-23396-1-git-send-email-henrik@austad.us>
In-Reply-To: <1393921253-23396-1-git-send-email-henrik@austad.us>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/4/2014 3:20 AM, Henrik Austad wrote:
> In commit 4cecf6d401a ("sched, x86: Avoid unnecessary overflow in
> sched_clock") and in recent patch "clocksource: avoid unnecessary
> overflow in cyclecounter_cyc2ns()" https://lkml.org/lkml/2014/3/4/17,
> the mult-shift approach is replaced by 2 steps to avoid storing a large,
> intermediate value that could overflow.
>
> arch/tile/kernel/time.c has a similar pattern in cycles2ns, and this
> copies the same pattern in this function
>
> CC: John Stultz <johnstul@us.ibm.com>
> CC: Mike Galbraith <bitbucket@online.de>
> CC: Salman Qazi <sqazi@google.com>
> Signed-off-by: Henrik Austad <henrik@austad.us>
> ---
>  arch/tile/kernel/time.c |   10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)

Thanks; taken into the tile tree (with some minor whitespace formatting tweaks).

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

