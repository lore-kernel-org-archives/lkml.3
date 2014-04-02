Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758230AbaDBIuj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 04:50:39 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:43315 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758052AbaDBIug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 04:50:36 -0400
From: David Peall <dkpeall@gmail.com>
Content-Type: multipart/signed; boundary="Apple-Mail=_B5C6AC04-002E-4C87-ACB2-292023D47338"; protocol="application/pkcs7-signature"; micalg=sha1
Subject: PROBLEM: IP Virtual Server for IPv6 broken Kernel version 3.6.11+
Date: Wed, 2 Apr 2014 10:50:28 +0200
Message-Id: <185D2915-2506-47DA-BD07-451D5994CEDC@gmail.com>
Cc: eppdev <eppdev@dnservices.co.za>
To: linux-kernel@vger.kernel.org
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
X-Mailer: Apple Mail (2.1874)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Apple-Mail=_B5C6AC04-002E-4C87-ACB2-292023D47338
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=windows-1252

[1.] One line summary of the problem:   =20

IP Virtual Server has stopped working with IPv6 virtual services since =
kernel version 3.6.11.

[2.] Full description of the problem/report:

After upgrading a server I use as a load balancer none of my ipv6 =
services load anymore.  I suspected the problem was the upgrade of =
keepalived from 1.2.2 to 1.2.7 but after compiling 1.2.12 form source it =
still didn=92t work.  I then looked at the IP Virtual Server and tried a =
number of kernels and eventual tracked down where it broke

http://kernel.ubuntu.com/~kernel-ppa/mainline/v3.6.11-raring/ seems to =
be where it broke

Working:
http://kernel.ubuntu.com/~kernel-ppa/mainline/v3.2.56-precise/ - works
http://kernel.ubuntu.com/~kernel-ppa/mainline/v3.3.8-quantal/ - works
http://kernel.ubuntu.com/~kernel-ppa/mainline/v3.4.85-quantal/ - works
http://kernel.ubuntu.com/~kernel-ppa/mainline/v3.5.7.32-quantal/ - works
http://kernel.ubuntu.com/~kernel-ppa/mainline/v3.6-quantal/ - works
http://kernel.ubuntu.com/~kernel-ppa/mainline/v3.6.3-quantal/ - works
http://kernel.ubuntu.com/~kernel-ppa/mainline/v3.6.4-raring/ - works
http://kernel.ubuntu.com/~kernel-ppa/mainline/v3.6.5-raring/ - works
http://kernel.ubuntu.com/~kernel-ppa/mainline/v3.6.8-raring/ - works
http://kernel.ubuntu.com/~kernel-ppa/mainline/v3.6.10-raring/ - works

Broken:
http://kernel.ubuntu.com/~kernel-ppa/mainline/v3.6.11-raring/ - broken
http://kernel.ubuntu.com/~kernel-ppa/mainline/v3.13.8-trusty/ - broken
http://kernel.ubuntu.com/~kernel-ppa/mainline/v3.14-trusty/ - broken

I get the following message when trying to list a virtual service:
ipvsadm -L -t [2001:xxxx:xxxx::xxx]:xxx
Resource temporarily unavailable

I initially though the problem was with keepalived and reported it here:
https://bugs.launchpad.net/ubuntu/+source/keepalived/+bug/1300739

[3.] Keywords (i.e., modules, networking, kernel):

kernel, ipv6, ipvs

[4.] Kernel version (from /proc/version):

Linux version 3.6.11-030611-generic (root@gomeisa) (gcc version 4.6.3 =
(Ubuntu/Linaro 4.6.3-1ubuntu5) ) #201212171335 SMP Mon Dec 17 18:36:00 =
UTC 2012

[5.] Output of Oops.. message (if applicable) with symbolic information=20=

     resolved (see Documentation/oops-tracing.txt)

N/A

[6.] A small shell script or example program which triggers the
     problem (if possible)
