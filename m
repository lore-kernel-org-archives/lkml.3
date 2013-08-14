Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933452Ab3HNW6S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 18:58:18 -0400
Received: from gate.crashing.org ([63.228.1.57]:38332 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933422Ab3HNW6Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 18:58:16 -0400
Message-ID: <1376521050.4255.82.camel@pasglop>
Subject: Re: [GIT PULL] DT/core: cpu_ofnode updates for v3.12
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
Cc: "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Olof Johansson <olof@lixom.net>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Date: Thu, 15 Aug 2013 08:57:30 +1000
In-Reply-To: <520B8468.7050307@arm.com>
References: <5208E2D3.7060005@arm.com> <3356439.a21MloFP7n@vostro.rjw.lan>
	 <520A536C.3030600@arm.com> <520A7B00.8060405@arm.com>
	 <1376428024.4255.14.camel@pasglop> <520B5584.7030608@arm.com>
	 <1376480227.4255.66.camel@pasglop> <520B8468.7050307@arm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-08-14 at 14:21 +0100, Sudeep KarkadaNagesha wrote:
> IMO moving of handling ibm,ppc-interrupt-server#s to generic code
> under
> #ifdef CONFIG_PPC seems to be cleaner approach than weak definitation.
> 
> As per my understanding each thread is a different logical cpu.
> Each logical cpu is mapped to unique physical id(either present in reg
> field or legacy ibm,ppc-interrupt-server#s field). So given a logical
> cpu id we can get the cpu node corresponding to it.
> Looking @ smp_setup_cpu_maps in arch/powerpc/kernel/setup-common.c
> and the comment in the same file: "This implementation only supports
> power of 2 number of threads.." the thread id id is implicit in the
> logical cpu id. Do we need to fetch that from DT ?

I don't want those parsing routines to make those assumptions. We have
changed our logical numbering in the past and may again.

Cheers,
Ben.


