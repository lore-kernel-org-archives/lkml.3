Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933487AbaJHLos (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 07:44:48 -0400
Received: from mail-ig0-f169.google.com ([209.85.213.169]:58466 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933462AbaJHLop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 07:44:45 -0400
Message-ID: <543523A8.1040006@gmail.com>
Date: Wed, 08 Oct 2014 07:44:40 -0400
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Grozdan <neutrino8@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: High latency while CPU is under full load
References: <CAFLt3pjkXgz9H9p=u-NATyf4C+8ybJ3fwLc=GXEjaabBZ8NF5g@mail.gmail.com>
In-Reply-To: <CAFLt3pjkXgz9H9p=u-NATyf4C+8ybJ3fwLc=GXEjaabBZ8NF5g@mail.gmail.com>
x-hashcash: 1:21:141008:neutrino8@gmail.com::a5af7dd63275b03a4b9097d563203980:54cf7a87a48006e4
x-hashcash: 1:21:141008:linux-kernel@vger.kernel.org::9a10bdbd48f31e4d8a60df5be64b166f:b7f917e9971a9ab7
x-stampprotocols: hashcash:1:17;mbound:0:10:3000:5000
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms000900000000010107030309"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms000900000000010107030309
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2014-10-07 15:28, Grozdan wrote:
> Hi,
>
> Basically, my problem is this:
>
> I'm doing a lot of audio/video encoding on an AMD FX8350. The encoder
> process always runs at nice 10. Even so, my whole system feels very
> sluggish. Switching between different app windows and/or virtual
> desktops takes up usually 3-5 seconds giving the impression that there
> is not enough processing power. Browsing the web is also severely
> impacted.
>
> I had to tune CFS in order to be (much) more responsive during an
> encoding session. This has worked out pretty well thus far, but it is
> my opinion that the user should *not* need to fiddle with buttons to
> make his system respond fluently even under high load. The below is
> what I had to do in order to get a snappy system during such load
>
> kernel.sched_nr_migrate =3D 64
> kernel.sched_latency_ns =3D 65000000
> kernel.sched_wakeup_granularity_ns =3D 100000
> kernel.sched_min_granularity_ns =3D 100000
> kernel.sched_migration_cost_ns =3D 7000000
>
> I have tried 3 different kernels, including one compiled myself, but
> the results are the same
> Kernels I tried were: 3.11.10, 3.12 and 3.16.4 (self-compiled)
>
> My system specs are as follows
>
> CPU: AMD FX-8350 @ 4GHz
> RAM: 16GB DDR1333
> GPU: NVIDIA GTX 560 with NV blob driver
> HDD: Seagate Constellation ES.3 128MB cache
> Desktop: KDE 4.11
>
Are you using a kernel with CONFIG_PREEMPT=3Dy?  I've personally found=20
that that can help hugely with UI sluggishness (and also tends to get=20
better results when doing stuff like live video capture), although to=20
get this you may need to build the kernel yourself.  Also, I would=20
suggest trying the deadline I/O scheduler; I've found it provides much=20
better latency than CFQ for most workloads, and you almost certainly=20
don't need I/O priorities.  I've actually got a similar setup (FX-8320 @ =

4GHz, 16GB DDR3-1600, High-end storage, and a Radeon R7-240 GPU), and=20
had similar issues when doing processing of big (>500MB) images in GIMP, =

and using a CONFIG_PREEMPT enabled kernel and the deadline I/O scheduler =

has pretty much resolved all of these issues.

Additionally, try with KDE's 'semantic desktop' functionality turned=20
off, this eats a huge amount of disk and memory bandwidth, and can=20
easily bring a system to it's knees.  Furthermore, unless you can=20
reproduce things using nouevau instead of the NV driver, you're not as=20
likely to get a lot of help.



--------------ms000900000000010107030309
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
GAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTQxMDA4MTE0NDQw
WjAjBgkqhkiG9w0BCQQxFgQUy+Z7LYQ2urm3zegaUnc2JNkyp1swbAYJKoZIhvcNAQkPMV8w
XTALBglghkgBZQMEASowCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMA4GCCqGSIb3DQMCAgIA
gDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggqhkiG9w0DAgIBKDCBkQYJKwYBBAGCNxAE
MYGDMIGAMHkxEDAOBgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6Ly93d3cuY2FjZXJ0
Lm9yZzEiMCAGA1UEAxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEhMB8GCSqGSIb3DQEJ
ARYSc3VwcG9ydEBjYWNlcnQub3JnAgMPYFQwgZMGCyqGSIb3DQEJEAILMYGDoIGAMHkxEDAO
BgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6Ly93d3cuY2FjZXJ0Lm9yZzEiMCAGA1UE
AxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEhMB8GCSqGSIb3DQEJARYSc3VwcG9ydEBj
YWNlcnQub3JnAgMPYFQwDQYJKoZIhvcNAQEBBQAEggEATLH5chvIfoleclLDrmk1lrxjFF74
F2e55lCt6t7i0iS9ChsQ+MeT52TOlfLbz1LxlpVACyUwNFEIA8LZSh1Qv8N5MgrZwGp6YBYt
0xWV78YOi1cIeiRXuMW6LRrFrAgLbJZsYBCTckGIzmDv4t1/2/ncCJogFkj29rjVdDn/JQlH
anrwBMpF8cjf9T9w5V0ebNAKFHWNxZKUOs28tLTL5OCugPlI8yId8aJUwlK7uACjJ8s1fm2f
4xXKnTc8h9CVhY8IqzORGOeXPgaUcA5orext88wtmvuO72CbSmAMO/S++B5Lt8+YlTmg30q/
36mSz+y8iCBYDliKozReJ9zhTwAAAAAAAA==
--------------ms000900000000010107030309--
