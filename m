Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756836AbaEJWiS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2014 18:38:18 -0400
Received: from powered.by.root24.eu ([91.121.15.64]:43550 "EHLO Root24.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752174AbaEJWiQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2014 18:38:16 -0400
X-Greylist: delayed 408 seconds by postgrey-1.27 at vger.kernel.org; Sat, 10 May 2014 18:38:16 EDT
Message-ID: <536EA8BB.4090403@ionic.de>
Date: Sun, 11 May 2014 00:31:23 +0200
From: Mihai Moldovan <ionic@ionic.de>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Pablo Neira Ayuso <pablo@netfilter.org>, Patrick McHardy <kaber@trash.net>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: NULL pointer dereference in netfilter
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms040206000104070205070903"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms040206000104070205070903
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi

earlier today, I experienced a kernel panic due to a NULL pointer derefer=
ence
somewhere in the netfilter subsystem.

Full kernel output (may contain typos):

[360412.114033] BUG: unable to handle kernel NULL pointer dereference at
0000000000000010
[360412.115643] IP: [<ffffffff81865efe>] nf_nat_setup_info+0x56e/0x900
[360412.117244] PGD: 0
[360412.117337] Oops: 0002 [#3] SMP
[360412.117337] Modules linked in: ath9k ath9k_common ath9k_hw ath mac802=
11
cfg80211 xt_conntrack xt_dscp kvm_intel kvm hfcsusb mISDN_core e1000e cp2=
10x
i915 rfkil ptp video pps_core drm_kms_helper backlight [last unloaded: cf=
g80211]
[360412.117337] CPU: 2 PID: 0 Comm: swapper/2 Tainted: G       D    O
3.14.2-OSS4.2 #2
[360412.117337] Hardware name:                  /DQ45CB, BIOS
CBQ4510H.86A.0133.2011.0810.1010 08/10/2011
[360412.117337] task: ffff8802321c5540 ti: ffff8802321f4000 task.ti:
ffff8802321f40000
[360412.117337] RIP: 0010:[<ffffffff81865efe>]  [<ffffffff81865efe>]
nf_nat_setup_info+0x56e/0x900
[360412.117337] RSP: 0018:ffff88023bd03668   EFLAGS: 000010246
[360412.117337] RAX: 0000000000000000 RBX: ffff8800b073d380 RCX: 00000000=
0ae3d87f
[360412.117337] RDX: ffff88021cdc9800 RSI: 00000000b8061897 RDI: ffffffff=
824808b8
[360412.117337] RBP: ffff88023bd03748 R08: ffff88003773e000 R09: ffffffff=
820ac780
[360412.117337] R10: ffff88021cdc9800 R11: ffff88021cdc98e0 R12: 00000000=
0000235d
[360412.117337] R13: 0000000000000000 R14: ffff88023bd03698 R15: ffff8802=
3bd036c0
[360412.117337] FS:  0000000000000000(0000) GS:ffff88023bd00000(0000)
knlGS:0000000000000000
[360412.117337] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[360412.117337] CR2: 0000000000000010 CR3: 000000000200b000 CR4: 00000000=
000407e0
[360412.117337] Stack:
[360412.117337]  ffffffff820ac780 ffffffff81d905b0 ffff88023bd036c0 fffff=
fff820ac780
[360412.117337]  ffffffff81d964e0 ffffffff81d906a0 00000000df8e782a 00000=
00000000000
[360412.117337]  8343b75500027f96 0000000000000000 0006bb0600000000 00000=
0008343b755
[360412.117337] Call Trace:
[360412.117337]  <IRQ>
[360412.117337]  [<ffffffff81874e9f>] xt_snat_target_v0+0x6f/0x90
[360412.117337]  [<ffffffff818e0453>] ipt_do_table+0x2c3/0x6c0
[360412.117337]  [<ffffffff818e04b6>] ? ipt_do_table+0x326/0x6c0
[360412.117337]  [<ffffffff818e0d07>] nf_nat_ipv6_fn+0x1d7/0x330
[360412.117337]  [<ffffffff81888e20>] ? __ip_append_data.isra.43+0xa30/0x=
a30
[360412.117337]  [<ffffffff818e1068>] nf_nat_ipv4_out+0x58/0x100
[360412.117337]  [<ffffffff81888e20>] ? __ip_append_data.isra.43+0xa30/0x=
a30
[360412.117337]  [<ffffffff81846b75>] nf_iterate+0x85/0xb0
[360412.117337]  [<ffffffff81888e20>] ? __ip_append_data.isra.43+0xa30/0x=
a30
[360412.117337]  [<ffffffff81846c0c>] nf_hook_slow+0x6c/0x130
[360412.117337]  [<ffffffff81888e20>] ? __ip_append_data.isra.43+0xa30/0x=
a30
[360412.117337]  [<ffffffff81889bb2>] ip_output+0x82/0x90
[360412.117337]  [<ffffffff81889314>] ip_local_out+0x24/0x30
[360412.117337]  [<ffffffff818e2182>] reject_tg+0x4d2/0x4e0
[360412.117337]  [<ffffffff818e0453>] ipt_do_table+0x2c3/0x6c0
[360412.117337]  [<ffffffff81883f30>] ? ip_rcv_finish+0x360/0x360
[360412.117337]  [<ffffffff818e0924>] iptable_filter_hook+0x34/0x70
[360412.117337]  [<ffffffff81846b75>] nf_iterate+0x85/0xb0
[360412.117337]  [<ffffffff81883f30>] ? ip_rcv_finish+0x360/0x360
[360412.117337]  [<ffffffff81846c0c>] nf_hook_slow+0x6c/0x130
[360412.117337]  [<ffffffff81883f30>] ? ip_rcv_finish+0x360/0x360
[360412.117337]  [<ffffffff81884303>] ip_local_deliver+0x73/0x80
[360412.117337]  [<ffffffff81883c53>] ip_rcv_finish+0x83/0x360
[360412.117337]  [<ffffffff818845b8>] ip_rcv+0x2a8/0x3e0
[360412.117337]  [<ffffffff817e7bb2>] __netif_receive_skb_core+0x632/0x7a=
0
[360412.117337]  [<ffffffff817e7d3c>] __netif_receive_skb+0x1c/0x70
[360412.117337]  [<ffffffff817e7e2c>] process_backlog+0x9c/0x170
[360412.117337]  [<ffffffff817e823b>] net_rx_action+0xfb/0x1a0
[360412.117337]  [<ffffffff810c3e65>] __do_softirq+0xd5/0x1f0
[360412.117337]  [<ffffffff810c4185>] irq_exit+0x95/0xa0
[360412.117337]  [<ffffffff81003d82>] do_IRQ+0x62/0x110
[360412.117337]  [<ffffffff81a20d67>] common_interrupt_0x67/0x67
[360412.117337]  <EOI>
[360412.117337]  [<ffffffff81791ce6>] ? cpuidle_enter_state+0x56/0xd0
[360412.117337]  [<ffffffff81791ce2>] ? cpuidle_enter_state+0x52/0xd0
[360412.117337]  [<ffffffff81791dfa>] cpuidle_idle_call+0x9a/0x140
[360412.117337]  [<ffffffff8100afe9>] arch_cpu_idle+0x9/0x20
[360412.117337]  [<ffffffff8110a81a>] cpu_startup_entry+0xda/0x1c0
[360412.117337]  [<ffffffff8102a1ad>] start_secondary+0x20d/0x2c0
[360412.117337] Code: e0 e8 a7 a9 1b 00 48 8b 93 e0 00 00 00 49 c1 ec 20 =
48 85
d2 74 0c 0f b6 42 11 84 c0 0f 85 93 02 00 00 31 c0 4c 8b 8d 38 ff ff ff <=
48> 89
58 10 49 8b 91 70 0b 00 00 4a 8d 14 e2 48 8b 0a 48 89 50
[360412.117337] RIP  [<ffffffff81865efe>] nf_nat_setup_info+0x56e/0x900
[360412.117337]  RSP <ffff88023bd03668>
[360412.117337] CR2: 0000000000000010
[360412.117337] - - -[ end trace 691638412d73c338 ]- - -
[360412.117337] Kernel panic - not syncing: Fatal exception in interrupt
[360412.117337] Kernel Offset: 0x0 from 0xffffffff81000000 (relocation ra=
nge:
0xffffffff80000000-0xffffffff9fffffff)
[360412.117337] drm_kms_helper: panic occurred, switching back to text co=
nsole


decodecode:

All code
=3D=3D=3D=3D=3D=3D=3D=3D
   0:    e0 e8                    loopne 0xffffffffffffffea
   2:    a7                       cmpsl  %es:(%rdi),%ds:(%rsi)
   3:    a9 1b 00 48 8b           test   $0x8b48001b,%eax
   8:    93                       xchg   %eax,%ebx
   9:    e0 00                    loopne 0xb
   b:    00 00                    add    %al,(%rax)
   d:    49 c1 ec 20              shr    $0x20,%r12
  11:    48 85 d2                 test   %rdx,%rdx
  14:    74 0c                    je     0x22
  16:    0f b6 42 11              movzbl 0x11(%rdx),%eax
  1a:    84 c0                    test   %al,%al
  1c:    0f 85 93 02 00 00        jne    0x2b5
  22:    31 c0                    xor    %eax,%eax
  24:    4c 8b 8d 38 ff ff ff     mov    -0xc8(%rbp),%r9
  2b:*    48 89 58 10              mov    %rbx,0x10(%rax)        <-- trap=
ping
instruction
  2f:    49 8b 91 70 0b 00 00     mov    0xb70(%r9),%rdx
  36:    4a 8d 14 e2              lea    (%rdx,%r12,8),%rdx
  3a:    48 8b 0a                 mov    (%rdx),%rcx
  3d:    48                       rex.W
  3e:    89                       .byte 0x89
  3f:    50                       push   %rax

Code starting with the faulting instruction
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
   0:    48 89 58 10              mov    %rbx,0x10(%rax)
   4:    49 8b 91 70 0b 00 00     mov    0xb70(%r9),%rdx
   b:    4a 8d 14 e2              lea    (%rdx,%r12,8),%rdx
   f:    48 8b 0a                 mov    (%rdx),%rcx
  12:    48                       rex.W
  13:    89                       .byte 0x89
  14:    50                       push   %rax


And, if it's of any interest (at least I've seen snat in there, so I'm go=
ing
ahead with this), one of the many rules in iptables:

Chain POSTROUTING (policy ACCEPT 1836 packets, 89722 bytes)
2189  157K SNAT       all  --  *      ppp0    0.0.0.0/0          =20
0.0.0.0/0            to:85.183.67.131


Can/should I provide any more information?

Unfortunately, I don't have a full packet log of my network when the issu=
e
happened. It came pretty much out of the blue.


Best regards,


Mihai


--------------ms040206000104070205070903
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIMkTCC
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
XmZz/OTfyJXsUOUXrym6KvI2rYpccSk5MIIGVTCCBT2gAwIBAgICR5UwDQYJKoZIhvcNAQEL
BQAwgYwxCzAJBgNVBAYTAklMMRYwFAYDVQQKEw1TdGFydENvbSBMdGQuMSswKQYDVQQLEyJT
ZWN1cmUgRGlnaXRhbCBDZXJ0aWZpY2F0ZSBTaWduaW5nMTgwNgYDVQQDEy9TdGFydENvbSBD
bGFzcyAyIFByaW1hcnkgSW50ZXJtZWRpYXRlIENsaWVudCBDQTAeFw0xNDAzMTkwNDMzMzFa
Fw0xNjAzMTgxNTIzMjJaMHYxCzAJBgNVBAYTAkRFMRswGQYDVQQIExJCYWRlbi1XdWVydHRl
bWJlcmcxEjAQBgNVBAcTCUthcmxzcnVoZTEXMBUGA1UEAxMOTWloYWkgTW9sZG92YW4xHTAb
BgkqhkiG9w0BCQEWDmlvbmljQGlvbmljLmRlMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIB
CgKCAQEAy1U08dzMfc3SpuUBHL+ZgUQJs4gX7DLBAr89BAoQkIEkMhlEGJ1OGBqvbOuGBlyd
l/BSa/vrkTFqrHjxs4UhYG/nide97RsalQ39eolmd/WSn1I0M3Ohg/LAnCt2v9mMx1Sx8QpE
jzLVvdMwO4mEJWH4+w8e8bLLIzN66/rAuD0EVeyWJh6pggCjI+Y59t0aqI7vzjcqgJGtmwHZ
VPtBhWP3jsDUhLjwxUeydFEwteh/fpo3czx4aKKMH0K53HHGfGZHl5IK/E8ZdL+veF4JSRs5
nCKAikwbtua3sMY1ejPRc2L5CyZAJvmfaKjBCi5/3j/DxYrEK+sH32AYUxbgYQIDAQABo4IC
1DCCAtAwCQYDVR0TBAIwADALBgNVHQ8EBAMCBLAwHQYDVR0lBBYwFAYIKwYBBQUHAwIGCCsG
AQUFBwMEMB0GA1UdDgQWBBSaZelU6HGlOzMKCINjBgsaA/nXxTAfBgNVHSMEGDAWgBSuVYNv
7DHKufcd+q9rMfPIHeOsuzAZBgNVHREEEjAQgQ5pb25pY0Bpb25pYy5kZTCCAUwGA1UdIASC
AUMwggE/MIIBOwYLKwYBBAGBtTcBAgMwggEqMC4GCCsGAQUFBwIBFiJodHRwOi8vd3d3LnN0
YXJ0c3NsLmNvbS9wb2xpY3kucGRmMIH3BggrBgEFBQcCAjCB6jAnFiBTdGFydENvbSBDZXJ0
aWZpY2F0aW9uIEF1dGhvcml0eTADAgEBGoG+VGhpcyBjZXJ0aWZpY2F0ZSB3YXMgaXNzdWVk
IGFjY29yZGluZyB0byB0aGUgQ2xhc3MgMiBWYWxpZGF0aW9uIHJlcXVpcmVtZW50cyBvZiB0
aGUgU3RhcnRDb20gQ0EgcG9saWN5LCByZWxpYW5jZSBvbmx5IGZvciB0aGUgaW50ZW5kZWQg
cHVycG9zZSBpbiBjb21wbGlhbmNlIG9mIHRoZSByZWx5aW5nIHBhcnR5IG9ibGlnYXRpb25z
LjA2BgNVHR8ELzAtMCugKaAnhiVodHRwOi8vY3JsLnN0YXJ0c3NsLmNvbS9jcnR1Mi1jcmwu
Y3JsMIGOBggrBgEFBQcBAQSBgTB/MDkGCCsGAQUFBzABhi1odHRwOi8vb2NzcC5zdGFydHNz
bC5jb20vc3ViL2NsYXNzMi9jbGllbnQvY2EwQgYIKwYBBQUHMAKGNmh0dHA6Ly9haWEuc3Rh
cnRzc2wuY29tL2NlcnRzL3N1Yi5jbGFzczIuY2xpZW50LmNhLmNydDAjBgNVHRIEHDAahhho
dHRwOi8vd3d3LnN0YXJ0c3NsLmNvbS8wDQYJKoZIhvcNAQELBQADggEBAH650RIseEtEpaRd
Av66u9KEu5mxHpRH8IopkCkwGBk95sSKSWVqJ6XbTHywi66GAqQ7LPlD5ittkhTlYtyst8vb
FLaafu6Ous2UDZhqJH1NHfRaG6m0Qt2Zm7KQsaxIhBEYFqqMxSq2E8DQU6WUB473bEqToVx+
pumW+T/KSnHq+FfCGSPvXtwkRP4eiJmvNPZKhGRk3RPkT3LzA380mX6DpcqEQ1a8TmsFBZ7c
AMa7KKDe4YnxDFSE/2C1WA5bibpmkCGa+R/0KBBWxDrzNUv6W8Ui6OzpkHTaqg+c9NpC1wDl
xt3r8GaytqtcHfB2VEbPd0Hrd+zrDh3co8/SkqgxggPaMIID1gIBATCBkzCBjDELMAkGA1UE
BhMCSUwxFjAUBgNVBAoTDVN0YXJ0Q29tIEx0ZC4xKzApBgNVBAsTIlNlY3VyZSBEaWdpdGFs
IENlcnRpZmljYXRlIFNpZ25pbmcxODA2BgNVBAMTL1N0YXJ0Q29tIENsYXNzIDIgUHJpbWFy
eSBJbnRlcm1lZGlhdGUgQ2xpZW50IENBAgJHlTAJBgUrDgMCGgUAoIICGzAYBgkqhkiG9w0B
CQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0xNDA1MTAyMjMxMjNaMCMGCSqGSIb3
DQEJBDEWBBT7mTfQbE1wgN7QwqXQKvoKkSnTDDBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFl
AwQBKjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3
DQMCAgFAMAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGkBgkrBgEEAYI3EAQxgZYwgZMwgYwx
CzAJBgNVBAYTAklMMRYwFAYDVQQKEw1TdGFydENvbSBMdGQuMSswKQYDVQQLEyJTZWN1cmUg
RGlnaXRhbCBDZXJ0aWZpY2F0ZSBTaWduaW5nMTgwNgYDVQQDEy9TdGFydENvbSBDbGFzcyAy
IFByaW1hcnkgSW50ZXJtZWRpYXRlIENsaWVudCBDQQICR5UwgaYGCyqGSIb3DQEJEAILMYGW
oIGTMIGMMQswCQYDVQQGEwJJTDEWMBQGA1UEChMNU3RhcnRDb20gTHRkLjErMCkGA1UECxMi
U2VjdXJlIERpZ2l0YWwgQ2VydGlmaWNhdGUgU2lnbmluZzE4MDYGA1UEAxMvU3RhcnRDb20g
Q2xhc3MgMiBQcmltYXJ5IEludGVybWVkaWF0ZSBDbGllbnQgQ0ECAkeVMA0GCSqGSIb3DQEB
AQUABIIBAAqWhlUqbFvQueM4nfyrcxTSbqs882E2kAjyRexbvAJTgS9/YHlOrIyN7lUUUYj4
4hj9Na/59QuvmiMlEm/rG9riBRH+A0kjoKvl99p7TSWnnlcwKvPui/m0oaDe8XZR8kU5PEWD
elVcib7ZLcUgPEiRPVzgakBiNI+Az62vlJ+P9iDTXyK/Ec8xlCgCn3aDEgf3TQWfvpA4uHYX
sB/RkalthBL1WMJSqWZb49pNdZ5bE6KT8qHyFTCrGItyO7MGkwMXYpjFDmW/iSEL+K4W2kft
vPzKxzdiJoumdLKzeficS5f2iJu59WP4bok5AMdF+GmVc628DgVrOYLN/XyQHnEAAAAAAAA=
--------------ms040206000104070205070903--
