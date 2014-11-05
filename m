Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751789AbaKETbV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 14:31:21 -0500
Received: from mail-ie0-f173.google.com ([209.85.223.173]:37718 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464AbaKETbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 14:31:17 -0500
Message-ID: <545A7B00.1040309@gmail.com>
Date: Wed, 05 Nov 2014 14:31:12 -0500
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Martin Tournoij <martin@arp242.net>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] The SIGINFO signal from BSD
References: <1415200663.3247743.187387481.75CE9317@webmail.messagingengine.com>
In-Reply-To: <1415200663.3247743.187387481.75CE9317@webmail.messagingengine.com>
x-hashcash: 1:21:141105:martin@arp242.net::21f2de7ab1cfc79980a96433437fb083:396d9f8c8fcf73
x-hashcash: 1:21:141105:linux-kernel@vger.kernel.org::11831f5b51b7ba5fd4a25f925a6b3a26:9d8d71ba3c2da7ae
x-stampprotocols: hashcash:1:17;mbound:0:10:3000:5000
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms080303040800010107000306"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms080303040800010107000306
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2014-11-05 10:17, Martin Tournoij wrote:
> Hi there,
>
> As a long-time BSD user, I have become quite used to the SIGINFO (sent =
with ^t)
> feature; after switching to Linux as my desktop a few months ago, I ver=
y much
> miss this.
>
> SIGINFO prints the status of the process to the terminal; BSD cp, for e=
xample,
> shows show much data it's copied:
>
>      $ cp large_file /dev/null
>      <press ^t>
>      load: 1.39  cmd: cp 85837 [running] 3.91r 0.00u 0.98s 8% 2340k
>      large_file -> /dev/null  15%
>
> As you see, it shows the current load, pid, process status, memory usag=
e, as
> well as how much of the file has been copied. Many other BSD tools prin=
t similar
> statistics (mv, tar, dd, sleep, fetch, etc.).
>
> On Linux, sometimes SIGUSR1 is used for similar purposes, the problem w=
ith this
> is that SIGUSR{1,2} will terminate a program if a program doesn't have =
a signal
> handler installed(!)
> SIGUSR1 also has no defined meaning, and may do something radically dif=
ferent;
> nginx, for example, reopens the logfiles on SIGUSR1, and SIGUSR2 upgrad=
es the
> nginx executable on-the-fly.
>
> So you need to carefully inspect the documentation, hope it's not out o=
f date,
> and then send SIGUSR1 and pray.
>
> This is different from SIGINFO, which does nothing when it's not instal=
led,
> which is safe. You can send SIGINFO to any process, and not be afraid y=
ou kill
> it.
>
> In addition, it's also not easy to send SIGUSR1, you need to open a new=

> terminal, find the pid, and use a kill command (you could also use
> pkill/killall, with the risk of sending the signal to other processes).=

>
> SIGINFO is, AFAIK, supported since 4.4BSD & descendants (ie. all modern=
 BSD
> systems), as well as MacOS X. Perhaps other systems as well (but did no=
t
> investigate).
>
> Why don't we have SIGINFO on Linux? Would a patch to implement this be =
accepted?
>
> SIGINFO is not defined in any standard, but Linux already implements ot=
her
> useful non-standard signals (most notably SIGWINCH). IMHO it's a very u=
seful
> feature.
>
> Thanks,
> Martin
>
> PS.
> I am *not* subscribed to this maillist; please cc me in replies!
Given a quick look at the signal(7) man page, it appears that on at=20
least alpha and sparc systems, SIGINFO is a synonym for SIGPWR, which=20
comes from SVR4, where it was used to indicate that the system had lost=20
power (I don't really understand this usage, but my guess was that UPS=20
monitoring software was supposed to send init a SIGPWR when the UPS=20
switched off AC to the backup power source).

You have to understand however, that the reason that SIGINFO works like=20
that on *BSD is that the kernel and core userspace are developed=20
together, whereas on Linux, they are maintained entirely separately.=20
Outside of core userspace components, using SIGINFO that way on *BSD is=20
just convention.  The people to talk to about that for the core=20
utilities on Linux would be the maintainers of the GNU coreutils, or=20
whatever your distribution might use in their place (I think it's very=20
unlikely that busybox or toybox would implement it however).



