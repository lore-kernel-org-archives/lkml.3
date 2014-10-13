Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753692AbaJMMJs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 08:09:48 -0400
Received: from fm1nodo1.polito.it ([130.192.180.11]:53440 "EHLO
	antispam.polito.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753301AbaJMMJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 08:09:47 -0400
X-AttachExt: p7s
X-ExtScanner: Niversoft's FindAttachments (free)
From: Roberto Sassu <roberto.sassu@polito.it>
To: linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-ima-devel@lists.sourceforge.net,
        zohar@us.ibm.com, d.kasatkin@samsung.com, jmorris@namei.org,
        Roberto Sassu <roberto.sassu@polito.it>
Subject: [PATCH-v4 0/5] ima: add support for custom template formats
Date: Mon, 13 Oct 2014 14:08:37 +0200
Message-Id: <1413202125-7062-1-git-send-email-roberto.sassu@polito.it>
X-Mailer: git-send-email 1.9.3
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature"; micalg="sha1"; boundary="----1AFDCB2422DD9313C3B6E5E2C7298A75"
X-FEAS-SYSTEM-WL: 130.192.180.41
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an S/MIME signed message

------1AFDCB2422DD9313C3B6E5E2C7298A75

Hi everyone

currently accepted patches for the new template management mechanism allow to
choose among a list of supported templates, statically defined in the code.
This functionality is not flexible enough, as users may want to include
in their measurements list only information needed and not use predefined
combinations.

For this reason, this patch set introduces the new kernel command line parameter
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
those information if they can handle listed template fields.

Changelog:
 - v3 (sent to ima-devel mailing list only):
   - patch 2/5: check the first byte of 'e->template_desc->name' instead of
     using strlen() in ima_fs.c (suggested by Mimi Zohar)
   - patch 3/5: added 'goto out' in template_desc_init_fields() to free
     allocated memory if a template field length is not valid (suggested by
     Mimi Zohar)
   - patch 4/5: do not check in this patch if 'fields' and 'num_fields' are NULL
     (suggested by Mimi Zohar)
   - patch 5/5: added check for 'fields' and 'num_fields' in
     template_desc_init_fields() (suggested by Mimi Zohar)

 - v2:
   - patch 1/5: display an error message if the format string contains too many
     fields (Roberto Sassu)
   - patch 2/5: print the template format in ima_init_template(), if the
     selected template is custom (Roberto Sassu)
   - patch 3/5: new
   - patch 4/5: new
   - patch 5/5: using template_desc_init_fields() to validate a format string
     (Roberto Sassu)
   - patch 5/5: updated documentation by stating that only the chosen template
     descriptor is initialized (Roberto Sassu)

 - v1:
   - patch 2/3: fixed patch description (Roberto Sassu, suggested by Mimi Zohar)
   - patch 3/3: set 'template_name' variable in ima_fs.c only once
     (Roberto Sassu, suggested by Mimi Zohar)
   - patch 3/3: simplified code of ima_template_fmt_setup()
     (Roberto Sassu, suggested by Mimi Zohar)
   - the patch 'ima: make a copy of template_fmt in template_desc_init_fields()'
     has been removed from this version of the patch set since it has been
     already merged in the mainline kernel (commit: dbc335d2d + fix: af91706d5)


Roberto Sassu (5):
  ima: added error messages to template-related functions
  ima: display template format in meas. list if template name length is
    zero
  ima: don't allocate a copy of template_fmt in
    template_desc_init_fields()
  ima: allocate field pointers array on demand in
    template_desc_init_fields()
  ima: added support for new kernel cmdline parameter ima_template_fmt

 Documentation/kernel-parameters.txt      |   4 ++
 Documentation/security/IMA-templates.txt |  29 +++++----
 security/integrity/ima/ima_fs.c          |  16 +++--
 security/integrity/ima/ima_template.c    | 103 +++++++++++++++++++++----------
 4 files changed, 101 insertions(+), 51 deletions(-)

-- 
1.9.3


------1AFDCB2422DD9313C3B6E5E2C7298A75
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
CwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0xNDEwMTMxMjA4NDVaMCMGCSqG
SIb3DQEJBDEWBBTI87rdD8BHs9jgR30MHCKEO7AB8DB5BgkqhkiG9w0BCQ8xbDBq
MAsGCWCGSAFlAwQBKjALBglghkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3
DQMHMA4GCCqGSIb3DQMCAgIAgDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggq
hkiG9w0DAgIBKDANBgkqhkiG9w0BAQEFAASCAQCXDcxdLK89BgRQhPBOS3PkENot
PVXs8ayNF3Awp1N9UG42j0Ipc/4PKzOkYEdc0EUG50Np7wHqcHe015ODkflYH6Yf
YJL99vDdIW5TuBP2ZDCVkwygRtXe1X6IQ23BIE8gfBexzMKKfYLM52Ocy/y60RGT
Yk9hZO6b9yquKGh3YbXqio0QfLXcx/1ISJEvdMkYsnOUHVsdSFDNmDOBRkTaWZUJ
l/XQqJ29cFXSbcukUxyVDijYMaDOtcZ7TrSEMrMkfTH+LLbQ5681S2Mk+HgVS3o5
mauBA4sJoqra6oFrC4lXmD2DMlnrCDYweQKWD9yppck3KUxcnXY0F+QkTadt

------1AFDCB2422DD9313C3B6E5E2C7298A75--


