Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966678Ab3DQUR2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 16:17:28 -0400
Received: from mx01.sz.bfs.de ([194.94.69.103]:28902 "EHLO mx01.sz.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965338Ab3DQUR1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 16:17:27 -0400
X-Greylist: delayed 652 seconds by postgrey-1.27 at vger.kernel.org; Wed, 17 Apr 2013 16:17:26 EDT
Message-ID: <516F00C8.9070906@BfS.de>
Date: Wed, 17 Apr 2013 22:06:32 +0200
From: Thomas Schweikle <TSchweikle@BfS.de>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:22.0) Gecko/20100101 Thunderbird/22.0a2
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: make rpm-pkg fails for all kernels with "spec file not found in <kernel>.tar.gz
X-Enigmail-Version: 1.6a1pre
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms050601090006020405030409"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms050601090006020405030409
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable


[1.] One line summary of the problem:
"make rpm-pkg" fails for all kernels with
"spec file not found in <kernel>.tar.gz"

[2.] Full description of the problem/report:
"make rpm-pkg" fails for all kernels with
"spec file not found in <kernel>.tar.gz"

make O=3D/home/sct-muc/dev/obj/3.8.8 defconfig
make O=3D/home/sct-muc/dev/obj/3.8.8 bzImage
make O=3D/home/sct-muc/dev/obj/3.8.8 rpm-pkg
/bin/bash /home/sct-muc/dev/linux-3.8.y/scripts/package/mkspec \
   > /home/sct-muc/dev/obj/3.8.8/kernel.spec
make clean
set -e; cd -P ..; ln -sf /home/sct-muc/dev/linux-3.8.y kernel-3.8.8
/bin/bash /home/sct-muc/dev/linux-3.8.y/scripts/setlocalversion \
   --save-scmversion
set -e; cd -P ..; tar -cz --exclude SCCS --exclude BitKeeper \
   --exclude .svn --exclude CVS --exclude .pc --exclude .hg \
   --exclude .git -f kernel-3.8.8.tar.gz kernel-3.8.8/.
set -e; cd -P ..; rm kernel-3.8.8
rm -f /home/sct-muc/dev/obj/3.8.8/.scmversion
set -e; \
   /bin/bash /home/sct-muc/dev/linux-3.8.y/scripts/mkversion \
   > /home/sct-muc/dev/obj/3.8.8/.tmp_version
set -e; \
   mv -f /home/sct-muc/dev/obj/3.8.8/.tmp_version \
   /home/sct-muc/dev/obj/3.8.8/.version
rpmbuild  --target x86_64 -ta ../kernel-3.8.8.tar.gz
Fehler: Konnte Spec-Datei von ../kernel-3.8.8.tar.gz nicht lesen
Baue f=FCr die Zielplattform(en): x86_64
Baue f=FCr das Ziel x86_64
make[2]: *** [rpm-pkg] Fehler 1
make[1]: *** [rpm-pkg] Fehler 2
make: *** [sub-make] Fehler 2

[3.] Keywords:
build, rpm-pkg

[4.] Kernel version:
all

[5.] Output of Oops.. message
"rpmbuild --target x86_64 -ta ../kernel-3.8.8.tar.gz"
Error: could not read spec-file from ../kernel-3.8.8.tar.gz
Building for target(s): x86_64
Building for target: x86_64
make[2]: *** [rpm-pkg] Error 1
make[1]: *** [rpm-pkg] Error 2
make: *** [sub-make] Error 2

[6.] Shell script to trigger the problem:
git clone \
   git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git
linux-3.4.y
cd linux-3.4.y
git checkout -t origin/linux-3.4.y
make clean
make mrpropper
mkdir -p ${HOME}/obj
make O=3D${HOME}/obj defconfig
make O=3D${HOME}/obj bzImage
make O=3D${HOME}/obj rpm-pkg

[7.] Environment

[7.1.] Software:
$ scripts/ver_linux
If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.

Linux cc-tps-build-muc 3.2.0-40-generic #64-Ubuntu SMP Mon Mar 25
21:22:10 UTC 2013 x86_64 x86_64 x86_64 GNU/Linux

