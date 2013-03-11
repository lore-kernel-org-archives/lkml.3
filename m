Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756Ab3CKXa3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 19:30:29 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:57974 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754571Ab3CKXa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 19:30:27 -0400
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.5+dev
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: [PATCH -mmotm] scsi: fix the wrong position of the comment
In-Reply-To: Your message of "Sun, 10 Mar 2013 17:09:50 +0900."
             <1362902990-25137-1-git-send-email-akinobu.mita@gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <1362902990-25137-1-git-send-email-akinobu.mita@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1363044514_1909P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 11 Mar 2013 19:28:35 -0400
Message-ID: <36693.1363044515@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=steiner.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020204.513E68A4.004D,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2011-07-25 19:15:43,
	dmn=2011-05-27 18:58:46,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1363044514_1909P
Content-Type: text/plain; charset=us-ascii

On Sun, 10 Mar 2013 17:09:50 +0900, Akinobu Mita said:
> This fixes the wrong position of the comment introduced by
> scsi-rename-random32-to-prandom_u32.patch in the -mm tree.
>
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
> Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>
> ---
>  drivers/scsi/qla2xxx/qla_attr.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
> index 04bf7b8..e44d47e 100644
> --- a/drivers/scsi/qla2xxx/qla_attr.c
> +++ b/drivers/scsi/qla2xxx/qla_attr.c
> @@ -1939,13 +1939,13 @@ qla24xx_vport_delete(struct fc_vport *fc_vport)
>  	}
>
>  	/* No pending activities shall be there on the vha now */
> -	if (ql2xextended_error_logging & ql_dbg_user)
> -		msleep(prandom_u32() % 10);
> +	if (ql2xextended_error_logging & ql_dbg_user) {
>  		/*
>  		 * Just to see if something falls on the net we have placed
>  		 * below
>  		 */
> -
> +		msleep(prandom_u32() % 10);
> +	}
>  	BUG_ON(atomic_read(&vha->vref_count));

As others have noted, the msleep is potentially a crock.  However,
this particular patch is also incorrect - the *real* problem is
that the 4 line comment connected to the BUG_ON is mis-indented.

The patch *should* make it look like this:

	/* No pending activities shall be there on the vha now */
	if (ql2xextended_error_logging & ql_dbg_user)
		msleep(prandom_u32() % 10);
	/*
	 * Just to see if something falls on the net we have placed
	 * below
	 */
	BUG_ON(atomic_read(&vha->vref_count));

And a different patch should fix the msleep issue.


--==_Exmh_1363044514_1909P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBUT5oogdmEQWDXROgAQI0txAAgzDU5MVPH6fu4QFf5EA2P92t2MsuPqmU
Rl0StIcSTFXCeBC3934rOrs/rwb4l0VpfrD5wziSDLlrDOySODAnGGzFmrVAP8pt
t9plSg5LP+gBZcrL1z+cuPbXzOPTei16nFFLXYi+pOKxwrO1AIxj9fUGl57VopTn
d4WpfCPOP1+gYBfsZOEoYiPCnLiqCRUrGFMkm24wUtn6ITvBtvXzt3O618Pfh7OR
Cx8R5KuISzYoSbfzQD791wzY0Wo7xnw/0SiPmcoBSWAi0N8dP+jZnQY9x4l3x2FR
kElb4/Q3FQq2fumDW3n63X5QWjcr3Wjyk9O6hie26dN3ICBruYR8+JHxURKkUEq4
UUlBVDlvhjnGpyR558rFbuNRNgzOW2I3XClifgt4P4lmhWOxNo6QusOtg+nn2O8V
ErHoROlIQH93fG5e5R3fRVgFZyEfPo/l2TApPQ2E4o2BAnsfTkAllyyyuiPPuoLU
VYmHvfsifQ9/fxW6IalOWOy7LEUEMUy9KqmIxLrXAnzr1a6xhmUh5CsslMgicqXI
wdds+tfBjn25+diF0SvtjGTYfBcMBtSX0sCT+4uUqjZXo0YYAzknSL67F5ZljvVI
d0iz29uZWktq8vuG4NTS8UpnhHXwOwOvaBCA4SBaFRUxV8acYkGNxr8xz6uHH5qv
UTSIvGo+9DY=
=r2Nr
-----END PGP SIGNATURE-----

--==_Exmh_1363044514_1909P--

