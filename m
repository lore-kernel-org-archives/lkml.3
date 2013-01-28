Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605Ab3A1Dfi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 22:35:38 -0500
Received: from powered.by.root24.eu ([91.121.15.64]:50676 "EHLO Root24.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753368Ab3A1Dff (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 22:35:35 -0500
Message-ID: <5105F203.9060200@ionic.de>
Date: Mon, 28 Jan 2013 04:35:31 +0100
From: Mihai Moldovan <ionic@ionic.de>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: Panic during interrupt handling while terminating hostapd
X-Enigmail-Version: 1.5
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms030100050103050900090009"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms030100050103050900090009
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi,

I've found yet another problem with (at least) 3.7.4 and 3.8-rc4.

When terminating hostapd via SIGINT, this bug and panic came up:

-------------------------------------------------------------------------=
---------------------------
BUG: unable to handle kernel paging request at 0000001d00008000
IP: [<-----ADDRESS---->] kmem_cache_alloc+0x43/0xb0
PGD 21c3db067 PUD 0
Oops: 0000 [#1] SMP
Modules linked in: xt_conntrack xt_dscp i915 ath9k drm_kms_helper mac8021=
1
kvm_intel video ath9k_common ath9k_hw kvm e1000e ath backlight cfg80211 r=
fkill
CPU 2
Pid: 6972, comm: modprobe Tainted: G        W    3.7.4-OSS4.2
#3                  /DQ45CB
RIP: 0010:[<-----ADDRESS---->]  [<-----ADDRESS---->] kmem_cache_alloc+0x4=
3/0xb0
RSP: 0018:-----ADDRESS----  EFLAGS: 00010206
RAX: -----ADDRESS---- RBX: -----ADDRESS---- RCX: -----ADDRESS----
RDX: -----ADDRESS---- RSI: -----ADDRESS---- RDI: -----ADDRESS----
RBP: -----ADDRESS---- R08: -----ADDRESS---- R09: -----ADDRESS----
R10: -----ADDRESS---- R11: -----ADDRESS---- R12: -----ADDRESS----
FS:  -----ADDRESS----(0000) GS:-----ADDRESS----(0000) knlGS:-----ADDRESS-=
---
CS:  0010 DS: 0000 ES: 0000 CR0: -----ADDRESS----
CR2: -----ADDRESS---- CR3: -----ADDRESS---- CR4: -----ADDRESS----
DR0: -----ADDRESS---- CR1: -----ADDRESS---- DR2: -----ADDRESS----
DR3: -----ADDRESS---- DR6: -----ADDRESS---- DR7: -----ADDRESS----
Process modprobe (pid: 6972, threadinfo -----ADDRESS----, task -----ADDRE=
SS----)
Stack:
 -----ADDRESS---- -----ADDRESS---- -----ADDRESS---- -----ADDRESS----
 -----ADDRESS---- -----ADDRESS---- -----ADDRESS---- -----ADDRESS----
 -----ADDRESS---- -----ADDRESS---- -----ADDRESS---- -----ADDRESS----
Call Trace:
 [<-----ADDRESS---->] __d_alloc+0x2f/0x180
 [<-----ADDRESS---->] d_alloc+0x13/0x70
 [<-----ADDRESS---->] lookup_dcache+0xa3/0xd0
 [<-----ADDRESS---->] ? path_get+0x26/0x40
 [<-----ADDRESS---->] lookup_open+0x54/0x1c0
 [<-----ADDRESS---->] do_last+0x319/0x830
 [<-----ADDRESS---->] path_openat+0xae/0x4c0
 [<-----ADDRESS---->] ? handle_mm_fault+0x210/0x2d0
 [<-----ADDRESS---->] do_filp_open+0x3d/0xa0
 [<-----ADDRESS---->] ? __alloc_fd+0x45/0x120
 [<-----ADDRESS---->] do_sys_open+0xf9/0x1e0
 [<-----ADDRESS---->] sys_openat+0xf/0x20
 [<-----ADDRESS---->] system_call_fastpath+0x16/0x1b
Code: 5d e0 4c 89 65 e8 49 8b 4d 00 65 48 03 0c 25 28 cd 00 00 48 8b 51 0=
8 4c 8b
21 4d 85 e4 74 62 49 63 45 20 48 8d 4a 01 49 8b 7d 00 <49> 8b 1c
 04 4c 89 e0 65 48 0f c7 0f 0f 94 c0 84 c0 74 c8 49 63
RIP  [<-----ADDRESS---->] kmem_cache_alloc+0x43/0xb0
 RSP <-----ADDRESS---->
CR2: -----ADDRESS----
general protection fault: 0000 [#2] SMP
Modules linked in: xt_conntrack xt_dscp i915 ath9k drm_kms_helper mac8021=
1
kvm_intel video ath9k_common ath9k_hw kvm e1000e ath backlight cfg80211 r=
fkill
CPU 2
Pid: 0, comm: swapper/2 Tainted: G      D W    3.7.4-OSS4.2 #3           =
     =20
/DQ45CB
RIP: 0010[<-----ADDRESS---->]  [<-----ADDRESS---->] rcu_do_batch.isra.37+=
0x131/0x290
RSP: 0018:-----ADDRESS----  EFLAGS: 00010212
RAX: -----ADDRESS---- RBX: -----ADDRESS---- RCX: -----ADDRESS----
RDX: -----ADDRESS---- RSI: -----ADDRESS---- RDI: -----ADDRESS----
RBP: -----ADDRESS---- R08: -----ADDRESS---- R09: -----ADDRESS----
R10: -----ADDRESS---- R11: -----ADDRESS---- R12: -----ADDRESS----
R13: -----ADDRESS---- R14: -----ADDRESS---- R15: -----ADDRESS----
FS:  -----ADDRESS----(0000) GS:-----ADDRESS----(0000) knlGS:-----ADDRESS-=
---
CS:  0010 DS: 0000 ES: 0000 CR0: -----ADDRESS----
CR2: -----ADDRESS---- CR3: -----ADDRESS---- CR4: -----ADDRESS----
DR0: -----ADDRESS---- DR1: -----ADDRESS---- DR2: -----ADDRESS----
DR3: -----ADDRESS---- DR6: -----ADDRESS---- DR7: -----ADDRESS----
Process swapper/2 (pid: 0, threadinfo -----ADDRESS----, task -----ADDRESS=
----)
Stack:
 -----ADDRESS---- -----ADDRESS---- -----ADDRESS---- -----ADDRESS----
 -----ADDRESS---- -----ADDRESS---- -----ADDRESS---- -----ADDRESS----
 -----ADDRESS---- -----ADDRESS---- -----ADDRESS---- -----ADDRESS----
Call Trace:
 <IRQ>
 [<-----ADDRESS---->] ? tick_program_event+0x1f/0x30
 [<-----ADDRESS---->] __rcu_process_callbacks+0xaa/0x140
 [<-----ADDRESS---->] rcu_process_callbacks+0x48/0x70
 [<-----ADDRESS---->] __do_softirq+0xa8/0x150
 [<-----ADDRESS---->] call_softirq+0x1c/0x30
 [<-----ADDRESS---->] do_softirq+0x4d/0x80
 [<-----ADDRESS---->] irq_exit+0x8e/0xb0
 [<-----ADDRESS---->] do_IRQ+0x5e/0xd0
 [<-----ADDRESS---->] common_interrupt+0x67/0x67
 <EOI>
 [<-----ADDRESS---->] ? acpi_idle_enter_simple+0xbd/0xf4
 [<-----ADDRESS---->] ? acpi_idle_enter_simple+0xb8/0xf4
 [<-----ADDRESS---->] acpi_idle_enter_bm+0xe1/0x24b
 [<-----ADDRESS---->] ? menu_select+0xe4/0x300
 [<-----ADDRESS---->] cpuidle_enter+0x19/0x20
 [<-----ADDRESS---->] cpuidle_idle_call+0x8b/0xf0
 [<-----ADDRESS---->] cpu_idle+0xbf/0x110
 [<-----ADDRESS---->] start_secondary+0xb3/0xb5
Code: b8 8b 92 ac 01 00 00 85 d2 75 2f 4d 85 ff 74 2a 4c 89 ff 48 8b 57 0=
8 4c 8b
3f 48 81 fa ff 0f 00 00 41 0f 18 0f 76 ab 48 89 45 a8 <ff> d2 48
 8b 45 a8 eb b4 0f 1f 80 00 00 00 00 48 89 c1 9c 41 5d
RIP [<-----ADDRESS---->] rcu_do_batch.isra.37+0x131/0x290
RSP <-----ADDRESS---->
Kernel panic - not syncing: Fatal exception in interrupt
panic occurred, switching back to text console.
-------------------------------------------------------------------------=
---------------------------

Should you need the mentioned addresses, just say the word and I'll trans=
cribe them.

As I have no idea whom to CC, I left that out. Maybe the maintainers of t=
he ACPI
subsystem (Len Brown) or IRQ subsystem (Thomas Gleixner), but I don't wan=
t to
pester them with unneccesary traffic. After all the problem was initiated=
 by
hostapd and most likely the ath9k cards.

Best regards,



Mihai


--------------ms030100050103050900090009
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
DxcNMTMwMTI4MDMzNTMxWjAjBgkqhkiG9w0BCQQxFgQUtXmMPeg/SMGqp4DNdkRcL+QsN3sw
bAYJKoZIhvcNAQkPMV8wXTALBglghkgBZQMEASowCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMH
MA4GCCqGSIb3DQMCAgIAgDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggqhkiG9w0DAgIB
KDCBpAYJKwYBBAGCNxAEMYGWMIGTMIGMMQswCQYDVQQGEwJJTDEWMBQGA1UEChMNU3RhcnRD
b20gTHRkLjErMCkGA1UECxMiU2VjdXJlIERpZ2l0YWwgQ2VydGlmaWNhdGUgU2lnbmluZzE4
MDYGA1UEAxMvU3RhcnRDb20gQ2xhc3MgMiBQcmltYXJ5IEludGVybWVkaWF0ZSBDbGllbnQg
Q0ECAh5/MIGmBgsqhkiG9w0BCRACCzGBlqCBkzCBjDELMAkGA1UEBhMCSUwxFjAUBgNVBAoT
DVN0YXJ0Q29tIEx0ZC4xKzApBgNVBAsTIlNlY3VyZSBEaWdpdGFsIENlcnRpZmljYXRlIFNp
Z25pbmcxODA2BgNVBAMTL1N0YXJ0Q29tIENsYXNzIDIgUHJpbWFyeSBJbnRlcm1lZGlhdGUg
Q2xpZW50IENBAgIefzANBgkqhkiG9w0BAQEFAASCAQA+g1QzvLDm9kFMuDaDqI95IyuMAqnD
9gVpPMA6fXBr+Xmuhqrrt5Gbt7MOHrMHs4kH+0bpNSbHXjhttJbJi8Vsd8sWdbQkqpTJuuGX
jh37AcHC3QOTzoDLYKgKb2v7KGRAa+tWZvNlWmjIUvjQRRqPnmjR9dJMcmh68mpg+MjgiONx
y3lcLlDQJF4dUHG669yxVvbvbMg0lMGdXAiuVIHSRpk8gftlV5D78uDqDSvnbgivgGbF+Cr4
PZR/CXZbc4d4xMRw01CmgWEzo8kD98rfT101z5rnQflqo32ZdcFPxE0i8z0eB0HUHBuLjiSl
eWuGhTy4ugrUbMW1LURUYsi0AAAAAAAA
--------------ms030100050103050900090009--
