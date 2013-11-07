Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754390Ab3KGPvi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 10:51:38 -0500
Received: from mail-ea0-f176.google.com ([209.85.215.176]:63874 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754030Ab3KGPvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 10:51:35 -0500
From: Roberto Sassu <roberto.sassu@polito.it>
To: linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-ima-devel@lists.sourceforge.net,
        zohar@us.ibm.com, d.kasatkin@samsung.com, james.l.morris@oracle.com,
        Roberto Sassu <roberto.sassu@polito.it>
Subject: [RFC][PATCH 2/6] ima: added new template helper lookup_template_desc_by_fmt()
Date: Thu,  7 Nov 2013 16:49:37 +0100
Message-Id: <1383839383-18152-3-git-send-email-roberto.sassu@polito.it>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1383839383-18152-1-git-send-email-roberto.sassu@polito.it>
References: <1383839383-18152-1-git-send-email-roberto.sassu@polito.it>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature"; micalg="sha1"; boundary="----4C9BDB069FE8AD78B524BF4F5F00A23F"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an S/MIME signed message

------4C9BDB069FE8AD78B524BF4F5F00A23F

This patch adds a new helper to search a template descriptor by its format.
Also, the old function lookup_template_desc(), which performs the search
by name, has been renamed to lookup_template_desc_by_name().

Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
---
 security/integrity/ima/ima_template.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/security/integrity/ima/ima_template.c b/security/integrity/ima/ima_template.c
index 33c911a..c849723 100644
--- a/security/integrity/ima/ima_template.c
+++ b/security/integrity/ima/ima_template.c
@@ -38,7 +38,7 @@ static struct ima_template_field supported_fields[] = {
 };
 
 static struct ima_template_desc *ima_template;
-static struct ima_template_desc *lookup_template_desc(const char *name);
+static struct ima_template_desc *lookup_template_desc_by_name(const char *name);
 static struct ima_template_field *lookup_template_field(const char *field_id);
 
 static int __init ima_template_setup(char *str)
@@ -53,7 +53,7 @@ static int __init ima_template_setup(char *str)
 	 * Verify that a template with the supplied name exists.
 	 * If not, use CONFIG_IMA_DEFAULT_TEMPLATE.
 	 */
-	template_desc = lookup_template_desc(str);
+	template_desc = lookup_template_desc_by_name(str);
 	if (!template_desc) {
 		pr_err("IMA: template %s not found, using %s\n",
 		       str, CONFIG_IMA_DEFAULT_TEMPLATE);
@@ -117,7 +117,7 @@ static int __init ima_template_fmt_setup(char *str)
 }
 __setup("ima_template_fmt=", ima_template_fmt_setup);
 
-static struct ima_template_desc *lookup_template_desc(const char *name)
+static struct ima_template_desc *lookup_template_desc_by_name(const char *name)
 {
 	int i;
 
@@ -129,6 +129,18 @@ static struct ima_template_desc *lookup_template_desc(const char *name)
 	return NULL;
 }
 
+static struct ima_template_desc *lookup_template_desc_by_fmt(const char *fmt)
+{
+	struct ima_template_desc *desc;
+
+	list_for_each_entry(desc, &defined_templates[0].list, list) {
+		if (strcmp(desc->fmt, fmt) == 0)
+			return desc;
+	}
+
+	return NULL;
+}
+
 static struct ima_template_field *lookup_template_field(const char *field_id)
 {
 	int i;
@@ -232,7 +244,7 @@ struct ima_template_desc *ima_template_desc_current(void)
 {
 	if (!ima_template)
 		ima_template =
-		    lookup_template_desc(CONFIG_IMA_DEFAULT_TEMPLATE);
+		    lookup_template_desc_by_name(CONFIG_IMA_DEFAULT_TEMPLATE);
 	return ima_template;
 }
 
-- 
1.8.1.4


------4C9BDB069FE8AD78B524BF4F5F00A23F
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
CwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0xMzExMDcxNTUwMDlaMCMGCSqG
SIb3DQEJBDEWBBSvVwfOkaRwqX+IfaUogZn2BY1U6TB5BgkqhkiG9w0BCQ8xbDBq
MAsGCWCGSAFlAwQBKjALBglghkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3
DQMHMA4GCCqGSIb3DQMCAgIAgDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggq
hkiG9w0DAgIBKDANBgkqhkiG9w0BAQEFAASCAQAL2O6wJuZ0grPVxTXB3WQWT9QO
jdO73Pqa3C7Nev3Hzq27Iw6Jl8H3vi3zf5VlBTfs1Lwwsy3P7wnLZjpJ5ZL+/3V8
t3PSwOHhe6llA+dPe0GqQ2D1y1jUEq4+MMCOuTRCOHPe67Hs7HNEpIX6TQA6lGnS
y5AfjC0XJNkfWfYJsSXHT/pd70WQkNk4L4AAy0NmVrADABtEhH2n3gDGPtJxb2jC
frjFGv5NVWJDuFyIIt5xNToMhT0NhyHPoiXLb+IaNVPV4tJJj+oCT2x3kyz2Gyrf
k7+NNVZf4o3TjOuyebu6aeLbP9G5DYmfOCodeyBj/J1vT4ph6Wne/6pjaBjA

------4C9BDB069FE8AD78B524BF4F5F00A23F--


