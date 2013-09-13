Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932797Ab3IMOdE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 10:33:04 -0400
Received: from www.linutronix.de ([62.245.132.108]:36839 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757004Ab3IMOcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 10:32:36 -0400
Date: Fri, 13 Sep 2013 16:32:24 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Fan Du <fan.du@windriver.com>
cc: David Miller <davem@davemloft.net>, herbert@gondor.hengli.com.au,
        steffen.klassert@secunet.com, dborkman@redhat.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        John Stultz <john.stultz@linaro.org>
Subject: Re: [PATCHv3 linux-next] hrtimer: Add notifier when clock_was_set
 was called
In-Reply-To: <52327C92.5010009@windriver.com>
Message-ID: <alpine.DEB.2.02.1309131628250.4089@ionos.tec.linutronix.de>
References: <alpine.DEB.2.02.1309121441420.4089@ionos.tec.linutronix.de> <20130912134409.GB21212@gondor.apana.org.au> <alpine.DEB.2.02.1309121636010.4089@ionos.tec.linutronix.de> <20130912.133252.425268707009916773.davem@davemloft.net>
 <52327C92.5010009@windriver.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Sep 2013, Fan Du wrote:
> (2) What I have been bugging you around here for this long time is really the
> second
>     problem, I'm sorry I didn't make it clearly to you and others, which is
> below:
> 
>     Why using wall clock time to calculate soft/hard IPsec events when
> xfrm_state timer
>     out happens in its timeout handler? Because even if xfrm_state using
> CLOCK_BOOTTIME,
>     system wall clock time changing will surely disturb soft/hard IPsec
> events, which
>     you raised your concern about in (*a*).

No CLOCK_BOOTTIME is not affected by wall clock time changes. It's
basically CLOCK_MONOTONIC, it just keeps counting the suspend time as
well. So without a suspend/resume cycle CLOCK_MONOTONIC and
CLOCK_BOOTTIME are the same. After a suspend/resume cycle
CLOCK_BOOTTIME will be N seconds ahead of CLOCK_MONOTONIC, where N is
the number of seconds spent in suspend.

Thanks,

	tglx