[7.] Environment
[7.1.] Software (add the output of the ver_linux script here)

Ubuntu server 14.04

[7.2.] Processor information (from /proc/cpuinfo):

Virtual (KVM)

[7.3.] Module information (from /proc/modules):
[7.4.] Loaded driver and hardware information (/proc/ioports, =
/proc/iomem)
[7.5.] PCI information ('lspci -vvv' as root)
[7.6.] SCSI information (from /proc/scsi/scsi)
[7.7.] Other information that might be relevant to the problem
       (please look in /proc and include all information that you
       think to be relevant):

cat /proc/net/ip_vs
IP Virtual Server version 1.2.1 (size=3D4096)
Prot LocalAddress:Port Scheduler Flags
  -> RemoteAddress:Port Forward Weight ActiveConn InActConn

On kernel versions before 3.6.11 i get the following:
IP Virtual Server version 1.2.1 (size=3D4096)
Prot LocalAddress:Port Scheduler Flags
  -> RemoteAddress:Port           Forward Weight ActiveConn InActConn
TCP  [2001:xxx:xxx::xxx]:xxxx lc persistent 1
  -> [2001:xxx:xxx::x:xxx]:xxxx   Route   1      0          0 =20

[X.] Other notes, patches, fixes, workarounds:



--Apple-Mail=_B5C6AC04-002E-4C87-ACB2-292023D47338
Content-Disposition: attachment;
	filename=smime.p7s
