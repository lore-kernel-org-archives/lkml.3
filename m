Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751443Ab3K1VcL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 16:32:11 -0500
Received: from mail-bk0-f41.google.com ([209.85.214.41]:36672 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769Ab3K1VcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 16:32:07 -0500
Date: Thu, 28 Nov 2013 22:32:00 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: r65073@freescale.com, s.hauer@pengutronix.de, swarren@wwwdotorg.org,
        t.figa@samsung.com, grant.likely@linaro.org, linux@arm.linux.org.uk,
        rob@landley.net, ian.campbell@citrix.com, mark.rutland@arm.com,
        pawel.moll@arm.com, rob.herring@calxeda.com,
        linux-arm-kernel@lists.infradead.org, linux-pwm@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCHv6 4/4] Documentation: Add device tree bindings for
 Freescale FTM PWM.
Message-ID: <20131128213159.GE14689@mithrandir>
References: <1384220218-12716-1-git-send-email-Li.Xiubo@freescale.com>
 <1384220218-12716-5-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SNIs70sCzqvszXB4"
Content-Disposition: inline
In-Reply-To: <1384220218-12716-5-git-send-email-Li.Xiubo@freescale.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SNIs70sCzqvszXB4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 12, 2013 at 09:36:58AM +0800, Xiubo Li wrote:
> This adds the Document for Freescale FTM PWM driver under

s/Document/binding documentation/?

> Documentation/devicetree/bindings/pwm/.
>=20
> Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
> Reviewed-by: Sascha Hauer <s.hauer@pengutronix.de>
> Acked-by: Kumar Gala <galak@codeaurora.org>
> ---
>  .../devicetree/bindings/pwm/pwm-fsl-ftm.txt        | 29 ++++++++++++++++=
++++++
>  1 file changed, 29 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/pwm/pwm-fsl-ftm.txt
>=20
> diff --git a/Documentation/devicetree/bindings/pwm/pwm-fsl-ftm.txt b/Docu=
mentation/devicetree/bindings/pwm/pwm-fsl-ftm.txt
> new file mode 100644
> index 0000000..5c1cd2b
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/pwm/pwm-fsl-ftm.txt
> @@ -0,0 +1,29 @@
> +Freescale FlexTimer Module(FTM) PWM controller

I think it's customary to have a space before the opening parenthesis.

> +Required properties:
> +- compatible: Should be "fsl,vf610-ftm-pwm"
> +- reg: Physical base address and length of the controller's registers
> +- #pwm-cells: Should be 3. See pwm.txt in this directory for a descripti=
on of
> +  the cells format.
> +- clock-names : Should includes the following module clock source entrie=
s:

s/includes/include/

> +    "ftm0" (module clock),
> +    "ftm0_counter" (counter clock),
> +- clocks : Must contain a clock specifier for each entry in clock-names,
> +  See clock/clock-bindings.txt for details of the property values.

Note that the order is significant here, at least from the way the
driver currently implements this. You can probably make this more
generic in the driver by using of_property_match_string() on the
clock-names property to find the index of "ftm0_counter" and pass that
index to the of_parse_phandle_with_args() function to cope with the
situation where the device tree has the clocks in a different order.

> +Example:
> +
> +pwm0: pwm@40038000 {
> +		compatible =3D "fsl,vf610-ftm-pwm";
> +		reg =3D <0x40038000 0x1000>;
> +		#pwm-cells =3D <3>;
> +		clock-names =3D "ftm0", "ftm0_counter;

There's a missing " at the end here.

Thierry

--SNIs70sCzqvszXB4
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSl7ZPAAoJEN0jrNd/PrOhOc8P/0ka8dZRYnomZdxLpWZzvAm/
7DpCsaaWm9vs+RO9KPrlpUW59I4gFHZwGQFHoxN3LQn08M/0wUzzQW2Xfd+BjeM1
3PxpxIQNsrVtHUF8XRvHCXUH1xjN8+8LBL51UzQ5qWhc4auf0QKljL7aagYEuAin
qS4oXBOfBhMYZlxknY28CpBo5kk/VuCG5yuafoNNl8VOfPJtyGBWGL6HMlC2eTKY
S/EJRM7j5pnWoUw9Fo+LkooVHJlbGZMG84uTGG9H5SOWyoLDwC0Ndxk2QoiBqQqt
4dCu4E8k309ftStxd6U4ttcmltkwu0ozqASdfRj/ULBo42kkyzl+o0fb04yTx6vJ
gPInfHpeR0Yg6EIPLZ3hAuwGC+VCXd3LngAX3hi/E7zR6IrU0524Sr7ULyZzVbFg
pG9LHzEjFL5Eg7uaUjvpp8JVg5sMqj7IyoQcx80nifQMbIcGPhrnphYKyKmbaYrP
VVaoRjSwYBXg/VbwVyhklY5YkBSMAkg9DgDuTzvb5UKn/v5YwYEcmI7oSa9fs/UQ
yN++1pAcGy13fuqBMx/PonYxNbUMVt0xeL3YQ4LRBUD21oBO+1ZIgjsXPuNocVtM
LAk9AsnvwxkaPQIc57a8mnS48dLV5Gx+wFoUXmX1jgiprvQp2WCA8vcD44IMkVBU
R+tpD+A3T62Exxl67Je9
=mPzy
-----END PGP SIGNATURE-----

--SNIs70sCzqvszXB4--
