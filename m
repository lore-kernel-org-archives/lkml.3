Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951Ab3GTLM2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 07:12:28 -0400
Received: from mail-db9lp0253.outbound.messaging.microsoft.com ([213.199.154.253]:2544
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753688Ab3GTLM1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 07:12:27 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI9371I1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hz8dhz1de098h1de097h8275bhz2dh2a8h668h839h8e2h8e3h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dhbe9i1155h)
From: Chen Peter-B29397 <B29397@freescale.com>
To: Rong Wang <wr011235813@gmail.com>
CC: Greg KH <gregkh@linuxfoundation.org>, "balbi@ti.com" <balbi@ti.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Rong.Wang@csr.com" <Rong.Wang@csr.com>
Subject: RE: [PATCH] usb: udc: add gadget state kobject uevent
Thread-Topic: [PATCH] usb: udc: add gadget state kobject uevent
Thread-Index: AQHOgQ/L6yTmjsCbR0ibTspDf9T00pll9SqAgAC3joCAAC1PgIAB1u+AgAFtlYCAA019sA==
Date: Sat, 20 Jul 2013 10:57:13 +0000
Message-ID: <F281D0F91ED19E4D8E63A7504E8A649803F5B0F8@039-SN2MPN1-021.039d.mgd.msft.net>
References: <CA+k=oDzG+R-ei5WGxP8L1Od6VWTK9SgWcXHNjd89u6+b2bECkQ@mail.gmail.com>
	<20130715165209.GA6000@kroah.com>
	<CA+k=oDzZ5sf_wFMUvE_vkkqRQaOV0P3vWP99tDpoZkrwMN7Q+A@mail.gmail.com>
	<20130716063117.GA30320@kroah.com>	<20130717023649.GD29679@nchen-desktop>
 <CA+k=oDxnHJN6NgMM_Ziz92_0d8+anfMEqz7WvBCrg5RAn9MzCg@mail.gmail.com>
In-Reply-To: <CA+k=oDxnHJN6NgMM_Ziz92_0d8+anfMEqz7WvBCrg5RAn9MzCg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.192.185.215]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 
> 
> On Wed, Jul 17, 2013 at 10:36 AM, Peter Chen <peter.chen@freescale.com>
> wrote:
> > On Mon, Jul 15, 2013 at 11:31:17PM -0700, Greg KH wrote:
> >> On Tue, Jul 16, 2013 at 11:49:07AM +0800, Rong Wang wrote:
> >> > Hi Greg,
> >> >
> >> > The USB on our platform can change roles between HOST and GADGET,
> but
> >> > it is not capable of OTG.
> >>
> >> That kind of sounds like the definition of OTG :)
> >>
> >> > When the USB changes between roles the udev will run some scripts
> >> > automatically according to the udev rules.
> >>
> >> What exactly does udev/userspace see when the roles change?
> >>
> >> And what can trigger the change in roles?
> >>
> >> > The default role is GADGET, and we bind the g_mass_storage to the
> USB
> >> > GADGET role.
> >> >
> >> > We should secure the back end file storage between the device and
> the
> >> > host PC connecting to our device.
> >> > We need to know when the GADGET is really connect to a host PC, then
> >> > we can umount the file on the device
> >> > and export it to the g_mass_storage.
> >>
> >> I thought you already get an event for this, otherwise no one would be
> >> able to properly deal with this.
> >>
> >> > The question is since we default GADGET, so the g_mass_storage.ko is
> >> > installed early but connecting to a host PC
> >> > is randomly, But the udev has no idea when a host PC connects our
> device.
> >> >
> >> > So we consider it's reasonable to let the udev know the GADGET
> device state.
> >> > Is there any alternative to our question?
> >>
> >> I thought we already export events for gadget device states, have you
> >> looked for them?  I can't dig through the code at the moment, but this
> >> seems like a pretty common issue...
> >>
> >
> > If I understand correctly,  what Rong wants is udev can be notified the
> > udc state changes, like connect/disconnect event. Currently, we only
> > export it to /sys.
> 
> OK. Thanks for your share.
> 
> And you develop a new utility rather than udev to monitor that file?
> And you probably create a work queue in your udc driver to do this work?
> 
 
Not yet, no one complains it, so I haven't added it.
But, it is a useful user interface, Android has implemented similar functions
at its gadget driver.

Best regards,
Peter



