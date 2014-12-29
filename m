Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752212AbaL2Qjk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 11:39:40 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:42128 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751321AbaL2Qjj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 11:39:39 -0500
Date: Mon, 29 Dec 2014 10:39:09 -0600
From: Felipe Balbi <balbi@ti.com>
To: Robert Baldyga <r.baldyga@samsung.com>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: gadget: udc-core: call udc_stop() before gadget
 unbind
Message-ID: <20141229163909.GG29379@saruman>
Reply-To: <balbi@ti.com>
References: <1418390248-6254-1-git-send-email-r.baldyga@samsung.com>
 <20141215051317.GC25410@shlinux2>
 <548EB262.6040208@samsung.com>
 <20141222163430.GH12815@saruman>
 <54990CE7.1030008@samsung.com>
 <20141223183120.GG9147@saruman>
 <54A102FC.4000307@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kjpMrWxdCilgNbo1"
Content-Disposition: inline
In-Reply-To: <54A102FC.4000307@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--kjpMrWxdCilgNbo1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 29, 2014 at 08:30:04AM +0100, Robert Baldyga wrote:
> Hi Felipe,
>=20
> On 12/23/2014 07:31 PM, Felipe Balbi wrote:
> > On Tue, Dec 23, 2014 at 07:34:15AM +0100, Robert Baldyga wrote:
> >> On 12/22/2014 05:34 PM, Felipe Balbi wrote:
> >>> On Mon, Dec 15, 2014 at 11:05:22AM +0100, Robert Baldyga wrote:
> >>>> On 12/15/2014 06:13 AM, Peter Chen wrote:
> >>>>> On Fri, Dec 12, 2014 at 02:17:28PM +0100, Robert Baldyga wrote:
> >>>>>> As usb function drivers assumes that all usb request will be compl=
eted
> >>>>>> before function unbind call, we should supply such behavior. In so=
me
> >>>>>> cases ep_disable() won't kill all request effectively, because some
> >>>>>> IN requests can be in running state. In such situation it's possib=
le
> >>>>>> to have unbind function called before last request completion, whi=
ch
> >>>>>> can cause problems.
> >>>>>
> >>>>> Doesn't the function's disable/unbind should call usb_ep_dequeue to=
 make
> >>>>> sure the transfer has ended?
> >>>>
> >>>> USB function drivers like ECM or HID surely doesn't. It looks like
> >>>> there's assumption that all requests will be completed by UDC driver.
> >>>
> >>> that's a bug on those drivers :-)
> >>
> >> So we can't make assumptions that requests will be completed in
> >> ep_disable()?
> >=20
> > oh, no you can. I misread it.
> >=20
> >>>> Function ep_disable() should complete requests in hardware driver, b=
ut
> >>>> at least in DWC2 driver not all requests are completed at this stage
> >>>
> >>> and that's a bug on dwc2 :-)
> >>
> >> I have already found that out. Another UDC drivers simply kill all
> >> request without waiting for currently running, so I did the same in
> >> DWC2. Here is my patch:
> >> http://www.spinics.net/lists/linux-usb/msg118698.html
> >=20
> > should be in my pull request already.
>=20
> It looks like you applied wrong patch. I meant patch titled "drivers:
> usb: dwc2: remove 'force' parameter from kill_all_requests()" is the
> latest and complete fix. The patch you have applied named "usb: dwc2:
> gadget: kill requests with 'force' in s3c_hsotg_udc_stop()" do not solve
> problem completely without changes in udc-core, which we concluded are
> not acceptable.
>=20
> Sorry for the mess. I understand that titles of both patches are
> confusing similar.

Can you send a patch on top fixing things up ? Either that or a revert
followed by correct patch.

--=20
balbi

--kjpMrWxdCilgNbo1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUoYOtAAoJEIaOsuA1yqRE/zAQAKNXiPqYDG2JG6ms9XuJY2SN
9XXsQMlPlgMmE3b/PruFVXKFSAbwlMtiZ1JSBv4YEm+F+rQd1NVaCQyboMsY430z
5XeXXNNABE3oYgXhMzDQUnkqYp6iKFsf7hil+e5vyuySF0bABXhMTH+bGGEnGazx
eVMKsimdjrDADT5sCK/tozaibklDt/ng+O+dVsq8kzMOMqw8SkNNLLRDuNngWl0A
Rvy4L6FEnQLwwlDB2k90H3YmRLM8QtiQrPvssZwvCsSNq+vBa+0WsnTEgwkY7lNi
ge4BdCuDDWK3pMGDc7bONe9k+FvI7oEnCKFci4vhblSsxmfsN23INkS3Rg7CWKkq
uBslzEjkoMCkIH5HEdq/6xrndUX3VofJP4NSlS+ade5RQyRgxFnXOdqahp17xlLs
UA/VcqibmvrcAWmXU5sX9y+joDAD4xwK5WB79Obc1kq4M2U/i+MPVznxLRwtLvF0
oiKGx6x4aKPr/rMF2WDpC2ZupeG3FNU6uDBUS59rkhDYSEb/COmfDv5OKT53vxmk
IfXuJlyPmk7dlIwCBxZbu4RMqH4icnk02g80+4chkBUSBYrq/bDdsJRRx+My34uq
gt8Pj6xdoCJNwVx207smKt7wm1EsjY6RnsF0vUZmSNggkK5Cr1JvcknFsUC4uttc
L9z1KuYUTepl3NizmwHl
=Jhu5
-----END PGP SIGNATURE-----

--kjpMrWxdCilgNbo1--
