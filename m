Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753984Ab3FNWxu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 18:53:50 -0400
Received: from gate.crashing.org ([63.228.1.57]:55692 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753728Ab3FNWxt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 18:53:49 -0400
Message-ID: <1371250417.21896.17.camel@pasglop>
Subject: Re: [PATCH] powerpc/sysfs: disable hotplug for the boot cpu
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Zhao Chenhui <chenhui.zhao@freescale.com>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Date: Sat, 15 Jun 2013 08:53:37 +1000
In-Reply-To: <20130613112552.GC7536@localhost.localdomain>
References: <1369727984-21505-1-git-send-email-chenhui.zhao@freescale.com>
	 <1369727984-21505-2-git-send-email-chenhui.zhao@freescale.com>
	 <1370036984.3928.144.camel@pasglop>
	 <20130603104315.GA1365@localhost.localdomain>
	 <1371007522.8250.169.camel@pasglop>
	 <20130613112552.GC7536@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-06-13 at 19:25 +0800, Zhao Chenhui wrote:
> Some multicore SoCs firstly boot up the cpu0 after warm reset.
> In some suspend/resume cases, SoC will do a warm reset when resuming.
> In order to ensure that the suspending and resuming is running
> on a same cpu, cpu0 should be the last cpu to suspend. Here, cpu0 is
> the boot_cpuid.

Well, so:

  - In any case, your patch will break pseries, so it's not acceptable.

  - Why does it have to absolutely resume from the same CPU it suspended
from ? Can't you have a little bit of code on the resuming CPU that
checks if it's not online, poke an online one and goes back to sleep ?

Cheers,
Ben.


