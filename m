Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932105Ab3HGQ0j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 12:26:39 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:57279 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756738Ab3HGQ0i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 12:26:38 -0400
Message-ID: <1375892797.2424.126.camel@joe-AO722>
Subject: Re: [RFC v02 5/5] Introduce Intel RAPL power capping driver
From: Joe Perches <joe@perches.com>
To: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org, rjw@sisk.pl,
        arjan@linux.intel.com, len.brown@intel.com,
        jacob.jun.pan@linux.intel.com, corbet@lwn.net
Date: Wed, 07 Aug 2013 09:26:37 -0700
In-Reply-To: <1375891965-6921-6-git-send-email-srinivas.pandruvada@linux.intel.com>
References: <1375891965-6921-1-git-send-email-srinivas.pandruvada@linux.intel.com>
	 <1375891965-6921-6-git-send-email-srinivas.pandruvada@linux.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-08-07 at 09:12 -0700, Srinivas Pandruvada wrote:
> RAPL(Running Average Power Limit) interface provides platform software
> with the ability to monitor, control, and get notifications on SOC
> power consumptions.

trivial notes:

> diff --git a/drivers/powercap/intel_rapl.c b/drivers/powercap/intel_rapl.c
[]
> +#define POWER_LIMIT1_MASK       0x7FFF
> +#define POWER_LIMIT1_ENABLE     BIT(15)
> +#define POWER_LIMIT1_CLAMP      BIT(16)
> +
> +#define POWER_LIMIT2_MASK       (0x7FFFULL<<32)
> +#define POWER_LIMIT2_ENABLE     (0x1ULL<<47)
> +#define POWER_LIMIT2_CLAMP      (0x1ULL<<48)
> +#define POWER_PKG_LOCK          (0x1ULL<<63)

Maybe it's time add a generic bitops.h macro

#define BIT_ULL(nr)	(1ULL << (nr))

[]

> +/* called after domain detection and package level data are set */
> +static void rapl_init_domains(struct rapl_pkg *rp)
> +{
> +	int i;
> +	struct rapl_domain *rd = rp->domains;
> +
> +	for (i = 0; i < RAPL_DOMAIN_MAX; i++) {
> +		unsigned int mask = rp->domain_map & (1 << i);
> +		switch (mask) {
> +		case 1 << RAPL_DOMAIN_PKG:

Maybe use defines or BIT(RAPL_DOMAIN_PKG)

Other than that the code seems to read pretty easily.

