Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752733Ab3KGOCo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 09:02:44 -0500
Received: from mail-ea0-f180.google.com ([209.85.215.180]:46157 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083Ab3KGOCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 09:02:42 -0500
From: Roberto Sassu <roberto.sassu@polito.it>
To: linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-ima-devel@lists.sourceforge.net,
        zohar@us.ibm.com, d.kasatkin@samsung.com, james.l.morris@oracle.com,
        Roberto Sassu <roberto.sassu@polito.it>
Subject: [RFC][PATCH 0/4] ima: add support for custom template formats
Date: Thu,  7 Nov 2013 15:00:41 +0100
Message-Id: <1383832849-17125-1-git-send-email-roberto.sassu@polito.it>
X-Mailer: git-send-email 1.8.1.4
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature"; micalg="sha1"; boundary="----6D302F5C2315391DBA7A43406747BDC0"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an S/MIME signed message

------6D302F5C2315391DBA7A43406747BDC0

Hi everyone

currently accepted patches for the new template management mechanism allow to
choose among a list of supported templates, statically defined in the code.
This functionality is not flexible enough as users may want to include
in their measurements list only information needed and not use predefined
combinations.

For this reason, this patch set introduce the new kernel command line parameter
'ima_template_fmt' to specify a custom template format at boot time,
i.e. a string of template fields identifiers concatenated with the '|'
separator character. The complete list of defined template fields can be
found in Documentation/security/IMA-templates.txt.

The format string is checked at the very beginning in the setup function
ima_template_fmt_setup() so that, if it is wrong, IMA can go back to the
default template, selected through a kernel configuration option.

To allow userspace tools parse a measurements list with a custom format, IMA
provides as template name the same format string provided by users at boot
time, so that tools know which information are included in a entry and extract
them if they can handle listed template fields.

Roberto Sassu


Roberto Sassu (4):
  ima: added error messages to template-related functions
  ima: make a copy of template_fmt in template_desc_init_fields()
  ima: display template format in meas. list if template name length is
    zero
  ima: added support for new kernel cmdline parameter ima_template_fmt

 Documentation/kernel-parameters.txt      |  4 ++
 Documentation/security/IMA-templates.txt | 29 +++++++------
 security/integrity/ima/ima_fs.c          | 18 ++++++--
 security/integrity/ima/ima_template.c    | 71 ++++++++++++++++++++++++++++++--
 4 files changed, 100 insertions(+), 22 deletions(-)

-- 
1.8.1.4


------6D302F5C2315391DBA7A43406747BDC0
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
CwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0xMzExMDcxNDAwNDlaMCMGCSqG
SIb3DQEJBDEWBBSpuM7V9BRpNXuV40e+qK6J95CZUjB5BgkqhkiG9w0BCQ8xbDBq
MAsGCWCGSAFlAwQBKjALBglghkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3
DQMHMA4GCCqGSIb3DQMCAgIAgDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggq
hkiG9w0DAgIBKDANBgkqhkiG9w0BAQEFAASCAQBKkZvapKuiZDDCvlTJ+nq7zbat
7TLfsROWpJKCWdNlbOfdPjmNFX/p/Dv2a3L4xJc3JYepU6mxSyia7lxMoOl0wZtm
X2s9V+gb0sYQGJEQMcVXaHpfQKVpGakIa5izYGxchLefcASYrVPOmuw4PbfVY9SD
SCNQBfgEYhI3rwEFx9mV6QoD3C9flEBLKuaqT6WHeZ9HPBDJS0CExWfJj7Yojh8A
1hygtD+mFW0jZw4kEbNTTQuUrh6NKCbyUj7HJgjZtIVCmymmPqgEJaQrC+t40PQ3
C8gRtdkKoA8G3mItIJxVMGKXskEjxRXZjwYwb7Iv5Bo6GF7txNRueUp5FxLi

------6D302F5C2315391DBA7A43406747BDC0--


