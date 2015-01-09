Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752625AbbAIUpb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 15:45:31 -0500
Received: from sauhun.de ([89.238.76.85]:50232 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751233AbbAIUpa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 15:45:30 -0500
Date: Fri, 9 Jan 2015 21:45:22 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: linux-i2c@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, linux-mips@linux-mips.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC 02/11] i2c: add quirk checks to core
Message-ID: <20150109204522.GB1904@katana>
References: <1420824103-24169-1-git-send-email-wsa@the-dreams.de>
 <1420824103-24169-3-git-send-email-wsa@the-dreams.de>
 <54B02D7F.7040501@cogentembedded.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wzJLGUyc3ArbnUjN"
Content-Disposition: inline
In-Reply-To: <54B02D7F.7040501@cogentembedded.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wzJLGUyc3ArbnUjN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 09, 2015 at 10:35:27PM +0300, Sergei Shtylyov wrote:
> Hello.
>=20
> On 01/09/2015 08:21 PM, Wolfram Sang wrote:
>=20
> >Let the core do the checks if HW quirks prevent a transfer. Saves code
> >from drivers and adds consistency.
>=20
> >Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
> >---
> >  drivers/i2c/i2c-core.c | 53 ++++++++++++++++++++++++++++++++++++++++++=
++++++++
> >  1 file changed, 53 insertions(+)
> >
> >diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
> >index 39d25a8cb1ad..7b10a19abf5b 100644
> >--- a/drivers/i2c/i2c-core.c
> >+++ b/drivers/i2c/i2c-core.c
> >@@ -2063,6 +2063,56 @@ module_exit(i2c_exit);
> >   * ----------------------------------------------------
> >   */
> >
> >+/* Check if val is exceeding the quirk IFF quirk is non 0 */
> >+#define i2c_quirk_exceeded(val, quirk) ((quirk) && ((val) > (quirk)))
> >+
> >+static int i2c_quirk_error(struct i2c_adapter *adap, struct i2c_msg *ms=
g, char *err_msg)
> >+{
> >+	dev_err(&adap->dev, "quirk: %s (addr 0x%04x, size %u)\n", err_msg, msg=
->addr, msg->len);
> >+	return -EOPNOTSUPP;
> >+}
>=20
>    Always returning the same value doesn't make much sense. Are you trying
> to save space on the call sites?

Please elaborate. I think it does. If a quirk matches, we report that we
don't support this transfer.

> [...]
> >@@ -2080,6 +2130,9 @@ int __i2c_transfer(struct i2c_adapter *adap, struc=
t i2c_msg *msgs, int num)
> >  	unsigned long orig_jiffies;
> >  	int ret, try;
> >
> >+	if (adap->quirks && i2c_check_for_quirks(adap, msgs, num))
>=20
>    So, you only check for non-zero result of this function? Perhaps it ma=
kes
> sense to return true/false instead?

Could be done, but what would be the advantage? A lot of functions
return errno or 0.


--wzJLGUyc3ArbnUjN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUsD3iAAoJEBQN5MwUoCm2IBYP/0XZWZD4A2PX+VdU1SejfyEb
wCn0Ys4/8ln9Lo4Xan99vokUdShedP6BxStzkSS+zM7Wmrguh0rfUsfOKB9rwx7+
iBlVUYe9MNV79EjcwL0/iVv5LyRWwjkVZINqiiHEfpYmPlK6JU3PbrspV7AlTB/4
0df1UAN2Vl/OOxWLfUJxY1kB+GDns9EfWXdsWTwCzAO1JGFgry4ALCxA8F96WC56
egQ4KGchqkSSlkrZoP0mfGeU8XQs/15diIoAbrde6dW5uMeedeZfLiA3V9oARZIh
yqHDIUjoT76mPDwb8cK+VKsaV0xgaePjwYfbtXstA4oBRHtQbiklfkz/h9uX212v
CUdGi3/YuCadhqs6/mF9keK2s6kpBkKOAOo0FOWx1ivETYuIXsmCTDFZW7zB6kHC
2mx3ECHRQq5RadZNGTnuxTKwuNJpmqp1q4FowhRb04/CTHs0LJz4ujMhBlejesmE
CTQmn+poeJob2dp4PiLlDwq0GZIz3U23W134sJgIDPk5Fy75Y3K3j9g5hu3HxKEI
f0HOgvwlgvsT+V3KjiVJ6oPqgSPA/365WaM8r1+V8bsWiOkITuliTEOaW55lXOWs
WrgeMFWmZFKM71KfDtBaYS/4iPb2z8nwfTtQgzvT71mSQoMDD/EILcB6v/nfdfpe
c2LBOivFzvqS+hyUTn59
=mCd0
-----END PGP SIGNATURE-----

--wzJLGUyc3ArbnUjN--
