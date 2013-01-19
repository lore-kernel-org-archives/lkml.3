Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751920Ab3ASQ0k (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2013 11:26:40 -0500
Received: from powered.by.root24.eu ([91.121.15.64]:37208 "EHLO Root24.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751610Ab3ASQ0j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2013 11:26:39 -0500
Message-ID: <50FAC93C.3040205@ionic.de>
Date: Sat, 19 Jan 2013 17:26:36 +0100
From: Mihai Moldovan <ionic@ionic.de>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Daniel Vetter <daniel.vetter@ffwll.ch>
CC: LKML <linux-kernel@vger.kernel.org>, David Woodhouse <dwmw2@infradead.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        dri-devel <dri-devel@lists.freedesktop.org>
Subject: Re: i915-related and general system freezes with specific kernel
 config // IOMMU
References: <50F9DF53.4090601@ionic.de> <CAKMK7uExHc=PEBpn2vPrX+sQcv=U7VuvsJHRxc-SSOh=_G_1Dg@mail.gmail.com> <50FAC61A.9060503@ionic.de>
In-Reply-To: <50FAC61A.9060503@ionic.de>
X-Enigmail-Version: 1.5
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms070805080301000702010105"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms070805080301000702010105
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

* On 19.01.2013 05:13 PM, Mihai Moldovan wrote:
> * On 19.01.2013 02:27 PM, Daniel Vetter wrote:
>> You have a gen4.5 chipset which is known to be utterly broken for
>> IOMMU+intel gpu.
> Nice description for what I'm seeing. ;)
>
> After some more hours of uptime I'm inclined to say, that "intel_iommu=3D=
off
> iommu=3Doff" fixes my random freezes as well.
> Alas, the USB and PCI(e) problems are still around, but I could test re=
compiling
> 3.7.2 with Intel IOMMU turned off completely in the kernel config.
> Interestingly, my 3.0.2 kernel which worked fine for so long doesn't ev=
en *have*
> support for VT-d/Intel IOMMU. This could explain why I wasn't bit by th=
ose
> problems on all previous versions.
>
>
>> [...] and we've never added the proper
>> quirks. See https://bugzilla.kernel.org/show_bug.cgi?id=3D51921 for a
>> proposed patch to fix this (i.e. automatically set
>> intel_iommu=3Digfx_off for affected platfroms). Testing highly welcome=
=2E
> From a quick glance, I don't think this patch will work as-is, my PCI I=
D 2e12 is
> missing.
> [...]

Which of course will work, as 2e10 is my DRAM controller as reported by l=
spci,
sorry.

But, shouldn't the
"DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x2eXX, quirk_iommu_rwbf);=
"
calls be rather
" DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x2e00, quirk_iommu_g4x_g=
fx);"
?

The current patch errors out on my while compiling as quirk_iommu_rwbf is=
 not
yet defined at that place.


--------------ms070805080301000702010105
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIINgjCC
BjQwggQcoAMCAQICASAwDQYJKoZIhvcNAQEFBQAwfTELMAkGA1UEBhMCSUwxFjAUBgNVBAoT
DVN0YXJ0Q29tIEx0ZC4xKzApBgNVBAsTIlNlY3VyZSBEaWdpdGFsIENlcnRpZmljYXRlIFNp
Z25pbmcxKTAnBgNVBAMTIFN0YXJ0Q29tIENlcnRpZmljYXRpb24gQXV0aG9yaXR5MB4XDTA3
MTAyNDIxMDI1NVoXDTE3MTAyNDIxMDI1NVowgYwxCzAJBgNVBAYTAklMMRYwFAYDVQQKEw1T
dGFydENvbSBMdGQuMSswKQYDVQQLEyJTZWN1cmUgRGlnaXRhbCBDZXJ0aWZpY2F0ZSBTaWdu
aW5nMTgwNgYDVQQDEy9TdGFydENvbSBDbGFzcyAyIFByaW1hcnkgSW50ZXJtZWRpYXRlIENs
aWVudCBDQTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMsohUWcASz7GfKrpTOM
KqANy9BV7V0igWdGxA8IU77L3aTxErQ+fcxtDYZ36Z6GH0YFn7fq5RADteP0AYzrCA+EQTfi
8q1+kA3m0nwtwXG94M5sIqsvs7lRP1aycBke/s5g9hJHryZ2acScnzczjBCAo7X1v5G3yw8M
DP2m2RCye0KfgZ4nODerZJVzhAlOD9YejvAXZqHksw56HzElVIoYSZ3q4+RJuPXXfIoyby+Y
2m1E+YzX5iCZXBx05gk6MKAW1vaw4/v2OOLy6FZH3XHHtOkzUreG//CsFnB9+uaYSlR65cdG
zTsmoIK8WH1ygoXhRBm98SD7Hf/r3FELNvUCAwEAAaOCAa0wggGpMA8GA1UdEwEB/wQFMAMB
Af8wDgYDVR0PAQH/BAQDAgEGMB0GA1UdDgQWBBSuVYNv7DHKufcd+q9rMfPIHeOsuzAfBgNV
HSMEGDAWgBROC+8apEBbpRdphzDKNGhD0EGu8jBmBggrBgEFBQcBAQRaMFgwJwYIKwYBBQUH
MAGGG2h0dHA6Ly9vY3NwLnN0YXJ0c3NsLmNvbS9jYTAtBggrBgEFBQcwAoYhaHR0cDovL3d3
dy5zdGFydHNzbC5jb20vc2ZzY2EuY3J0MFsGA1UdHwRUMFIwJ6AloCOGIWh0dHA6Ly93d3cu
c3RhcnRzc2wuY29tL3Nmc2NhLmNybDAnoCWgI4YhaHR0cDovL2NybC5zdGFydHNzbC5jb20v
c2ZzY2EuY3JsMIGABgNVHSAEeTB3MHUGCysGAQQBgbU3AQIBMGYwLgYIKwYBBQUHAgEWImh0
dHA6Ly93d3cuc3RhcnRzc2wuY29tL3BvbGljeS5wZGYwNAYIKwYBBQUHAgEWKGh0dHA6Ly93
d3cuc3RhcnRzc2wuY29tL2ludGVybWVkaWF0ZS5wZGYwDQYJKoZIhvcNAQEFBQADggIBADqp
Jw3I07QWke9plNBpxUxcffc7nUrIQpJHDci91DFG7fVhHRkMZ1J+BKg5UNUxIFJ2Z9B90Mic
c/NXcs7kPBRdn6XGO/vPc87Y6R+cWS9Nc9+fp3Enmsm94OxOwI9wn8qnr/6o3mD4noP9Jphw
UPTXwHovjavRnhUQHLfo/i2NG0XXgTHXS2Xm0kVUozXqpYpAdumMiB/vezj1QHQJDmUdPYMc
p+reg9901zkyT3fDW/ivJVv6pWtkh6Pw2ytZT7mvg7YhX3V50Nv860cV11mocUVcqBLv0gcT
+HBDYtbuvexNftwNQKD5193A7zN4vG7CTYkXxytSjKuXrpEatEiFPxWgb84nVj25SU5q/r1X
hwby6mLhkbaXslkVtwEWT3Van49rKjlK4XrUKYYWtnfzq6aSak5u0Vpxd1rY79tWhD3EdCvO
hNz/QplNa+VkIsrcp7+8ZhP1l1b2U6MaxIVteuVMD3X0vziIwr7jxYae9FZjbxlpUemqXjcC
0QaFfN7qI0JsQMALL7iGRBg7K0CoOBzECdD3fuZil5kU/LP9cr1BK31U0Uy651bFnAMMMkqh
AChIbn0ei72VnbpSsrrSdF0BAGYQ8vyHae5aCg+H75dVCV33K6FuxZrf09yTz+Vx/PkdRUYk
XmZz/OTfyJXsUOUXrym6KvI2rYpccSk5MIIHRjCCBi6gAwIBAgICHn8wDQYJKoZIhvcNAQEF
BQAwgYwxCzAJBgNVBAYTAklMMRYwFAYDVQQKEw1TdGFydENvbSBMdGQuMSswKQYDVQQLEyJT
ZWN1cmUgRGlnaXRhbCBDZXJ0aWZpY2F0ZSBTaWduaW5nMTgwNgYDVQQDEy9TdGFydENvbSBD
bGFzcyAyIFByaW1hcnkgSW50ZXJtZWRpYXRlIENsaWVudCBDQTAeFw0xMjAzMjEyMzU3NTda
Fw0xNDAzMjMxNTE0MzlaMIGRMRkwFwYDVQQNExAwSjh4RlU1aWNwTGFuNHlLMQswCQYDVQQG
EwJERTEbMBkGA1UECBMSQmFkZW4tV3VlcnR0ZW1iZXJnMRIwEAYDVQQHEwlLYXJsc3J1aGUx
FzAVBgNVBAMTDk1paGFpIE1vbGRvdmFuMR0wGwYJKoZIhvcNAQkBFg5pb25pY0Bpb25pYy5k
ZTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMaylRRCBj2U12flvhmZMgwADN/0
P/ej3O9uLe8XWsr6McU8my6GYxfTXFxfcLl8MxqugflmQQqq1c1Qt69n3zHi+qTvZnHBCBHs
G1CkuL3Of7Srx6ulz0/zgNRMlDnJ7EUAIQDoYkUzn69y/4ap3n/nQf7EmO9o3FnSCX27td5Y
J21uJp/PLvbwvG9kdWMVeiyBubwdBSoMu1D9Cy6YlqFE1DIgPO9RR6EOkie4BgMr/3eliAoK
j7HAOkFhsqTrVy81YtxQDYNrpeMZ2imSQUP1wN1X0NNkdcIWpUNYkRdvzrmpFXxYNhwPPPiE
BIKctzMt00Pss2ziyMqpkQFzcI8CAwEAAaOCA6kwggOlMAkGA1UdEwQCMAAwCwYDVR0PBAQD
AgSwMB0GA1UdJQQWMBQGCCsGAQUFBwMCBggrBgEFBQcDBDAdBgNVHQ4EFgQUypNX2Sx5I6PQ
yCj0Lgno1pTiwnswHwYDVR0jBBgwFoAUrlWDb+wxyrn3HfqvazHzyB3jrLswGQYDVR0RBBIw
EIEOaW9uaWNAaW9uaWMuZGUwggIhBgNVHSAEggIYMIICFDCCAhAGCysGAQQBgbU3AQICMIIB
/zAuBggrBgEFBQcCARYiaHR0cDovL3d3dy5zdGFydHNzbC5jb20vcG9saWN5LnBkZjA0Bggr
BgEFBQcCARYoaHR0cDovL3d3dy5zdGFydHNzbC5jb20vaW50ZXJtZWRpYXRlLnBkZjCB9wYI
KwYBBQUHAgIwgeowJxYgU3RhcnRDb20gQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkwAwIBARqB
vlRoaXMgY2VydGlmaWNhdGUgd2FzIGlzc3VlZCBhY2NvcmRpbmcgdG8gdGhlIENsYXNzIDIg
VmFsaWRhdGlvbiByZXF1aXJlbWVudHMgb2YgdGhlIFN0YXJ0Q29tIENBIHBvbGljeSwgcmVs
aWFuY2Ugb25seSBmb3IgdGhlIGludGVuZGVkIHB1cnBvc2UgaW4gY29tcGxpYW5jZSBvZiB0
aGUgcmVseWluZyBwYXJ0eSBvYmxpZ2F0aW9ucy4wgZwGCCsGAQUFBwICMIGPMCcWIFN0YXJ0
Q29tIENlcnRpZmljYXRpb24gQXV0aG9yaXR5MAMCAQIaZExpYWJpbGl0eSBhbmQgd2FycmFu
dGllcyBhcmUgbGltaXRlZCEgU2VlIHNlY3Rpb24gIkxlZ2FsIGFuZCBMaW1pdGF0aW9ucyIg
b2YgdGhlIFN0YXJ0Q29tIENBIHBvbGljeS4wNgYDVR0fBC8wLTAroCmgJ4YlaHR0cDovL2Ny
bC5zdGFydHNzbC5jb20vY3J0dTItY3JsLmNybDCBjgYIKwYBBQUHAQEEgYEwfzA5BggrBgEF
BQcwAYYtaHR0cDovL29jc3Auc3RhcnRzc2wuY29tL3N1Yi9jbGFzczIvY2xpZW50L2NhMEIG
CCsGAQUFBzAChjZodHRwOi8vYWlhLnN0YXJ0c3NsLmNvbS9jZXJ0cy9zdWIuY2xhc3MyLmNs
aWVudC5jYS5jcnQwIwYDVR0SBBwwGoYYaHR0cDovL3d3dy5zdGFydHNzbC5jb20vMA0GCSqG
SIb3DQEBBQUAA4IBAQAWDJnVeIEl30sEHVyZ43IOK1RrYRyNJFAoClulBqL229p3whd4mtCY
hE25avnoZIMPTxhjZJlnmIlr0Ahh8hjSeqzjeEIVzBV//vVRBwI1DnaJ2u965og2FBhp3KXc
5pIHJA6aqJFqZE8EoI+81gdPB9Rc4cDAa0S4Bd4YtsLFfmxgR33EPC0MhEkwE2cihRTbF5Ye
yW1j4sUmnaJKlv9mxAs79D6n3Ggx8YBAOnkmg/tCTbTrJcqrB67NUpFhEcgFNRNqaL2oxE3u
qO7IjtyOzIlD+5dOJragt5dJJjXZF3NqWjsohcyYMECY8WEKUJlE0lPFQ4bPNfzWWdh16ooV
MYID2jCCA9YCAQEwgZMwgYwxCzAJBgNVBAYTAklMMRYwFAYDVQQKEw1TdGFydENvbSBMdGQu
MSswKQYDVQQLEyJTZWN1cmUgRGlnaXRhbCBDZXJ0aWZpY2F0ZSBTaWduaW5nMTgwNgYDVQQD
Ey9TdGFydENvbSBDbGFzcyAyIFByaW1hcnkgSW50ZXJtZWRpYXRlIENsaWVudCBDQQICHn8w
CQYFKw4DAhoFAKCCAhswGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUx
DxcNMTMwMTE5MTYyNjM2WjAjBgkqhkiG9w0BCQQxFgQUOdDSZhqzYUiQ3fvF9v8D0N1VP4sw
bAYJKoZIhvcNAQkPMV8wXTALBglghkgBZQMEASowCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMH
MA4GCCqGSIb3DQMCAgIAgDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggqhkiG9w0DAgIB
KDCBpAYJKwYBBAGCNxAEMYGWMIGTMIGMMQswCQYDVQQGEwJJTDEWMBQGA1UEChMNU3RhcnRD
b20gTHRkLjErMCkGA1UECxMiU2VjdXJlIERpZ2l0YWwgQ2VydGlmaWNhdGUgU2lnbmluZzE4
MDYGA1UEAxMvU3RhcnRDb20gQ2xhc3MgMiBQcmltYXJ5IEludGVybWVkaWF0ZSBDbGllbnQg
Q0ECAh5/MIGmBgsqhkiG9w0BCRACCzGBlqCBkzCBjDELMAkGA1UEBhMCSUwxFjAUBgNVBAoT
DVN0YXJ0Q29tIEx0ZC4xKzApBgNVBAsTIlNlY3VyZSBEaWdpdGFsIENlcnRpZmljYXRlIFNp
Z25pbmcxODA2BgNVBAMTL1N0YXJ0Q29tIENsYXNzIDIgUHJpbWFyeSBJbnRlcm1lZGlhdGUg
Q2xpZW50IENBAgIefzANBgkqhkiG9w0BAQEFAASCAQAmdHnINZH9wczDanAfQVASUVHxVvn/
sGAkOAOLoM5Esj/FUT4yxUj9cnt95NhPncts15NkyFxnJ8jatOWyfuOkOYuuyrJKbbe6Y5J1
i8k+m+iaCYjDnmDlNDsl0CJtr8U4ROZIay79zhxVpZr/LgEAuRnES9bB5i0nVmbXW4hg/33T
BP0ZjaGgOfaNSx6VH6ejiieQzX2Ppl0BRcp6uuyx9KQthgyFX4lbNeEl3rOyMLbkC/IR4EGH
ALM83jNoPjqNbcAyYr64NUzGRhUbOrcIgid0oRWIARbBP18pjBN9nuB9Yl9GbfEfZR6luRtv
8kfJN5UAITNsoAN76DR5Rw9JAAAAAAAA
--------------ms070805080301000702010105--
