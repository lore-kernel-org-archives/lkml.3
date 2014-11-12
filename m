Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215AbaKLPHo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 10:07:44 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:46378 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753020AbaKLPHn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 10:07:43 -0500
Date: Wed, 12 Nov 2014 09:08:09 -0600
From: Felipe Balbi <balbi@ti.com>
To: Roger Quadros <rogerq@ti.com>
CC: <balbi@ti.com>, <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: dwc3: gadget: Fix broken gadget on system
 suspend/resume
Message-ID: <20141112150809.GE641@saruman>
Reply-To: <balbi@ti.com>
References: <1415804296-28980-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9ADF8FXzFeE7X4jE"
Content-Disposition: inline
In-Reply-To: <1415804296-28980-1-git-send-email-rogerq@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--9ADF8FXzFeE7X4jE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 12, 2014 at 04:58:16PM +0200, Roger Quadros wrote:
> On TI SoCs (e.g. DRA7) we don't support the DWC3 hibernation feature.
> We need to stop the gadget controller while system suspend
> else it results in L3 Bus errors on resume with broken
> USB gadget on J6-evm.
>=20
> [   55.718226] WARNING: CPU: 0 PID: 0 at drivers/bus/omap_l3_noc.c:147 l3=
_interrupt_handler+0x224/0x31c()
> [   55.718232] 44000000.ocp:L3 Custom Error: MASTER USB3 TARGET GPMC (Idl=
e): Data Access in User mode during Functional access
> [   55.718263] Modules linked in: usb_f_ss_lb g_zero libcomposite configf=
s xhci_hcd btwilink bluetooth dwc3 6lowpan_iphc m25p80 dwc3_omap omap_remot=
eproc
> [   55.718271] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.14.19-02011-g3=
ece3ca-dirty #658
> [   55.718290] [<c0016090>] (unwind_backtrace) from [<c0012060>] (show_st=
ack+0x10/0x14)
> [   55.718302] [<c0012060>] (show_stack) from [<c062a2e4>] (dump_stack+0x=
78/0x94)
> [   55.718315] [<c062a2e4>] (dump_stack) from [<c0043bc4>] (warn_slowpath=
_common+0x6c/0x90)
> [   55.718325] [<c0043bc4>] (warn_slowpath_common) from [<c0043c7c>] (war=
n_slowpath_fmt+0x30/0x40)
> [   55.718336] [<c0043c7c>] (warn_slowpath_fmt) from [<c030fb24>] (l3_int=
errupt_handler+0x224/0x31c)
> [   55.718348] [<c030fb24>] (l3_interrupt_handler) from [<c0093010>] (han=
dle_irq_event_percpu+0x5c/0x23c)
> [   55.718358] [<c0093010>] (handle_irq_event_percpu) from [<c009322c>] (=
handle_irq_event+0x3c/0x5c)
> [   55.718367] [<c009322c>] (handle_irq_event) from [<c0096160>] (handle_=
fasteoi_irq+0x98/0x158)
> [   55.718377] [<c0096160>] (handle_fasteoi_irq) from [<c00929dc>] (gener=
ic_handle_irq+0x20/0x30)
> [   55.718385] [<c00929dc>] (generic_handle_irq) from [<c000eea8>] (handl=
e_IRQ+0x4c/0xb0)
> [   55.718393] [<c000eea8>] (handle_IRQ) from [<c0008638>] (gic_handle_ir=
q+0x28/0x5c)
> [   55.718402] [<c0008638>] (gic_handle_irq) from [<c0630964>] (__irq_svc=
+0x44/0x5c)
> [   55.718406] Exception stack(0xc09c1f68 to 0xc09c1fb0)
> [   55.718412] 1f60:                   00000001 00000001 00000000 0000000=
0 c09c0000 00000000
> [   55.718418] 1f80: c09c0000 c09c0000 c0a7a1e4 c09c8938 c09c89b4 0000000=
0 60000093 c09c1fb0
> [   55.718423] 1fa0: c008a2e4 c00926cc 60000013 ffffffff
> [   55.718433] [<c0630964>] (__irq_svc) from [<c00926cc>] (cpu_startup_en=
try+0x100/0x1f4)
> [   55.718444] [<c00926cc>] (cpu_startup_entry) from [<c0901ac4>] (start_=
kernel+0x324/0x388)
>=20
> Signed-off-by: Roger Quadros <rogerq@ti.com>
> ---
>  drivers/usb/dwc3/gadget.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
> index 3818b26..bc15b54 100644
> --- a/drivers/usb/dwc3/gadget.c
> +++ b/drivers/usb/dwc3/gadget.c
> @@ -2741,7 +2741,13 @@ int dwc3_gadget_prepare(struct dwc3 *dwc)

there is no more dwc3_gadget_prepare(), please rebase on 'next'.

>  {
>  	if (dwc->pullups_connected) {
>  		dwc3_gadget_disable_irq(dwc);
> -		dwc3_gadget_run_stop(dwc, true, true);
> +		if (dwc->has_hibernation) {
> +			dwc3_gadget_run_stop(dwc, true, true);
> +		} else {
> +			dwc3_gadget_run_stop(dwc, false, true);
> +			/* remember to connect back on resume */
> +			dwc->pullups_connected =3D true;
> +		}

Another thing you probably want to do is make sure there is nothing
pending on our request list because if there is, then we need to wait
for any in-flight transfers to complete before disconnecting.

I also wonder if current code isn't really fragile... I mean, when you
clear run_stop bit, you should notify the gadget by means of
->disconnect() and so on... But since we can't test this with mainline,
then it's difficult to tell.

--=20
balbi

--9ADF8FXzFeE7X4jE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUY3fZAAoJEIaOsuA1yqREjA0P/jd4NJG8DNkfhdytwecEtQQH
GZ6W1dJ2ZSSHhlBIiUBPXxTl5O53SwxWP2+fbP6Mkv9Jo2LojX+kFnq9VYoWsbF1
Eo0i1Sk6k51thb4jT9D1TGnyPyOE9fFgmTC5mwPlVicY/7oZY2Yu9Fey04WHUxyU
mSm+L3tTEgmJD3rQzfhbisfBBT9pNCjbxOua1Ajgj7LtN5RTD6J4wge56mA0ZAU8
72ERpyzJgIK4VqxY7jDGyHYx3dcd2kKd+Pj6ALlHyo4z7c3/ULwmSILRtwEK9J6E
Pql/lw+icKBqoBeRLAI4QQuV/GnC5apzbABjHoK93KSfw6kGu2NElc6d7TSqQOHf
BhZoHf0duTbvn9QCQRgeA6ZLTZRBr7j7/Ehdb9v1jN24g23h91uRFf0w5VgCpA2y
OJxDTCpJYPQKtROoJRpwGscHYMAg8t7zhmJxFqamMklI0G2Yr/C3GEAbKFZuqnF/
n1KmFzllBquH66RqdnFmZGtaqpiyBwJPfBP/aAMBU67aTSRalOGLVCZ6UVsTG0xW
vfdiRWnVW1xCUDRi+1YL1H4cZAGVvPxVq0ZJmmYbS2td4QQgfTKZbA5HLZ0gp9wF
NLiwsE0/bok+R0KC2Ox0X/SQDLOoeXKVxemkP08aTm1Qt+e2rWNr7l32ez8gOVpi
Zl2cUOr1/oWBCF0fVZMK
=/GEh
-----END PGP SIGNATURE-----

--9ADF8FXzFeE7X4jE--
