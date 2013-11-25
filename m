Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752528Ab3KYJfW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 04:35:22 -0500
Received: from mail-bk0-f44.google.com ([209.85.214.44]:33696 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305Ab3KYJfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 04:35:16 -0500
Date: Mon, 25 Nov 2013 10:34:35 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Tony Lindgren <tony@atomide.com>
Cc: Rob Herring <robherring2@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] of/platform: Fix no irq domain found errors when
 populating interrupts
Message-ID: <20131125093434.GE22043@ulmo.nvidia.com>
References: <20131123004334.GJ10023@atomide.com>
 <20131123005509.GJ16735@n2100.arm.linux.org.uk>
 <20131123010850.GN10023@atomide.com>
 <20131123011515.GO10023@atomide.com>
 <20131123015034.GP10023@atomide.com>
 <CAL_JsqKV7K+QdLHS+3LtfcVx5Dpc7n6A8UwwNWKBP33Gs19c8g@mail.gmail.com>
 <20131123163240.GW5928@atomide.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+SfteS7bOf3dGlBC"
Content-Disposition: inline
In-Reply-To: <20131123163240.GW5928@atomide.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+SfteS7bOf3dGlBC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 23, 2013 at 08:32:40AM -0800, Tony Lindgren wrote:
> * Rob Herring <robherring2@gmail.com> [131123 07:43]:
> > On Fri, Nov 22, 2013 at 7:50 PM, Tony Lindgren <tony@atomide.com> wrote:
> > > * Tony Lindgren <tony@atomide.com> [131122 17:16]:
> > >> * Tony Lindgren <tony@atomide.com> [131122 17:09]:
> > >> > * Russell King - ARM Linux <linux@arm.linux.org.uk> [131122 16:56]:
> > >> > > On Fri, Nov 22, 2013 at 04:43:35PM -0800, Tony Lindgren wrote:
> > >> > > > +               /* See of_device_resource_notify for populatin=
g interrupts */
> > >> > > > +               for (i =3D 0; i < num_irq; i++, res++) {
> > >> > > > +                       res->flags =3D IORESOURCE_IRQ;
> > >> > > > +                       res->start =3D -EPROBE_DEFER;
> > >> > > > +                       res->end =3D -EPROBE_DEFER;
> > >> > >
> > >> > > NAK.  Definitely a bad idea to start introducing magic values ot=
her into
> > >> > > resources.  Please don't do this.
> > >> >
> > >> > Do you have any better ideas on how to sort out this issue then?
> > >>
> > >> I guess we could allocate all the resources lazily here, I'll take a=
 look
> > >> at that.
> > >
> > > Here's a version that allocates the resources lazily with the notifie=
r.
> > > Seems to boot, need to play with it a bit more though to make sure we=
're
> > > not overwriting resources for any legacy devices.
> >=20
> > Have you seen Thierry's series[1]? While your approach is certainly
> > more concise, it seems like a work-around for the problem. I don't
> > think a notifier is the right long term solution.
>=20
> OK cool. I think we can fix the $Subject bug first without making all
> those changes, then do the rest of the reorg for v3.14.
>=20
> The bug is that we try to populate IRQ resources at a wrong time
> when they may not exist.
>=20
> Based on a quick look it seems we could combine Thierry's addition
> of the new function of_platform_probe(struct platform_device *pdev)
> and use that to allocate all resources at driver probe time like my
> patch is doing. And then there's no need for the notifier.

My series already does the allocation at probe time as well. That was
the whole point. The reason why I added of_platform_probe() is because I
think we'll be needing this for other types of resources in the future
as well, so it could serve as a central place to do all of that.

There was also a proposal[0] by Arnd a few weeks ago that solved this in
a more generic way. I've said it before, and I'll say again that the
idea scares me somewhat, but it does solve some interesting aspects and
has the potential to get rid of a whole lot of boilerplate code. While
the original purpose was to handle all things devm_*(), I suspect that
same mechanism could be used to resolve DT references at probe time.

Thierry

[0]: http://www.spinics.net/lists/devicetree/msg10684.html

--+SfteS7bOf3dGlBC
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSkxmqAAoJEN0jrNd/PrOh+IYP/RJKfbAcBxxP90/OIZFw91tj
n3WL8dBmytjY4Jia8+POZeu9QrPB/3MXQyC9wP6IRheItOnfEtYCEznVBgBi4AKa
SynOPZd3CSIY9BCIk1hDOMRQQR+lfkXgGj4Pmj/eT+S4Yj7F672f4WTmNGXMEAv7
cyPzx4P2Er8YqW3dyHHgWN3CgAwAQuTxQGEksVJccvoN0XaZcn3LpgrSKreGdfMd
CRisVAKU24ZmSpKoG+Sxsj0jkT9l+9BVMtLUpjZqbxhw9s4/Mr+0U7edKV/DQN5Y
r9fbmha/bCfzTTzmolTvNeBqjVrqcy3i1alUlJrPuXSTkA094m7DyyavHgwRnpKC
LFfkSq8a/X83F6GGqtcOmZQQDmTj4aT3XSHLlI7BP27vvkQxcB/24LL68MHRh/G8
rx7Ik5qy+U3UjkSi8QDK9segbBaqKuw2CFJgJbmUssU1+NM792Xip0BDHZ8ar1OP
dG0cJoGlhRXdEd1tGW/6/WPq7kLPHo3gP2oojyN1dTZe0yTBBDTVznGTKYl7lJdk
hnlnkMwcpBl+fITDpM1DB9b4j+FVZ7eqdT7ojheIVYZHZNhcxWvV2DmXVp3qt7qn
2/SHS/Jc/M8XTZol099/4Yk4fm7nowZa63SJcWq03o96QLZWbgPoZRiU+7EW6JXB
SGfgj8C4g4nJjaduNEwd
=KwPk
-----END PGP SIGNATURE-----

--+SfteS7bOf3dGlBC--
