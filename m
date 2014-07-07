Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752078AbaGGVn5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 17:43:57 -0400
Received: from p3plsmtpa06-10.prod.phx3.secureserver.net ([173.201.192.111]:48937
	"EHLO p3plsmtpa06-10.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751236AbaGGVn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 17:43:56 -0400
X-Greylist: delayed 471 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Jul 2014 17:43:56 EDT
Message-ID: <53BB12C4.5010709@componentsw.com>
Date: Mon, 07 Jul 2014 14:36:04 -0700
From: Walter Mack <wmack@componentsw.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Alexander Smirnov <alex.bluesman.smirnov@gmail.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
CC: linux-kernel@vger.kernel.org, Walter Mack <wmack@componentsw.com>
Subject: [net-next PATCH] mrf24j40: - enable use of external rx/tx components
 kernel
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms020207020603080600050104"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms020207020603080600050104
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

Description: Add boolean parameter ext_rx_tx to enable use of external tx=
/rx components.
kernel version: 3.16.0-rc4

Signed-off-by: Walter J Mack <wmack@componentsw.com>
---
diff --git a/drivers/net/ieee802154/mrf24j40.c b/drivers/net/ieee802154/m=
rf24j40.c
index 4048062..18cff47 100644
--- a/drivers/net/ieee802154/mrf24j40.c
+++ b/drivers/net/ieee802154/mrf24j40.c
@@ -26,6 +26,10 @@
  #include <net/mac802154.h>
  #include <net/ieee802154.h>
 =20
+static bool ext_rx_tx =3D false ;
+module_param(ext_rx_tx, bool, 0);
+MODULE_PARM_DESC(ext_rx_tx, " turn on statemachine to manage external tx=
/rx");
+
  /* MRF24J40 Short Address Registers */
  #define REG_RXMCR    0x00  /* Receive MAC control */
  #define REG_PANIDL   0x01  /* PAN ID (low) */
@@ -63,6 +67,8 @@
  #define REG_SLPCON1    0x220
  #define REG_WAKETIMEL  0x222  /* Wake-up Time Match Value Low */
  #define REG_WAKETIMEH  0x223  /* Wake-up Time Match Value High */
+#define REG_TESTMODE   0x22f  /* test mode and state machine control reg=
ister */
+
  #define REG_RX_FIFO    0x300  /* Receive FIFO */
 =20
  /* Device configuration: Only channels 11-26 on page 0 are supported. *=
/
@@ -669,6 +675,10 @@ static int mrf24j40_probe(struct spi_device *spi)
  	write_short_reg(devrec, REG_RFCTL, 0x0);
  	udelay(192);
 =20
+	if ( false !=3D ext_rx_tx ){
+	  write_long_reg(devrec, REG_TESTMODE, 0x0f);
+	}
+
  	/* Set RX Mode. RXMCR<1:0>: 0x0 normal, 0x1 promisc, 0x2 error */
  	ret =3D read_short_reg(devrec, REG_RXMCR, &val);
  	if (ret)
---



--------------ms020207020603080600050104
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIFcTCC
BW0wggNVoAMCAQICAw6PxjANBgkqhkiG9w0BAQ0FADB5MRAwDgYDVQQKEwdSb290IENBMR4w
HAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMTGUNBIENlcnQgU2lnbmlu
ZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2FjZXJ0Lm9yZzAeFw0xNDAy
MjMwNTU0NTZaFw0xNDA4MjIwNTU0NTZaMDgxGDAWBgNVBAMTD0NBY2VydCBXb1QgVXNlcjEc
MBoGCSqGSIb3DQEJARYNd21hY2tAY294Lm5ldDCCASIwDQYJKoZIhvcNAQEBBQADggEPADCC
AQoCggEBAKWa811nL+6We0iL+DUEX2pwWma6wJ9Ap7Mxq6jkTiFFW9QOLdzmIH9lT/HDYDlM
QlHesmQFOYPCxyCyZVlge8QlH2U11dbe7f7IG4CtTyEn3y6mPSrTOPAlcJtamw366BYcxB59
nP9eRNt/NvDFX0XYhGJHRi6kuwf5S69Up1jllCdlnaRz19DF23PK1s2D0t0HjIUpFUhI61RT
pwl/zMqLdZ0Acs4pHEWNXfSgb7kgpH2efEpNpZDG6itxbno0mheWZ4Hg7TdMDM/oJd6pg3iU
GrpQ+MF/2mcAYrIsIYUv6oEUsLleaQ81A8Xa3Gd4eBYs8xcnPXv5gPWs7Nyu9EcCAwEAAaOC
AT0wggE5MAwGA1UdEwEB/wQCMAAwVgYJYIZIAYb4QgENBEkWR1RvIGdldCB5b3VyIG93biBj
ZXJ0aWZpY2F0ZSBmb3IgRlJFRSBoZWFkIG92ZXIgdG8gaHR0cDovL3d3dy5DQWNlcnQub3Jn
MA4GA1UdDwEB/wQEAwIDqDBABgNVHSUEOTA3BggrBgEFBQcDBAYIKwYBBQUHAwIGCisGAQQB
gjcKAwQGCisGAQQBgjcKAwMGCWCGSAGG+EIEATAyBggrBgEFBQcBAQQmMCQwIgYIKwYBBQUH
MAGGFmh0dHA6Ly9vY3NwLmNhY2VydC5vcmcwMQYDVR0fBCowKDAmoCSgIoYgaHR0cDovL2Ny
bC5jYWNlcnQub3JnL3Jldm9rZS5jcmwwGAYDVR0RBBEwD4ENd21hY2tAY294Lm5ldDANBgkq
hkiG9w0BAQ0FAAOCAgEAG7GD3lEgX4iVtG66adT+n79fQaLwLfn/kdo4SH6/wUxsXT5etSSI
Q+Ja7Cd40vtFtfhumm1upL++peiFS5Q1uoGKwOm+mT8Jbr39yFmvtoLU4ohYKYI6FrUBX27A
Qwu5oxDskhC+bavpLd7I8Ci58JZlm8/qmIvBhMIZqWFWpFOlfO5S8YszYM6n3493zeMbe2Bf
uSyIfRcxaJMmDiqzpBxORNRlVUT/ghyg2tKR+jwh7k0sKQLaW7dngTl/JuiNpqzKOZYvMFNG
fLhAt7732UhcvE9v80XeP4HHElRdHPBU0pxmtVmakkQlJJd+HAWEVPaI+pdwVlDVOCGNb23j
XwbfnwOzo6Hdn6OKFdQfi1zZ95VBurTvFnzBf6/do5J8/olLhx7GfJeqIYjdM3ZxCOSV4Qrv
vhMUdZ+CLq5oulfIYx26Ua4uobk9eYUUNH99mSMueIfwPaQKUtXQWSttSPvp7fw4UICXz09U
MUBj6cwXD4WCN714moL6liN/A0UtDOv1jml8xbRWkzbJFT0DvVrJh55wXokYo2+vYHpVjef8
MmCKWxI7a/D6iHEZv/s6kItsUJJ5tNVUSeAH/0eql6MOaZXT3l21MxLHYekIEip93v8G7fLS
enJUo+IE4t+nKgLqsgIDcNz4EVFHdrrL98h8b1MmuMi0w36ENCWhQocxggOhMIIDnQIBATCB
gDB5MRAwDgYDVQQKEwdSb290IENBMR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcx
IjAgBgNVBAMTGUNBIENlcnQgU2lnbmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1
cHBvcnRAY2FjZXJ0Lm9yZwIDDo/GMAkGBSsOAwIaBQCgggH1MBgGCSqGSIb3DQEJAzELBgkq
hkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTE0MDcwNzIxMzYwNFowIwYJKoZIhvcNAQkEMRYE
FKzYeXK+fBtXrmWu/ALwwy0vgZLqMGwGCSqGSIb3DQEJDzFfMF0wCwYJYIZIAWUDBAEqMAsG
CWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcNAwICAUAw
BwYFKw4DAgcwDQYIKoZIhvcNAwICASgwgZEGCSsGAQQBgjcQBDGBgzCBgDB5MRAwDgYDVQQK
EwdSb290IENBMR4wHAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMTGUNB
IENlcnQgU2lnbmluZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2FjZXJ0
Lm9yZwIDDo/GMIGTBgsqhkiG9w0BCRACCzGBg6CBgDB5MRAwDgYDVQQKEwdSb290IENBMR4w
HAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMTGUNBIENlcnQgU2lnbmlu
ZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2FjZXJ0Lm9yZwIDDo/GMA0G
CSqGSIb3DQEBAQUABIIBACoMj+BINiVeEMbaSKI2zH6vk67t4UlGLIyrtWye1JqyuxTodVRM
SVO3iOmAk9bMqlqye/RIK9PpmbqAtZpGBbGeFkZ+HAWbSFge2q2Z23BolNsDH3TpA3CxrXQm
pZwjA9PqWbT0ul8zd3PNVM4x43Qn8pmeedG0dSCdjzjt5p5DYGAH/rZIwHFMao+RvNGVboMB
746gXoizOs6yKwkkYP5wgChi70xvYO4NeIay5/BAnFfvQe9hnxD3dYjENaFN6eFeAwBFt2bo
E4kZOgZJwwOjYbi0TeLdPJpgB0zDGwV3CzwTSAZDg8auxkN5YmmCRy77VZLxscVZ9H0UoZe4
PTQAAAAAAAA=
--------------ms020207020603080600050104--
