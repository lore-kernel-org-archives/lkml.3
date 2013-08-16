Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753713Ab3HPWUV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 18:20:21 -0400
Received: from gate.crashing.org ([63.228.1.57]:59153 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753115Ab3HPWUT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:20:19 -0400
Message-ID: <1376691273.25016.5.camel@pasglop>
Subject: Re: [RFC PATCH v2 4/4] of: move of_get_cpu_node implementation to
 DT core library
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, devicetree@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, Jonas Bonn <jonas@southpole.se>,
        Michal Simek <monstr@monstr.eu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>
Date: Sat, 17 Aug 2013 08:14:33 +1000
In-Reply-To: <1376674791-28244-3-git-send-email-Sudeep.KarkadaNagesha@arm.com>
References: <1376586580-5409-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
	 <1376674791-28244-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
	 <1376674791-28244-3-git-send-email-Sudeep.KarkadaNagesha@arm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-08-16 at 18:39 +0100, Sudeep KarkadaNagesha wrote:
> +#ifdef CONFIG_PPC
> +               /* Check for historical "ibm,ppc-interrupt-server#s" property
> +                * for thread ids on PowerPC. If it doesn't exist fallback to
> +                * standard "reg" property.
> +                */
> +               if (__of_find_n_match_cpu_property(cpun,
> +                               "ibm,ppc-interrupt-server#s", cpu, thread))
> +                       return cpun;
> +#endif

It's not "historical". It's still very much in use and well defined in PAPR :-)

Cheers,
Ben.


