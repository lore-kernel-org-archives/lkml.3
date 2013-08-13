Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932187Ab3HMVEw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 17:04:52 -0400
Received: from gate.crashing.org ([63.228.1.57]:47770 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932069Ab3HMVEu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 17:04:50 -0400
Message-ID: <1376427839.4255.10.camel@pasglop>
Subject: Re: [GIT PULL] DT/core: cpu_ofnode updates for v3.12
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        linuxppc-dev@lists.ozlabs.org, Viresh Kumar <viresh.kumar@linaro.org>,
        Olof Johansson <olof@lixom.net>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Date: Wed, 14 Aug 2013 07:03:59 +1000
In-Reply-To: <520A536C.3030600@arm.com>
References: <5208E2D3.7060005@arm.com> <3356439.a21MloFP7n@vostro.rjw.lan>
	 <520A536C.3030600@arm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-08-13 at 16:40 +0100, Sudeep KarkadaNagesha wrote:
> There seems to be conflict in the new function "of_get_cpu_node" added.
> PowerPC also defines the same function name. Further microblaze and
> openrisc declares it(can be removed) but doesn't define it.
> To fix this:
> 1. I can rename the newly added function to something different like
>    `of_get_cpunode` or
> 2. If of_* namespace should be used by only OF/FDT and not by any
>    architecture specific code, then the arch specific version can be
>    renamed to some thing like arch_of_get_cpu_node.
>    Also most of the calls to arch specific function can be moved to
>    generic code.
> 
> Let me know your thoughts.

What is your new function about ? Does it perform the same job as the
one in powerpc ? If yes, make sure you have the same signature and
either copy the powerpc one over to a generic place or make the generic
one weak if you don't want the powerpc thread counting logic.

Cheers,
Ben.


