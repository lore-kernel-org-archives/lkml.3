Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751295AbaHOOIA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 10:08:00 -0400
Received: from casper.infradead.org ([85.118.1.10]:54419 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101AbaHOOH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 10:07:59 -0400
Date: Fri, 15 Aug 2014 16:07:41 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Ashwin Chaugule <ashwin.chaugule@linaro.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mike Turquette <mike.turquette@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Arjan van de Ven <arjan@linux.intel.com>, mingo@kernel.org,
        len.brown@intel.com, rjw@rjwysocki.net,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-acpi@vger.kernel.org,
        cpufreq@vger.kernel.org, Patch Tracking <patches@linaro.org>,
        Dirk Brandewie <dirk.brandewie@gmail.com>
Subject: Re: [RFC 0/3] Experimental patchset for CPPC
Message-ID: <20140815140741.GI19379@twins.programming.kicks-ass.net>
References: <1408046230-16439-1-git-send-email-ashwin.chaugule@linaro.org>
 <20140814205143.GY6758@twins.programming.kicks-ass.net>
 <CAJ5Y-ebgJi8Ngxg1X+h7KMundGZPFhYC0hr0Sog6htj=czszgQ@mail.gmail.com>
 <20140815061917.GX19379@twins.programming.kicks-ass.net>
 <CAJ5Y-eaLxCG7dDao00pozXBL2dxPS7tf=xGfaz3O_xfRHtQZnA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="iDeshIghY55r3+AG"
Content-Disposition: inline
In-Reply-To: <CAJ5Y-eaLxCG7dDao00pozXBL2dxPS7tf=xGfaz3O_xfRHtQZnA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--iDeshIghY55r3+AG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Aug 15, 2014 at 09:08:50AM -0400, Ashwin Chaugule wrote:
> If the OS only looks at Highest, Lowest, Delivered registers and only
> writes to Desired, then we're not really any different than how we do
> things today in the CPUFreq layer.

The thing is; we're already struggling to make 'sense' of x86 as it
stands today. And it looks like this CPPC stuff makes the behaviour even
less certain.

> Or even in the case of
> intel_pstate, if you map Desired to PERF_CTL and get value of
> Delivered by using aperf/mperf ratios (as my experimental driver
> does), then we can still maintain the existing system performance. It
> seems like if an OS can make use of the additional information then it
> should be net win for overall power savings and performance
> enhancement. Also, using the CPPC descriptors, we should be able to
> have one driver across X86 and ARM64. (possibly others too.)

Yikes, so aaargh64 will go do creative power management too?

And worse; it will go do ACPI? Welcome to the world of guaranteed BIOS
fail :-(

--iDeshIghY55r3+AG
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT7hQtAAoJEHZH4aRLwOS6/DIP/AmupGzWkhlSymd3IklcJwAz
/gsXPBhhpiM/2NlUzpHjx3yYXoGodNf0Agi0hTxKgEYhdOYnW1Dcq1mNmaFGZQtC
ygootTjLffyxYypXW4JxsteqY+5S6Nb6l7sjHkO+VA5ZMSsH4elaehcruOoPfvk5
mF40F8gNdTHhNq1ev0PEa5LDws4KnqNk7gZDZzFeFdSaDkZNnZ4RuVWof8vHIBh8
CNqVv13a5MzJXr8iDBwNuXdHRetFr2zih+/bw6wXAaTal3D2R4dz+zdPCW5JgKqx
TLZpFIAeGt35sg6gdmL9wifKSnZ9sif+Ic1D4tfTSnbA3ufrUW1vqqDD0vIrQ9bd
yaK17HG7TZLjGXIqNT6SotccmQdqTFnHAQZi24QrGWnJCJZUz8offICAXs37lN5M
wBlruD3wM7mlIjBXzi0OhKoPMrlcY3c15InqZPbGYzrv8CNDlZfkMHVtfR8JxBbv
UxIYL7+DnOU18wxP+bGcTo3jqu35fGf6iVifskBwHhciTmj1LDk59HhsM4Oilw7X
IWzBH1/ARwhr6KFQd56GJCn9JaoaGtKe7GIbabtp054jSIqfK2NTICxK0vQyatjN
+RwM8i6runTP7A+CyAKeIBIT3RdMa527U4BTEUZ55rWcG5d5CFGxCMPMsvNwaSjl
ZGBYTbwl4wVw7cuhB2nh
=7wyo
-----END PGP SIGNATURE-----

--iDeshIghY55r3+AG--
