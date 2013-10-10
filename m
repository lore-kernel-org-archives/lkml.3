Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756904Ab3JJTPI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 15:15:08 -0400
Received: from top.free-electrons.com ([176.31.233.9]:47189 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754093Ab3JJTPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 15:15:06 -0400
Date: Thu, 10 Oct 2013 21:13:11 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Emilio Lopez <emilio@elopez.com.ar>, linux-kernel@vger.kernel.org,
        kevin.z.m.zh@gmail.com, sunny@allwinnertech.com,
        shuge@allwinnertech.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/5] clocksource: Add Allwinner SoCs HS timers driver
Message-ID: <20131010191311.GL3041@lukather>
References: <1380117790-19390-1-git-send-email-maxime.ripard@free-electrons.com>
 <1380117790-19390-3-git-send-email-maxime.ripard@free-electrons.com>
 <52436EBE.9010002@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="L1EIGrW/+75u5Nmw"
Content-Disposition: inline
In-Reply-To: <52436EBE.9010002@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--L1EIGrW/+75u5Nmw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Stephen,

Just following back on this.

On Wed, Sep 25, 2013 at 04:16:14PM -0700, Stephen Boyd wrote:
> On 09/25/13 07:03, Maxime Ripard wrote:
> > +	sun5i_clockevent.cpumask =3D cpumask_of(0);
>=20
> Can this timer interrupt any CPU or is it hardwired to CPU0? If the
> interrupt can go to any CPU this should be cpu_possible_mask instead.

I've changed the few other things you spotted, but this one making the
timer unusable.

I think what happens here is that we have the A31 I've tested these
patches on is a quad-core SoC. As such, the device tree has 4 CPUs
declared. However, we don't have any SMP support for it now. So we end
up having 4 cpus set as possible, and only one online (the boot cpu),
which isn't working.

Would using cpu_online_mask work in our case?

Thanks,
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--L1EIGrW/+75u5Nmw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSVvxHAAoJEBx+YmzsjxAgiaEP/RtqeUq/ELdzHEQawp/Bd0YX
HHwCxPKyEmtsRiog9LMeuI89+ovwMYBBRdbWm4bnyzGZ1VWWzTHpsKB5+B3NPVg/
XJtbQFRis5Awpyo/7d+3uWEhwlDRc53Crs8GEBlc9DO7VuOZuyLM60SUO8/H8u7f
4/80m6oP0UqwSA/kzKdCmTuExxVHR718hV+lR2vc6qXhBQ7lttt8I+9iEt+5tvwb
L2jvcPiazcPrL61fewf34BHZ78ddaVl3KqmnO1K66gmZGPfZgyTMpSFaDq5NR2Zf
KCEGj/0Hf/XTzZcmYFX8BcxR7Ilk0vLJquYFQV/ln6oDOY1U+zT1ALpHKhDKegNE
UO1T2hxt94lkFkLkT07TpKMnRX4con4BsEJwNOsUo36WsYRQXkqrq+EbLtTSQiSs
ge664mKX9Bq0AI5tQOT5mCizSBY0W2ytwMShTGNb+Cihgfdq/CM5szw1hKy2DBPw
Ogf7yiMN+YbF6afxGP3b8HYiRprqqbKSMNk1J28eezL3xjyINdltg3q+ANj6/oYu
qjKpQG8S+x6dN56ZYo14kH2kCcjKJ9UNwDatCj+F41h9DFCoW5XbRsDVtP3TZIKV
WhM1V9l2913ZocCO7WnbFeQRPiHDk2gzmrE8Uz7nygjf0JNCMF1mUOvBE3AKoJ9W
0BraK9EbwneBf7EuM8QG
=dlgP
-----END PGP SIGNATURE-----

--L1EIGrW/+75u5Nmw--
