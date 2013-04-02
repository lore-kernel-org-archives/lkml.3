Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932172Ab3DBKmI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 06:42:08 -0400
Received: from mailout3.uni-hannover.de ([130.75.2.104]:34002 "EHLO
	mailout3.uni-hannover.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754532Ab3DBKmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 06:42:05 -0400
X-Greylist: delayed 360 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Apr 2013 06:42:05 EDT
Message-ID: <515AB490.8010703@tnt.uni-hannover.de>
Date: Tue, 02 Apr 2013 12:36:00 +0200
From: Marco Munderloh <munderl@tnt.uni-hannover.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Ilija Hadzic <ihadzic@research.bell-labs.com>
CC: Michal Hocko <mhocko@suse.cz>, Ilija Hadzic <ilijahadzic@gmail.com>,
        Thomas Hellstrom <thellstrom@vmware.com>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH] drm: fix i_mapping and f_mapping initialization in drm_open
 in error path
References: <20130326195601.GA5124@dhcp22.suse.cz> <CA+4h6Hnhm-Ox_5dRdBH3C9Lh_qVNac8_oL=3ruy75jBX7xp9OQ@mail.gmail.com> <20130331103418.GA18476@dhcp22.suse.cz> <Pine.GSO.4.64.1304011249370.27674@umail>
In-Reply-To: <Pine.GSO.4.64.1304011249370.27674@umail>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms070703020900080605010008"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms070703020900080605010008
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

> Attached is a v2 of the patch, for reference. I would appreciate if the=
 original reporter or you tested it in lieu of your proposed patch and le=
t me know if it fixes your
> issue.

The patch works for me. echo 3 > /proc/sys/vm/drop_caches as well as rmmo=
d radeon do not end up in a crash anymore. However, I have still no clue =
why one of these makes=20
drm_open to fail. On rmmod radeon I get the following log messages. If do=
n't know if the 'unpin not necessary' has anything to do with it.

[drm] radeon: finishing device.
radeon 0000:01:00.0: ffff88024e526c00 unpin not necessary
radeon 0000:01:00.0: ffff88024f2f6000 unpin not necessary
radeon 0000:01:00.0: ffff88024f2f6000 unpin not necessary
[TTM] Finalizing pool allocator
[TTM] Finalizing DMA pool allocator
[TTM] Zone  kernel: Used memory at exit: 0 kiB
[TTM] Zone   dma32: Used memory at exit: 0 kiB
[drm] radeon: ttm finalized
vga_switcheroo: disabled
[drm] Module unloaded

By the way, sometimes my r8169 ethernet controller does not survive suspe=
nd/hibernation (does not detect link). rmmod/modprobe helps. I don't know=
 if this is related.


