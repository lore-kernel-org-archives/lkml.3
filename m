Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756716AbbAZSrQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 13:47:16 -0500
Received: from utopia.booyaka.com ([74.50.51.50]:58622 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753521AbbAZSrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 13:47:12 -0500
Date: Mon, 26 Jan 2015 18:47:11 +0000 (UTC)
From: Paul Walmsley <paul@pwsan.com>
To: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
cc: Benoit Parrot <bparrot@ti.com>, Tony Lindgren <tony@atomide.com>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Darren Etheridge <detheridge@ti.com>, Felipe Balbi <balbi@ti.com>
Subject: Re: [PATCH v2] ARM: AM43xx: hwmod: add VPFE hwmod entries
In-Reply-To: <CA+V-a8vuD-+cwaP_bKpB8GweT-xX4E3PHrbB+uefCW+Xre7cog@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1501261846460.5450@utopia.booyaka.com>
References: <1422217915-24231-1-git-send-email-prabhakar.csengg@gmail.com> <alpine.DEB.2.02.1501260205090.5450@utopia.booyaka.com> <CA+V-a8urS2C20FDcfsGa+Gg+7wmbbQQw3U7BfXf6GBKoBGMc9w@mail.gmail.com> <20150126155032.GD2570@ti.com>
 <CA+V-a8vuD-+cwaP_bKpB8GweT-xX4E3PHrbB+uefCW+Xre7cog@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="843723315-1095457462-1422298031=:5450"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--843723315-1095457462-1422298031=:5450
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

Hi Prabhakar,

On Mon, 26 Jan 2015, Lad, Prabhakar wrote:

> Hi Benoit,
>=20
> On Mon, Jan 26, 2015 at 3:50 PM, Benoit Parrot <bparrot@ti.com> wrote:
> > Lad, Prabhakar <prabhakar.csengg@gmail.com> wrote on Mon [2015-Jan-26 0=
8:13:01 +0000]:
> >> Hi Paul,
> >>
> >> Thanks for the review.
> >>
> >> On Mon, Jan 26, 2015 at 2:15 AM, Paul Walmsley <paul@pwsan.com> wrote:
> >> > Hi
> >> >
> >> > On Sun, 25 Jan 2015, Lad, Prabhakar wrote:
> >> >
> >> >> From: Benoit Parrot <bparrot@ti.com>
> >> >>
> >> >> this patch adds VPFE HWMOD data for AM43xx.
> >> >>
> >> >> Signed-off-by: Benoit Parrot <bparrot@ti.com>
> >> >> Signed-off-by: Darren Etheridge <detheridge@ti.com>
> >> >> Signed-off-by: Felipe Balbi <balbi@ti.com>
> >> >> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> >> >> ---
> >> >>  Hi Paul,
> >> >>
> >> >>  You were right, the hardware team has confirmed that, the VPFE mas=
ter port is
> >> >>  connected to L3 and the VPFE slave port is connected to L4. The L3=
 port cannot
> >> >>  serve as a register target because it is initiator only.
> >> >
> >> > OK makes sense to me.,
> >> >
> >> >>
> >> >>  I have created links referring to dss l3/l4 hwmod and tested it, l=
emme know
> >> >>  if I have missed something.
> >> >
> >> > A few minor comments below
> >> >
> >> >>
> >> [Snip]
> >> >>  /* Interfaces */
> >> >>  static struct omap_hwmod_ocp_if am43xx_l3_main__l4_hs =3D {
> >> >>       .master         =3D &am33xx_l3_main_hwmod,
> >> >> @@ -788,6 +826,36 @@ static struct omap_hwmod_ocp_if am43xx_l4_ls__=
dss_rfbi =3D {
> >> >>       .user           =3D OCP_USER_MPU | OCP_USER_SDMA,
> >> >>  };
> >> >>
> >> >> +static struct omap_hwmod_ocp_if am43xx_l3__vpfe0 =3D {
> >> >> +     .master         =3D &am43xx_vpfe0_hwmod,
> >> >> +     .slave          =3D &am33xx_l3_main_hwmod,
> >> >> +     .clk            =3D "l3_gclk",
> >> >> +     .flags          =3D OCPIF_SWSUP_IDLE,
> >> >
> >> > OCPIF_SWSUP_IDLE probably isn't needed here.  Could you please try w=
ithout
> >> > it?
> >> >
> >> >> +     .user           =3D OCP_USER_MPU | OCP_USER_SDMA,
> >> >> +};
> >> >> +
> >> >> +static struct omap_hwmod_ocp_if am43xx_l3__vpfe1 =3D {
> >> >> +     .master         =3D &am43xx_vpfe1_hwmod,
> >> >> +     .slave          =3D &am33xx_l3_main_hwmod,
> >> >> +     .clk            =3D "l3_gclk",
> >> >> +     .flags          =3D OCPIF_SWSUP_IDLE,
> >> >
> >> > Same point as the above.
> >> >
> >> Dropped and tested works! posting a v3.
> >
> > When you tested it without the OCPIF_SWSUP_IDLE, did you go trhough a c=
omplete suspend/resume cycle?
> > This flag was added early on because otherwise the susbsytem would not =
go idle without it...
> >
> > Can you post the console output during a suspend/resume cycle?
> >
> Ah I didn=E2=80=99t test the suspend/resume will do and post the console =
log.

Could you also do a suspend/resume test on v2?
=20
thanks

- Paul
--843723315-1095457462-1422298031=:5450--
