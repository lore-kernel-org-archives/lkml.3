Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754562AbaJ1Ubh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 16:31:37 -0400
Received: from www.linutronix.de ([62.245.132.108]:52207 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858AbaJ1Ubg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 16:31:36 -0400
Date: Tue, 28 Oct 2014 21:31:32 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Arnd Bergmann <arnd@arndb.de>
cc: Heena Sirwani <heenasirwani@gmail.com>, linux-kernel@vger.kernel.org,
        john.stultz@linaro.org
Subject: Re: [PATCH v2] timekeeping: Added a function to return tv_sec portion
 of ktime_get_real_ts64()
In-Reply-To: <9160485.26T1OFaUNG@wuerfel>
Message-ID: <alpine.DEB.2.11.1410282123450.5308@nanos>
References: <20141027050804.GA8550@heena-HP-Compaq-8200-Elite-MT-PC> <3267270.TT2UKZmIpE@wuerfel> <alpine.DEB.2.11.1410281805410.5308@nanos> <9160485.26T1OFaUNG@wuerfel>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Oct 2014, Arnd Bergmann wrote:
> On Tuesday 28 October 2014 18:13:09 Thomas Gleixner wrote:
> I'd like to apply this patch to my y2038 branch and apply the
> other patches that need it on top, unless you want to still submit
> it for 3.18.

I think I should take these patches for 3.18. We do not create users
yet, but it makes it easier for submaintaners to apply stuff which you
convert. And it lets me have the whole core lot together with other
changes in that area. I create a seperate branch which you can pull
from.

> Regarding the names, should we then have
> 
> time64_t ktime_get_real_seconds(void);
> time64_t ktime_get_seconds(void);

I like that one. Moving all the time interfaces to a ktime_ prefix and
let the default implementation as CLOCK_MONOTONIC and the others with
the added '_real', '_boot' ... describe their CLOCK_WHATEVER property
makes it pretty clear.

Thanks,

	tglx
