Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751405AbaJAGB4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 02:01:56 -0400
Received: from ozlabs.org ([103.22.144.67]:53707 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751053AbaJAGBz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 02:01:55 -0400
Date: Wed, 1 Oct 2014 16:01:46 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Josh Cartwright <joshc@codeaurora.org>
Subject: linux-next: manual merge of the gpio tree with the pinctrl tree
Message-ID: <20141001160146.3649b2f8@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/5k=dW4iNGSjWAF+5jx8weK."; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/5k=dW4iNGSjWAF+5jx8weK.
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Today's linux-next merge of the gpio tree got a conflict in
drivers/pinctrl/qcom/pinctrl-msm.c between commit cf1fc1876289
("pinctrl: qcom: use restart_notifier mechanism for ps_hold") from the
pinctrl tree and commit 2fcea6cecbc9 ("pinctrl: remove remaining users
of gpiochip_remove() retval") from the gpio tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/pinctrl/qcom/pinctrl-msm.c
index d30dddd21323,041677113a48..000000000000
--- a/drivers/pinctrl/qcom/pinctrl-msm.c
+++ b/drivers/pinctrl/qcom/pinctrl-msm.c
@@@ -936,18 -903,9 +936,10 @@@ EXPORT_SYMBOL(msm_pinctrl_probe)
  int msm_pinctrl_remove(struct platform_device *pdev)
  {
  	struct msm_pinctrl *pctrl =3D platform_get_drvdata(pdev);
- 	int ret;
-=20
- 	ret =3D gpiochip_remove(&pctrl->chip);
- 	if (ret) {
- 		dev_err(&pdev->dev, "Failed to remove gpiochip\n");
- 		return ret;
- 	}
 =20
+ 	gpiochip_remove(&pctrl->chip);
  	pinctrl_unregister(pctrl->pctrl);
-=20
 +	unregister_restart_handler(&pctrl->restart_nb);
-=20
  	return 0;
  }
  EXPORT_SYMBOL(msm_pinctrl_remove);

--Sig_/5k=dW4iNGSjWAF+5jx8weK.
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUK5jPAAoJEMDTa8Ir7ZwVq6wP/jP2EApPmQxvynBDvW/oEMsw
UpfOZDYpUytQME/NjmfEpM2JG861M0W+H8QgeMNQ4ySmu4Gn61EAf4v5co8XFrIY
Bomdr4fX0JuC2A7nCR9FK7RfPPnspAWUhqPi31E5A08W20h/Po0fOB3deN5MIx8q
QYkZ0OIhnNRnBtJj8jwMpq2gPps6hXoGOpuZNgCycgBtBUBGXL+GsCXlxfSQ7yA3
5lMVzd+eyhNgfp0KmTaSHZfsc8H3ZslpmliasaIUfHrsEO6tMMDTz73iVS8KMaEg
aUMhlJfoY+zKkGITJYn9uIAI273vprLBuWi/jOR0f7HUnxPykLm7YyAgmRiWQsGB
p1e117PDuEA74if7ftlYbuXkB6WV+bhjaKoKEir7QwCxH3NqVtfZOgOKgG9e7yDh
zDPSaGTviZwOyDiMjJCnH5iJqFbN2/FJvt72xBPFq9GqfIto/TxW/vgw+qou03BG
pLHVCSWk4fUv6JeSbOWM50S+zf/BbA/+PglWtcDTvrtiZ4OmJgPUvonslSgUbks3
wFHrU5r/mgUyJ2mfNalrncLsQOoqBmfFuQPCMrCovtoASZfoD5Yl6EQRufiGAF7B
CBsth2ZJPiFZvf1I4p5bjTyBIb/ju/0NADZi4S7aWdogYmVhboFseK8azCN5Q8sT
fZclS15jtTJHpCM4xFq+
=brnf
-----END PGP SIGNATURE-----

--Sig_/5k=dW4iNGSjWAF+5jx8weK.--
