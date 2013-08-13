Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932213Ab3HMVHq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 17:07:46 -0400
Received: from gate.crashing.org ([63.228.1.57]:47802 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758487Ab3HMVHo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 17:07:44 -0400
Message-ID: <1376428024.4255.14.camel@pasglop>
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
Date: Wed, 14 Aug 2013 07:07:04 +1000
In-Reply-To: <520A7B00.8060405@arm.com>
References: <5208E2D3.7060005@arm.com> <3356439.a21MloFP7n@vostro.rjw.lan>
	 <520A536C.3030600@arm.com> <520A7B00.8060405@arm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-08-13 at 19:29 +0100, Sudeep KarkadaNagesha wrote:
> I don't understand completely the use of ibm,ppc-interrupt-server#s and
> its implications on generic of_get_cpu_node implementation.
> I see the PPC specific definition of of_get_cpu_node uses thread id only
> in 2 instances. Based on that, I have tried to move all the other
> instances to use generic definition.
> 
> Let me know if the idea is correct.

No. The device-tree historically only represents cores, not HW threads, so
it makes sense to retrieve also the thread number corresponding to the CPU.

However, the mechanism to represent HW threads in the device-tree is currently
somewhat platform specific (the ibm,ppc-interrupt-server#s).

So what you could do for now is:

 - Have a generic version that always returns 0 as the thread, which is weak

 - powerpc keeps its own implementation

 - Start a discussion on the bindings (if not already there) to define threads
in a better way at which point the generic function can be updated.

Cheers,
Ben.


