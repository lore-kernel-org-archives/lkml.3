Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759905Ab3HNLh6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 07:37:58 -0400
Received: from gate.crashing.org ([63.228.1.57]:51606 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759738Ab3HNLh4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 07:37:56 -0400
Message-ID: <1376480227.4255.66.camel@pasglop>
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
Date: Wed, 14 Aug 2013 21:37:07 +1000
In-Reply-To: <520B5584.7030608@arm.com>
References: <5208E2D3.7060005@arm.com> <3356439.a21MloFP7n@vostro.rjw.lan>
	 <520A536C.3030600@arm.com> <520A7B00.8060405@arm.com>
	 <1376428024.4255.14.camel@pasglop> <520B5584.7030608@arm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-08-14 at 11:01 +0100, Sudeep KarkadaNagesha wrote:
> Yes this doesn't cover the historical "ibm,ppc-interrupt-server#s",
> for
> which we can have PPC specific wrapper above the generic one i.e. get
> the cpu node and then parse for thread id under custom property.

A wrapper is wrong. I don't want to have to have all ppc callers to use
a different function.

As I said, just make a generic one that returns a thread ID, ie, same
signature as the powerpc one. Make it weak, we can override it in
powerpc-land, or we can move the ibm,ppc-interrupt-server#s handling
into the generic one, it won't hurt, but leave the thread_id return
there, it doesn't hurt it will come in handy in a few cases without
causing code duplication.

Cheers,
Ben.