Gnu C                  4.6
Gnu make               3.81
binutils               2.22
util-linux             2.20.1
mount                  support
module-init-tools      3.16
e2fsprogs              1.42
jfsutils               1.1.15
reiserfsprogs          3.6.21
pcmciautils            018
PPP                    2.4.5
Linux C Library        2.15
Dynamic linker (ldd)   2.15
Procps                 3.2.8
Net-tools              1.60
Kbd                    1.15.2
Sh-utils               8.13
wireless-tools         30
Modules Loaded         pcnet32 vmxnet vmblock vmsync vmhgfs nfsd nfs
lockd fscache auth_rpcgss nfs_acl sunrpc ext2 ppdev vmw_balloon psmouse
serio_raw vmwgfx ttm drm parport_pc i2c_piix4 shpchp vmci mac_hid lp
parport floppy e1000 mptspi mptscsih mptbase btrfs zlib_deflate libcrc32c=


[7.2.] Processor information (from /proc/cpuinfo):
n.a.

[7.3.] Module information (from /proc/modules):
n.a.

[7.4.] Loaded driver and hardware information:
n.a.

[7.5.] PCI information ('lspci -vvv' as root)
n.a.

[7.6.] SCSI information (from /proc/scsi/scsi)
n.a.

[7.7.] Other information that might be relevant to the problem
       (please look in /proc and include all information that you
       think to be relevant):
n.a.


[X.] Other notes, patches, fixes, workarounds:
git clone \
   git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git
linux-3.4.y
cd linux-3.4.y
git checkout -t origin/linux-3.4.y
make clean
make mrpropper
mkdir -p ${HOME}/obj
make O=3D${HOME}/obj defconfig
make O=3D${HOME}/obj bzImage
make O=3D${HOME}/obj deb-pkg

works.

--=20
Mit freundlichen Gr=FCssen
Thomas Schweikle


Bundesamt f=FCr Strahlenschutz    Thomas Schweikle
Ingolst=E4dter Landstra=DFe 1       AG-IT
D-85764 Oberschlei=DFheim         Tel.: +49(0) 30 / 18 333 2594
                                Fax:  +49(0) 30 / 18 10 333 2594
http://www.bfs.de               e-mail: tschweikle@bfs.de


