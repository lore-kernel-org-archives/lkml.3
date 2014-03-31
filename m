Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755124AbaCaNiX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 09:38:23 -0400
Received: from www.linutronix.de ([62.245.132.108]:60459 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754307AbaCaNiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 09:38:21 -0400
Date: Mon, 31 Mar 2014 15:38:31 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Viresh Kumar <viresh.kumar@linaro.org>
cc: linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, linaro-networking@linaro.org,
        Arvind.Chauhan@arm.com
Subject: Re: [PATCH 00/16] timers/hrtimers: Minor cleanups: Part II
In-Reply-To: <cover.1396006658.git.viresh.kumar@linaro.org>
Message-ID: <alpine.DEB.2.02.1403311522080.14882@ionos.tec.linutronix.de>
References: <cover.1396006658.git.viresh.kumar@linaro.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Mar 2014, Viresh Kumar wrote:
> I have got few more cleanups other than what I posted yesterday:
> https://lkml.org/lkml/2014/3/26/107

And those cleanups make the compiler generate worse code at least on
x86_64:

   text	     data      bss      dec     hex    filename
   7475	     554       0	8029	1f5d   kernel/hrtimer.o
   7706	     554       0	8260	2044   kernel/hrtimer.o

So just removing parameters and return values because you can get the
same information from a datastructure is not necessarily a good thing.

Thanks,

	tglx
