Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932667AbaDVOwQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 10:52:16 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:35127 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756182AbaDVOwH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 10:52:07 -0400
Date: Tue, 22 Apr 2014 09:49:44 -0500
From: Felipe Balbi <balbi@ti.com>
To: sundeep subbaraya <sundeep.lkml@gmail.com>
CC: Alan Stern <stern@rowland.harvard.edu>, Felipe Balbi <balbi@ti.com>,
        Subbaraya Sundeep Bhatta <subbaraya.sundeep.bhatta@xilinx.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Michal Simek <michals@xilinx.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Subbaraya Sundeep Bhatta <sbhatta@xilinx.com>
Subject: Re: [PATCH v2 2/2] usb: gadget: Add xilinx axi usb2 device support
Message-ID: <20140422144944.GF5524@saruman.home>
Reply-To: <balbi@ti.com>
References: <20140421160802.GA22794@saruman.home>
 <Pine.LNX.4.44L0.1404211228190.1201-100000@iolanthe.rowland.org>
 <CALHRZur7+MaYXbWOfbvjggPN7_eYAE+th5VNbcLP=ehvm0HGsA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RMedoP2+Pr6Rq0N2"
Content-Disposition: inline
In-Reply-To: <CALHRZur7+MaYXbWOfbvjggPN7_eYAE+th5VNbcLP=ehvm0HGsA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--RMedoP2+Pr6Rq0N2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Apr 22, 2014 at 12:58:41PM +0530, sundeep subbaraya wrote:
> Hi,
>=20
> On Mon, Apr 21, 2014 at 10:09 PM, Alan Stern <stern@rowland.harvard.edu> =
wrote:
> > On Mon, 21 Apr 2014, Felipe Balbi wrote:
> >
> >> Hi,
> >>
> >> On Fri, Apr 18, 2014 at 07:34:08PM +0530, sundeep subbaraya wrote:
> >>
> >> <snip>
> >>
> >> > >> in ep_queue driver starts dma transfer from/to IP buffer to/from =
req->buf.
> >> > >> If transfer is completed then request is not added to ep request =
queue
> >> > >> and returns from ep_queue.
> >> > >> If transfer is not completed (actual < length) then request is ad=
ded
> >> > >> to queue and returns from ep_queue.
> >> > >
> >> > > This is wrong. Why wouldn't you give gadget driver the chance to d=
ecide
> >> > > if it needs to queue the request again or not ?
> >> >
> >> > When does gadget driver decides to queue the same request again?
> >> > if -EBUSY is returned from ep_queue or req.status !=3D 0 in completi=
on
> >> > routine?
> >>
> >> whenever it so decides. Different gadget drivers might have different
> >> requirements. The code is open and sits under drivers/usb/gadget/ why
> >> don't you have a read ?
> >
> > I get the impression that the two of you are arguing past each other.
> > It appears that Sundeep is talking about transferring data from the
> > gadget driver's buffer to an internal buffer in the UDC hardware, but
> > Felipe is talking about transferring data from the UDC to the host.
> >
> > As I understand it, Sundeep said that when the gadget driver queues a
> > data-IN request, the UDC driver copies as much of the data buffer as
> > possible into a hardware FIFO.  If it succeeds in copying all the data
> > into the FIFO then the request's completion routine gets called
> > immediately, even though the data doesn't get sent from the FIFO to the
> > host until the host asks for it.
> >
> > If only part of the data can be copied into the FIFO then the request
> > is added to the ep's request queue before the usb_ep_queue() call
> > returns.  When space becomes available in the FIFO, the data will be
> > copied and eventually sent to the host.  When all the data has been
> > copied to the FIFO, the request's completion routine will be called.

there seems to be a slight problem with this approach: how will the IP
know that even though you copied X bytes into the FIFO, it should wait
for another Y bytes before shifting data to the wire ? How will it know
that it shouldn't generate CRC yet because there's still data to be
added ?

If there's no space in the FIFO yet, why copy data at all ?

> > Thus there never is any need for the gadget driver to queue the request
> > again.  An incomplete transfer means the FIFO didn't have enough room
> > when the request was submitted; it doesn't mean that the data didn't
> > eventually get sent to the host.
>=20
> Exactly Alan,this is what I was trying to say. Probably I was not
> clear in explaining. I didnt see any harm this way and even this
> implementation is same like at91_udc.c. I have been reading
> mas_storage to understand when does gadget driver tries to enqueue a
> request again. Since different gadget drivers might have different
> requirements (agree with Felipe), wanted to know criteria for queuing
> a same request again.
>=20
> I will change this implementation as per Felipe comments and test with
> some of the gadgets.

Let's see, please help me understand the questions above.

--=20
balbi

--RMedoP2+Pr6Rq0N2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTVoGIAAoJEIaOsuA1yqREZgAQAJDKKoPqv706bCJ2YgdkDeXa
zcoF+7Te2y5OyYHjC7RD8VcERyMCLKxrotsg0rlZAKekjRpWzzKHSeIEsWrlEpNM
81gmmq3FqyaP4bExSZ4e0jnsjBbQpuUI8VWS4I+BcOl1NGkNpFPIA4KhDqCJ1zhw
n9KEiykzjibjGrwOur/XJuwLbDX7/27woIcuqbDDfz3UEjRX8FYuT3p7qXZhz+nn
XiXDPTwXP2z3R5fw6H4pAVtoEEJlW6mTKEiDqGFy5IDZvrQE1MTPKeJu6aAlJ3U2
728MLSy4aFxRMKpifaRL+AFztxhAmqO/kFentRk57HmAxobKU0R+FQJD2AyvISBz
/qAVPRN3zfG7UlxNJa2mywoVZrKLdggHTDMQWo1zr9ia5tuZiA7kmMiwFu2fx0Sw
Gpi+n1v1JUczLl5xWgxTDAUU6khPqD6rNolDPYHnbAnGjm5GevHJTjdrk+zojXhC
bUAwTMg2l03M9MNjNArRPBsWuMpEgfTqLVoFJENCLAf5KkAzCr3sDBNje+nPrNvK
zm5nuBX3+ApoDThoj4AdQMfJxBpv18NVgHSyBKBGeA648+wkiHqvUdPWlRxcO+Bt
25WD65I7tS4+PugJaPu704ZPmO+CfKzerD9ACKvcaHytVmQDrsPb4AxE4bhdkpGO
sTLbzVS/w63iEzYNzQKe
=yiQQ
-----END PGP SIGNATURE-----

--RMedoP2+Pr6Rq0N2--
