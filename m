Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751714AbaH1Lhb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 07:37:31 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:44164 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624AbaH1Lh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 07:37:29 -0400
Message-ID: <53FF1472.3020404@gmail.com>
Date: Thu, 28 Aug 2014 07:37:22 -0400
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Rob Landley <rob@landley.net>
CC: Shea Levy <shea@shealevy.com>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Documentation for init
References: <20140826054837.GA2766@nixos.hsd1.nh.comcast.net>	<53FC7EC1.9070401@gmail.com> <CAOS_Y6R6uZtW1QZ9KKtwYk=thYmPU6NVTt8i5ACMmJLYLK=dhw@mail.gmail.com>
In-Reply-To: <CAOS_Y6R6uZtW1QZ9KKtwYk=thYmPU6NVTt8i5ACMmJLYLK=dhw@mail.gmail.com>
x-hashcash: 1:21:140828:rob@landley.net::f261b5a505ce7730b2b27e5d803a13cc:3c6d36fb63b52bb4
x-hashcash: 1:21:140828:shea@shealevy.com::8cac13c28e0a71eb3acd1a4704f35233:2fc2fb2056468dba
x-hashcash: 1:21:140828:linux-kernel@vger.kernel.org::3fa0d4083c6dd00eaa4518e9b20f624:55911ca34f2563e0
x-stampprotocols: hashcash:1:17;mbound:0:10:3000:5000
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms020300020601090200000909"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms020300020601090200000909
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 2014-08-26 18:00, Rob Landley wrote:
> On Tue, Aug 26, 2014 at 7:34 AM, Austin S Hemmelgarn
> <ahferroin7@gmail.com> wrote:
>>  A lot of LiveCD's make use of this
>> to control hardware detection and module loading.  The only open file
>> descriptors (i believe, I may be wrong) are 0, 1, and 2, all pointing =
at
>> /dev/console.
>=20
> Specifically to the /dev/console out of initramfs. If you don't supply
> an initramfs, it'll fake one for you, but if you _do_ you need a
> /dev/console in there. (I have a todo item to fix the devtmpfs
> auto-mount so it actually applies to initramfs/initmpfs instead of
> only applying to the root=3D filesystem.)
>=20
> Note that /dev/console is broken, and does not provide a controlling
> tty. I have no idea why this is the case, but it's been that way
> forever. The dance you have to do to get a shell prompt that actually
> responds to ctrl-c and ctrl-z is:
>=20
> http://landley.net/hg/toybox/file/tip/toys/other/oneit.c
>=20
>> As for special properties:
>>  * Parent of all orphans
>=20
> Because I complained about this in early 2.4 and Andrew Morton added
> reparent_to_init. :)
>=20
> Now that we have containers, the container init process
>=20
>>  * Doesn't have a session ID until it calls setsid() (not certain abou=
t
>> this one)
>=20
> News to me.
>=20
I think now (after reading the rest of your e-mail) that I am wrong
about this.  I assumed that this was the case because I had heard
something about needing to call setsid() to get a shell to behave
properly when started as init.
>>  * Calling exit() will cause either a reboot or possibly a panic (I
>> think that this is dependent on the argument passed to exit())
>=20
> No, it's a panic. You can set "panic=3D1" on the kernel command line to=

> convert all panics into a reboot after a 1 second delay.
>=20
Yeah, I usually use panic=3D-1 when I'm not doing debugging, so I can't
always tell the difference.
> There's a mostly complete list of kernel command line options at:
>=20
> https://www.kernel.org/doc/Documentation/kernel-parameters.txt
>=20
> (And there's some syntax for passing arguments to statically linked
> modules that I never remember. Might be involved with that dot
> nonsense mentioned above.)
>=20
Yeah, the dot thing is a result of using that for statically linked
modules (ie, to pass the argument bar to statically linked module foo,
you specify foo.bar on the kernel commandline).  There are still some
edge-cases here where things that should work don't, I keep meaning to
look into this code further, but never have had the time.
>>  * Not catching a fatal signal will cause a panic (this means that
>> sending SIGKILL and SIGABRT to PID 1 will always cause a panic).
>=20
> No, the kernel starts with SIG_IGNORE on all signals. If you supply a
> handler, your handler gets called. If you don't supply a handler, the
> signal is ignored.
I actually hadn't realized this, are you sure that it does that for all
signals?  If that is the case, then there must be some special handling
in the kernel for if init does something to get a SIGSEGV or SIGFPE that
it doesn't set a handler for.


--------------ms020300020601090200000909
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
GAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTQwODI4MTEzNzIy
WjAjBgkqhkiG9w0BCQQxFgQUZO2E1eP+9XuNzobSBdijupCRNFYwbAYJKoZIhvcNAQkPMV8w
XTALBglghkgBZQMEASowCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMA4GCCqGSIb3DQMCAgIA
gDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggqhkiG9w0DAgIBKDCBkQYJKwYBBAGCNxAE
MYGDMIGAMHkxEDAOBgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6Ly93d3cuY2FjZXJ0
Lm9yZzEiMCAGA1UEAxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEhMB8GCSqGSIb3DQEJ
ARYSc3VwcG9ydEBjYWNlcnQub3JnAgMPYFQwgZMGCyqGSIb3DQEJEAILMYGDoIGAMHkxEDAO
BgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6Ly93d3cuY2FjZXJ0Lm9yZzEiMCAGA1UE
AxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEhMB8GCSqGSIb3DQEJARYSc3VwcG9ydEBj
YWNlcnQub3JnAgMPYFQwDQYJKoZIhvcNAQEBBQAEggEAMv9JC/6fkKejrnff+77gual7wO23
+EGIDeNwGMr73Maf6UkCaUVpOmrwFxilB85hEfoRxIdRvn6t4/0fcri6gKka8V4YABvnsqo7
MEjuBJ3c2taq2i5YS/zrz1WscwFvVTKGchnJQqcpwrGkd9MQWtxAjNMI99Rh+w4FzkNhXEGq
LjzxObqiCHJNgbMMwLzD6SnXQbj0aFZjdRr2AR0Jd3L8P0uTka+CEICJOpq5U9UgRR3n/RYZ
554g+v+wQOmkDIogCyJfHxWws/aH8Vh9VNdt74keONIM6b/+zSubl0YMyxTPj+UGEz5tF0j1
Ca49CXtTRP3b773Ngtx/RzDk5gAAAAAAAA==
--------------ms020300020601090200000909--
