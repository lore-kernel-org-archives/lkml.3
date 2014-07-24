Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759304AbaGXOob (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 10:44:31 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:53061 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759007AbaGXOo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 10:44:29 -0400
Date: Thu, 24 Jul 2014 15:43:27 +0100
From: Mark Brown <broonie@kernel.org>
To: Hanjun Guo <hanjun.guo@linaro.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Rutland <mark.rutland@arm.com>,
        Graeme Gregory <graeme.gregory@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Grant Likely <grant.likely@linaro.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>, Will Deacon <will.deacon@arm.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Robert Richter <rric@kernel.org>, Lv Zheng <lv.zheng@intel.com>,
        Robert Moore <robert.moore@intel.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>, Charles.Garcia-Tobin@arm.com,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linaro-acpi-private@linaro.org
Message-ID: <20140724144327.GJ17528@sirena.org.uk>
References: <1406206825-15590-1-git-send-email-hanjun.guo@linaro.org>
 <1406206825-15590-5-git-send-email-hanjun.guo@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="u1ypDpa0Zap8goqZ"
Content-Disposition: inline
In-Reply-To: <1406206825-15590-5-git-send-email-hanjun.guo@linaro.org>
X-Cookie: 98% lean.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 04/19] ARM64 / ACPI: Introduce arch_fix_phys_package_id()
 for cpu topology
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--u1ypDpa0Zap8goqZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 24, 2014 at 09:00:10PM +0800, Hanjun Guo wrote:

> +/*
> + * Use the CPU slot number provided by ACPI to update the physical
> + * package id when cpuid_topo->cluster_id is not available, then we
> + * can get the right value in the "physical id" field of /proc/cpuinfo.
> + */
> +void arch_fix_phys_package_id(int num, u32 slot)
> +{
> +	struct cpu_topology *cpuid_topo = &cpu_topology[num];
> +
> +	if (cpuid_topo->cluster_id == -1)
> +		cpuid_topo->cluster_id = slot;
> +}
> +EXPORT_SYMBOL_GPL(arch_fix_phys_package_id);

As I said on the previous version of this patch are you sure this runs
at a point between the cluster ID getting initialized to -1 and the slot
being initialized (bear in mind that we now use MPIDR information if
availabe).  I don't understand why we don't just unconditionally use the
value given.

--u1ypDpa0Zap8goqZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT0RuMAAoJELSic+t+oim9h5cP+QHa9hzHL1neoprYDXds2eZ4
9SWWzVO9PMGx1KqYRcssebSjmWvUyGDHdzycgK1QV9QNwkpt2G+JAkdKYZSv8bh9
k4mLOdTDz415a5bLX5bO6tzwc9NJmlDcl+wuNTlfssqdmUNhOYd2oVQbPPbR9P0n
/HLHStFBIs5/5YGvmjz5pqYe0WuGhrjNl/k4MXWjnrmELD9sTUBrvPEMff9NXz4B
w6Z7ku3bF8YtfSRo7S38VhyV03Vp9v7jvrHSPbIajIG9+2svMi6y6/kHl+GgcQCK
qDq/ydde5srTRohmWUtmVMj6+f1ofJWBcdEw9CByM6rYHtSE1fHDYneveDOXecF/
JEmd79kaRSgYbYDSGd0KVuIshthniLOTq52sB8HDrIUqTMz53JBfeYDypgiwss0X
ch2ukITAv7P0YsngYpOLsOkSQvWi0agxDEE8kc6EbGxnT9bWDB9ZNRbVmEM0A7eF
8dCY1XClXW4O29whMkoNBmY2E/RXe8XaMgGvRpAKV4iT2aUkde25btcuLGhP9A5f
m+xoRcOqrKLWn5+SnaoqWuuWLrAT19rDxZxxrG4QHhIETua2LgdKkWB2LILsNzLQ
FEbmvAgc941lSiZ05O1i7l/CI8lZBEdH8+ygIyiUqDqNCrFBCkV9TJjgwYhk/uxP
no1e52bzQkhoTzupg50a
=bPHV
-----END PGP SIGNATURE-----

--u1ypDpa0Zap8goqZ--
