Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752358AbaGDEvj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 00:51:39 -0400
Received: from ozlabs.org ([103.22.144.67]:35410 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750976AbaGDEvh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 00:51:37 -0400
Date: Fri, 4 Jul 2014 14:51:27 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Felipe Balbi <balbi@ti.com>, Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Daniel Mack <zonque@gmail.com>
Subject: linux-next: manual merge of the usb-gadget tree with the
 usb.current tree
Message-ID: <20140704145127.30008370@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/5w9Um9aForBeZoI_HhigBRi"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/5w9Um9aForBeZoI_HhigBRi
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Felipe,

Today's linux-next merge of the usb-gadget tree got a conflict in
drivers/usb/musb/musb_cppi41.c between commit c58d80f523ff ("usb: musb:
Ensure that cppi41 timer gets armed on premature DMA TX irq") from the
usb.current tree and commit 50aea6fca771 ("usb: musb: cppi41: fire
hrtimer according to programmed channel length") from the usb-gadget
tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/usb/musb/musb_cppi41.c
index 5341bb223b7c,adfffe884891..000000000000
--- a/drivers/usb/musb/musb_cppi41.c
+++ b/drivers/usb/musb/musb_cppi41.c
@@@ -312,15 -271,13 +271,13 @@@ static void cppi41_dma_callback(void *p
  				goto out;
  			}
  		}
- 		if (is_isoc(hw_ep, 0)) {
- 			schedule_work(&cppi41_channel->dma_completion);
- 			goto out;
- 		}
  		list_add_tail(&cppi41_channel->tx_check,
  				&controller->early_tx_list);
 -		if (!hrtimer_active(&controller->early_tx)) {
 +		if (!hrtimer_is_queued(&controller->early_tx)) {
+ 			unsigned long usecs =3D cppi41_channel->total_len / 10;
+=20
  			hrtimer_start_range_ns(&controller->early_tx,
- 				ktime_set(0, 140 * NSEC_PER_USEC),
+ 				ktime_set(0, usecs * NSEC_PER_USEC),
  				40 * NSEC_PER_USEC,
  				HRTIMER_MODE_REL);
  		}

--Sig_/5w9Um9aForBeZoI_HhigBRi
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJTtjLWAAoJEMDTa8Ir7ZwVQ2QP/jLvDZwzP+rsIuDjHaqgiKSB
xTn9+G0cdmaUf78/PFDVmZ+U9rgaxTUfQhBkxRlcMG3bgSkMShfK5EG7BgFYFzYA
9ixHIW8WGLMJZPu+j3mPFmGTSRNK4ITn5yny3MJRa9bqAJMCv+gXqeaf3uYZpYY7
IXI2sXchYy4actuJO49aStNq8K+D31DdbTwsxaKn7BRlwfoZi7calw1FMknSLnhF
L2YyhlJTW4iKwAdBPut6iWyoGA7Ny9fx6DYodjdDpRrqPjJTEHWkF3GI+OZn3bBp
CwqX+EXtfRiTh8lN+sAlMyRna71/pTAaSLuOJHD2XHoaLHTlX8lWRprVXkC0w2Ey
vg5PC5peyGHFdBP2vFyKz+YB628ffL8DP9xjWt6YOALDZWqy29e05cgRRJBONkQt
EiSjKXyAsgvyd2MpQpH9UEyKf98F55huNZTHfJPkaLNtmyfDdrp1gBlelNl39UOh
cApGgnBZM0ovkGA6thI5vIKj59mOD4JKn+gXvYFQN55XM3U3DVN1pLkG2ynOQzJt
jJmqkVQdc+G/LT6YWt9QzbDKVfh1vlurye/+JTIxJIANbCp74fC1UE7ZBRqilLG+
G/1FUh075fIRxQWPb5mL4FKC35CCxL+4DwFlghk+zQ5Xkw+X+gLLH1dho/ngQmtV
ZjV689iqheMr1sDYxhhC
=ENee
-----END PGP SIGNATURE-----

--Sig_/5w9Um9aForBeZoI_HhigBRi--
