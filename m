Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008Ab3H0T7o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 15:59:44 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:50380 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753749Ab3H0T7l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 15:59:41 -0400
Date: Tue, 27 Aug 2013 14:58:59 -0500
From: Felipe Balbi <balbi@ti.com>
To: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
CC: "Ivan T. Ivanov" <iivanov@mm-sol.com>, Kumar Gala <galak@codeaurora.org>,
        "balbi@ti.com" <balbi@ti.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "ian.campbell@citrix.com" <ian.campbell@citrix.com>,
        "rob@landley.net" <rob@landley.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "idos@codeaurora.org" <idos@codeaurora.org>,
        "mgautam@codeaurora.org" <mgautam@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Subject: Re: [PATCH v4 2/3] usb: phy: Add Qualcomm SS-USB and HS-USB drivers
 for DWC3 core
Message-ID: <20130827195859.GF3005@radagast>
Reply-To: <balbi@ti.com>
References: <1376992565-22292-3-git-send-email-iivanov@mm-sol.com>
 <20130820122907.GU26587@radagast>
 <1377005543.26268.22.camel@iivanov-dev.int.mm-sol.com>
 <20130820133712.GC26587@radagast>
 <1377007751.26268.27.camel@iivanov-dev.int.mm-sol.com>
 <20130820143319.GG26587@radagast>
 <1377010458.26268.30.camel@iivanov-dev.int.mm-sol.com>
 <8691FDFE-326E-4198-838A-202D9EC988E1@codeaurora.org>
 <1377012381.26268.42.camel@iivanov-dev.int.mm-sol.com>
 <A2CA0424C0A6F04399FB9E1CD98E030458DECB7C@US01WEMBX2.internal.synopsys.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8hYiR1SWmJV79WGg"
Content-Disposition: inline
In-Reply-To: <A2CA0424C0A6F04399FB9E1CD98E030458DECB7C@US01WEMBX2.internal.synopsys.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--8hYiR1SWmJV79WGg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Aug 22, 2013 at 09:24:49PM +0000, Paul Zimmerman wrote:
> > From: Ivan T. Ivanov [mailto:iivanov@mm-sol.com]
> > Sent: Tuesday, August 20, 2013 8:26 AM
> >=20
> > On Tue, 2013-08-20 at 10:01 -0500, Kumar Gala wrote:
> > > On Aug 20, 2013, at 9:54 AM, Ivan T. Ivanov wrote:
> > >
> > > >
> > > > Hi,
> > > >
> > > > On Tue, 2013-08-20 at 09:33 -0500, Felipe Balbi wrote:
> > > >> On Tue, Aug 20, 2013 at 05:09:11PM +0300, Ivan T. Ivanov wrote:
> > > >>>
> > > >>> On Tue, 2013-08-20 at 08:37 -0500, Felipe Balbi wrote:
> > > >>>>
> > > >>>> On Tue, Aug 20, 2013 at 04:32:23PM +0300, Ivan T. Ivanov wrote:
> > > >>>>>
> > > >>>>> I think they are SNPS DesignWare PHY's, additionally
> > > >>>>> wrapped with Qualcomm logic. I could substitute "dwc3"
> > > >>>>> with just "dw", which will be more correct.
> > > >>>>
> > > >>>> alright, thank you. Let's add Paul to the loop since he might ha=
ve very
> > > >>>> good insight in the synopsys PHYs.
> > > >>>>
> > > >>>> mental note: if any other platform shows up with Synopsys PHY, a=
sk them
> > > >>>> to use this driver instead :-)
> > > >>>
> > > >>> I really doubt that this will bi possible. Control of the PHY's is
> > > >>> not directly trough ULPI, UTMI or PIPE3 interfaces, but trough
> > > >>> QSCRATCH registers, which of course is highly Qualcomm specific.
> > > >>
> > > >> isn't it a memory mapped IP ? doesn't synopsys provide their own s=
et of
> > > >> registers ?
> > > >
> > > > From what I see it is not directly mapped. How QSCRATCH write and
> > > > reads transactions are translated to DW IP is unclear to me.
> > >
> > >
> > > I think the question is how does SW access them?
> >=20
> > "USB QSCRATCH Hardware registers" don't ask me what is this :-)
> > or like Pawel says: "it depends on the SOC" .
>=20
> To answer the question "doesn't synopsys provide their own set of
> registers", we provide registers in our USB cores to access the PHYs
> through I2C, ULPI/UTMI, or PIPE3 interfaces. But if someone wants to use
> our PHY with some other controller that doesn't provide that, then they
> may need to implement their own register set, as Qualcomm has apparently
> done.

thanks for clarifying. that pretty much hinders writing any sort of
generic drivers for Synopsys' PHYs though :-s

But I guess that's alright.

--=20
balbi

--8hYiR1SWmJV79WGg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSHQUDAAoJEIaOsuA1yqREE5AP/2ZZ5zmei7G9/mOyYAwyr3/z
79+Q+X/YxO2IKZSGZvH7fEyIbIsVBGq1BxFJTOyhkg6EyHkZixZeUotzMcMtcNB9
OsSkZTlVNLGa737/U0FAHwG9xLXrL3pHKiZepuZ3V2ch/2MlCY1IQn2BmBjfsrC+
PNHEjYyn1266O6r2JVJuiHv3sWyUI1cIbDn8d8jJG2pvbAAuEhmkgWMHZkSFvtco
MrORQpW4beCZAYPtdsukl4jllXIa1Uu+J0+ff5ViHzTZxK4xGpYIQU3smLkU/F52
hWdqr/gfsWSQa3/sHn6zJEaoQW/HlySAOaD6SzHCoLFUoemDqYkg0w0HPBRS8+lP
g4ON6lvPywt0xOTzrgbGRp+OORnVwQOuKnfAI16aio/NZPsuIJKP8ECrVYjVno1b
kkzg7x6i6ziSZ3iYimuN3w6hEG+RoK9qe/eCgmi8SuenpifOtdhjl7QexgAx5gC6
j4Ux4/bGtg0oawzqfAuh87aC1XRn1EZjEHQWo8VH8iVbIWbLIH5NcAaq5U6EqraF
4YLMOFGIjMgp8y+MAaIilZqiyBrRz24p+om1riZQOWLlYZZjjJPunhWI5BmA71mT
3LMdpnJLLYceHQjgBPm2WSyvwFqMSiNzicmPpgY8312/utPUX5KkBv3J1/nIeFge
39L0sMFx6xf3DhMmYM5F
=OD97
-----END PGP SIGNATURE-----

--8hYiR1SWmJV79WGg--
