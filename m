Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751729AbaI3VUu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 17:20:50 -0400
Received: from www.linutronix.de ([62.245.132.108]:33481 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098AbaI3VUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 17:20:48 -0400
Date: Tue, 30 Sep 2014 23:20:45 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Xiubo Li <Li.Xiubo@freescale.com>
cc: daniel.lezcano@linaro.org, linux-kernel@vger.kernel.org,
        john.stultz@linaro.org
Subject: Re: [PATCH v3 1/2] clocksource: Update to the newer memory
 functions.
In-Reply-To: <1412053408-21751-2-git-send-email-Li.Xiubo@freescale.com>
Message-ID: <alpine.DEB.2.11.1409302229400.4455@nanos>
References: <1412053408-21751-1-git-send-email-Li.Xiubo@freescale.com> <1412053408-21751-2-git-send-email-Li.Xiubo@freescale.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Sep 2014, Xiubo Li wrote:

> Use ioread{16,32} instead of read{w,l}_relaxed.
> 
> For read{w,l}_relaxed accessor, if one arch has its own defination,
> then used it. Or will use the generic one, which will be read as LE
> endian as default.
>  
> For some ARCHes, such PowerPC, if using the clocksource mmio, the
> read{w,l}_relaxed will couldn't be used directly. There must be its
> own BE accessor in its individual clocksource driver.
>
> The ioread{16,32} will be read as LE endian as default if the arch
> hasn't any defination of it too, like read{w,l}_relaxed do.
> 
> To prepare supporting the BE APIs and to be more unified with them,
> using ioread{16,32}[be] is a good chioce here.

This is complete nonsense. I asked you to split this change out and
provide a very reasonable changelog for it in the hope that you would
start to think about what the difference between read*, read*_relaxed
and ioread* are.

I bet you did not even try to think about it for a split second.

You just mechanically split out the changes and dumped your completely
incompetent opinion how these interfaces work and why they are there
in the first place into a uncomprehensible changelog.

Try again, once you understood the semantics of the interfaces and a
proper explanation why inflicting a massive performance hit on most
existing users seems to be a brilliant idea.

Once you've done that use that acquired knowledge to look at your
proposed BE functions and figure out why they are wrong as well.

Thanks,

	tglx
