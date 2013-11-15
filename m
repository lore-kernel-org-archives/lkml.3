Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752746Ab3KONrd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 08:47:33 -0500
Received: from mail-ee0-f53.google.com ([74.125.83.53]:57594 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046Ab3KONrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 08:47:24 -0500
From: Roberto Sassu <roberto.sassu@polito.it>
To: linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-ima-devel@lists.sourceforge.net,
        zohar@us.ibm.com, d.kasatkin@samsung.com, james.l.morris@oracle.com,
        Roberto Sassu <roberto.sassu@polito.it>
Subject: [PATCH 0/6] ima: fixes for the new template management mechanism
Date: Fri, 15 Nov 2013 14:45:38 +0100
Message-Id: <1384523146-9290-1-git-send-email-roberto.sassu@polito.it>
X-Mailer: git-send-email 1.8.1.4
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature"; micalg="sha1"; boundary="----14E65DC0B285C3136B1790BB0674AC1D"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an S/MIME signed message

------14E65DC0B285C3136B1790BB0674AC1D

Hi everyone

this patch set fixes some issues in the new template management mechanism.
In particular, first four patches are simple bug fixes, explained in the patch
description, while last two restore the original IMA behavior when producing
a measurement entry with the old 'ima' template'. In respect to the behavior
adopted for newly introduced templates ('ima-ng' and 'ima-sig'), where
the total template length and the field length are sent through the
'binary_runtime_measurements' interface and the latter information is included
in the calculation of the template digest, for the old 'ima' template it is
necessary to handle the following exceptions:

 - the event digest field length is NOT sent through the userspace interface
   and is NOT included in the template digest calculation;
 - the event name field length is sent through the userspace interface
   but is NOT included in the template digest calculation.


Regards

Roberto Sassu


Roberto Sassu (6):
  ima: change the default hash algorithm to SHA1 in
    ima_eventdigest_ng_init()
  ima: pass HASH_ALGO__LAST as hash algo in ima_eventdigest_init()
  ima: remove unneeded size_limit argument from
    ima_eventdigest_init_common()
  ima: check result of crypto_shash_update() in
    ima_calc_field_array_hash_tfm
  ima: do not include field length in template digest calc for ima
    template
  ima: do not send field length to userspace for digest of ima template

 security/integrity/ima/ima.h              |  6 ++++--
 security/integrity/ima/ima_api.c          |  1 +
 security/integrity/ima/ima_crypto.c       | 17 ++++++++++++-----
 security/integrity/ima/ima_fs.c           | 14 +++++++++++---
 security/integrity/ima/ima_template_lib.c | 24 +++++++++++++-----------
 5 files changed, 41 insertions(+), 21 deletions(-)

-- 
1.8.1.4


------14E65DC0B285C3136B1790BB0674AC1D
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
CwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0xMzExMTUxMzQ1NDZaMCMGCSqG
SIb3DQEJBDEWBBROddF/9oiDX2MKFGFPvVpXltZv3DB5BgkqhkiG9w0BCQ8xbDBq
MAsGCWCGSAFlAwQBKjALBglghkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3
DQMHMA4GCCqGSIb3DQMCAgIAgDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggq
hkiG9w0DAgIBKDANBgkqhkiG9w0BAQEFAASCAQCTdlzFENSZvCeTcH0XhcUhQCMV
Re2Oyx24uAacLmoijf+P8czsjJlweAZ5egjZ3L3FyoZv1ugSoi+Zpkm1vgadfDHs
lrJb97HYkG5wlGUrVGGfuqT+2NLSxPOIJe4lPYhao1bcHCEs0a2goSS7fOTHQqaO
4ZBKQCkHrDrDudZUboglFOahxj5oV1jqD/dBv7IKtd6nkOLwtjxiQisx2Q8iGvDY
cSGC0s46ff27QVWK+VzL+OeVWXAnFmu9GJ4yBDstvPsF8Whe32xJkOxAhavDC7FM
qbKb/jCBoHlR3d5Z+gpCU1rmDNRLMq9iveBgVtfA/4NBGckD50mgxzJj/YTV

------14E65DC0B285C3136B1790BB0674AC1D--


