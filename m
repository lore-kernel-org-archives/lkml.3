Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754934AbaDPSEs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 14:04:48 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:45508 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457AbaDPSEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 14:04:44 -0400
Date: Wed, 16 Apr 2014 13:02:28 -0500
From: Felipe Balbi <balbi@ti.com>
To: sundeep subbaraya <sundeep.lkml@gmail.com>
CC: <balbi@ti.com>,
        Subbaraya Sundeep Bhatta <subbaraya.sundeep.bhatta@xilinx.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Michal Simek <michals@xilinx.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Subbaraya Sundeep Bhatta <sbhatta@xilinx.com>
Subject: Re: [PATCH v2 2/2] usb: gadget: Add xilinx axi usb2 device support
Message-ID: <20140416180228.GK28035@saruman.home>
Reply-To: <balbi@ti.com>
References: <1396510519-8555-1-git-send-email-sbhatta@xilinx.com>
 <113d0620-4003-417d-806b-0b79ae692829@VA3EHSMHS023.ehs.local>
 <20140403145853.GD14162@saruman.home>
 <CALHRZuoCtEz5-CmU17dUpVS_MjSDdYVLMSvgXq_RwxLj_KJMDA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nrM5Z5VIJgwP9LWp"
Content-Disposition: inline
In-Reply-To: <CALHRZuoCtEz5-CmU17dUpVS_MjSDdYVLMSvgXq_RwxLj_KJMDA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nrM5Z5VIJgwP9LWp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Apr 16, 2014 at 04:09:28PM +0530, sundeep subbaraya wrote:
> Hi Felipe,
>=20
> On Thu, Apr 3, 2014 at 8:28 PM, Felipe Balbi <balbi@ti.com> wrote:
>=20
> >> +static int start_dma(struct xusb_ep *ep, u32 src, u32 dst, u32 length)
> >
> > please prepend this with xudc_, it makes tracing a lot easier.
> >
> >> +{
> >> +     struct xusb_udc *udc;
> >> +     int rc =3D 0;
> >> +     unsigned long timeout;
> >> +
> >> +     udc =3D ep->udc;
> >> +     /*
> >> +      * Set the addresses in the DMA source and
> >> +      * destination registers and then set the length
> >> +      * into the DMA length register.
> >> +      */
> >> +     udc->write_fn(udc->base_address, XUSB_DMA_DSAR_ADDR_OFFSET, src);
> >> +     udc->write_fn(udc->base_address, XUSB_DMA_DDAR_ADDR_OFFSET, dst);
> >> +     udc->write_fn(udc->base_address, XUSB_DMA_LENGTH_OFFSET, length);
> >> +
> >> +     /*
> >> +      * Wait till DMA transaction is complete and
> >> +      * check whether the DMA transaction was
> >> +      * successful.
> >> +     */
> >> +     while ((udc->read_fn(ep->udc->base_address + XUSB_DMA_STATUS_OFF=
SET) &
> >> +                     XUSB_DMA_DMASR_BUSY) =3D=3D XUSB_DMA_DMASR_BUSY)=
 {
> >> +             timeout =3D jiffies + 10000;
> >> +
> >> +             if (time_after(jiffies, timeout)) {
> >> +                     rc =3D -ETIMEDOUT;
> >> +                     goto clean;
> >> +             }
> >> +     }
> >
> > don't you get an IRQ for DMA completion ? If you do, you could be using
> > wait_for_completion()
>=20
> This function is called in interrupt context when buffer is ready or
> free. It initiates DMA to transfer data from IP buffer to memory.
> Hence it waits in busy loop till DMA completes

wait, so you start_dma() before your gadget driver asks you to ?

--=20
balbi

--nrM5Z5VIJgwP9LWp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTTsW0AAoJEIaOsuA1yqREHwAP/R0teoahsAB8zL6AjKLcMJNO
pG4yFlMlaF/FnjkLARjtJGaW1gqOe7xgV89+BFzjt9613Jr9RUOJB4E5jbLYG87A
4lxyaI4oPset5cgG3Pa/L2W43COg1v368usIZTiA/jyNBa/P8InU0K8NhHCExKDZ
Q98LXvRHk5v2BY6rrROpsZlTzhs+z8zrPohT7LajL435Ywo6AcD+Q3kanWt9zV1n
dtyMM3sPk3oSe3oAFloBPqxsh5T6BfuRRHL1U10dwoXq4HUnV6+KDGrykhJot+A1
QnBqJzNP4hawDY/3naDk5PIgM5G/EZyooDYQA/86vx2O70ltCzhuxRODn+dJxyVt
6qHAkEZw+s7gg09XxT0eHcvoo7WtoX9iw6ok+IthCEs89Uz70fSdl5/Y/wSBXEWg
H5H5zG1XfQhLTaiY6BDXgp8QuRDlf2C/XzZlhH+IPOfQWFTGgarr80M/UnE642iN
FDXYQWkOKu/Cbj3mhnwgBVkS43T0pfv6jkI3ki7XZiWnlipUgX2p5pR3lz/FjkbZ
fmT9DLReNq6eyoyDDDc7tt3IOZwJgvdbtslvIQq14lQhfzCcxmo4hmUw5ealWzOL
ozs80ZQH3dddN7uAMnuMoEfMa1+mkZFbhf78cHiaPcofFGpCdM8MeUEKLt3CO6sl
SuAR/EEYObe4xB5T3Rpw
=54C0
-----END PGP SIGNATURE-----

--nrM5Z5VIJgwP9LWp--
