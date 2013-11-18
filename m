Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751597Ab3KRNar (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 08:30:47 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:54179 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742Ab3KRNaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 08:30:39 -0500
Message-ID: <528A1652.4000806@ti.com>
Date: Mon, 18 Nov 2013 15:29:54 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: "Dr. H. Nikolaus Schaller" <hns@goldelico.com>
CC: Belisko Marek <marek.belisko@gmail.com>, Tony Lindgren <tony@atomide.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, <linux-fbdev@vger.kernel.org>,
        NeilBrown <neilb@suse.de>, Marek Belisko <marek@goldelico.com>
Subject: Re: [PATCH 0/3] omapdss: venc: Add support for bypass and acbias.
References: <1381784555-18344-1-git-send-email-marek@goldelico.com> <CAAfyv34j+YhEjtHyf7zg5oBoCV5ROEXow8VV0PQNHLTF5uDZJg@mail.gmail.com> <5280DBA6.50303@ti.com> <FB10035C-B13C-4A03-BE9C-0576806F2577@goldelico.com> <5280E617.3000004@ti.com> <F97741D2-FC6F-4DBD-A0DD-E35304501993@goldelico.com>
In-Reply-To: <F97741D2-FC6F-4DBD-A0DD-E35304501993@goldelico.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="3WILi8Rrmjxp5j7DTGaKoVD7JD76b7NcU"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--3WILi8Rrmjxp5j7DTGaKoVD7JD76b7NcU
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 2013-11-11 16:30, Dr. H. Nikolaus Schaller wrote:

> Maybe it looks as if it is an unsolvable problem. The OPA works only if=
 acbias
> and bypass are enabled, but is not allowed to tell that it is there.

That's why the board file or dts file is there, to have "glue" data to
make different pieces work together.

The perfect (?) solution would be a CDF like data. The idea would be
that in the board file, you would describe configuration options for
VENC and for OPA. In this particular case, you'd tell VENC that it needs
to enable acbias and bypass when OPA is to be connected to VENC. Then
there could be more entries for VENC, saying disable acbias and bypass
when BAR is to be connected to VENC.

However, we don't have such support (yet).

For now, I hope it's enough if we handle VENC in a "single
configuration" manner, i.e. you'll tell VENC to enable acbias and bypass
when VENC is enabled. This means you can't have board setups where you'd
change the VENC->OPA connection to some other analog tv output at
runtime. I hope that's the case (i.e. OPA is always in use on that board)=
=2E

If so, then I think you can just pass the acbias and bypass
configuration values via omapdss platform data. And VENC driver will use
them to configure those. OPA doesn't know anything about this at all.

 Tomi



--3WILi8Rrmjxp5j7DTGaKoVD7JD76b7NcU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJSihZSAAoJEPo9qoy8lh71ZhsP/1DLeXny3KsX6fC1jDPS8IBd
Ux7TLBA0mbxpKHrofM+nI72ohQ1hq+HyjhEhNltDFGgmjtOIqGlFisyaW/M0XDxu
tcHYnB9VHZrMSPmmM6HSt1INhAjAaamPSyqjY23aoJ2SZcyKqHLfiMHkPxBh/EOU
587Cjpp9URq1vqD8dRRhoHgVkTjUuSzG8dxzoSQLzGQcvLMp2oN+ZieNbNgWzJ6n
qQvEsNtfyBT78zRdpXaQvKQHK3Q/3uoy1tET4kPzEzwh1Arj/i+uJwcA27CTm2m3
JdHrhbvaGfsrXzD7nBrGuJIWqnAewyubo4e/i1IRxIFaTykqE4f8Eqe6uisuuAbI
QH+AkK+kOIWkzx5eme8s1iTEZVMI6aoP/DkU5yXf3AAhDBsXw6+veowqGWtzcjnd
UX9sERkrOhVFGI1NynYAXXHsJe9ZepssjebpMU9cYLOzXwTQDKFc4eS3lxaSKSGs
WExByrIf4u8GcsdmSiSYo8cWgQ6+Wg1bNq3n1+wVKNA3qhL5s2GYEeJkYq6vLjx3
RXLVs+tYOaCYz9ZexM2pHyo9YPYfUx42EnBRLkaSXFofIbg1prbWpOpk43+JQbMk
zrBsIzCclbw4FASxyRQKvmyH7ttO8k9laM4nGNtte6K+J9YbdRfY2w2b5HBgcqX6
YCBny9yOgFCRDp6E8ccR
=4lFa
-----END PGP SIGNATURE-----

--3WILi8Rrmjxp5j7DTGaKoVD7JD76b7NcU--
