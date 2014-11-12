Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752944AbaKLPgQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 10:36:16 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:35670 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752620AbaKLPgO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 10:36:14 -0500
Date: Wed, 12 Nov 2014 09:36:40 -0600
From: Felipe Balbi <balbi@ti.com>
To: Roger Quadros <rogerq@ti.com>
CC: <balbi@ti.com>, <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: dwc3: gadget: Fix broken gadget on system
 suspend/resume
Message-ID: <20141112153640.GH641@saruman>
Reply-To: <balbi@ti.com>
References: <1415804296-28980-1-git-send-email-rogerq@ti.com>
 <20141112150809.GE641@saruman>
 <54637D70.7060208@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="J+eNKFoVC4T1DV3f"
Content-Disposition: inline
In-Reply-To: <54637D70.7060208@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--J+eNKFoVC4T1DV3f
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Nov 12, 2014 at 05:32:00PM +0200, Roger Quadros wrote:
> On 11/12/2014 05:08 PM, Felipe Balbi wrote:
> > On Wed, Nov 12, 2014 at 04:58:16PM +0200, Roger Quadros wrote:
> >> On TI SoCs (e.g. DRA7) we don't support the DWC3 hibernation feature.
> >> We need to stop the gadget controller while system suspend
> >> else it results in L3 Bus errors on resume with broken
> >> USB gadget on J6-evm.
> >>
> >> [   55.718226] WARNING: CPU: 0 PID: 0 at drivers/bus/omap_l3_noc.c:147=
 l3_interrupt_handler+0x224/0x31c()
