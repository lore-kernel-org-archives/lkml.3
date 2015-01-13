Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753488AbbAMUmj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 15:42:39 -0500
Received: from www.linutronix.de ([62.245.132.108]:47196 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192AbbAMUmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 15:42:38 -0500
Date: Tue, 13 Jan 2015 21:42:18 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Xunlei Pang <xlpang@126.com>
cc: linux-kernel@vger.kernel.org, John Stultz <john.stultz@linaro.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>, rtc-linux@googlegroups.com,
        Alessandro Zummo <a.zummo@towertech.it>,
        Xunlei Pang <pang.xunlei@linaro.org>
Subject: Re: [RFC PATCH v2 2/9] time: Provide y2106 safe get_seconds()
 replacement
In-Reply-To: <1421163897-8020-3-git-send-email-xlpang@126.com>
Message-ID: <alpine.DEB.2.11.1501132138440.5526@nanos>
References: <1421163897-8020-1-git-send-email-xlpang@126.com> <1421163897-8020-3-git-send-email-xlpang@126.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Jan 2015, Xunlei Pang wrote:

> From: Xunlei Pang <pang.xunlei@linaro.org>
> 
> As part of addressing "y2038 problem" for in-kernel uses, this
> patch adds safe get_seconds64() using time64_t.
> 
> After this patch, get_seconds() is deprecated and all its call sites
> will be fixed using get_seconds64(), after that it can be removed.

Why another interface?

We already have ktime_get_real_seconds(). That handles 32bit
correctly, while your new function does not.

You cannot return a 64bit value unprotected against updates on 32bit,
unless you want to implement a RNG.

Thanks,

	tglx


