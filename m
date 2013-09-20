Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072Ab3ITD1W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 23:27:22 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:48505 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132Ab3ITD1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 23:27:21 -0400
Date: Fri, 20 Sep 2013 13:27:09 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sonic Zhang <sonic.zhang@analog.com>
Subject: linux-next: build failure after merge of the pinctrl tree
Message-Id: <20130920132709.11fbc8443fc6385fd5c17830@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__20_Sep_2013_13_27_09_+1000_QnHHMG10wpvpauWN"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__20_Sep_2013_13_27_09_+1000_QnHHMG10wpvpauWN
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

After merging the pinctrl tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/pinctrl/pinctrl-adi2.c:25:25: fatal error: asm/portmux.h: No such f=
ile or directory
 #include <asm/portmux.h>
                         ^

Caused by commit e9a03add0c6e ("pinctrl: ADI PIN control driver for the
GPIO controller on bf54x and bf60x"). asm/portmux.h only exists on
blackfin ...

I have used the version of the pinctrl tree from next-20130919 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__20_Sep_2013_13_27_09_+1000_QnHHMG10wpvpauWN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBCAAGBQJSO8CSAAoJEECxmPOUX5FE3H0QAJaf1bDcPfzkXa7oaSL+rf0j
1cyprIAHjSiltHEFfI2Cw/lG2Da+nWrNNu4ljd4IsgEV7WUbF+Ny7B9XR0qgvaqG
n2Xol0Bc6nW6Ms3vUrzXdXwlOm1/yaVZoHUz7JMNV5aY565aEAZNJia67h0pDd2r
dHs2rmunrHVlxUoQWvYYEynrc8yUWJhGmINpaqCFhD9KvhxWRuXUuXqsUmW+nuRW
ltwsxqDtk/7Z+TVJK/g6MjoqswMzg4m2W/qbGZW4xLof0DBMmMmgko8F7X1qtsKy
E2ipkhyo6iNH6u8F+71zTeDMlg/6UaPKDDtp0CzOWL+m1AGSTTZC9afgEYHBHXK2
XJLmyT1AYZqKVcNporw+4f9sk4oEHa1xKnt0c+9YcEgs/Gu7a+oP3j+EERGQW+RY
017Z9qFfXrxl/Nk43GMx4GlfRR97wD5irPbRZ/mSThjcvOYUaY/E3E4xq55exf73
VTv38D/U4bKYDXYLF/GxNSgnVqDG0QQcTp8HtMYePZwm/T5ezehisnOVx01LTRml
wIlK1enc7528nP/zKn0UGlTw3WFSWcvUVqIkcGldvUl9cubfndIRxCVOunDmeGKq
iERA11U1VJWbbBTNahEBnN7x9o6jU40sIxCuk1yGGTXmiqu3eYeTt2jDOg54kVxB
aZlcbN1wRVLglSqSjaE2
=Ez+K
-----END PGP SIGNATURE-----

--Signature=_Fri__20_Sep_2013_13_27_09_+1000_QnHHMG10wpvpauWN--
