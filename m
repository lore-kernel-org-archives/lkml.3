Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756597AbaGIOQn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 10:16:43 -0400
Received: from casper.infradead.org ([85.118.1.10]:59665 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755438AbaGIOQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 10:16:40 -0400
Date: Wed, 9 Jul 2014 16:16:31 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: kan.liang@intel.com
Cc: andi@firstfloor.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH V4 1/2] perf ignore LBR and extra_regs.
Message-ID: <20140709141631.GE9918@twins.programming.kicks-ass.net>
References: <1404838181-3911-1-git-send-email-kan.liang@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ILuaRSyQpoVaJ1HG"
Content-Disposition: inline
In-Reply-To: <1404838181-3911-1-git-send-email-kan.liang@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ILuaRSyQpoVaJ1HG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 08, 2014 at 09:49:40AM -0700, kan.liang@intel.com wrote:
> +/*
> + * Under certain circumstances, access certain MSR may cause #GP.
> + * The function tests if the input MSR can be safely accessed.
> + */
> +static inline bool check_msr(unsigned long msr)
> +{
> +	u64 value;
> +
> +	if (rdmsrl_safe(msr, &value) < 0)
> +		return false;
> +	if (wrmsrl_safe(msr, value) < 0)
> +		return false;
> +	return true;
> +}

What does this thing return after patch 2? does the write still fault or
will KVM silently take writes too?

--ILuaRSyQpoVaJ1HG
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTvU66AAoJEHZH4aRLwOS6e/sP/iPnsBNTry0G/nEjfacMK61t
Q6sxleac2QVj8DD6JzvjIOVOuSYULdWQmbcpPn7vaJ9yjqhphFW6MQeKvUL3gJyD
3QzVX01qmafz/NUZYOWU8dEsRwm+MuGnrRMCRSIXL+vEZsmCY7QmQmNX97NHlalB
vaN5Wp3I12h6WxYOAYnrX/9SI3OMQ3TktcRE6s+4327UjitDnFcdDUxbacLiOaCy
TA3HPNXhHi5kV/qmh5gTNT54gwWitCS5qtz6oupqSUZY5M5BS43tNgPzmzzcRI6u
wNluZO2ctlk1WMg9pidmGO1usC0TVAMzJA87NLMbt70H2A3KQUa5Xi8YYLswgBuK
bU+o10RMeAdo5C2/YiuXkqW4nd6J3220ho3x1cjmwiAPFrkx7ha05B0IA8NfLb2E
55WNMztAwn7D1gdWp4jm2gtgO01RAoY5K/STUVLockp5s0ZgByXGteIWTVRSoGke
sfxE/AfHhfSK5jY53iNXB+WO0IjVV3sDIZeO5PsavNkdU69W2kR6LiQU7c4C5nhU
H8hLhlQYsxrPhSN+RftPtYGAgNw9p/cz07kZCPF4gxrVX1lcBZ4BEfg2Gli7753l
lAmfjR7Oui4iLkPty5Hd5KSjKrVSCH0Xu6tHHVjUbnWRMfPQendERizMPDnEzVBx
AW8reqbFAnOqe/g294Cn
=tbGS
-----END PGP SIGNATURE-----

--ILuaRSyQpoVaJ1HG--
