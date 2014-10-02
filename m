Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753997AbaJBORU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 10:17:20 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:30986 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753546AbaJBORS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 10:17:18 -0400
X-CheckPoint: {542D5E6D-4-2100090A-C0000000}
Message-ID: <542D5E6D.5040908@tilera.com>
Date: Thu, 2 Oct 2014 10:17:17 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Henrik Austad <henrik@austad.us>
CC: <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: [PATCH] tile: add clock_gettime support to vDSO
References: <201409301938.s8UJcfY4018093@lab-40.internal.tilera.com> <20141001212439.GA12974@sisyphus.home.austad.us>
In-Reply-To: <20141001212439.GA12974@sisyphus.home.austad.us>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.9.0.23]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/1/2014 5:24 PM, Henrik Austad wrote:
> On Tue, Sep 30, 2014 at 03:29:45PM -0400, Chris Metcalf wrote:
>> >This change adds support for clock_gettime with CLOCK_REALTIME
>> >and CLOCK_MONOTONIC using vDSO.  In addition, with this change
>> >we switch to use seqlocks instead of integer counters.
>> >
>> >We also support the *_COARSE clockid_t, for apps that want speed
>> >but aren't concerned about fine-grained timestamps; this saves
>> >about 20 cycles per call (seehttp://lwn.net/Articles/342018/).
>> >
>> >Signed-off-by: Chris Metcalf<cmetcalf@tilera.com>
> What rev is this based on? When I apply it to Linus latest (aad7fb916), it
> fails in arch/tile/kernel/time.c and arch/tile/kernel/vdso/vgettimeofday.c
> (see below)

It's based on the linux-tile tree (on kernel.org under cmetcalf/linux-tile.git), which was last synced up at 3.16-rc7. I'll refresh the tree to pick up Thomas's recent changes that were queued for 3.17.  Thanks.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

