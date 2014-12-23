Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751748AbaLWSbr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 13:31:47 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:47138 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725AbaLWSbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 13:31:45 -0500
Date: Tue, 23 Dec 2014 12:31:20 -0600
From: Felipe Balbi <balbi@ti.com>
To: Robert Baldyga <r.baldyga@samsung.com>
CC: <balbi@ti.com>, Peter Chen <peter.chen@freescale.com>,
        <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <m.szyprowski@samsung.com>,
        <k.opasiak@samsung.com>
Subject: Re: [PATCH] usb: gadget: udc-core: call udc_stop() before gadget
 unbind
Message-ID: <20141223183120.GG9147@saruman>
Reply-To: <balbi@ti.com>
References: <1418390248-6254-1-git-send-email-r.baldyga@samsung.com>
 <20141215051317.GC25410@shlinux2>
 <548EB262.6040208@samsung.com>
 <20141222163430.GH12815@saruman>
 <54990CE7.1030008@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="E69HUUNAyIJqGpVn"
Content-Disposition: inline
In-Reply-To: <54990CE7.1030008@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--E69HUUNAyIJqGpVn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 23, 2014 at 07:34:15AM +0100, Robert Baldyga wrote:
> Hi Felipe,
>=20
> On 12/22/2014 05:34 PM, Felipe Balbi wrote:
> > On Mon, Dec 15, 2014 at 11:05:22AM +0100, Robert Baldyga wrote:
> >> On 12/15/2014 06:13 AM, Peter Chen wrote:
> >>> On Fri, Dec 12, 2014 at 02:17:28PM +0100, Robert Baldyga wrote:
> >>>> As usb function drivers assumes that all usb request will be complet=
ed
> >>>> before function unbind call, we should supply such behavior. In some
> >>>> cases ep_disable() won't kill all request effectively, because some
> >>>> IN requests can be in running state. In such situation it's possible
> >>>> to have unbind function called before last request completion, which
> >>>> can cause problems.
> >>>
> >>> Doesn't the function's disable/unbind should call usb_ep_dequeue to m=
ake
> >>> sure the transfer has ended?
> >>
> >> USB function drivers like ECM or HID surely doesn't. It looks like
> >> there's assumption that all requests will be completed by UDC driver.
> >=20
> > that's a bug on those drivers :-)
>=20
> So we can't make assumptions that requests will be completed in
> ep_disable()?

oh, no you can. I misread it.

> >> Function ep_disable() should complete requests in hardware driver, but
> >> at least in DWC2 driver not all requests are completed at this stage
> >=20
> > and that's a bug on dwc2 :-)
>=20
> I have already found that out. Another UDC drivers simply kill all
> request without waiting for currently running, so I did the same in
> DWC2. Here is my patch:
> http://www.spinics.net/lists/linux-usb/msg118698.html

should be in my pull request already.

> >> (request which are in hardware FIFO are omitted to give them chance to
> >> be transferred). Those requests are forced to complete in udc_stop()
> >=20
> > that's wrong, we're disabling the endpoint anyway. Either dwc2 needs to
> > wait_for_completion() or forcibly cancel the request. The bottom line is
> > that control should not exit ep_disable() until all requests have been
> > quiesced.
>=20
> So that's not bug in function drivers. They make correct assumption,
> because they expect that requests will be completed in ep_disable().

right :-)

--=20
balbi

--E69HUUNAyIJqGpVn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUmbT4AAoJEIaOsuA1yqRElzgP/2ldPEi92cbdOZO82r6j0/Fa
suDaHNZzYe3sOI7Ew7taPrj1XXN4O79/7DOjUBXjMv0fc2sn6Mc7+HDa0IzlK2RQ
pK+6P+/VqaigE46FSOMkAHv+qlKMuGak2V2vtqcWvYtfJBoTZBmhs47Xc494RMPa
tT0QaFAtfzNBcoG0A3VDWYaIoRirkCw/G0uKUOuX2VwzbVHOe2JFgHeazm4omugX
GFJ0mXgzVKksNB+imotbxv+6Wje9Oxh8tCm1sjirXavc2e0MTH9BSkgW7ZRQuCw3
nBZl99J+Y/d6MiwmCIQFw9fM4VNvxtqW/HOoqhywwBMfpbLnRfqTlrnT1uVxVbgX
fEQPD3R1jGfgedv2X6xVwGBoC/UJuqv36bPcYgqaLmA9cjEMcvlAp4AAmqtR0Caw
5FviU2zbkl0TKGkmC6hIicFZ48q7Oes4yCsFu/LZgzu9mmmXa9vRZQ2Z6PeG1U33
r35TQ1dEK0TsJr3aBXJNz6MuBhmocONnuJYKdLTSY5vxJhYCu774QLljCpfKRtTD
zma1wvXaF+PQPuXXs+KGeB/M2cA0MAJkE9r1pPpcUV5jKeqHLdt9MqnPmDkt5fzB
qLOzu+MFUv/QHFbfDrdVD5ZdfS0Xhj7auh74R6HJkkcwHqXL8FbKo6uyELKmTMhc
J+Z0gz01MHz7rVqZzpO2
=8VoC
-----END PGP SIGNATURE-----

--E69HUUNAyIJqGpVn--
