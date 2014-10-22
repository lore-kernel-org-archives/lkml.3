Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782AbaJVNOk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 09:14:40 -0400
Received: from mx11.unify.com ([62.134.46.9]:45955 "EHLO mx11.unify.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933186AbaJVNOh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 09:14:37 -0400
X-Greylist: delayed 451 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 Oct 2014 09:14:37 EDT
From: "Kokoris, Ioannis" <ioannis.kokoris@unify.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
CC: "timur@freescale.com" <timur@freescale.com>
Subject: [PATCH] ucc_geth: invalid rx checksum error values
Thread-Topic: [PATCH] ucc_geth: invalid rx checksum error values
Thread-Index: Ac/t+RIN9+zVQOrtTdOPMDTyCrhb7A==
Date: Wed, 22 Oct 2014 13:07:02 +0000
Message-ID: <FDB831DFAAC88B42A50BA37D1BC5E13A29C63D1F@MCHP03MSX.global-ad.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [172.29.42.225]
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature";
	micalg=SHA1; boundary="----=_NextPart_000_0083_01CFEE12.375D5800"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_NextPart_000_0083_01CFEE12.375D5800
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi, 

The value in QE UCC ethernet interfaces shows random values:

# ethtool -S eth0
NIC statistics:
     ...
     rx-ip-checksum-errors: 3933892214

The problem is located in a mismatch between the rx_fw_stat_gstrings fields
- used in ucc_geth_ethtool - and the ucc_geth_rx_firmware_statistics_pram
fields - used in ucc_geth.
Although the QE UCC Ethernet Controller includes the Rx checksum error
counter in the 'Rx firmware counters', the related field is missing from the
ucc_geth driver.  
After adding the RxChecksumError field in
ucc_geth_rx_firmware_statistics_pram structure the counter works fine.



Signed-off-by: Ioannis Kokkoris <ioannis.kokoris@unify.com>


diff -Nru a/drivers/net/ethernet/freescale/ucc_geth.h
b/drivers/net/ethernet/freescale/ucc_geth.h
--- a/drivers/net/ethernet/freescale/ucc_geth.h 2014-10-22
15:19:16.000000000 +0300
+++ b/drivers/net/ethernet/freescale/ucc_geth.h 2014-10-22
15:24:39.000000000 +0300
@@ -541,6 +541,8 @@
                                   replaced */
        u32 insertvlan;         /* total frames that had their VLAN tag
                                   inserted */
+       u32 checksumerr;        /* total frames that have IP Checksum Error
+                                */
 } __packed;

 struct ucc_geth_rx_interrupt_coalescing_entry {



Best Regards,
Ioannis

------=_NextPart_000_0083_01CFEE12.375D5800
Content-Type: application/x-pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIPkTCCAzYw
ggIeoAMCAQICEFKIki0gLsWYSyx9eBbYcr0wDQYJKoZIhvcNAQELBQAwNTELMAkGA1UEBhMCREUx
DjAMBgNVBAoMBVVuaWZ5MRYwFAYDVQQDDA1VbmlmeSBSb290IENBMB4XDTEzMDkyNTA3MzQzMFoX
DTI4MDkyNTA3NDQyNVowNTELMAkGA1UEBhMCREUxDjAMBgNVBAoMBVVuaWZ5MRYwFAYDVQQDDA1V
bmlmeSBSb290IENBMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAp7oHRPmtJ+/8I3iv
apenTzPKMh+diPfZPmp9SkuRTuW3NZivOarkd7vs2+gkhD8syKpPyLpKDRMG2zHgBjYxxdUhagYW
MNKej07xGs3kmPXKbt/FxL+xI+64aHLV35fCmOrOS7tLBGpDfAMJhAWMEI9xmQdDAYcxJOXlR4Hw
cosfPFvfDI7Tiwj4Kml547YRq1cKTpy8AtQgo1Rc41WakCknXeRcRtSlllGHydqd8RCNe49Ut+OI
zBtKSfoe/cYVuUrSh2cOCUFOh3EAxKmFi2lCEI5t3mtZV35MVGOIAbFF8On9udmA10uvM/RR51fg
o3oh9wdCOn0tFfMPLYOSGwIDAQABo0IwQDAOBgNVHQ8BAf8EBAMCAYYwDwYDVR0TAQH/BAUwAwEB
/zAdBgNVHQ4EFgQUL/fEwyUdkMhFfPNnCnMzxVyab08wDQYJKoZIhvcNAQELBQADggEBAGaM56dC
Yx9O21zPZ/Qnw8jw7uIVxlAdOE+jlrs5MLvenLmrlG5StAIgpqaXVzp5i9m+duDXhR+NVy9FwnyA
xqah+NZd0sp5p/M+0MYPu2BynLBfrMBoW6TwtStkkoK8PfQr5U9u8KeVifyQJe2fswcDWg6odiUb
/bdEmqQmXc2aA9qM6WEcCOYWa7QNHKt+bLXqFiznNiEkhIyehiro213FOvPn9OgVd8OjZzlSbxCp
WbkGER4aD36mJSq7dU1/8qdfLn1nXwtlJkqP5Gj0DCjyNVRZTGKNvKRvHGDTOTRD/bbQOigqHDlf
SXemNB3a5En3X73EJd8raK2M5JZRQ7MwggW9MIIEpaADAgECAg4w9GNsY4mqiwAAAAAABDANBgkq
hkiG9w0BAQsFADA1MQswCQYDVQQGEwJERTEOMAwGA1UECgwFVW5pZnkxFjAUBgNVBAMMDVVuaWZ5
IFJvb3QgQ0EwHhcNMTMwOTI2MTQ0MDA0WhcNMjMwOTI2MTQ1MDA0WjA1MQswCQYDVQQGEwJERTEO
MAwGA1UECgwFVW5pZnkxFjAUBgNVBAMMDVVuaWZ5IFVzZXIgQ0EwggEiMA0GCSqGSIb3DQEBAQUA
A4IBDwAwggEKAoIBAQCPGIg7woGyfrEXR+ihrCDd3i0M2evThPreB9ap8fL+bBiANbWggXV5rR/w
DBo1rzMnTeaEEsmQQ8n00D+wl/Rwby8JZUtgS3y3284/H5kfgVnGL6FW7qnJLq/cQKgIQuCP+nGs
dt5gc9LriPuwDo1p22lQuduffmF21saaFYOu7cSLAwV+YKoERBL7M00r9I4Qm1twYUqPI6/T9OVw
V2nmerPobEwBUcBeXDxHzD7MGR+z0CRUuVvROcM28lakGuDW09YlBSNY81xrCj7Zf82uPoNdEb1T
MkEcjVQO8U/IfCKPnalP/2/frXrWK6JAgGWpxXAcWMgKXAghR8uqsySTAgMBAAGjggLJMIICxTAO
BgNVHQ8BAf8EBAMCAYYwHQYDVR0OBBYEFJhx96C5h8dG9AYMgSYzvV3eUAtmMBIGA1UdEwEB/wQI
MAYBAf8CAQAwHwYDVR0jBBgwFoAUL/fEwyUdkMhFfPNnCnMzxVyab08wggEbBgNVHR8EggESMIIB
DjCCAQqgggEGoIIBAoYqaHR0cDovL3BraS51bmlmeS5jb20vY3JsL3VuaWZ5LXJvb3QtY2EuY3Js
hoHTbGRhcDovL3BraS1kaXJlY3RvcnkudW5pZnkuY29tL0NOPVVuaWZ5JTIwUm9vdCUyMENBLENO
PXVuaWZ5LXBraSxDTj1DRFAsQ049UHVibGljJTIwS2V5JTIwU2VydmljZXMsQ049U2VydmljZXMs
Q049Q29uZmlndXJhdGlvbixEQz1nbG9iYWwtYWQsREM9bmV0P2NlcnRpZmljYXRlUmV2b2NhdGlv
bkxpc3Q/YmFzZT9vYmplY3RDbGFzcz1jUkxEaXN0cmlidXRpb25Qb2ludDCCAT4GCCsGAQUFBwEB
BIIBMDCCASwwNgYIKwYBBQUHMAKGKmh0dHA6Ly9wa2kudW5pZnkuY29tL2NydC91bmlmeS1yb290
LWNhLmNydDCByQYIKwYBBQUHMAKGgbxsZGFwOi8vcGtpLWRpcmVjdG9yeS51bmlmeS5jb20vQ049
VW5pZnklMjBSb290JTIwQ0EsQ049QUlBLENOPVB1YmxpYyUyMEtleSUyMFNlcnZpY2VzLENOPVNl
cnZpY2VzLENOPUNvbmZpZ3VyYXRpb24sREM9Z2xvYmFsLWFkLERDPW5ldD9jQUNlcnRpZmljYXRl
P2Jhc2U/b2JqZWN0Q2xhc3M9Y2VydGlmaWNhdGlvbkF1dGhvcml0eTAmBggrBgEFBQcwAYYaaHR0
cDovL29jc3AudW5pZnkuY29tL29yMDEwDQYJKoZIhvcNAQELBQADggEBAJ/DjgX7xxKEhsGGpQ0J
xImw4V8hTITbBq8FqllxWhvkMjyI+7524g2xXBNLeHAfF+1W6BFgVeUuWjYqQzKl2vFkjLXJy4OX
JQMigXk24N+s6PtF235yqMCiaOg4q/KIT4RjdWJKgNpWuf3r5GMUKCmRQiAOQggHKCbSfyky5f+J
IHNHzby2x+AlRjipyEoy8Y4S96kdG90PQ/8fkplmjoigN03cSKglEvDVdf+EoBjVEgzhRTb+YIhh
GCRuzlTl2BFQNMHoNDsIU4eoMa0eLIcsOZOEoTl9YLbdHrOkEiiF8FkOmsVRoQTmVeGTA6Cx0gd0
ZB4vGvsaMJFxezMZTf8wggaSMIIFeqADAgECAgpvr+FjAAAAAAHeMA0GCSqGSIb3DQEBCwUAMDUx
CzAJBgNVBAYTAkRFMQ4wDAYDVQQKDAVVbmlmeTEWMBQGA1UEAwwNVW5pZnkgVXNlciBDQTAeFw0x
MzEwMTgxMDE5NTRaFw0xODEwMTcxMDE5NTRaMFAxKDAmBgkqhkiG9w0BCQEWGWlvYW5uaXMua29r
b3Jpc0B1bmlmeS5jb20xJDAiBgNVBAMMG0tva29yaXMgSW9hbm5pcyBTRU5HUjAyMDE0MDCCASIw
DQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAL+k5vMN94RhBNn+Gi698FpqA/lf0tT1hX6cizr8
3cuNvS56J83yb4ZvJzGcVlUJrRbpChkxDaw9er+JHA7wfOh2pMp56gbOI8tFgaTVmdw8pvjE6UHG
u9ys4cOj9kJ9svsXi+gn75vCL+FBKsFld6QVzkHHxAMdzfJ/+ai/1iQH3wzqieQCLXr24tIl8zaz
eGulWXM0Mo6dTSAzmY7G5MNKiSUpat96qUqVn9zwi60e1t9g2Mg1pbs/rZlEx0c8LFxz+y5mlBKA
ukbhqZx16tPY+2Pmfg5A2WT85P+0cSDD10vohzuvGQJ1qQlnFbdT/kDQ4BVaFNRTgQXnz1QnrQUC
AwEAAaOCA4cwggODMA4GA1UdDwEB/wQEAwIEsDAdBgNVHQ4EFgQUlP/VUcHRCl4BtjCnnKp3i2tm
XKgwPQYJKwYBBAGCNxUHBDAwLgYmKwYBBAGCNxUIgt6SVoGmryaGiZkJpvV0gvKhRYEphvjFSoLY
uW8CAWQCAQ4wHwYDVR0jBBgwFoAUmHH3oLmHx0b0BgyBJjO9Xd5QC2YwggEbBgNVHR8EggESMIIB
DjCCAQqgggEGoIIBAoYqaHR0cDovL3BraS51bmlmeS5jb20vY3JsL3VuaWZ5LXVzZXItY2EuY3Js
hoHTbGRhcDovL3BraS1kaXJlY3RvcnkudW5pZnkuY29tL0NOPVVuaWZ5JTIwVXNlciUyMENBLENO
PXVuaWZ5LXBraSxDTj1DRFAsQ049UHVibGljJTIwS2V5JTIwU2VydmljZXMsQ049U2VydmljZXMs
Q049Q29uZmlndXJhdGlvbixEQz1nbG9iYWwtYWQsREM9bmV0P2NlcnRpZmljYXRlUmV2b2NhdGlv
bkxpc3Q/YmFzZT9vYmplY3RDbGFzcz1jUkxEaXN0cmlidXRpb25Qb2ludDCCAT4GCCsGAQUFBwEB
BIIBMDCCASwwNgYIKwYBBQUHMAKGKmh0dHA6Ly9wa2kudW5pZnkuY29tL2NydC91bmlmeS11c2Vy
LWNhLmNydDCByQYIKwYBBQUHMAKGgbxsZGFwOi8vcGtpLWRpcmVjdG9yeS51bmlmeS5jb20vQ049
VW5pZnklMjBVc2VyJTIwQ0EsQ049QUlBLENOPVB1YmxpYyUyMEtleSUyMFNlcnZpY2VzLENOPVNl
cnZpY2VzLENOPUNvbmZpZ3VyYXRpb24sREM9Z2xvYmFsLWFkLERDPW5ldD9jQUNlcnRpZmljYXRl
P2Jhc2U/b2JqZWN0Q2xhc3M9Y2VydGlmaWNhdGlvbkF1dGhvcml0eTAmBggrBgEFBQcwAYYaaHR0
cDovL29jc3AudW5pZnkuY29tL29yMDEwDAYDVR0TAQH/BAIwADA1BgNVHSUELjAsBgorBgEEAYI3
FAICBggrBgEFBQcDBAYKKwYBBAGCNwoDBAYIKwYBBQUHAwIwTAYDVR0RBEUwQ6AmBgorBgEEAYI3
FAIDoBgMFkdSTVM5TTk2QEdMT0JBTC1BRC5ORVSBGWlvYW5uaXMua29rb3Jpc0B1bmlmeS5jb20w
DQYJKoZIhvcNAQELBQADggEBACw7SaKbk0Rgr5cotki/+UNlHML563VkoUsUDbDlf15Me3kThVSh
M3FEKZvYTTSOy7XdJOUjygt8pyo5+Z4f4MBsAdkNZX2fxy5pD0akZAwa1OY/ozeGjPOodjHtAQq7
WTkIe2fnLB4OKr1UowB6awxZrCNxJdqqnENVtHJeC9q1eiXW39oNBigMfUmwvnAYPAXPVE8wcPwF
zSoIV8p4SQXh7daffkUOVwOgP/KNaN3wnOE5e4zFodixnLdadBFAQVif2mq3KdnRUs/rJyM1OyG+
maUvI3vzTnXTYpYQ7wKTZGzpYniGQ2hDJ38HqjXWGTuxUV1w8hR6Ho2mlkobmHAxggMvMIIDKwIB
ATBDMDUxCzAJBgNVBAYTAkRFMQ4wDAYDVQQKDAVVbmlmeTEWMBQGA1UEAwwNVW5pZnkgVXNlciBD
QQIKb6/hYwAAAAAB3jAJBgUrDgMCGgUAoIIBwTAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwG
CSqGSIb3DQEJBTEPFw0xNDEwMjIxMzA3MDJaMCMGCSqGSIb3DQEJBDEWBBTbXLaPIhN/kUk8YJ6Q
trME2+AHqjBSBgkrBgEEAYI3EAQxRTBDMDUxCzAJBgNVBAYTAkRFMQ4wDAYDVQQKDAVVbmlmeTEW
MBQGA1UEAwwNVW5pZnkgVXNlciBDQQIKb6/hYwAAAAAB3jBUBgsqhkiG9w0BCRACCzFFoEMwNTEL
MAkGA1UEBhMCREUxDjAMBgNVBAoMBVVuaWZ5MRYwFAYDVQQDDA1VbmlmeSBVc2VyIENBAgpvr+Fj
AAAAAAHeMIG3BgkqhkiG9w0BCQ8xgakwgaYwCwYJYIZIAWUDBAEqMAsGCWCGSAFlAwQBFjAKBggq
hkiG9w0DBzALBglghkgBZQMEAQIwDgYIKoZIhvcNAwICAgCAMAcGBSsOAwIHMA0GCCqGSIb3DQMC
AgFAMA0GCCqGSIb3DQMCAgEoMAcGBSsOAwIaMAsGCWCGSAFlAwQCAzALBglghkgBZQMEAgIwCwYJ
YIZIAWUDBAIBMAoGCCqGSIb3DQIFMA0GCSqGSIb3DQEBAQUABIIBABDRvD08ySgwRO2wPHH5a3J2
Hxz1/CJTca1mN2YuFZOhJZngndToZGJU6LF7iZS4tNw3uxkGO6FdGqJpVqm/EFNFuigZ7PrPGanI
yZZAXFUBQVh6c28cmQ3R8be2DQHPcz6aR6hPf1eaCcJ+J/MR9LugVI9OHYfMEJfmWdND+34SCy+l
9bhvQjPaaHZhcYMOv/BgfhkHXIq2MlDLb6Vl4YUs14X7694iSWexj8qJk32YJin2gEvnE/RZn3Nv
zwz9NAjGQc5BHevZlQ9vOlBbigBr7HpotRPydDU9JE18ayeQ7s9dhP0S4P677rkwFKFC0g1IGs31
d9cUzWStIcqHM2AAAAAAAAA=

------=_NextPart_000_0083_01CFEE12.375D5800--