--------------ms050601090006020405030409
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Kryptografische Unterschrift

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIOcDCC
BCEwggMJoAMCAQICAgDHMA0GCSqGSIb3DQEBBQUAMHExCzAJBgNVBAYTAkRFMRwwGgYDVQQK
ExNEZXV0c2NoZSBUZWxla29tIEFHMR8wHQYDVQQLExZULVRlbGVTZWMgVHJ1c3QgQ2VudGVy
MSMwIQYDVQQDExpEZXV0c2NoZSBUZWxla29tIFJvb3QgQ0EgMjAeFw0wNjEyMTkxMDI5MDBa
Fw0xOTA2MzAyMzU5MDBaMFoxCzAJBgNVBAYTAkRFMRMwEQYDVQQKEwpERk4tVmVyZWluMRAw
DgYDVQQLEwdERk4tUEtJMSQwIgYDVQQDExtERk4tVmVyZWluIFBDQSBHbG9iYWwgLSBHMDEw
ggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDpm8NnhfkNrvWNVMOWUDU9YuluTO2U
1wBblSJ01CDrNI/W7MAxBAuZgeKmFNJSoCgjhIt0iQReW+DieMF4yxbLKDU5ey2QRdDtoAB6
fL9KDhsAw4bpXCsxEXsM84IkQ4wcOItqaACa7txPeKvSxhObdq3u3ibo7wGvdA/BCaL2a869
080UME/15eOkyGKbghoDJzANAmVgTe3RCSMqljVYJ9N2xnG2kB3E7f81hn1vM7PbD8URwoqD
oZRdQWvY0hD1TP3KUazZve+Sg7va64sWVlZDz+HVEz2mHycwzUlU28kTNJpxdcVs6qcLmPkh
nSevPqM5OUhqjK3JmfvDEvK9AgMBAAGjgdkwgdYwcAYDVR0fBGkwZzBloGOgYYZfaHR0cDov
L3BraS50ZWxlc2VjLmRlL2NnaS1iaW4vc2VydmljZS9hZl9Eb3dubG9hZEFSTC5jcmw/LWNy
bF9mb3JtYXQ9WF81MDkmLWlzc3Vlcj1EVF9ST09UX0NBXzIwHQYDVR0OBBYEFEm3xs/oPR9/
6kR7Eyn38QpwPt5kMB8GA1UdIwQYMBaAFDHDeRu69VPXF+CJei0XbAqzK50zMA4GA1UdDwEB
/wQEAwIBBjASBgNVHRMBAf8ECDAGAQH/AgECMA0GCSqGSIb3DQEBBQUAA4IBAQA74Vp3wEgX
3KkY7IGvWonwvSiSpspZGBJw7Cjy565/lizn8l0ZMfYTK3S9vYCyufdnyTmieTvhERHua3iR
M347XyYndVNljjNj7s9zw7CSI0khUHUjoR8Y4pSFPT8z6XcgjaK95qGFKUD2P3MyWA0Ja6ba
hWzAP7uNZmRWJE6uDT8yNQFb6YyC2XJZT7GGhfF0hVblw/hc843uR7NTBXDn5U2KaYMo4RMJ
hp5eyOpYHgwf+aTUWgRo/Sg+iwK2WLX2oSw3VwBnqyNojWOl75lrXP1LVvarQIc01BGSbOyH
xQoLBzNytG8MHVQs2FHHzL8w00Ny8TK/jM5JY6gA9/IcMIIFCTCCA/GgAwIBAgIED21YGTAN
BgkqhkiG9w0BAQUFADBaMQswCQYDVQQGEwJERTETMBEGA1UEChMKREZOLVZlcmVpbjEQMA4G
A1UECxMHREZOLVBLSTEkMCIGA1UEAxMbREZOLVZlcmVpbiBQQ0EgR2xvYmFsIC0gRzAxMB4X
DTEwMDExMzE0MzY1N1oXDTE5MDYzMDAwMDAwMFowfzELMAkGA1UEBhMCREUxJjAkBgNVBAoT
HUJ1bmRlc2FtdCBmdWVyIFN0cmFobGVuc2NodXR6MSkwJwYDVQQDEyBCdW5kZXNhbXQgZnVl
ciBTdHJhaGxlbnNjaHV0eiBDQTEdMBsGCSqGSIb3DQEJARYOYmZzLXBraUBiZnMuZGUwggEi
MA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQC6xeorzlerpr2Y7jez7MCMxBdc8OyV3Vj+
Roj6DKmvSYLntluI//fHhHYxyWyuUIbgftIL6nRXhE21ud1sgGWIPGnCU8g9tFfMZHWsC/3N
+YLA2xdsxRNPkWLdTYzHBP0UpftfYXoAPRG1DqAoPhaMrmRmEIcXdqVpAofreB/fM3cun3tL
zUowci77r9lmepITiLv/Eu+tELabLoWTduRRk8gwlNo7vCjtIueBJ9ukHEICpmHn6ZLXffCO
4LrEyLS2B8pEqUF+p/IwHX2QOU04dynPVHr9dXEl8VL8R5RNKI5Iz8BTpL9casPVRK6F2kE7
k4+44RdS6esBCj6sY73JAgMBAAGjggGwMIIBrDASBgNVHRMBAf8ECDAGAQH/AgEBMAsGA1Ud
DwQEAwIBBjAdBgNVHQ4EFgQUCO901YUYJz+KIW2LZMaE7dZGG2EwHwYDVR0jBBgwFoAUSbfG
z+g9H3/qRHsTKffxCnA+3mQwGQYDVR0RBBIwEIEOYmZzLXBraUBiZnMuZGUwgYgGA1UdHwSB
gDB+MD2gO6A5hjdodHRwOi8vY2RwMS5wY2EuZGZuLmRlL2dsb2JhbC1yb290LWNhL3B1Yi9j
cmwvY2FjcmwuY3JsMD2gO6A5hjdodHRwOi8vY2RwMi5wY2EuZGZuLmRlL2dsb2JhbC1yb290
LWNhL3B1Yi9jcmwvY2FjcmwuY3JsMIGiBggrBgEFBQcBAQSBlTCBkjBHBggrBgEFBQcwAoY7
aHR0cDovL2NkcDEucGNhLmRmbi5kZS9nbG9iYWwtcm9vdC1jYS9wdWIvY2FjZXJ0L2NhY2Vy
dC5jcnQwRwYIKwYBBQUHMAKGO2h0dHA6Ly9jZHAyLnBjYS5kZm4uZGUvZ2xvYmFsLXJvb3Qt
Y2EvcHViL2NhY2VydC9jYWNlcnQuY3J0MA0GCSqGSIb3DQEBBQUAA4IBAQAoFsmEYlz8niQV
Sv/D1PnRkqr28yk7ps8AuPltDuTIsdp+eNP5PJwW5pJ1tgb9vJtFeCwpMRSu/UUhGoLe0bDk
HLP4nnoW62TQFcsV4Y5gmWHU+YHMdeYGrVLkF2cnyK/oGB7VX0acbEDzB4e6/k71fJXY0pn/
GNhjTyAWtCpL6a2a5LVU2L6waJtV0nUAfFKB1uz/oJdDMQGcGRQ/KGymA8iw6GXqlOMlZe1B
c+PuXxwB1hh2frzIrI7NHablVwuHjvCR4pT3wNSqmxjb9EJmJfsgdx/83HDwE3By2RevUCn7
DEt+gdMAj4SD222QGNwD8jeCS8M8QyhY8ecqZJtDMIIFOjCCBCKgAwIBAgIHFOApgslVXDAN
BgkqhkiG9w0BAQUFADB/MQswCQYDVQQGEwJERTEmMCQGA1UEChMdQnVuZGVzYW10IGZ1ZXIg
U3RyYWhsZW5zY2h1dHoxKTAnBgNVBAMTIEJ1bmRlc2FtdCBmdWVyIFN0cmFobGVuc2NodXR6
IENBMR0wGwYJKoZIhvcNAQkBFg5iZnMtcGtpQGJmcy5kZTAeFw0xMjEyMDYxNDMwMTBaFw0x
NTEyMDYxNDMwMTBaMGAxCzAJBgNVBAYTAkRFMSYwJAYDVQQKEx1CdW5kZXNhbXQgZnVlciBT
dHJhaGxlbnNjaHV0ejEOMAwGA1UECxMFQUctSVQxGTAXBgNVBAMTEFRob21hcyBTY2h3ZWlr
bGUwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDPPq7cs501wxoBLhgvMeeRrNv7
7roZMYmGNQnMNWxIp265uJuIj22RSo6R7RVUyD58WSj3itLrBedhQX2vTlPz1RJ745j37lzO
/Pk6FmneiiyyDB59DSE71OtLJXVdZieBJk2SYNBQZHnIYNsvDmQKoebgg8gPlFXoixFJmxtp
vaRBRDLsBMPgXrXYh3drPUbTRArB/Q+IneV28x4b+PmCmAMFrdeZt6nLqEGe6vrbv8BQAUV+
QFmfQEDqt8V3RQn7u44XllllLU5hdI39ykhUkE35gGhtdQviOZf7vqZxHR/hj15JomYjxkfO
DzV9ge++z6rq24zYgyib92HQQh7TAgMBAAGjggHYMIIB1DAvBgNVHSAEKDAmMBEGDysGAQQB
ga0hgiwBAQQDADARBg8rBgEEAYGtIYIsAgEEAwAwCQYDVR0TBAIwADALBgNVHQ8EBAMCBeAw
HQYDVR0lBBYwFAYIKwYBBQUHAwIGCCsGAQUFBwMEMB0GA1UdDgQWBBRt6ElNIPSjYhhHEePs
at5X1VBr9TAfBgNVHSMEGDAWgBQI73TVhRgnP4ohbYtkxoTt1kYbYTAcBgNVHREEFTATgRF0
c2Nod2Vpa2xlQGJmcy5kZTB3BgNVHR8EcDBuMDWgM6Axhi9odHRwOi8vY2RwMS5wY2EuZGZu
LmRlL2Jmcy1jYS9wdWIvY3JsL2NhY3JsLmNybDA1oDOgMYYvaHR0cDovL2NkcDIucGNhLmRm
bi5kZS9iZnMtY2EvcHViL2NybC9jYWNybC5jcmwwgZIGCCsGAQUFBwEBBIGFMIGCMD8GCCsG
AQUFBzAChjNodHRwOi8vY2RwMS5wY2EuZGZuLmRlL2Jmcy1jYS9wdWIvY2FjZXJ0L2NhY2Vy
dC5jcnQwPwYIKwYBBQUHMAKGM2h0dHA6Ly9jZHAyLnBjYS5kZm4uZGUvYmZzLWNhL3B1Yi9j
YWNlcnQvY2FjZXJ0LmNydDANBgkqhkiG9w0BAQUFAAOCAQEAX/Ueqq1uHcKyo01wU4gSj8/b
Un9XlKs/arToZfr+M0v67b5GPsf/0ak6YH480eNGfjjy4pDcl9gVDC9txbJgH9ZgMIeZj/Uh
FD3hBRF3vi6U9H6VvCJN/OQIbI6BNWLk97XTRdngi40piJVuVc6cmeomrLYrvpMk2bCbfDr4
cU8zfJWkHAHJ2Ynm954BqVCMr8v6hvFNPWKV0htrnTawU0yQ8PO3JZB72QMIsn6nHY0toDiK
Ty110vUEGfeWSl5NZ+8t8qNJf9sG31PReLYzcT/GqLoGJrN3mrZutf+1Rsn2Q/vxz8xNygtu
dXu9sM0hZB51rNw5nyk0TXXGRHcJxDGCA78wggO7AgEBMIGKMH8xCzAJBgNVBAYTAkRFMSYw
JAYDVQQKEx1CdW5kZXNhbXQgZnVlciBTdHJhaGxlbnNjaHV0ejEpMCcGA1UEAxMgQnVuZGVz
YW10IGZ1ZXIgU3RyYWhsZW5zY2h1dHogQ0ExHTAbBgkqhkiG9w0BCQEWDmJmcy1wa2lAYmZz
LmRlAgcU4CmCyVVcMAkGBSsOAwIaBQCgggIJMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEw
HAYJKoZIhvcNAQkFMQ8XDTEzMDQxNzIwMDYzMlowIwYJKoZIhvcNAQkEMRYEFEwb7noizjgo
knadeZvlnu6MfrhjMGwGCSqGSIb3DQEJDzFfMF0wCwYJYIZIAWUDBAEqMAsGCWCGSAFlAwQB
AjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcNAwICAUAwBwYFKw4DAgcw
DQYIKoZIhvcNAwICASgwgZsGCSsGAQQBgjcQBDGBjTCBijB/MQswCQYDVQQGEwJERTEmMCQG
A1UEChMdQnVuZGVzYW10IGZ1ZXIgU3RyYWhsZW5zY2h1dHoxKTAnBgNVBAMTIEJ1bmRlc2Ft
dCBmdWVyIFN0cmFobGVuc2NodXR6IENBMR0wGwYJKoZIhvcNAQkBFg5iZnMtcGtpQGJmcy5k
ZQIHFOApgslVXDCBnQYLKoZIhvcNAQkQAgsxgY2ggYowfzELMAkGA1UEBhMCREUxJjAkBgNV
BAoTHUJ1bmRlc2FtdCBmdWVyIFN0cmFobGVuc2NodXR6MSkwJwYDVQQDEyBCdW5kZXNhbXQg
ZnVlciBTdHJhaGxlbnNjaHV0eiBDQTEdMBsGCSqGSIb3DQEJARYOYmZzLXBraUBiZnMuZGUC
BxTgKYLJVVwwDQYJKoZIhvcNAQEBBQAEggEAUmfokwi2ATxKY4WxmFAchobo4ycFcbrsL9OX
M5pGAT/uwHd8I6wzP2Uyiwl9nTD3FPVDTtw0P5kcc/HEu80l/wEGQR0zXZjZ+Ndn8v5910pt
Xlo979xzmWl6KSYG0OB2I9DW5wUbSb13Clzo4qa/eSigR1qhIravbtUvxMMGD03FaQQuH4Nb
1mYQZtehKn6LIwl5yAsyRNDQvIpS6WWd0MLkAQ1d4Hd2A+pliVjxt7/ix4+ISaYfZvGxHdZj
REoni67SPAFXbN2GRj9n2GTYJYXAFffo9zMCRIZlXj56LStHSau8EVs+oCfrMdULOMOWKLsh
Q7RZYK0eD5wYmz27MwAAAAAAAA==
--------------ms050601090006020405030409--
