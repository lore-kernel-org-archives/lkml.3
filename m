Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756101Ab3HPMdp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 08:33:45 -0400
Received: from gate.crashing.org ([63.228.1.57]:54894 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751149Ab3HPMdn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 08:33:43 -0400
Message-ID: <1376656351.25016.2.camel@pasglop>
Subject: Re: [RFC PATCH 3/4] powerpc: refactor of_get_cpu_node to support
 other architectures
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "microblaze-uclinux@itee.uq.edu.au" 
	<microblaze-uclinux@itee.uq.edu.au>,
        "linux@openrisc.net" <linux@openrisc.net>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Jonas Bonn <jonas@southpole.se>, Michal Simek <monstr@monstr.eu>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>
Date: Fri, 16 Aug 2013 22:32:31 +1000
In-Reply-To: <520DE753.8090601@arm.com>
References: <1374492747-13879-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
	 <1376586580-5409-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
	 <1376586580-5409-4-git-send-email-Sudeep.KarkadaNagesha@arm.com>
	 <1376628563.4255.137.camel@pasglop> <520DE753.8090601@arm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-08-16 at 09:48 +0100, Sudeep KarkadaNagesha wrote:

> > Naming is a bit gross. You might want to make it clearer that
> > we are talking about CPU IDs in the device-tree here.
> > 
> Any particular preference to the name or just a note is sufficient.
> Also unlike PPC, in ARM we don't set hard processor id value based
> values read from device tree. DT must contain the values matching to the
> hardware ID registers.

This is exactly the same on ppc. We don't "set" HW values. The
device-tree content matches the HW internals. Some processors have a
"PIR" register as well which contains the HW value, in this case the
device-tree must contain the same value as the PIR on that processor.

> >> +static bool __of_find_n_match_cpu_property(struct device_node *cpun,
> >> +			const char *prop_name, int cpu, unsigned int *thread)
> >> +{
> >> +	const __be32 *cell;
> >> +	int ac, prop_len, tid;
> >> +	u64 hwid;
> >> +
> >> +	ac = of_n_addr_cells(cpun);
> >> +	cell = of_get_property(cpun, prop_name, &prop_len);
> >> +	if (!cell)
> >> +		return false;
> >> +	prop_len /= sizeof(*cell);
> >> +	for (tid = 0; tid < prop_len; tid++) {
> >> +		hwid = of_read_number(cell, ac);
> >> +		if (arch_match_cpu_phys_id(cpu, hwid)) {
> >> +			if (thread)
> >> +				*thread = tid;
> >> +			return true;
> >> +		}
> > 
> > Missing:          cell += ac;
> Ah, missed it while refactoring, will fix it. Thanks

Ben.

> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