Content-Type: application/pkcs7-signature;
	name=smime.p7s
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIINfTCCBjQw
ggQcoAMCAQICASAwDQYJKoZIhvcNAQEFBQAwfTELMAkGA1UEBhMCSUwxFjAUBgNVBAoTDVN0YXJ0
Q29tIEx0ZC4xKzApBgNVBAsTIlNlY3VyZSBEaWdpdGFsIENlcnRpZmljYXRlIFNpZ25pbmcxKTAn
BgNVBAMTIFN0YXJ0Q29tIENlcnRpZmljYXRpb24gQXV0aG9yaXR5MB4XDTA3MTAyNDIxMDI1NVoX
DTE3MTAyNDIxMDI1NVowgYwxCzAJBgNVBAYTAklMMRYwFAYDVQQKEw1TdGFydENvbSBMdGQuMSsw
KQYDVQQLEyJTZWN1cmUgRGlnaXRhbCBDZXJ0aWZpY2F0ZSBTaWduaW5nMTgwNgYDVQQDEy9TdGFy
dENvbSBDbGFzcyAyIFByaW1hcnkgSW50ZXJtZWRpYXRlIENsaWVudCBDQTCCASIwDQYJKoZIhvcN
AQEBBQADggEPADCCAQoCggEBAMsohUWcASz7GfKrpTOMKqANy9BV7V0igWdGxA8IU77L3aTxErQ+
fcxtDYZ36Z6GH0YFn7fq5RADteP0AYzrCA+EQTfi8q1+kA3m0nwtwXG94M5sIqsvs7lRP1aycBke
/s5g9hJHryZ2acScnzczjBCAo7X1v5G3yw8MDP2m2RCye0KfgZ4nODerZJVzhAlOD9YejvAXZqHk
sw56HzElVIoYSZ3q4+RJuPXXfIoyby+Y2m1E+YzX5iCZXBx05gk6MKAW1vaw4/v2OOLy6FZH3XHH
tOkzUreG//CsFnB9+uaYSlR65cdGzTsmoIK8WH1ygoXhRBm98SD7Hf/r3FELNvUCAwEAAaOCAa0w
ggGpMA8GA1UdEwEB/wQFMAMBAf8wDgYDVR0PAQH/BAQDAgEGMB0GA1UdDgQWBBSuVYNv7DHKufcd
+q9rMfPIHeOsuzAfBgNVHSMEGDAWgBROC+8apEBbpRdphzDKNGhD0EGu8jBmBggrBgEFBQcBAQRa
MFgwJwYIKwYBBQUHMAGGG2h0dHA6Ly9vY3NwLnN0YXJ0c3NsLmNvbS9jYTAtBggrBgEFBQcwAoYh
aHR0cDovL3d3dy5zdGFydHNzbC5jb20vc2ZzY2EuY3J0MFsGA1UdHwRUMFIwJ6AloCOGIWh0dHA6
Ly93d3cuc3RhcnRzc2wuY29tL3Nmc2NhLmNybDAnoCWgI4YhaHR0cDovL2NybC5zdGFydHNzbC5j
b20vc2ZzY2EuY3JsMIGABgNVHSAEeTB3MHUGCysGAQQBgbU3AQIBMGYwLgYIKwYBBQUHAgEWImh0
dHA6Ly93d3cuc3RhcnRzc2wuY29tL3BvbGljeS5wZGYwNAYIKwYBBQUHAgEWKGh0dHA6Ly93d3cu
c3RhcnRzc2wuY29tL2ludGVybWVkaWF0ZS5wZGYwDQYJKoZIhvcNAQEFBQADggIBADqpJw3I07QW
ke9plNBpxUxcffc7nUrIQpJHDci91DFG7fVhHRkMZ1J+BKg5UNUxIFJ2Z9B90Micc/NXcs7kPBRd
n6XGO/vPc87Y6R+cWS9Nc9+fp3Enmsm94OxOwI9wn8qnr/6o3mD4noP9JphwUPTXwHovjavRnhUQ
HLfo/i2NG0XXgTHXS2Xm0kVUozXqpYpAdumMiB/vezj1QHQJDmUdPYMcp+reg9901zkyT3fDW/iv
JVv6pWtkh6Pw2ytZT7mvg7YhX3V50Nv860cV11mocUVcqBLv0gcT+HBDYtbuvexNftwNQKD5193A
7zN4vG7CTYkXxytSjKuXrpEatEiFPxWgb84nVj25SU5q/r1Xhwby6mLhkbaXslkVtwEWT3Van49r
KjlK4XrUKYYWtnfzq6aSak5u0Vpxd1rY79tWhD3EdCvOhNz/QplNa+VkIsrcp7+8ZhP1l1b2U6Ma
xIVteuVMD3X0vziIwr7jxYae9FZjbxlpUemqXjcC0QaFfN7qI0JsQMALL7iGRBg7K0CoOBzECdD3
fuZil5kU/LP9cr1BK31U0Uy651bFnAMMMkqhAChIbn0ei72VnbpSsrrSdF0BAGYQ8vyHae5aCg+H
75dVCV33K6FuxZrf09yTz+Vx/PkdRUYkXmZz/OTfyJXsUOUXrym6KvI2rYpccSk5MIIHQTCCBimg
AwIBAgICIRwwDQYJKoZIhvcNAQEFBQAwgYwxCzAJBgNVBAYTAklMMRYwFAYDVQQKEw1TdGFydENv
bSBMdGQuMSswKQYDVQQLEyJTZWN1cmUgRGlnaXRhbCBDZXJ0aWZpY2F0ZSBTaWduaW5nMTgwNgYD
VQQDEy9TdGFydENvbSBDbGFzcyAyIFByaW1hcnkgSW50ZXJtZWRpYXRlIENsaWVudCBDQTAeFw0x
MjA1MTcwMzQzMTFaFw0xNDA1MTgwNzMzNTlaMIGJMRkwFwYDVQQNExB0SGJCY1FFamw1elZIM3I2
MQswCQYDVQQGEwJaQTEQMA4GA1UECBMHR2F1dGVuZzEVMBMGA1UEBxMMSm9oYW5uZXNidXJnMRQw
EgYDVQQDEwtEYXZpZCBQZWFsbDEgMB4GCSqGSIb3DQEJARYRZGtwZWFsbEBnbWFpbC5jb20wggEi
MA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDpmZ6NbtIrcIkPBzEWMGE+mPy5Hw/bY/qYRQ+4
Gx+0+h5IkUr8B4Ly4CtNIbIC8Ob6WtHJsTH/nux/ivNCaOf88SMOeiLrwDUp0zCkMedWD+J7CK46
2WR2wwbYIPElOaeqzIrNf6S+YLTTq13sUU1Ig8GrW1qe14q4Dedon5YTzQwnyk1PcakDrUZN1f8+
kvAQSmZIjPu1F6aD2a/BalydPK/E/2V0wRQLj0Hc4srABW1NIQU0fLMmtdtCrpgZ7BcEyM1B9+kH
CGsqwQyIal7ec7hiNRkK4GrWQ9PZ/UEg6Cz0YvLiE0reDNNw7OuCjhA/q2ztoE9lmCzk1aJR6RXl
AgMBAAGjggOsMIIDqDAJBgNVHRMEAjAAMAsGA1UdDwQEAwIEsDAdBgNVHSUEFjAUBggrBgEFBQcD
AgYIKwYBBQUHAwQwHQYDVR0OBBYEFF41oNGIJjR4XifS53LXaTJ+whYUMB8GA1UdIwQYMBaAFK5V
g2/sMcq59x36r2sx88gd46y7MBwGA1UdEQQVMBOBEWRrcGVhbGxAZ21haWwuY29tMIICIQYDVR0g
BIICGDCCAhQwggIQBgsrBgEEAYG1NwECAjCCAf8wLgYIKwYBBQUHAgEWImh0dHA6Ly93d3cuc3Rh
cnRzc2wuY29tL3BvbGljeS5wZGYwNAYIKwYBBQUHAgEWKGh0dHA6Ly93d3cuc3RhcnRzc2wuY29t
L2ludGVybWVkaWF0ZS5wZGYwgfcGCCsGAQUFBwICMIHqMCcWIFN0YXJ0Q29tIENlcnRpZmljYXRp
b24gQXV0aG9yaXR5MAMCAQEagb5UaGlzIGNlcnRpZmljYXRlIHdhcyBpc3N1ZWQgYWNjb3JkaW5n
IHRvIHRoZSBDbGFzcyAyIFZhbGlkYXRpb24gcmVxdWlyZW1lbnRzIG9mIHRoZSBTdGFydENvbSBD
QSBwb2xpY3ksIHJlbGlhbmNlIG9ubHkgZm9yIHRoZSBpbnRlbmRlZCBwdXJwb3NlIGluIGNvbXBs
aWFuY2Ugb2YgdGhlIHJlbHlpbmcgcGFydHkgb2JsaWdhdGlvbnMuMIGcBggrBgEFBQcCAjCBjzAn
FiBTdGFydENvbSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTADAgECGmRMaWFiaWxpdHkgYW5kIHdh
cnJhbnRpZXMgYXJlIGxpbWl0ZWQhIFNlZSBzZWN0aW9uICJMZWdhbCBhbmQgTGltaXRhdGlvbnMi
IG9mIHRoZSBTdGFydENvbSBDQSBwb2xpY3kuMDYGA1UdHwQvMC0wK6ApoCeGJWh0dHA6Ly9jcmwu
c3RhcnRzc2wuY29tL2NydHUyLWNybC5jcmwwgY4GCCsGAQUFBwEBBIGBMH8wOQYIKwYBBQUHMAGG
LWh0dHA6Ly9vY3NwLnN0YXJ0c3NsLmNvbS9zdWIvY2xhc3MyL2NsaWVudC9jYTBCBggrBgEFBQcw
AoY2aHR0cDovL2FpYS5zdGFydHNzbC5jb20vY2VydHMvc3ViLmNsYXNzMi5jbGllbnQuY2EuY3J0
MCMGA1UdEgQcMBqGGGh0dHA6Ly93d3cuc3RhcnRzc2wuY29tLzANBgkqhkiG9w0BAQUFAAOCAQEA
PZllFKTbRAEdO69+lkzuGgHvAmBT7wLFSzh4AoximdJOFcGOLp6DGH7W+fQ/XrR+6Pr5P/pQluHe
g7Mc7I4yPAbgivxVX+r173cs32ujNs2EhiZe3PFssl7nJ3jCJ0L6MgedxS1/nhhIzhhapUDpUttp
iF4Oq5KzOPlAsF82zokMDaenZETZRb+OmGWWqUhisG1rw6q2/JWqiaveLOrqFcFKosWrlSJpPAkB
m06sjAxW8cnR8vfvM9rI62bYgihxqS/xdtzyildCq+O0onBSSPQCrfQWX59M6thdn24WiUsAAQ7+
eW7+QBQYDnBlUXrTBRnjdCNhYakiFnPzl1Uh4TGCA2wwggNoAgEBMIGTMIGMMQswCQYDVQQGEwJJ
TDEWMBQGA1UEChMNU3RhcnRDb20gTHRkLjErMCkGA1UECxMiU2VjdXJlIERpZ2l0YWwgQ2VydGlm
aWNhdGUgU2lnbmluZzE4MDYGA1UEAxMvU3RhcnRDb20gQ2xhc3MgMiBQcmltYXJ5IEludGVybWVk
aWF0ZSBDbGllbnQgQ0ECAiEcMAkGBSsOAwIaBQCgggGtMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0B
BwEwHAYJKoZIhvcNAQkFMQ8XDTE0MDQwMjA4NTAyOFowIwYJKoZIhvcNAQkEMRYEFNqbZiaTYlvn
sm8mo6b1J/9bvuJpMIGkBgkrBgEEAYI3EAQxgZYwgZMwgYwxCzAJBgNVBAYTAklMMRYwFAYDVQQK
Ew1TdGFydENvbSBMdGQuMSswKQYDVQQLEyJTZWN1cmUgRGlnaXRhbCBDZXJ0aWZpY2F0ZSBTaWdu
aW5nMTgwNgYDVQQDEy9TdGFydENvbSBDbGFzcyAyIFByaW1hcnkgSW50ZXJtZWRpYXRlIENsaWVu
dCBDQQICIRwwgaYGCyqGSIb3DQEJEAILMYGWoIGTMIGMMQswCQYDVQQGEwJJTDEWMBQGA1UEChMN
U3RhcnRDb20gTHRkLjErMCkGA1UECxMiU2VjdXJlIERpZ2l0YWwgQ2VydGlmaWNhdGUgU2lnbmlu
ZzE4MDYGA1UEAxMvU3RhcnRDb20gQ2xhc3MgMiBQcmltYXJ5IEludGVybWVkaWF0ZSBDbGllbnQg
Q0ECAiEcMA0GCSqGSIb3DQEBAQUABIIBAESK1i+UGMHgRrpmYrCS6VsHFsJRI/HbHG2PuF1IZ2kY
kXOA4x+uqPcOEOx7raMIQ7si394eXQVI6Iby9pBldLXljLlbHOYFC7guKbofhuEpWJzww2Ic0gk9
/T/0/UnMOuw0PgNTid6PL+6+7xrTjmQLke9Kj8rzyYgPzmzMj6fE4wAYEEuEDeHziLhi9EVv2BOB
soU38frTUa61Z/efSDiSxfD+tHQim2ylaejpuzc0hAVNOqj9YcUf4VI3M0MJ5a8DAKA4KF6nEhkX
fbRcwU/uJu4CyGwoFXiCbeRnjw2UmyZcHn4drRLK4qRYfZ3KnhOIuagkKlm1kGGQa59QKY4AAAAA
AAA=

--Apple-Mail=_B5C6AC04-002E-4C87-ACB2-292023D47338--
