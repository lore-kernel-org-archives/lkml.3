Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751407Ab3HTG7v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 02:59:51 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:40048 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196Ab3HTG7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 02:59:47 -0400
Date: Mon, 19 Aug 2013 23:59:44 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Mark Rutland <mark.rutland@arm.com>
cc: Rohit Vaswani <rvaswani@codeaurora.org>,
        David Brown <davidb@codeaurora.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Nicolas Pitre <nico@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
Subject: Re: [RESEND PATCH 2/4] ARM: msm: Re-organize platsmp to make it
 extensible
In-Reply-To: <20130812155016.GC27165@e106331-lin.cambridge.arm.com>
Message-ID: <alpine.DEB.2.02.1308192357420.17575@chino.kir.corp.google.com>
References: <1375409725-22004-1-git-send-email-rvaswani@codeaurora.org> <1375409725-22004-3-git-send-email-rvaswani@codeaurora.org> <20130812155016.GC27165@e106331-lin.cambridge.arm.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Aug 2013, Mark Rutland wrote:

> >  static void __init msm_smp_prepare_cpus(unsigned int max_cpus)
> >  {
> > +	int cpu, map;
> > +	unsigned int flags = 0;
> > +
> > +	for_each_present_cpu(cpu) {
> > +		map = cpu_logical_map(cpu);
> > +		if (map > ARRAY_SIZE(cold_boot_flags)) {
> > +			set_cpu_present(cpu, false);
> > +			__WARN();
> > +			continue;
> > +		}
> > +		flags |= cold_boot_flags[map];

__WARN() can't be used in generic code because it's possible to have 
CONFIG_BUG=n, you probably want something like WARN_ON(1) instead.
