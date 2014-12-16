Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751281AbaLPT1n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 14:27:43 -0500
Received: from mail.csclub.uwaterloo.ca ([129.97.134.52]:42392 "EHLO
	mail.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926AbaLPT1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 14:27:42 -0500
From: "Lennart Sorensen" <lsorense@csclub.uwaterloo.ca>
Date: Tue, 16 Dec 2014 14:27:40 -0500
To: Nishanth Menon <nm@ti.com>
Cc: Lokesh Vutla <lokeshvutla@ti.com>, t-kristo@ti.com,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Sekhar Nori <nsekhar@ti.com>
Subject: Re: [PATCH 2/2] ARM: omap5/dra7xx: Fix counter frequency drift for
 AM572x errata i856.
Message-ID: <20141216192740.GN24110@csclub.uwaterloo.ca>
References: <cover.1418421100.git.lsorense@csclub.uwaterloo.ca>
 <358281a880ccd89873efeea75edaa6c953eac2bd.1418421100.git.lsorense@csclub.uwaterloo.ca>
 <20141214044517.GD24110@csclub.uwaterloo.ca>
 <549018EC.8020207@ti.com>
 <20141216145856.GA23358@kahuna>
 <20141216163657.GL24110@csclub.uwaterloo.ca>
 <54908128.7040005@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54908128.7040005@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I see why arch_timer_freq might skip the rounding error of 39, 15 and
> 55 Vs existing logic which is possibly at a truncation error risk
> (without errata for sysclk 13, 26 and 27MHz).
> 
> all you'd probably need to do is cast rate, num and den to unsigned
> long and have a common computation logic.

If that is acceptable, then sure I can do that.  I liked avoiding casts
in general though.

> if you'd really want to handle truncation error, it must be a separate
> patch of it's own - I would not mix it with the errata fix.

Well there is no error in the existing code because the rate / den
is always a clean integer division.  The problem is introduced by the
SYSCLK1 / 610 used by the emulated clock which is not a clean division.

So for the existing logic, the calculation was perfect.  It is only for
the errata case that it is a problem.

So I think leaving the existing calculation but moved up works well,
and then having the alternate order calculation only in the errata case
seemed cleaner and avoids casts and 64bit math which I thought was
overall desirable.

-- 
Len Sorensen
