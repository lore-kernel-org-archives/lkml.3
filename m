Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161014Ab3LFM7Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 07:59:25 -0500
Received: from mail-ea0-f179.google.com ([209.85.215.179]:41260 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754386Ab3LFM7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 07:59:22 -0500
From: Roberto Sassu <roberto.sassu@polito.it>
To: jmorris@namei.org, zohar@linux.vnet.ibm.com
Cc: d.kasatkin@samsung.com, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-ima-devel@lists.sourceforge.net,
        Roberto Sassu <roberto.sassu@polito.it>
Subject: [PATCH-v2 1/3] ima: added error messages to template-related functions
Date: Fri,  6 Dec 2013 13:57:15 +0100
Message-Id: <1386334640-31393-2-git-send-email-roberto.sassu@polito.it>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1386334640-31393-1-git-send-email-roberto.sassu@polito.it>
References: <1386334640-31393-1-git-send-email-roberto.sassu@polito.it>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature"; micalg="sha1"; boundary="----7A2575D75F2079048772886EAC5C6FDD"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an S/MIME signed message

------7A2575D75F2079048772886EAC5C6FDD

This patch adds some error messages to inform users about the following
events: template descriptor not found, template field not found, and
template initialization failed.

Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
---
 security/integrity/ima/ima_template.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/security/integrity/ima/ima_template.c b/security/integrity/ima/ima_template.c
index 635695f..a001477 100644
--- a/security/integrity/ima/ima_template.c
+++ b/security/integrity/ima/ima_template.c
@@ -49,8 +49,11 @@ static int __init ima_template_setup(char *str)
 	 * If not, use CONFIG_IMA_DEFAULT_TEMPLATE.
 	 */
 	template_desc = lookup_template_desc(str);
-	if (!template_desc)
+	if (!template_desc) {
+		pr_err("IMA: template %s not found, using %s\n",
+		       str, CONFIG_IMA_DEFAULT_TEMPLATE);
 		return 1;
+	}
 
 	/*
 	 * Verify whether the current hash algorithm is supported
@@ -134,6 +137,7 @@ static int template_desc_init_fields(const char *template_fmt,
 		struct ima_template_field *f = lookup_template_field(c);
 
 		if (!f) {
+			pr_err("IMA: field '%s' not found\n", c);
 			result = -ENOENT;
 			goto out;
 		}
@@ -161,8 +165,12 @@ static int init_defined_templates(void)
 		result = template_desc_init_fields(template->fmt,
 						   &(template->fields),
 						   &(template->num_fields));
-		if (result < 0)
+		if (result < 0) {
+			pr_err("IMA: template %s init failed, result: %d\n",
+			       (strlen(template->name) ?
+			       template->name : template->fmt), result);
 			return result;
+		}
 	}
 	return result;
 }
-- 
1.8.1.4


------7A2575D75F2079048772886EAC5C6FDD
Content-Type: application/x-pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"

MIIICQYJKoZIhvcNAQcCoIIH+jCCB/YCAQExCzAJBgUrDgMCGgUAMAsGCSqGSIb3
DQEHAaCCBWQwggVgMIIESKADAgECAgICuzANBgkqhkiG9w0BAQUFADBlMQswCQYD
VQQGEwJJVDEeMBwGA1UEChMVUG9saXRlY25pY28gZGkgVG9yaW5vMTYwNAYDVQQD
Ey1Qb2xpdGVjbmljbyBkaSBUb3Jpbm8gQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkw
HhcNMTAxMjIwMTExOTU0WhcNMTUxMjMxMjM1OTU5WjBfMQswCQYDVQQGEwJJVDEe
MBwGA1UEChMVUG9saXRlY25pY28gZGkgVG9yaW5vMRcwFQYDVQQDEw5Sb2JlcnRv
ICBTYXNzdTEXMBUGCgmSJomT8ixkAQETB2QwMjEzMDUwggEiMA0GCSqGSIb3DQEB
AQUAA4IBDwAwggEKAoIBAQDS6p4SaJdmmJHJu9On9ZohhBFE2GgYiY7YtRnhhQJA
NfOtHEhSbpUMaSOfq/Pna6ipR5nAFrlM8cOGcSHZdxrPcgzeJU7F2v1fl2ThvFOc
TIkcC1aAJGQUuCaCXDlQt+KFecJWTrRZnalMHZueO+J6cgHcvR1CQz5e88dSzo3Q
XZy0w/hxGL9Ht9velqsl48ohBk2rs/svAOCp6GfqT1Yxwx1p87d3ViTrmuZB4/X+
da39nJqmo6AZ/y3Zg+r91BgNcfsHVqFT0JTcG6qRIaeqTtqVYpYl+rH1rZzYCakD
yQyys66sBvaXyaiMr0M+SpyH+LaGz5bDn5Odq16FYEq7AgMBAAGjggIeMIICGjAO
BgNVHQ8BAf8EBAMCA/gwJwYDVR0lBCAwHgYIKwYBBQUHAwIGCCsGAQUFBwMDBggr
BgEFBQcDBDAiBgNVHREEGzAZgRdyb2JlcnRvLnNhc3N1QHBvbGl0by5pdDAMBgNV
HRMBAf8EAjAAMB0GA1UdDgQWBBQgKbXSXn+j769x0tsZQ9pSOzIIdDAfBgNVHSME
GDAWgBTNm1tbnup2IcQQaOjSLTfbHy/I5DCBywYDVR0gBIHDMIHAMD4GCisGAQQB
qQcBAQIwMDAuBggrBgEFBQcCARYiaHR0cDovL3d3dy5ldXJvcGtpLm9yZy9jYS9j
cHMvMS4yLzBEBgorBgEEAakHAgECMDYwNAYIKwYBBQUHAgEWKGh0dHA6Ly93d3cu
aXRhbHkuZXVyb3BraS5vcmcvY2EvY3BzLzEuMi8wOAYKKwYBBAGVYgECAjAqMCgG
CCsGAQUFBwIBFhxodHRwOi8vY2EucG9saXRvLml0L2Nwcy8yLjIvMGYGCCsGAQUF
BwEBBFowWDAhBggrBgEFBQcwAYYVaHR0cDovL29jc3AucG9saXRvLml0MDMGCCsG
AQUFBzAChidodHRwOi8vY2EucG9saXRvLml0L2NlcnRzL3BvbGl0b19jYS5jZXIw
NwYDVR0fBDAwLjAsoCqgKIYmaHR0cDovL2NhLnBvbGl0by5pdC9jcmwvcG9saXRv
X2NybC5jcmwwDQYJKoZIhvcNAQEFBQADggEBADMe0aHcBJXV6pMJPVVSt1Vazd8Y
LuTLO45Igs9Sb2LuaO6pvcDGvq9dEJnBhP1B+zBAK6WEA1PWb66xC4QXaJnlGZTX
S3XeBivHWm6BNOH2kNeU0HBeGZCV/n5r70TPxkEAcc7u8YY2i6CiMM428YhZK8Zj
oN9D3QNIRf4HZgh0FTbf8eL/XvBbK/oPC+Rew+Qql6M3DHnaS1q2SKUwwO/4VXA4
JsOdatFI68AMXH0Xx9UIcjRi+kvsyvwHlc0Z8AoAtfRMoIl4zFF4Qaowec2UunBK
YlqPpFTtU9czuoEP12A86nqSVsoNok2mZOeYa9IdIjeE2rfdKx6k3YNRg08xggJt
MIICaQIBATBrMGUxCzAJBgNVBAYTAklUMR4wHAYDVQQKExVQb2xpdGVjbmljbyBk
aSBUb3Jpbm8xNjA0BgNVBAMTLVBvbGl0ZWNuaWNvIGRpIFRvcmlubyBDZXJ0aWZp
Y2F0aW9uIEF1dGhvcml0eQICArswCQYFKw4DAhoFAKCB2DAYBgkqhkiG9w0BCQMx
CwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0xMzEyMDYxMjU3NDJaMCMGCSqG
SIb3DQEJBDEWBBTEnNJBSZ/tf5hPiKYSz+Pe0LqorDB5BgkqhkiG9w0BCQ8xbDBq
MAsGCWCGSAFlAwQBKjALBglghkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3
DQMHMA4GCCqGSIb3DQMCAgIAgDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggq
hkiG9w0DAgIBKDANBgkqhkiG9w0BAQEFAASCAQA6SJ+/ObLmTuIlmxoJ+4Udv6Ul
23wBirbOmkiN/vM8ymIQMk8JEd51senCNelzzuUvtu40Fn8eMEZW0MsXMrCDJDgQ
kC8BI993RcpVyGRiIhrcFtojGlTwNJB6oBVBQ6nCIjYDb2IaD89eg/MwmCLo/Phq
ZRagUadMeEfRuubstOawANrNrewIbPpPyRPkXh5AXDn1sb7tUb448bJ3z8dCLx9c
hXVv+pS2xRtlV7ZcTpEtpbfhAGMwHDrPDdjtRvAZ2G1Pgv4HCPx7MhHkxQWUh+uO
hFGEt1BgYmcurvA9+6vGDrk4HvLismbToekEYvcwa+DeDxK/2KnTpYd+xRx8

------7A2575D75F2079048772886EAC5C6FDD--


