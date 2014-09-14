Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752449AbaINC2k (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2014 22:28:40 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:57806 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752286AbaINC2i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2014 22:28:38 -0400
Date: Sat, 13 Sep 2014 21:24:52 -0500
From: Felipe Balbi <balbi@ti.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: Andy Gross <agross@codeaurora.org>, Felipe Balbi <balbi@ti.com>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Jack Pham <jackp@codeaurora.org>, Kumar Gala <galak@codeaurora.org>,
        <linux-arm-msm@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>
Subject: Re: [Patch v9 3/3] phy: Add Qualcomm DWC3 HS/SS PHY driver
Message-ID: <20140914022452.GA16652@saruman.home>
Reply-To: <balbi@ti.com>
References: <1410550088-8754-1-git-send-email-agross@codeaurora.org>
 <1410550088-8754-4-git-send-email-agross@codeaurora.org>
 <5413E829.8020804@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MGYHOYXEY6WxJCY8"
Content-Disposition: inline
In-Reply-To: <5413E829.8020804@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--MGYHOYXEY6WxJCY8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Sat, Sep 13, 2014 at 12:16:01PM +0530, Kishon Vijay Abraham I wrote:
> On Saturday 13 September 2014 12:58 AM, Andy Gross wrote:
> > This patch adds a new driver for the Qualcomm USB 3.0 PHY that exists o=
n some
> > Qualcomm platforms.  This driver uses the generic PHY framework and will
> > interact with the DWC3 controller.
>=20
> Do you have dt documentation for this driver?

see patch 1

> > +static inline void qcom_dwc3_phy_write_readback(
> > +	struct qcom_dwc3_usb_phy *phy_dwc3, u32 offset,
> > +	const u32 mask, u32 val)
> > +{
> > +	u32 write_val, tmp =3D readl(phy_dwc3->base + offset);
> > +
> > +	tmp &=3D ~mask;		/* retain other bits */
> > +	write_val =3D tmp | val;
> > +
> > +	writel(write_val, phy_dwc3->base + offset);
> > +
> > +	/* Read back to see if val was written */
>=20
> Does it fail sometime? I'm not sure if this should be present in the
> driver since this looks more of a debug code.

this was mentioned before. Silicon bug.

> > +	writel_relaxed(data | SSUSB_CTRL_SS_PHY_RESET,
> > +		phy_dwc3->base + SSUSB_PHY_CTRL_REG);
> > +	usleep_range(2000, 2200);
>=20
> use msleep here..

why ? usleep_range() gives the scheduler oportunity to group timers.

--=20
balbi

--MGYHOYXEY6WxJCY8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUFPx0AAoJEIaOsuA1yqRE+9wP/jgUkSQfawiG2UAtz29uFiRk
8ukQVJjYHMDnklLr0IXYHFUKiBxLxycDwBZBW1gciwiabJAyAFu1sovWGLJ0mJmG
F1v/NnYThwC6cpEzMi0qtw8FXT6N3QJ7oGFFLqqV4Sw4WKbSocnKq0jXfwc1PqMH
VTTCpV2hgcQzwiNvx0CQ/kpTHExtwDKxFsfcXBUR6xbtYRY8duv4TsoY7k8rdUnC
cW9eaVXfhgj6cdKYaobH45t26BVx/l2TKeCO9HazaOn4PjvFSA0nr3nkOyqYE9Hz
yNjBNofOd1LRJM+O/QXOGRF6KjRq+V0HxvkGbgAworlfOrgWKhcMUKZjKjwSSU5a
cNo0Ac5KvX4pBXxNGJCds+9vPtoleqpQQa/QC5j3cemei+JGnWIiANkO5BDXlFk7
q1dDxA5MWjG1Wpo4rqpqu6vxX1/0kCoieVqwWVWQ96jYVC/ezakyP10a/CRfF01K
uT4CKT46gtx0IUN+x4pWLCeh84Cts1HAIVC6N0B4JEoTbpfBzIkvmTdBEksxdnFW
kxEQxsnk7OXZw9E8dXqTUREBVditeP1flpGxqJTUmL5wAPXGNWPKDWT/UQ71oYTK
NVIsb+NBLnRkthI72ur3Bwwf1AamTqNmJmrx61xcfUK1tc3bHLUvybjWSEDLJVjS
dhD13DFs9biOKDKFWX8j
=5gl2
-----END PGP SIGNATURE-----

--MGYHOYXEY6WxJCY8--