--------------ms080303040800010107000306
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIFuDCC
BbQwggOcoAMCAQICAw9gVDANBgkqhkiG9w0BAQ0FADB5MRAwDgYDVQQKEwdSb290IENBMR4w
HAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMTGUNBIENlcnQgU2lnbmlu
ZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2FjZXJ0Lm9yZzAeFw0xNDA4
MDgxMTMwNDRaFw0xNTAyMDQxMTMwNDRaMGMxGDAWBgNVBAMTD0NBY2VydCBXb1QgVXNlcjEj
MCEGCSqGSIb3DQEJARYUYWhmZXJyb2luN0BnbWFpbC5jb20xIjAgBgkqhkiG9w0BCQEWE2Fo
ZW1tZWxnQG9oaW9ndC5jb20wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDdmm8R
BM5D6fGiB6rpogPZbLYu6CkU6834rcJepfmxKnLarYUYM593/VGygfaaHAyuc8qLaRA3u1M0
Qp29flqmhv1VDTBZ+zFu6JgHjTDniBii1KOZRo0qV3jC5NvaS8KUM67+eQBjm29LhBWVi3+e
a8jLxmogFXV0NGej+GHIr5zA9qKz2WJOEoGh0EfqZ2MQTmozcGI43/oqIYhRj8fRMkWXLUAF
WsLzPQMpK19hD8fqwlxQWhBV8gsGRG54K5pyaQsjne7m89SF5M8JkNJPH39tHEvfv2Vhf7EM
Y4WGyhLAULSlym1AI1uUHR1FfJaj3AChaEJZli/AdajYsqc7AgMBAAGjggFZMIIBVTAMBgNV
HRMBAf8EAjAAMFYGCWCGSAGG+EIBDQRJFkdUbyBnZXQgeW91ciBvd24gY2VydGlmaWNhdGUg
Zm9yIEZSRUUgaGVhZCBvdmVyIHRvIGh0dHA6Ly93d3cuQ0FjZXJ0Lm9yZzAOBgNVHQ8BAf8E
BAMCA6gwQAYDVR0lBDkwNwYIKwYBBQUHAwQGCCsGAQUFBwMCBgorBgEEAYI3CgMEBgorBgEE
AYI3CgMDBglghkgBhvhCBAEwMgYIKwYBBQUHAQEEJjAkMCIGCCsGAQUFBzABhhZodHRwOi8v
b2NzcC5jYWNlcnQub3JnMDEGA1UdHwQqMCgwJqAkoCKGIGh0dHA6Ly9jcmwuY2FjZXJ0Lm9y
Zy9yZXZva2UuY3JsMDQGA1UdEQQtMCuBFGFoZmVycm9pbjdAZ21haWwuY29tgRNhaGVtbWVs
Z0BvaGlvZ3QuY29tMA0GCSqGSIb3DQEBDQUAA4ICAQCr4klxcZU/PDRBpUtlb+d6JXl2dfto
OUP/6g19dpx6Ekt2pV1eujpIj5whh5KlCSPUgtHZI7BcksLSczQbxNDvRu6LNKqGJGvcp99k
cWL1Z6BsgtvxWKkOmy1vB+2aPfDiQQiMCCLAqXwHiNDZhSkwmGsJ7KHMWgF/dRVDnsl6aOQZ
jAcBMpUZxzA/bv4nY2PylVdqJWp9N7x86TF9sda1zRZiyUwy83eFTDNzefYPtc4MLppcaD4g
Wt8U6T2ffQfCWVzDirhg4WmDH3MybDItjkSB2/+pgGOS4lgtEBMHzAGQqQ+5PojTHRyqu9Jc
O59oIGrTaOtKV9nDeDtzNaQZgygJItJi9GoAl68AmIHxpS1rZUNV6X8ydFrEweFdRTVWhUEL
70Cnx84YBojXv01LYBSZaq18K8cERPLaIrUD2go+2ffjdE9ejvYDhNBllY+ufvRizIjQA1uC
OdktVAN6auQob94kOOsWpoMSrzHHvOvVW/kbokmKzaLtcs9+nJoL+vPi2AyzbaoQASVZYOGW
pE3daA0F5FJfcPZKCwd5wdnmT3dU1IRUxa5vMmgjP20lkfP8tCPtvZv2mmI2Nw5SaXNY4gVu
WQrvkV2in+TnGqgEIwUrLVbx9G6PSYZZs07czhO+Q1iVuKdAwjL/AYK0Us9v50acIzbl5CWw
ZGj3wjGCA6EwggOdAgEBMIGAMHkxEDAOBgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6
Ly93d3cuY2FjZXJ0Lm9yZzEiMCAGA1UEAxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEh
MB8GCSqGSIb3DQEJARYSc3VwcG9ydEBjYWNlcnQub3JnAgMPYFQwCQYFKw4DAhoFAKCCAfUw
GAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTQxMTA1MTkzMTEy
WjAjBgkqhkiG9w0BCQQxFgQU55OuqCIAx1AvlVxMLv4WrXMzqQIwbAYJKoZIhvcNAQkPMV8w
XTALBglghkgBZQMEASowCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMA4GCCqGSIb3DQMCAgIA
gDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggqhkiG9w0DAgIBKDCBkQYJKwYBBAGCNxAE
MYGDMIGAMHkxEDAOBgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6Ly93d3cuY2FjZXJ0
Lm9yZzEiMCAGA1UEAxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEhMB8GCSqGSIb3DQEJ
ARYSc3VwcG9ydEBjYWNlcnQub3JnAgMPYFQwgZMGCyqGSIb3DQEJEAILMYGDoIGAMHkxEDAO
BgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6Ly93d3cuY2FjZXJ0Lm9yZzEiMCAGA1UE
AxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEhMB8GCSqGSIb3DQEJARYSc3VwcG9ydEBj
YWNlcnQub3JnAgMPYFQwDQYJKoZIhvcNAQEBBQAEggEAhRTa0Xr4QFrQRG880R8u6ImrMziY
UimZJKUC/w/p7ceGEWzBSC18PVvVC8/oETgDd3k1p5IboazkVPHXaRbKAHvEnc2IGgSi63Fu
PeLtezLLvohmGX3jyLPd7vazbsgF1h74wFzbqOeGAzS3k4iSEihkovH/c+GVYLHVKxW6HPEc
ans0IMRewigA5E+CbNlbBN+ogeKlBzU9KWt5e5iIaTcl49/Zheeq+7kON7NHR8F7pJ88egCU
PplttS5kb9hdfU8qGyugyiRd4E2kPTqN1r/bC+7gxdSGEDqQc8XuLVdwDRWhspKqYMf+i4fP
TqCIZT5A2UTmCuXwd+5+8DLUXgAAAAAAAA==
--------------ms080303040800010107000306--
