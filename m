Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751616AbaIEPrj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 11:47:39 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:38742 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750797AbaIEPrg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 11:47:36 -0400
Date: Fri, 5 Sep 2014 10:47:01 -0500
From: Felipe Balbi <balbi@ti.com>
To: Peter Griffin <peter.griffin@linaro.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <balbi@ti.com>, <maxime.coquelin@st.com>, <patrice.chotard@st.com>,
        <srinivas.kandagatla@gmail.com>, <lee.jones@linaro.org>,
        <devicetree@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <peppe.cavallaro@st.com>
Subject: Re: [PATCH v6 1/3] usb: dwc3: add ST dwc3 glue layer to manage dwc3
 HC
Message-ID: <20140905154700.GE24449@saruman.home>
Reply-To: <balbi@ti.com>
References: <1409931392-22340-1-git-send-email-peter.griffin@linaro.org>
 <1409931392-22340-2-git-send-email-peter.griffin@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VdOwlNaOFKGAtAAV"
Content-Disposition: inline
In-Reply-To: <1409931392-22340-2-git-send-email-peter.griffin@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--VdOwlNaOFKGAtAAV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Sep 05, 2014 at 04:36:30PM +0100, Peter Griffin wrote:
> +static int st_dwc3_remove_child(struct device *dev, void *c)
> +{
> +	struct platform_device *pdev =3D to_platform_device(dev);
> +
> +	of_device_unregister(pdev);
> +
> +	return 0;
> +}
> +
> +static int st_dwc3_remove(struct platform_device *pdev)
> +{
> +	struct st_dwc3 *dwc3_data =3D platform_get_drvdata(pdev);
> +
> +	device_for_each_child(&pdev->dev, NULL, st_dwc3_remove_child);

same as before, of_platform_depopulate(). I can fix this one myself this
time.

--=20
balbi

--VdOwlNaOFKGAtAAV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUCdr0AAoJEIaOsuA1yqREyvAP/2XzSmWXusr9Z4vccu9UKdEO
HyN/HGFAcIzXevRVsh73xmi3LnZdyGWJJQoxHy3MiMJC18FaAJEb0HKblAfuYwld
yVPZLkYa/xnnQ/ru6rf15hXSLVVIDNmoAvLwVPKCAfAG+yBwUcd2rbOM4QVZHR5+
3iyP8aXJxb4shaGyopV3/k1ZrWrXJXizy8sDgI209xQi7yHmUObAHyN04DBhpO/2
bzj3Dbn7e61Z2AHBUxxpbSd5ewpG7viKlIEaehyEnNHCXgs+adEdeFD/CEsx3T06
uSzjwdBIJmzW03dMwAMzjxab18KxHh4JbDUAyo51SITNTTSqaXHKqhLqh/bx/THs
7YECetoskIGH3jvg0ZK48JCSzEDatzab/i7+Zj59jgYP7stoE3+kvTYzDP+o/+DD
Rwfn41WAUqwMYooa04rCjVjHqf2OO7zRteODJ7Vy5uSgFCRwxxFhxnY7y4B5DsXi
t0HlzXUBjDeLasG+KTS7ygFGUPUMbkP6IKuNZyox2IXczznbygRiG6+jo37Jx/zJ
l3CIxTzNBTXscY0Nn124bfOFxqsbOexHRFpA7Bur+umWXJUaBkC9RofZW9C+/eK6
zCCZKhRwl+WUAbJuRT4wgpqRwwssR+vcVwF8GFGdK4tBr6FAfvFzW8vDz+cZTLdb
juyyy070QMxMleRBr17k
=1CKY
-----END PGP SIGNATURE-----

--VdOwlNaOFKGAtAAV--
