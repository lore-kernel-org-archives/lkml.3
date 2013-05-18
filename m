Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752529Ab3ERFkl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 May 2013 01:40:41 -0400
Received: from mga03.intel.com ([143.182.124.21]:52749 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750752Ab3ERFkj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 May 2013 01:40:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,696,1363158000"; 
   d="asc'?scan'208";a="243339358"
Message-ID: <1368855636.2235.136.camel@jtkirshe-mobl>
Subject: Re: [ 094/136 ] e1000e: fix runtime power management transitions
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Reply-To: jeffrey.t.kirsher@intel.com
To: Konstantin Khlebnikov <khlebnikov@openvz.org>,
        "Allan, Bruce W" <bruce.w.allan@intel.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Bruce Allan <bruce.w.allan@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Borislav Petkov <bp@suse.de>, Aaron Brown <aaron.f.brown@intel.com>
Date: Fri, 17 May 2013 22:40:36 -0700
In-Reply-To: <5197132A.5030308@openvz.org>
References: <20130518021557.139113314@goodmis.org>
	 <20130518021656.829696669@goodmis.org> <5197132A.5030308@openvz.org>
Organization: Intel Corporation
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-yQWPYFFiJHSIA/BLGYdC"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-yQWPYFFiJHSIA/BLGYdC
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2013-05-18 at 09:35 +0400, Konstantin Khlebnikov wrote:
> Steven Rostedt wrote:
> > 3.6.11.4 stable review patch.
> > If anyone has any objections, please let me know.
>=20
> I don't think that 3.6.y needs this. That was fix for problem which appea=
red
> in 3.8 after some changes in PCI power management code. Probably it depen=
ds
> on these changes. If no one complains about problems we should leave it a=
s is.

My thoughts are the same as Konstantin, but I would like Bruce Allan to
weigh in on this since he is the e1000e maintainer.  Since it is late
Friday night, Bruce probably won't see this until Monday to respond.

> >
> > ------------------
> >
> > From: Konstantin Khlebnikov<khlebnikov@openvz.org>
> >
> > [ Upstream commit 66148babe728f3e00e13c56f6b0ecf325abd80da ]
> >
> > This patch removes redundant actions from driver and fixes its interact=
ion
> > with actions in pci-bus runtime power management code.
> >
> > It removes pci_save_state() from __e1000_shutdown() for normal adapters=
,
> > PCI bus callbacks pci_pm_*() will do all this for us. Now __e1000_shutd=
own()
> > switches to D3-state only quad-port adapters, because they needs quirk =
for
> > clearing false-positive error from downsteam pci-e port.
> >
> > pci_save_state() now called after clearing bus-master bit, thus __e1000=
_resume()
> > and e1000_io_slot_reset() must set it back after restoring configuratio=
n space.
> >
> > This patch set get_link_status before calling pm_runtime_put() in e1000=
_open()
> > to allow e1000_idle() get real link status and schedule first runtime s=
uspend.
> >
> > This patch also enables wakeup for device if management mode is enabled
> > (like for WoL) as result pci_prepare_to_sleep() would setup wakeup with=
out
> > special actions like custom 'enable_wakeup' sign.
> >
> > Cc: Bruce Allan<bruce.w.allan@intel.com>
> > Signed-off-by: Konstantin Khlebnikov<khlebnikov@openvz.org>
> > Acked-by: Rafael J. Wysocki<rafael.j.wysocki@intel.com>
> > Tested-by: Borislav Petkov<bp@suse.de>
> > Tested-by: Aaron Brown<aaron.f.brown@intel.com>
> > Signed-off-by: Jeff Kirsher<jeffrey.t.kirsher@intel.com>
> > Signed-off-by: Steven Rostedt<rostedt@goodmis.org>
>=20



--=-yQWPYFFiJHSIA/BLGYdC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iQIcBAABCgAGBQJRlxRUAAoJEOVv75VaS+3OMCsP/2ttsaKvPTYI4lnWp49Nju0W
QJt7/b6LLU52CroLkglO96/3XZsA9C0BtK6u2T6vQBhtCoFkjrZI8aocBoBNWaOv
KGRAsyoCIN25MJ3wZzwB6cMvMtKyi9e8h3VfCA8xSsZNvKK5uKjSDBJzdkvnbucO
KWTLGx02qvWPYIwjcX2jq8N62Vo31y/YdkYLqp1V326ihCXwyV53bePGprL7bEtg
2XXMexgoISc4f9L1Am1qk+MC44zQCz1PF4h36M5aRWLXdUNhjZI7SNeJkSY7MRc2
0iGQTRc0dQPchv+95KMAKH4ryPyA1YXfF/FdFzTgcN2beejZFzMXLnedHHHYxpeO
CIBWuG/dfs14mhwFAhfflCjQaiyQazsoeRDbePJ39Ghqa1p2ndFPKygQo15h9DQL
G0w+YawldfvADyjqeKg6xAxx65QP/+e3v7I9g3e/dtvhtTCh0vqTdIEl/pafmzJ8
fIMn+r213iDU9Os3KQ9r/ExKmc9xdblrrRyUDY8riNLd2WWO+r9f58ePWhYPthph
pS21WiWbB43geFSCXpz65dy/HpFtsg6KTm7jOGjlkbN0ozDGnWpvujlu4lVCsl0X
3cTOy0TzemzqAizFCBru9oEqNg6E2X7ucb+QOnVUWM4kvIxpyMIFhz3SsEFQ+YFs
8sjMYqO4Xygs2imuGI/f
=46jN
-----END PGP SIGNATURE-----

--=-yQWPYFFiJHSIA/BLGYdC--

