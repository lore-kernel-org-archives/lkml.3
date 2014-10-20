Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752547AbaJTN2A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 09:28:00 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:54375 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752468AbaJTN15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 09:27:57 -0400
Message-ID: <54450DD5.8060001@gmail.com>
Date: Mon, 20 Oct 2014 09:27:49 -0400
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Sandy Harris <sandyinchina@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: RFC: Alternative to systemd?
References: <CACXcFmnjqsDZ0nq2h9ymiUQMczD7yX64COVnz8WsrC38fL1iuQ@mail.gmail.com>
In-Reply-To: <CACXcFmnjqsDZ0nq2h9ymiUQMczD7yX64COVnz8WsrC38fL1iuQ@mail.gmail.com>
x-hashcash: 1:21:141020:sandyinchina@gmail.com::7d5998d3d394cdd1b83fdab5c54a0cbd:5373c04303e38de6
x-hashcash: 1:21:141020:linux-kernel@vger.kernel.org::42e59cb02b052da6743456b894405ed5:92450f86d8435edf
x-stampprotocols: hashcash:1:17;mbound:0:10:3000:5000
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms090002030305070502070400"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms090002030305070502070400
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2014-10-17 11:53, Sandy Harris wrote:
> I've been reading the debates around systemd, haven't reached any firm
> conclusion but the criticism that Unix programs should "do one thing
> and do it well" certainly resonates with me.
>
> On the other hand, this may be one of those cases where theory and
> practice need to differ; more-or-less all the arguments against
> systemd's complexity and overly broad scope have been used in debates
> over monolithic vs. message-passing kernels. I'd say that in theory
> message-passing and smaller programs are obviously better in some
> ways, but in practice other considerations may be more important. That
> is certainly the case for the kernel; I do not know if it is for
> systemd.
>
> All that said, I don't want to re-open the debate here. I would,
> though, like to solicit comment on what seems to me a possible simple
> alternative that deals with only one of the problems systemd claims to
> solve; expressing dependencies that the init process needs to deal
> with. There seems to be fairly widespread agreement that the way
> sysvinit does this rather clumsy.
>
> We already have a well-established way of dealing with some types of
> dependency, in makefiles. Would something with roughly that syntax
> work for expressing the dependencies here? Sample lines might be
> things like:
>
> sshd: random
>
> !random:
>         cat /var/run/random_seed >/dev/urandom
>
> The first line says sshd depends on random; "init sshd" will first
> deal with dependencies, so it does the command for random before
> starting sshd. Since no command is given for sshd, it defaults to
> "sshd &". If arguments are needed, put in a command line. If some
> other process depends on sshd it just checks whether it is running via
> "ps -C sshd" and, if not, starts it.
>
> "!random:" says, via the "!", that random is not a process that can be
> checked with ps -C. We would need to add a data structure to support
> another way to check if the process had been run. In actual use' we'd
> also have a more complex command than just the cat.
>
> It seems to me this could handle everything needed for init's startup
> activities. Adding simple run levels is straightforward; just define
> !runlevel3 or !network or whatever with appropriate dependencies. I am
> not certain whether or how it might be extended to stop processes when
> reducing run level, though.
>
> Comments?

Actually, Gentoo's OpenRC init system uses make for dependency=20
processing already, but only when configured for parallel startup.  It=20
would be nice if it were better integrated (OpenRC generates (and then=20
caches) the Makefile each time one of the initscripts or runlevels gets=20
modified).
To be honest though, systemd's developers seem to ignore the fact that=20
there are many other init systems that have better dependency processing =

than sysvinit and/or can do parallel startup.  The only thing that I can =

see in systemd that isn't available in some other init system is socket=20
activation, and even that isn't exclusive anymore with the advent of=20
uselessd.



--------------ms090002030305070502070400
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
GAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTQxMDIwMTMyNzQ5
WjAjBgkqhkiG9w0BCQQxFgQUIx/2xT985M7xfIxD78rKdRKmx6wwbAYJKoZIhvcNAQkPMV8w
XTALBglghkgBZQMEASowCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMA4GCCqGSIb3DQMCAgIA
gDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggqhkiG9w0DAgIBKDCBkQYJKwYBBAGCNxAE
MYGDMIGAMHkxEDAOBgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6Ly93d3cuY2FjZXJ0
Lm9yZzEiMCAGA1UEAxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEhMB8GCSqGSIb3DQEJ
ARYSc3VwcG9ydEBjYWNlcnQub3JnAgMPYFQwgZMGCyqGSIb3DQEJEAILMYGDoIGAMHkxEDAO
BgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6Ly93d3cuY2FjZXJ0Lm9yZzEiMCAGA1UE
AxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEhMB8GCSqGSIb3DQEJARYSc3VwcG9ydEBj
YWNlcnQub3JnAgMPYFQwDQYJKoZIhvcNAQEBBQAEggEATvRXO1nro7x9tREwyVXYSx1iI/qH
SlwTxtYiELM4kfWjmxsm08SkjgHmJfbJZ70hPGtjGaMGxVcyWGN2pSnZLvWb1CGiWNKD+09u
GG8rsVTzSTVkw7BCb3sgqncQM2j0yACjBlla/X84kRRdRoLZVr5r8oUVwl7Z8dRrKAHI4BBk
/4InhY7FF8NBTMbOJYSsLLcgHZzk6u2xBYuI+hY1jngG+O6pmD1PL+jYsoDhpM3ym+whWfvG
ys8jyrfJR0LVEi6/XfeC2iGfG1/DDwweunL1nnJtDlmpLaFrIkY4YbN+/IzL29nqkivreunO
nGIiT5h3vRizHaaFloCr6AsCjwAAAAAAAA==
--------------ms090002030305070502070400--