--------------ms070703020900080605010008
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIOBTCC
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
xQoLBzNytG8MHVQs2FHHzL8w00Ny8TK/jM5JY6gA9/IcMIIE0zCCA7ugAwIBAgIECihcPjAN
BgkqhkiG9w0BAQUFADBaMQswCQYDVQQGEwJERTETMBEGA1UEChMKREZOLVZlcmVpbjEQMA4G
A1UECxMHREZOLVBLSTEkMCIGA1UEAxMbREZOLVZlcmVpbiBQQ0EgR2xvYmFsIC0gRzAxMB4X
DTA3MDMyNzA5MDY1NVoXDTE5MDMyNjAwMDAwMFowZzELMAkGA1UEBhMCREUxJjAkBgNVBAoT
HUxlaWJuaXogVW5pdmVyc2l0YWV0IEhhbm5vdmVyMQ0wCwYDVQQLEwRSUlpOMSEwHwYDVQQD
ExhDQSBkZXIgTFVIIChVSC1DQSkgLSBHMDMwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEK
AoIBAQDQqNv2Q98KioaZviQqCRxVSqqwRZkROa6VEJOtMGEzTgS9wBgfZjdFWtqbZjZ1PQ6f
fvMeXfGbycU09eJSz0FY3mra/pw04e32ibas34L/zfjhBoZVnRy7Q5joZoWtdh6eRBLDM0g1
tCFsuwHS8u9+4ERY3+dxqqjJqS+RigelBH6qi3q/+2mN9b6pFcrgEalRIj//GOHQYxAwsCsj
KpyDTl5S7B/MUb3i3tNTuLbgpJkshk+NHyGdienaTDO6zVfR1S6eL9NHQqyNhnZsDutPDZ17
hgJ3Obt3b610grSGNTmzqdc5aI5SoE5xURNrfmtAoXM3xDr9SAPNcvnnpE1nAgMBAAGjggGS
MIIBjjAPBgNVHRMBAf8EBTADAQH/MAsGA1UdDwQEAwIBBjAdBgNVHQ4EFgQU0/vgTeRNiIX0
UalveXXpwCkhLhMwHwYDVR0jBBgwFoAUSbfGz+g9H3/qRHsTKffxCnA+3mQwgYgGA1UdHwSB
gDB+MD2gO6A5hjdodHRwOi8vY2RwMS5wY2EuZGZuLmRlL2dsb2JhbC1yb290LWNhL3B1Yi9j
cmwvY2FjcmwuY3JsMD2gO6A5hjdodHRwOi8vY2RwMi5wY2EuZGZuLmRlL2dsb2JhbC1yb290
LWNhL3B1Yi9jcmwvY2FjcmwuY3JsMIGiBggrBgEFBQcBAQSBlTCBkjBHBggrBgEFBQcwAoY7
aHR0cDovL2NkcDEucGNhLmRmbi5kZS9nbG9iYWwtcm9vdC1jYS9wdWIvY2FjZXJ0L2NhY2Vy
dC5jcnQwRwYIKwYBBQUHMAKGO2h0dHA6Ly9jZHAyLnBjYS5kZm4uZGUvZ2xvYmFsLXJvb3Qt
Y2EvcHViL2NhY2VydC9jYWNlcnQuY3J0MA0GCSqGSIb3DQEBBQUAA4IBAQDNgDr2fBimkpg/
1AOyq9lN8fmHjns5kPSioM83th54EwVB7ALIyNbneGQQddseA1211ug/vCp1rDEvdHDif2Pi
Or51ezw8pWHsoUmxJlijB8eN3mRe/1RX2nyJwFrWbE9syZ+jnFqsx558tBT8JpCayTHdyyV5
K0QrNwUuhkndHTxvTb5H9o17ljk4jlAFKdbdSwwMISOM0OiDR6NIiQV/PiiZ+JgqMuvh3uNn
so/qNwBQea6W+VYJc7IIh1bxFQSiVcpfbn+yMx/j+Ei4gwkJkGde5WHPJEF0CpOly4kJLJNE
w2GVKhw4Xd3ysAbn7aKpMgMQZYQE11qUR++QlxnRMIIFBTCCA+2gAwIBAgIEEL/H/jANBgkq
hkiG9w0BAQUFADBnMQswCQYDVQQGEwJERTEmMCQGA1UEChMdTGVpYm5peiBVbml2ZXJzaXRh
ZXQgSGFubm92ZXIxDTALBgNVBAsTBFJSWk4xITAfBgNVBAMTGENBIGRlciBMVUggKFVILUNB
KSAtIEcwMzAeFw0xMDA5MjcwNzQwMzFaFw0xMzA5MjYwNzQwMzFaMF0xCzAJBgNVBAYTAkRF
MSYwJAYDVQQKEx1MZWlibml6IFVuaXZlcnNpdGFldCBIYW5ub3ZlcjEMMAoGA1UECxMDdG50
MRgwFgYDVQQDEw9NYXJjbyBNdW5kZXJsb2gwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEK
AoIBAQChhydrsnNsSylhRz/AKYCgRHVwYhNJmEthqm1bWlGaVoEg5FcBaNCLKTpn6O1kMRme
+Ifh56Lp2Yb+0jNz4Pm74Nen3aVAkzgV07OO+n43xP6n7mxDg1Fd/4iKOdUbhSN1/StE7rxu
fUEM4oT5cLOuUJsJIDp4uul5qi5dKMk2bVgxA8hBHDwgaRUT96ymFZBNRLN/MPTK7xq4xCuh
9iNp3FMxuMfnCLRvShql3/40Z+MEniVgN8hjt9JnBfC/QCeQTT4f2rL17N6znAHE6VFwES+i
cEjtlls/McdhH+suXplACXgzPZGcY1DRJj3A6+yWVLLJ0NClvMiL81fX1+9DAgMBAAGjggHB
MIIBvTAJBgNVHRMEAjAAMAsGA1UdDwQEAwIF4DApBgNVHSUEIjAgBggrBgEFBQcDAgYIKwYB
BQUHAwQGCisGAQQBgjcUAgIwHQYDVR0OBBYEFNbN/f5g73ju85hEKNhyrSnUFuj1MB8GA1Ud
IwQYMBaAFNP74E3kTYiF9FGpb3l16cApIS4TMCYGA1UdEQQfMB2BG211bmRlcmxAdG50LnVu
aS1oYW5ub3Zlci5kZTB5BgNVHR8EcjBwMDagNKAyhjBodHRwOi8vY2RwMS5wY2EuZGZuLmRl
L3VoLWNhL3B1Yi9jcmwvZ19jYWNybC5jcmwwNqA0oDKGMGh0dHA6Ly9jZHAyLnBjYS5kZm4u
ZGUvdWgtY2EvcHViL2NybC9nX2NhY3JsLmNybDCBlAYIKwYBBQUHAQEEgYcwgYQwQAYIKwYB
BQUHMAKGNGh0dHA6Ly9jZHAxLnBjYS5kZm4uZGUvdWgtY2EvcHViL2NhY2VydC9nX2NhY2Vy
dC5jcnQwQAYIKwYBBQUHMAKGNGh0dHA6Ly9jZHAyLnBjYS5kZm4uZGUvdWgtY2EvcHViL2Nh
Y2VydC9nX2NhY2VydC5jcnQwDQYJKoZIhvcNAQEFBQADggEBABGj4fM8+KQFHi1zsbYO+1xd
miP90lcjMM7Dmw1NrxKfJqggLOhPvLlpgqUS0IXvwdMVLJ1JdhbwBDcOxU7/5Za3MbUCBnDA
KpbddjNq7hWkDtp/eZ+0OugrqWAJkEpfyx5/pkFgci84JJG/lVvFKAhhwcUmpcukkM4GQrZC
UvC+PonYkeXrR8TOB6+zdVXArbApyHTQAvofGZiTkvEJ+/8snMS/qGHtlaj4KaeHLfT/Kqj8
6FoZYXUwbrQTmUHfR0X634PijYg4s0GvDF3CzeNdbmFZll7ODzSKG3Acwl/GkgHc1uAYdn4U
l1aHdZAHGLz4uyM/ep+QstVI/xsFHvoxggNoMIIDZAIBATBvMGcxCzAJBgNVBAYTAkRFMSYw
JAYDVQQKEx1MZWlibml6IFVuaXZlcnNpdGFldCBIYW5ub3ZlcjENMAsGA1UECxMEUlJaTjEh
MB8GA1UEAxMYQ0EgZGVyIExVSCAoVUgtQ0EpIC0gRzAzAgQQv8f+MAkGBSsOAwIaBQCgggHO
MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTEzMDQwMjEwMzYw
MFowIwYJKoZIhvcNAQkEMRYEFIwAFpLY4oz5PyJQ/BEVmJ3OrKwMMGwGCSqGSIb3DQEJDzFf
MF0wCwYJYIZIAWUDBAEqMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgIC
AIAwDQYIKoZIhvcNAwICAUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwfgYJKwYBBAGCNxAE
MXEwbzBnMQswCQYDVQQGEwJERTEmMCQGA1UEChMdTGVpYm5peiBVbml2ZXJzaXRhZXQgSGFu
bm92ZXIxDTALBgNVBAsTBFJSWk4xITAfBgNVBAMTGENBIGRlciBMVUggKFVILUNBKSAtIEcw
MwIEEL/H/jCBgAYLKoZIhvcNAQkQAgsxcaBvMGcxCzAJBgNVBAYTAkRFMSYwJAYDVQQKEx1M
ZWlibml6IFVuaXZlcnNpdGFldCBIYW5ub3ZlcjENMAsGA1UECxMEUlJaTjEhMB8GA1UEAxMY
Q0EgZGVyIExVSCAoVUgtQ0EpIC0gRzAzAgQQv8f+MA0GCSqGSIb3DQEBAQUABIIBACUsTprm
iW7BL74Dxz6wQPvrEE5zaGUiqM3WDYsMK85hcdXDNSZj+hm9yUYaMS55/rUNzCWA8+N6IfJC
8kLaYxCpYZdObgOTFRE8lQ2l8JmCfyCWxhpsSMAXd3/JsewCxqPQ7zzmsMEK/SIdjCfs9CBz
oJ547yAoakcVsXgTOrhxWQD6fxScXcifEE4Go8dn5Jeg7vaB6SFNHxvOn8LG80Am4MmGy95s
6sTMVQs2mGTBsfa/T7xJ/vx2xgC+NVGJrA5qDUyWWiaz4n7ZBSRn4FNJZ99Rovkdh1ddcpa8
MJX5bm7wut+xmYk0WcHnJb+UxxXgdBGwuZcBljWKyYcfUS4AAAAAAAA=
--------------ms070703020900080605010008--
