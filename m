Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752963Ab3EKORd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 May 2013 10:17:33 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:56729 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752815Ab3EKORb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 May 2013 10:17:31 -0400
Date: Fri, 10 May 2013 22:24:22 +0100
From: Mark Brown <broonie@kernel.org>
To: Soren Brinkmann <soren.brinkmann@xilinx.com>
Cc: Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Message-ID: <20130510212422.GY3200@sirena.org.uk>
References: <1368207091-32538-1-git-send-email-soren.brinkmann@xilinx.com>
 <1368207091-32538-2-git-send-email-soren.brinkmann@xilinx.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DHd0DHvhbdljNSqO"
Content-Disposition: inline
In-Reply-To: <1368207091-32538-2-git-send-email-soren.brinkmann@xilinx.com>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.247.243.210
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH RFC] clk: Introduce userspace clock driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DHd0DHvhbdljNSqO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, May 10, 2013 at 10:31:31AM -0700, Soren Brinkmann wrote:

> +Example:
> +	usclk: usclk {
> +		compatible = "clk-userspace";
> +		clocks = <&foo 15>, <&bar>;
> +		clock-count = <2>;
> +	};

This is clearly *very* Linux specific so needs to be a linux vendor
thing (everything should have a namespaced name anyway).  It's not at
all obvious to me that this should be in device tree, though, since it's
not hardware description but a detail of how the OS is currently
implemented.

For your use case should these things be exposed by the FPGA device
asking for that rather than by having the clocks available separately?
Or is this part of the DT blob that's loaded incrementally along with
the FPGA (which does make things more interesting of course...).

> + * Expose clock controls through sysfs to userspace.

> + * By writing 0/1 to 'enable' the clock can be disabled/enabled. Reading
> + * that file returns the current state - 0 = disabled, 1 = enabled.

> + * Reading 'set_rate' returns the current clock frequency in Hz. Writing
> + * the file requests setting a new frequency in Hz.

This needs to be covered in Documentation/ABI since it's adding new
sysfs stuff.

> +	if (enable)
> +		ret = clk_prepare_enable(pdata->clk);
> +	else
> +		clk_disable_unprepare(pdata->clk);

> +	if (ret)
> +		return -EBUSY;

Why not pass back the actual error?

> +	pdata = kzalloc(clock_count * sizeof(*pdata), GFP_KERNEL);
> +	if (!pdata)
> +		return -ENOMEM;

devm?

> +late_initcall(usclk_setup);

Why not just a regular driver?

--DHd0DHvhbdljNSqO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRjWV+AAoJELSic+t+oim9vrQQAJbobwyqbbFAo1SoqD8j8AlZ
i0G1QEyPsMUg3lWG0Aw2Vkwi417INijYkGXmazpN7Pp8FvIqGAhmQyjx2jm/5OOR
1XvwEb3R9KTOKAQS2SV1quIMOFhHqCq4aQY0jwHSPnlh4Hf4Bn/3XO1p+0VrJE8C
12uWFVHTVCMGF4Jv8A6O3A2Nwuml+ZPmH/bVetootUKG97pULs3IAjkBqLzBGQns
Ril2QWdyZLjlEDTBnokVMs45q3RYKstulXLE+jXUU/M+q886xdxFmkrRjsxjfhtM
LxgWy9SdiQ+nW1Jb84BJTKXHy8aSOu+oI0Iy+wOFsLVoNq6TDTlvkUQlKErht57Z
tdnZknunSBHWlvxEQvyCvWNsp6sJGrEJX/B49/RLna/+a2ojVuvdENpVWGe1DS31
LLvnP1YGwu8hmQEz2rc3h9zCYQbGgPHpBFahcFElY3ujJXgmXtCTFWyAQj3rT3OW
F/kY3iUT2f9vACFhQd8KvKgElIH6tp980S25W0a+bRroL3ST2Xujt1JwnKe/bOqs
K7xdj1YCacF96fECLMOvH1bgT1C7Jjznz5a1SD1OvFDNvwHpZ+fxa/ozRpVF1FlU
KRr4m7toqSrmF4dFAVAvm9sOjv1xrYHFFcyhibZzw7YR/EIBiLeGyqynwe/M0Osb
pSsSwgTfE9FMDkwsAwda
=i05g
-----END PGP SIGNATURE-----

--DHd0DHvhbdljNSqO--
