Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755143AbaHUNVf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 09:21:35 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:47043 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754291AbaHUNVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 09:21:33 -0400
Date: Thu, 21 Aug 2014 15:21:25 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Andrzej Hajda <a.hajda@samsung.com>
Cc: Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Mark Rutland <mark.rutland@arm.com>, linux-pwm@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>, Pawel Moll <pawel.moll@arm.com>,
        devicetree@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Nicolas Ferre <nicolas.ferre@atmel.com>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, Rob Herring <robh+dt@kernel.org>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Bo Shen <voice.shen@atmel.com>, Kumar Gala <galak@codeaurora.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Andrew Victor <linux@maxim.org.za>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 00/11] drm: add support for Atmel HLCDC Display
 Controller
Message-ID: <20140821132124.GB19293@ulmo.nvidia.com>
References: <1406034695-15534-1-git-send-email-boris.brezillon@free-electrons.com>
 <20140821081619.GZ2452@ldesroches-Latitude-E6320>
 <20140821103706.2349915d@bbrezillon>
 <20140821090406.GA13733@ulmo>
 <20140821114159.319e741b@bbrezillon>
 <20140821095202.GA21848@ulmo>
 <53F5CACB.5010706@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1LKvkjL3sHcu1TtY"
Content-Disposition: inline
In-Reply-To: <53F5CACB.5010706@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1LKvkjL3sHcu1TtY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 21, 2014 at 12:32:43PM +0200, Andrzej Hajda wrote:
> On 08/21/2014 11:52 AM, Thierry Reding wrote:
> > On Thu, Aug 21, 2014 at 11:41:59AM +0200, Boris BREZILLON wrote:
> >> On Thu, 21 Aug 2014 11:04:07 +0200
> >> Thierry Reding <thierry.reding@gmail.com> wrote:
> >>
> >>> On Thu, Aug 21, 2014 at 10:37:06AM +0200, Boris BREZILLON wrote:
> >>>> Hi Ludovic,
> >>>>
> >>>> On Thu, 21 Aug 2014 10:16:19 +0200
> >>>> Ludovic Desroches <ludovic.desroches@atmel.com> wrote:
> >>>>
> >>>>> Hi Boris,
> >>>>>
> >>>>> You can add
> >>>>>
> >>>>> Tested-by: Ludovic Desroches <ludovic.desroches@atmel.com>
> >>>>
> >>>> Thanks for testing this driver.
> >>>>
> >>>>>
> >>>>> Only one issue but not related to your patches, you can't display
> >>>>> quickly the bootup logo since the panel detection takes too much
> >>>>> time.
> >>>>
> >>>> Yes, actually this is related to the device probe order: the
> >>>> hlcdc-display-controller device is probed before the simple-panel, t=
hus
> >>>> nothing is detected on the RGB connector (I use of_drm_find_panel to
> >>>> check for panel availability) when the display controller is
> >>>> instantiated. I rely on the default polling infrastructure provided =
by
> >>>> the DRM/KMS framework which polls for a new connector every 10s, and
> >>>> this is far more than you kernel boot time.
> >>>>
> >>>> Do anyone see a solution to reduce this delay (without changing the
> >>>> polling interval). I thought we could add a notifier infrastructure =
to
> >>>> the DRM panel framework, but I'm not sure this is how you want things
> >>>> done...
> >>>
> >>> Other drivers return -EPROBE_DEFER when a panel hasn't been registered
> >>> yet. This will automatically take care of ordering things in a way th=
at
> >>> DRM/KMS will only be initialized after the panel has been probed.
> >>
> >> Actually I'd like to avoid doing this with a deferred probe, because,
> >> AFAIU, the remote endpoint is not tightly linked with the display
> >> controller driver (I mean the display controller can still be
> >> initialized without having a display connected on it).
> >> Moreover the atmel dev kit I'm using has an HDMI bridge connected on
> >> the same RGB connector and I'd like to use it in a near future.
> >> Returning -EPROBE_DEFER in case of several devices connected on the
> >> same connector implies that I'll have to wait for all the remote
> >> end-points to be available before my display controller could be
> >> instantiated.
> >>
> >> While this could be acceptable when all drivers are statically linked
> >> in the kernel, it might be problematic when you're using modules,
> >> meaning that you won't be able to display anything on your LCD panel
> >> until your HDMI bridge module has been loaded.
> >=20
> > No. HDMI should be using proper hotplugging anyway, hence it should be
> > always be loaded anyway. You're in for a world of pain if you think you
> > can run DRM with a driver that's composed of separate kernel modules.
> >=20
> > Also if you don't want to use deferred probe, then you're in for the
> > full hotplugging panel dance and that implies that you need to fix a
> > bunch of things in DRM (one being the framebuffer console instantiation
> > that I referred to in the other thread). You also can't be using the
> > current device tree bindings because they all assume a dependency from
> > the display controller/output to the panel. For hotplugging you'd need
> > the dependency the other way around (the panel needs to refer to the
> > output by phandle).
>=20
> I have tested panel as a module in exynos-dsi + panel-s6e8aa0
> configuration, everything works. There is a workaround for fb console
> not being reconfigurable, but it does not make thing worse than before.
> And I do not see a problem with phandles, ie in DT they point both ways,
> according to binding advices at the time, but in the code it is display
> controller/encoder which is looking for the panel.

That works because it's DSI. And we have attach/detach callbacks for
DSI. We don't have those for regular panels, so we'd need to find a way
to add that.

The way that this currently works is that an encoder/connector driver
looks up the panel and attaches it to itself. If you allow panels to be
hotpluggable, then they have no knowledge about what they are connected
to, so there needs to be a way to inject that knowledge so that they can
attach to a connector.

Thierry

--1LKvkjL3sHcu1TtY
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT9fJUAAoJEN0jrNd/PrOhF/0P/juJ+JoRu5a2baSD+CT4IGgf
Hxm9y5mYHImYXTXKcAecP8glRMDLXcQBlHsJskN0uXwm7ITd7HTr+QOA3akPJMv6
fe/PaujCB5q8pv+b/wKCe1aPxMqAnjfg8IRcI//TH4qYg2UxrN+s5Oeg97gPQtpE
FF0BAT7tLFY3OeqU2tVE5SRrOKMpkFn2ggmRboXkxWRTdMiDetzWpe+0H7Dxbl6h
3XjGcobLzrI2vC828XdXzq0MCZ2eRvbEK5lyNukjUJZzuACFH86adOEM4b1d/J+K
jFQnbygLlvGqPrZkSJ6essG90ymM/4uyyifWAFCIbISqd7WxbX4oRC7IK8WehTuo
jO94a/RzxTdK07SVim5YXLK2LklSynSebrGQraXW+mtrZ0TJEF+F5ILRLVNSDMvz
ozhY1a3eH+FerMw3m1GnipK+UspdwjNMYtjKmwvczxCeqtGIQD0OEDiz3xKfJl89
0C9htIdB5GPK97lPS2lZ0t8kbpKpjbmK0ViAIU7xFK/plN3psF3khpt0NG3krIs3
MkkxOnAQ876yXuaEiIlwxUXgq6QayhhYzRXXsXUZSlPF/JZ2nEUYc0gVCRVuwdjZ
Iv+2lWdLme60N4pAnTRlidjALbQ2lhCZaZzLmP0F6VVy0geMy2EctkEbMAj+W3je
LFgqnDdWUPmcyRmnH8rS
=lFUl
-----END PGP SIGNATURE-----

--1LKvkjL3sHcu1TtY--
