Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751213AbaCVJz2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 05:55:28 -0400
Received: from moutng.kundenserver.de ([212.227.126.130]:49389 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbaCVJzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 05:55:25 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Rob Herring <robherring2@gmail.com>
Subject: Re: [PATCH 0/8] Generic serial earlycon
Date: Sat, 22 Mar 2014 10:54:39 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Catalin Marinas <catalin.marinas@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>, x86@kernel.org,
        Rob Herring <robh@kernel.org>
References: <1395436128-11244-1-git-send-email-robherring2@gmail.com>
In-Reply-To: <1395436128-11244-1-git-send-email-robherring2@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201403221054.39799.arnd@arndb.de>
X-Provags-ID: V02:K0:7AvfroIMrMXz6szKSBtajLrmjkLu3eJBjk+Qk9dVybm
 kWms7cQr8wnIxDP9XoASwyN4WUYOX8Rlh+Zfoxhk1pZiGA2gu8
 bvxZRSGncatF8HiLjXJcSMaC758d6cVWIDNQ92PYBguK3F8aLO
 Fj3qPJW1SAI8XuQVnUQkZpyibk7ZMwCtjVAUfDpr47jGo+FieL
 NllLEjuGqkT+QAl1/4U1CNkqiyhEj203uGWX28rvFqQ70x2ZKJ
 0d3k4CSpdqR01V31HNTNCZbQsHI1Tf++K31Dom71+QQdFtFZQp
 8/PDO+TMqMEeiWtvf77Vptk7iwALQ8XFELpugxFYP3mlZz2BBq
 azICWtCPv885I/8Tg9q+mBcY9E8CZOo3DK8uZWMDj
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 21 March 2014, Rob Herring wrote:
> From: Rob Herring <robh@kernel.org>
> 
> This started out as an attempt to add arm64's earlyprintk support to ARM
> in order to get an earlier, runtime setup console on multi-platform
> kernels. The first issue was needing the fixmap support which
> conveniently Mark Salter was working on and is mostly in place now. Like
> many things on ARM and arm64 now, it then became where do I put the now
> common, shared code. After digging more into various early console/printk
> support, it turns out the 8250_early.c setup code was the best starting
> point. 
> 
> This is based on Mark Salter's fixmap support currently in linux-next.
> This is tested on arm64 and ARM with pl011 and 8250. The ARM support
> also requires fixmap and fixed mapping support which are not yet in place.
> I have some patches in my tree to support fixmap, but they need some more
> work. Fortunately, once fixmap is in place, it is just a Kconfig option
> to enable earlycon support on ARM. A git tree is available here[1].
> 
> Based on this series, I would like to add support for doing earlycon
> setup using DT.

Hi Rob,

I like this series a lot, great work!

I would consider the DT parsing support essential here, we should not
merge the patches until that is done as well, because I don't want
to see users pass earlycon command line options in DT when they can
use the established "linux,stdout-path" property instead. I would
expect that in almost every case in which we are booting using DT
today, we can just use linux,stdout-path to locate the device that
the boot loader has already set up and start usign it.

	Arnd
