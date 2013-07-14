Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753570Ab3GOAEM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jul 2013 20:04:12 -0400
Received: from powered.by.root24.eu ([91.121.15.64]:40986 "EHLO Root24.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753496Ab3GOAEK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jul 2013 20:04:10 -0400
X-Greylist: delayed 546 seconds by postgrey-1.27 at vger.kernel.org; Sun, 14 Jul 2013 20:04:06 EDT
Message-ID: <51E33A4F.4040500@ionic.de>
Date: Mon, 15 Jul 2013 01:54:55 +0200
From: Mihai Moldovan <ionic@ionic.de>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: Oops (NULL ptr deref) while loading some module
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms060202040105070200010500"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms060202040105070200010500
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi all,

I'm seeing following oopses when booting up my kernel:

[    3.173479] BUG: unable to handle kernel NULL pointer dereference
at           (null)
[    3.173602] IP: [<ffffffff810d2f54>] futex_wake+0x74/0x130
[    3.173679] PGD 231d65067 PUD 231d64067 PMD 0
[    3.173783] Oops: 0000 [#1] SMP
[    3.173870] Modules linked in:
[    3.173936] CPU 0
[    3.173959] Pid: 615, comm: modprobe Not tainted 3.9.6-OSS4.2-dirty
#34                  /DQ45CB
[    3.174091] RIP: 0010:[<ffffffff810d2f54>]  [<ffffffff810d2f54>]
futex_wake+0x74/0x130
[    3.174195] RSP: 0018:ffff8802311dbda8  EFLAGS: 00010246
[    3.174249] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 000000007=
f125139
[    3.174306] RDX: 0000000000000000 RSI: 000000003c28288f RDI: ffffffff8=
222ee70
[    3.174363] RBP: ffff8802311dbe08 R08: 00000000efa13b63 R09: 000000000=
0000000
[    3.174420] R10: 0000000000000000 R11: 0000000000000202 R12: ffffffff8=
222ee70
[    3.174477] R13: 00000000ffffffff R14: ffffffff8222ee78 R15: 000000000=
0000000
[    3.174535] FS:  00007ff44c2a3700(0000) GS:ffff88023bc00000(0000)
knlGS:0000000000000000
[    3.174620] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    3.174676] CR2: 0000000000000000 CR3: 0000000231d61000 CR4: 000000000=
00407f0
[    3.174734] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 000000000=
0000000
[    3.174791] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 000000000=
0000400
[    3.174849] Process modprobe (pid: 615, threadinfo ffff8802311da000, t=
ask
ffff880231e272c0)
[    3.174935] Stack:
[    3.174984]  ffff880231d62a10 0000000100000001 00000000000007f8 00007f=
ff78d0a000
[    3.175139]  ffff8802311e8000 000000000000091c ffff8802311dbdf8 000000=
0000000000
[    3.175293]  0000000000000000 0000000000000001 00007fff78d0a91c 000000=
0000000001
[    3.175447] Call Trace:
[    3.175499]  [<ffffffff810d4d40>] do_futex+0x100/0xab0
[    3.175555]  [<ffffffff819772d4>] ? __do_page_fault+0x244/0x4e0
[    3.175611]  [<ffffffff811806f1>] ? mntput+0x21/0x30
[    3.175666]  [<ffffffff81164c7b>] ? __fput+0x16b/0x240
[    3.175721]  [<ffffffff810d5778>] sys_futex+0x88/0x180
[    3.175775]  [<ffffffff81977579>] ? do_page_fault+0x9/0x10
[    3.175830]  [<ffffffff8197a252>] system_call_fastpath+0x16/0x1b
[    3.175886] Code: ff ff 85 c0 41 89 c7 0f 85 b0 00 00 00 48 8d 7d b8 e=
8 61 f9
ff ff 49 89 c4 48 89 c7 e8 46 0d 8a 00 49 8b 44 24 08 4d 8d 74 24 08 <48>=
 8b 18
48 8d 78 e8 48 83 eb 18 49 39 c6 75 23 eb 6a 66 2e 0f
[    3.176678] RIP  [<ffffffff810d2f54>] futex_wake+0x74/0x130
[    3.176678]  RSP <ffff8802311dbda8>
[    3.176678] CR2: 0000000000000000
[    3.177366] ---[ end trace 7213d911e494c10b ]---
[    3.177823] BUG: unable to handle kernel NULL pointer dereference
at           (null)
[    3.177944] IP: [<ffffffff810d2f54>] futex_wake+0x74/0x130
[    3.178017] PGD 2311f4067 PUD 2311f5067 PMD 0
[    3.178122] Oops: 0000 [#2] SMP
[    3.178207] Modules linked in:
[    3.178274] CPU 0
[    3.178296] Pid: 617, comm: modprobe Tainted: G      D    =20
3.9.6-OSS4.2-dirty #34                  /DQ45CB
[    3.178428] RIP: 0010:[<ffffffff810d2f54>]  [<ffffffff810d2f54>]
futex_wake+0x74/0x130
[    3.178531] RSP: 0018:ffff880231213da8  EFLAGS: 00010246
[    3.178585] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 000000000=
06a3b48
[    3.178643] RDX: 0000000000000000 RSI: 000000001d796f0a RDI: ffffffff8=
222ec60
[    3.178700] RBP: ffff880231213e08 R08: 00000000cbc14f19 R09: 000000000=
0000000
[    3.178758] R10: 0000000000000000 R11: 0000000000000202 R12: ffffffff8=
222ec60
[    3.178816] R13: 00000000ffffffff R14: ffffffff8222ec68 R15: 000000000=
0000000
[    3.178873] FS:  00007f5baf639700(0000) GS:ffff88023bc00000(0000)
knlGS:0000000000000000
[    3.178958] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    3.179013] CR2: 0000000000000000 CR3: 00000002311f7000 CR4: 000000000=
00407f0
[    3.179071] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 000000000=
0000000
[    3.179128] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 000000000=
0000400
[    3.179185] Process modprobe (pid: 617, threadinfo ffff880231212000, t=
ask
ffff880231e26540)
[    3.179270] Stack:
[    3.179318]  ffff8802311f3a10 0000000100000001 00000000000007f0 00007f=
ff80ed6000
[    3.179472]  ffff8802311e8340 000000000000082c ffff880231213df8 000000=
0000000000
[    3.179626]  0000000000000000 0000000000000001 00007fff80ed682c 000000=
0000000001
[    3.179780] Call Trace:
[    3.179829]  [<ffffffff810d4d40>] do_futex+0x100/0xab0
[    3.179884]  [<ffffffff819772d4>] ? __do_page_fault+0x244/0x4e0
[    3.179940]  [<ffffffff811806f1>] ? mntput+0x21/0x30
[    3.179994]  [<ffffffff81164c7b>] ? __fput+0x16b/0x240
[    3.180071]  [<ffffffff810d5778>] sys_futex+0x88/0x180
[    3.180126]  [<ffffffff81977579>] ? do_page_fault+0x9/0x10
[    3.180183]  [<ffffffff8197a252>] system_call_fastpath+0x16/0x1b
[    3.180238] Code: ff ff 85 c0 41 89 c7 0f 85 b0 00 00 00 48 8d 7d b8 e=
8 61 f9
ff ff 49 89 c4 48 89 c7 e8 46 0d 8a 00 49 8b 44 24 08 4d 8d 74 24 08 <48>=
 8b 18
48 8d 78 e8 48 83 eb 18 49 39 c6 75 23 eb 6a 66 2e 0f
[    3.180892] RIP  [<ffffffff810d2f54>] futex_wake+0x74/0x130
[    3.180892]  RSP <ffff880231213da8>
[    3.180892] CR2: 0000000000000000
[    3.181699] ---[ end trace 7213d911e494c10c ]---

This is obviously happening while booting and udev is loading *some* modu=
le, but
I have no idea which module is affected as such.

Luckily, my module list is quite concise:
Module                  Size  Used by
xt_conntrack            3129  7
xt_dscp                 1627  12
ath9k                 158146  0
ath9k_common            1928  1 ath9k
ath9k_hw              415466  2 ath9k_common,ath9k
ath                    15622  3 ath9k_common,ath9k,ath9k_hw
mac80211              309142  1 ath9k
kvm_intel             120679  0
cfg80211              195508  3 ath,ath9k,mac80211
i915                  516965  2
rfkill                 15045  2 cfg80211
kvm                   263860  1 kvm_intel
cp210x                 14910  2
drm_kms_helper         27953  1 i915
e1000e                222638  0
ptp                     7996  1 e1000e
pps_core                8569  1 ptp
video                  11025  1 i915
backlight               4688  1 video

I guess I can rule out ath9k, ath9k_common, ath9k_hw, ath, mac80211, cfg8=
0211,
rfkill, kvm_intel and cp210x. Unloading and reloading them again are not =
causing
any oopses, so that's that. xt_conntrack and xt_dscp can't be unloaded, u=
nless I
remove all iptables rules...  but I don't think those are the root cause =
either.

Anyway, I'd be happy to try to test more, but first of all, what are the =
oopses
telling me, anyway? The kernel is not oopsing *in* a module, so... hum...=

Also, it's oopsing two times at boot time, but all modules are being load=
ed just
fine afterwards, I'm not missing any module and I'm not having defunct mo=
dprobe
proccesses. I'm a little bit puzzled.

Anyone care to shed some light on that?


Best regards,



Mihai


--------------ms060202040105070200010500
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
DxcNMTMwNzE0MjM1NDU1WjAjBgkqhkiG9w0BCQQxFgQUoeQrKzqeIzBw2LZEcWn7uCKdOWEw
bAYJKoZIhvcNAQkPMV8wXTALBglghkgBZQMEASowCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMH
MA4GCCqGSIb3DQMCAgIAgDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggqhkiG9w0DAgIB
KDCBpAYJKwYBBAGCNxAEMYGWMIGTMIGMMQswCQYDVQQGEwJJTDEWMBQGA1UEChMNU3RhcnRD
b20gTHRkLjErMCkGA1UECxMiU2VjdXJlIERpZ2l0YWwgQ2VydGlmaWNhdGUgU2lnbmluZzE4
MDYGA1UEAxMvU3RhcnRDb20gQ2xhc3MgMiBQcmltYXJ5IEludGVybWVkaWF0ZSBDbGllbnQg
Q0ECAh5/MIGmBgsqhkiG9w0BCRACCzGBlqCBkzCBjDELMAkGA1UEBhMCSUwxFjAUBgNVBAoT
DVN0YXJ0Q29tIEx0ZC4xKzApBgNVBAsTIlNlY3VyZSBEaWdpdGFsIENlcnRpZmljYXRlIFNp
Z25pbmcxODA2BgNVBAMTL1N0YXJ0Q29tIENsYXNzIDIgUHJpbWFyeSBJbnRlcm1lZGlhdGUg
Q2xpZW50IENBAgIefzANBgkqhkiG9w0BAQEFAASCAQB5Z8bGIYKNubDoTRiSUZjmD6NqR2DY
W4Gh28VaV1AHBmYxBIKiccaU6iKuJLy5MIQoV5xOC6ANDY25LyE1sy+GZfTx/KIdkLClGKxb
1ZgbHt5z775RQVM8PwpznVV3jO6kEEeGY9msI25lWhBT3cypdxlT0XtamqIPyiCeNsYWUxx0
VnIQlTVbna4QmEbLDXPLBc8B40ku62TWSIZruDPlIKQeNvv9c2PmrfblEG/NRclzMXC3xqbs
qdjjrQNdFHUnr3t8D2s5gu50eWv2Yv/wkLxpNkcNbv3hpdb/UP+w6hPAgYB2+spOEHdUX7U6
NpDzFlozcwWhkPp58crrmsq1AAAAAAAA
--------------ms060202040105070200010500--
