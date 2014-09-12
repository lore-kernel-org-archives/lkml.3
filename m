Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841AbaILUab (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 16:30:31 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:41073 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751726AbaILUa2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 16:30:28 -0400
Date: Fri, 12 Sep 2014 15:29:43 -0500
From: Felipe Balbi <balbi@ti.com>
To: Pramod Gurav <pramod.gurav@smartplayin.com>
CC: <balbi@ti.com>, Pramod Gurav <pramod.gurav.etc@gmail.com>,
        Andy Gross <agross@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Jack Pham <jackp@codeaurora.org>, Kumar Gala <galak@codeaurora.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>
Subject: Re: [Patch v9 2/3] usb: dwc3: Add Qualcomm DWC3 glue layer driver
Message-ID: <20140912202942.GC25500@saruman.home>
Reply-To: <balbi@ti.com>
References: <1410550088-8754-1-git-send-email-agross@codeaurora.org>
 <1410550088-8754-3-git-send-email-agross@codeaurora.org>
 <CAMf-jSm2fPPstFD2h4-gG=MCDty34f-O0ooizDEKyQUd3+CxGQ@mail.gmail.com>
 <20140912202008.GB25500@saruman.home>
 <541356CE.1020902@smartplayin.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dkEUBIird37B8yKS"
Content-Disposition: inline
In-Reply-To: <541356CE.1020902@smartplayin.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--dkEUBIird37B8yKS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Sat, Sep 13, 2014 at 01:55:50AM +0530, Pramod Gurav wrote:
> >>> +       qdwc =3D devm_kzalloc(&pdev->dev, sizeof(*qdwc), GFP_KERNEL);
> >>> +       if (!qdwc)
> >>> +               return -ENOMEM;
> >>> +
> >>> +       platform_set_drvdata(pdev, qdwc);
> >>> +
> >>> +       qdwc->dev =3D &pdev->dev;
> >>> +
> >>> +       qdwc->core_clk =3D devm_clk_get(qdwc->dev, "core");
> >>> +       if (IS_ERR(qdwc->core_clk)) {
> >>> +               dev_err(qdwc->dev, "failed to get core clock\n");
> >>> +               return PTR_ERR(qdwc->core_clk);
> >>> +       }
> >>> +
> >>> +       qdwc->iface_clk =3D devm_clk_get(qdwc->dev, "iface");
> >>> +       if (IS_ERR(qdwc->iface_clk)) {
> >>> +               dev_dbg(qdwc->dev, "failed to get optional iface cloc=
k\n");
> >>> +               qdwc->iface_clk =3D NULL;
> >>> +       }
> >>> +
> >>> +       qdwc->sleep_clk =3D devm_clk_get(qdwc->dev, "sleep");
> >>> +       if (IS_ERR(qdwc->sleep_clk)) {
> >>> +               dev_dbg(qdwc->dev, "failed to get optional sleep cloc=
k\n");
> >>> +               qdwc->sleep_clk =3D NULL;
> >>> +       }
> >>> +
> >>> +       ret =3D clk_prepare_enable(qdwc->core_clk);
> >>> +       if (ret) {
> >>> +               dev_err(qdwc->dev, "failed to enable core clock\n");
> >>> +               goto err_core;
> >>> +       }
> >>> +
> >>> +       ret =3D clk_prepare_enable(qdwc->iface_clk);
> >>>
> >> Should not we check if  qdwc->iface_clk is valid?
> >=20
> > read the sources luke.
> Now I read that its initialized to NULL in fail case but should we call
> prepare_enable at all if its NULL?

now read the source of clk_enable() and clk_prepare() ;-) NULL is a
valid clock, it just returns 0. This is better than sprinkling IS_ERR()
all over the place.

--=20
balbi

--dkEUBIird37B8yKS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUE1e2AAoJEIaOsuA1yqREJzsP/3F+k9wovz/FojoYLqJ4n99e
RyUr85Wxne41OspspC4UptVzq9RcS7CEZp/2hSTF5iYoL6CNSupZq72vkgX5s16S
sPsBCEtUVSu0MrQFGfM8UJP0Rw7K9qgKls6HSyPfznmDJDn5TFdNSbDJQf85dFFr
WhrkofOxGwMSOMahnkCZ1LlqHw3k0OcbPNPs3inuKI7xEw/XpzPCRb3oBPMZLGzD
FoGMb6U7sl9Nwe+w+sMmNCtPUIG5il5gUPETRdKhfD7BnH6Dzgu+J4VL8q89jCN1
W+ZNOBgH6HcRtIi56ek4nRXCJhplb1wmUB9ri6j/yuZMmhLvvnsfS7S+koYsRt2W
J4IwSl72veXqSg+D4kR1QAThrf2dHOHyZNYBDzO7NK3VEAxgka1wQ8Jef33NNX0P
oSpXJWJZmbDJCnCCWPEe8+F7OYXFrdlGjbA8XffoAHMujagQOP2sqYJUJu24I4FZ
dL4jweAfceeiOLNUvCRDMFQamxAl+8DWAX+Vwjihct/3EfKK/gIj9fNJvvgeIFmm
FcRlF2gCIwWuizo4d2QumnmN3L5mN56w2MU2AeB+Ku4do9amOEPOuc2SyDzLufOA
799bhdhdJlDas4AiTaZ3WlFVbeGoWdoJByzeGYri8P60VsnP/Y4XJICC4R+8LUsz
wtWT965SNKPgToY35hr4
=W/XX
-----END PGP SIGNATURE-----

--dkEUBIird37B8yKS--