> >> [   55.718232] 44000000.ocp:L3 Custom Error: MASTER USB3 TARGET GPMC (=
Idle): Data Access in User mode during Functional access
> >> [   55.718263] Modules linked in: usb_f_ss_lb g_zero libcomposite conf=
igfs xhci_hcd btwilink bluetooth dwc3 6lowpan_iphc m25p80 dwc3_omap omap_re=
moteproc
> >> [   55.718271] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.14.19-02011=
-g3ece3ca-dirty #658
> >> [   55.718290] [<c0016090>] (unwind_backtrace) from [<c0012060>] (show=
_stack+0x10/0x14)
> >> [   55.718302] [<c0012060>] (show_stack) from [<c062a2e4>] (dump_stack=
+0x78/0x94)
> >> [   55.718315] [<c062a2e4>] (dump_stack) from [<c0043bc4>] (warn_slowp=
ath_common+0x6c/0x90)
> >> [   55.718325] [<c0043bc4>] (warn_slowpath_common) from [<c0043c7c>] (=
warn_slowpath_fmt+0x30/0x40)
> >> [   55.718336] [<c0043c7c>] (warn_slowpath_fmt) from [<c030fb24>] (l3_=
interrupt_handler+0x224/0x31c)
> >> [   55.718348] [<c030fb24>] (l3_interrupt_handler) from [<c0093010>] (=
handle_irq_event_percpu+0x5c/0x23c)
> >> [   55.718358] [<c0093010>] (handle_irq_event_percpu) from [<c009322c>=
] (handle_irq_event+0x3c/0x5c)
> >> [   55.718367] [<c009322c>] (handle_irq_event) from [<c0096160>] (hand=
le_fasteoi_irq+0x98/0x158)
> >> [   55.718377] [<c0096160>] (handle_fasteoi_irq) from [<c00929dc>] (ge=
neric_handle_irq+0x20/0x30)
> >> [   55.718385] [<c00929dc>] (generic_handle_irq) from [<c000eea8>] (ha=
ndle_IRQ+0x4c/0xb0)
> >> [   55.718393] [<c000eea8>] (handle_IRQ) from [<c0008638>] (gic_handle=
_irq+0x28/0x5c)
> >> [   55.718402] [<c0008638>] (gic_handle_irq) from [<c0630964>] (__irq_=
svc+0x44/0x5c)
> >> [   55.718406] Exception stack(0xc09c1f68 to 0xc09c1fb0)
> >> [   55.718412] 1f60:                   00000001 00000001 00000000 0000=
0000 c09c0000 00000000
> >> [   55.718418] 1f80: c09c0000 c09c0000 c0a7a1e4 c09c8938 c09c89b4 0000=
0000 60000093 c09c1fb0
> >> [   55.718423] 1fa0: c008a2e4 c00926cc 60000013 ffffffff
> >> [   55.718433] [<c0630964>] (__irq_svc) from [<c00926cc>] (cpu_startup=
_entry+0x100/0x1f4)
> >> [   55.718444] [<c00926cc>] (cpu_startup_entry) from [<c0901ac4>] (sta=
rt_kernel+0x324/0x388)
> >>
> >> Signed-off-by: Roger Quadros <rogerq@ti.com>
> >> ---
> >>  drivers/usb/dwc3/gadget.c | 8 +++++++-
> >>  1 file changed, 7 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
> >> index 3818b26..bc15b54 100644
> >> --- a/drivers/usb/dwc3/gadget.c
> >> +++ b/drivers/usb/dwc3/gadget.c
> >> @@ -2741,7 +2741,13 @@ int dwc3_gadget_prepare(struct dwc3 *dwc)
> >=20
> > there is no more dwc3_gadget_prepare(), please rebase on 'next'.
>=20
> right.
>=20
> >=20
> >>  {
> >>  	if (dwc->pullups_connected) {
> >>  		dwc3_gadget_disable_irq(dwc);
> >> -		dwc3_gadget_run_stop(dwc, true, true);
> >> +		if (dwc->has_hibernation) {
> >> +			dwc3_gadget_run_stop(dwc, true, true);
> >> +		} else {
> >> +			dwc3_gadget_run_stop(dwc, false, true);
> >> +			/* remember to connect back on resume */
> >> +			dwc->pullups_connected =3D true;
> >> +		}
> >=20
> > Another thing you probably want to do is make sure there is nothing
> > pending on our request list because if there is, then we need to wait
> > for any in-flight transfers to complete before disconnecting.
>=20
> shouldn't that check be done in dwc3_gadget_run_stop()?

no, gadget drivers only disconnect pullups when they know there's
nothing pending. And sometimes, we actually want to break such transfers
to see how the thing would behave. Only suspend/resume needs to make
transfers complete before hand.

> > I also wonder if current code isn't really fragile... I mean, when you
> > clear run_stop bit, you should notify the gadget by means of
> > ->disconnect() and so on... But since we can't test this with mainline,
> > then it's difficult to tell.
> >=20
> that is true.

Not sure what to do with this patch :-p

--=20
balbi

--J+eNKFoVC4T1DV3f
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUY36IAAoJEIaOsuA1yqRE9owP/11VBy5jLHzwj6hGI41StPTK
BTBEFqVRMmMjAprOqiS+zSRw+A9LUjdoL9Gzo6Cyf5wfTpYsQNyWCgPqNFXpd2nd
l8FRPGxAOs4qlLWn10sii70bNZ53It+GIxAOhhjR5LpEcB8piOi4AUP2n0gwqJrA
XQEG3v2y7oWwRt8wr3AJTBNLFds1SUUvVcfTy6obamEg9LPSdXm4jbD0bThHjOw+
jZAriGg0k6Faq52bTKcTE8vqz4oSmQL2PgW6uL0gkr5unsUgOMMFvy8tZHm/VJQk
dUnGzA6JmJkPtaKINl/vYXhJ0a20HqLTdRILmDpcZB06PYtonEeCISNOC//jzQ8w
Y4m7JAmAikVPJC87MeoobJU6OYZrnXXq1dPMEkrvLWS4hGC34jop1knVlU+g9lqp
957S6kROvVyWrCCTogbitJirp30wgjJbypYWXycMHGBQzk2TlVpBy3R2i+M9Ye5r
sDRx5WajliBXf8SzPiCdAwT//aphrz2+2frRq5vzwfdTgMBxzGTLPh6Ai9KSaarG
ITe22BGzhJ02st2szCN1jtYiuNApv8ZG1NIWDiNUf7pYFU+JWeF6mTcE3hR1eyLG
NUMCEkdu/RoRZODViMZuKYxXsKyHsFSb9cexChhAINjNiFFV5kBK9AD8mcqs4nsR
WVJgO1JhBKi2TsHkYI4J
=WDb4
-----END PGP SIGNATURE-----

--J+eNKFoVC4T1DV3f--
