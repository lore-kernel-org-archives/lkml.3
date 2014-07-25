Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760222AbaGYLni (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 07:43:38 -0400
Received: from mailout1.zih.tu-dresden.de ([141.30.67.72]:34860 "EHLO
	mailout1.zih.tu-dresden.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752077AbaGYLnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 07:43:37 -0400
Message-ID: <53D242DC.9070503@tu-dresden.de>
Date: Fri, 25 Jul 2014 13:43:24 +0200
From: Thomas Ilsche <thomas.ilsche@tu-dresden.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH 2/2] perf tools: Default to python version 2
References: <53D135F9.1070104@tu-dresden.de>	<1406258045-25726-1-git-send-email-namhyung@kernel.org>	<1406258045-25726-2-git-send-email-namhyung@kernel.org>	<53D22357.9010005@tu-dresden.de> <87wqb1ivnb.fsf@sejong.aot.lge.com>
In-Reply-To: <87wqb1ivnb.fsf@sejong.aot.lge.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms090802080603000406090605"
X-TUD-Virus-Scanned: mailout1.zih.tu-dresden.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms090802080603000406090605
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Namhyung,

apologies for mixing up your first name earlier.

On 2014-07-25 12:24, Namhyung Kim wrote:
> Hi Thomas,
>=20
> On Fri, 25 Jul 2014 11:28:55 +0200, Thomas Ilsche wrote:
>> Hi Kim,
>>
>> On 2014-07-25 05:14, Namhyung Kim wrote:
>>> According to PEP 394 recommendation [1], it's more portable to use
>>> python2 rather than plain python to refer python binary version 2.
>>
>> I tried to find out how backwards-compatible this is. python2(-config)=

>> was first available in Python 2.7.3 (April 2012), but it is still not
>> available in 2.6.9 (Oct. 2013). So it might be better to use python2
>> as default but fall back to python if python2 is not available.
>>
>> Best,
>> Thomas
>>
>> Signed-off-by: Thomas Ilsche <thomas.ilsche@tu-dresden.de>
>> ---
>> diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
>> index f4f7f58..1b1bc9c 100644
>> --- a/tools/perf/config/Makefile
>> +++ b/tools/perf/config/Makefile
>> @@ -117,8 +117,8 @@ ifdef PARSER_DEBUG
>>  endif
>>
>>  ifndef NO_LIBPYTHON
>> -  override PYTHON :=3D \
>> -    $(call get-executable-or-default,PYTHON,python)
>> +  PYTHON2 :=3D $(call get-executable-or-default,PYTHON,python2)
>=20
> But wouldn't it set PYTHON2 to python2 even if the system doesn't have
> python2 actually?
>=20
>=20
>> +  override PYTHON :=3D $(if $(PYTHON2),$(PYTHON2),$(call get-executab=
le,python))
>=20
> And then it'll set PYTHON to python2, no?
>=20

No, get-executable-or-default only returns anything if it is an actual ex=
ecutable
(asserted by a 'command -v' and 'test -f $ -a -x $'). At least this is ho=
w I understand
the Makefile code. I also tested it with a Python 2.6.9 (no python2 in pa=
th) and it worked
(after fixing some totally unrelated issues in python headers). It will h=
owever complain
that "The path 'python2' is not executable." before using python.

>=20
>>    override PYTHON_CONFIG :=3D \
>>      $(call get-executable-or-default,PYTHON_CONFIG,$(PYTHON)-config)
>=20
>=20
> I'm thinking about something like below.. but sadly it doesn't work for=

> me.. hmm.

Actually this appears to work for me (with 2.6.9 & 2.7.6) and I find this=
 solution more
elegant.

Best,
Thomas

>=20
> Thanks,
> Namhyung
>=20
>=20
>=20
> diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
> index 0f4b7fbc4852..60177278a357 100644
> --- a/tools/perf/config/Makefile
> +++ b/tools/perf/config/Makefile
> @@ -121,8 +121,8 @@ ifdef PARSER_DEBUG
>  endif
> =20
>  ifndef NO_LIBPYTHON
> -  override PYTHON :=3D \
> -    $(call get-executable-or-default,PYTHON,python2)
> +  PYTHON2 :=3D $(if $(call get-executable,python2),python2,python)
> +  override PYTHON :=3D $(call get-executable-or-default,PYTHON,$(PYTHO=
N2))
>    override PYTHON_CONFIG :=3D \
>      $(call get-executable-or-default,PYTHON_CONFIG,$(PYTHON)-config)
> =20
>=20

--=20
Dipl. Inf. Thomas Ilsche
Computer Scientist
Highly Adaptive Energy-Efficient Computing
CRC 912 HAEC: http://tu-dresden.de/sfb912
Technische Universit=E4t Dresden
Center for Information Services and High Performance Computing (ZIH)
01062 Dresden, Germany

Phone: +49 351 463-42168
Fax: +49 351 463-3773
E-Mail: thomas.ilsche@tu-dresden.de


--------------ms090802080603000406090605
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIPhTCC
BHQwggNcoAMCAQICCQCJkBEVWD6HmzANBgkqhkiG9w0BAQsFADBxMQswCQYDVQQGEwJERTEc
MBoGA1UEChMTRGV1dHNjaGUgVGVsZWtvbSBBRzEfMB0GA1UECxMWVC1UZWxlU2VjIFRydXN0
IENlbnRlcjEjMCEGA1UEAxMaRGV1dHNjaGUgVGVsZWtvbSBSb290IENBIDIwHhcNMTQwMjEx
MTMxMTQ1WhcNMTkwNzA5MjM1OTAwWjBaMQswCQYDVQQGEwJERTETMBEGA1UEChMKREZOLVZl
cmVpbjEQMA4GA1UECxMHREZOLVBLSTEkMCIGA1UEAxMbREZOLVZlcmVpbiBQQ0EgR2xvYmFs
IC0gRzAxMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA6ZvDZ4X5Da71jVTDllA1
PWLpbkztlNcAW5UidNQg6zSP1uzAMQQLmYHiphTSUqAoI4SLdIkEXlvg4njBeMsWyyg1OXst
kEXQ7aAAeny/Sg4bAMOG6VwrMRF7DPOCJEOMHDiLamgAmu7cT3ir0sYTm3at7t4m6O8Br3QP
wQmi9mvOvdPNFDBP9eXjpMhim4IaAycwDQJlYE3t0QkjKpY1WCfTdsZxtpAdxO3/NYZ9bzOz
2w/FEcKKg6GUXUFr2NIQ9Uz9ylGs2b3vkoO72uuLFlZWQ8/h1RM9ph8nMM1JVNvJEzSacXXF
bOqnC5j5IZ0nrz6jOTlIaoytyZn7wxLyvQIDAQABo4IBJDCCASAwDgYDVR0PAQH/BAQDAgEG
MB0GA1UdDgQWBBRJt8bP6D0ff+pEexMp9/EKcD7eZDAfBgNVHSMEGDAWgBQxw3kbuvVT1xfg
iXotF2wKsyudMzASBgNVHRMBAf8ECDAGAQH/AgECMD8GA1UdHwQ4MDYwNKAyoDCGLmh0dHA6
Ly9vY3NwMDMzNi50ZWxlc2VjLmRlL3JsL0RUX1JPT1RfQ0FfMi5jcmwweQYIKwYBBQUHAQEE
bTBrMCwGCCsGAQUFBzABhiBodHRwOi8vb2NzcDAzMzYudGVsZXNlYy5kZS9vY3NwcjA7Bggr
BgEFBQcwAoYvaHR0cDovL29jc3AwMzM2LnRlbGVzZWMuZGUvY3J0L0RUX1JPT1RfQ0FfMi5j
ZXIwDQYJKoZIhvcNAQELBQADggEBACwvqeBeQy8FcNxRlXVdgI47DMFjWFSBMIOcXalRh8m2
1w8runhIJGBCzPGi4jPhMh4ym1ETlXnGtazQJO0YFLwvKuovq7ITrEkdXgALBBhqmmXU6Ec1
vK7t33S22PGAUGWgxtojm41TR8psu0DJlV1OYHor5LtmQFWvtjPB6iMhbvxUnd0zQm5Ma9Xk
w/LqBrdaMmoyRXS2tW/+6v8cY6q7iNH4WK8gfo+///b3OHeLGrZQP609R3lGw1e0F2KHvZ6j
NiUHaCSqIvL2rynsN6UUma66AWCGdS1hFbp4loe1ks/hUJGeWToV7J5axob8KD5mutTZNa+t
PEkihYfub48wggVhMIIESaADAgECAgcXpCR5aFyOMA0GCSqGSIb3DQEBCwUAMFoxCzAJBgNV
BAYTAkRFMRMwEQYDVQQKEwpERk4tVmVyZWluMRAwDgYDVQQLEwdERk4tUEtJMSQwIgYDVQQD
ExtERk4tVmVyZWluIFBDQSBHbG9iYWwgLSBHMDEwHhcNMTQwNTI3MTQ1MzI5WhcNMTkwNzA5
MjM1OTAwWjCBhTELMAkGA1UEBhMCREUxKDAmBgNVBAoTH1RlY2huaXNjaGUgVW5pdmVyc2l0
YWV0IERyZXNkZW4xDDAKBgNVBAsTA1pJSDEcMBoGA1UEAxMTVFUgRHJlc2RlbiBDQSAtIEcw
MjEgMB4GCSqGSIb3DQEJARYRcGtpQHR1LWRyZXNkZW4uZGUwggEiMA0GCSqGSIb3DQEBAQUA
A4IBDwAwggEKAoIBAQDBDh6T80T27NAn91B6YQsENBWT/LEfbGPagOzhM1w1Cjx3ICCilYCg
JeIPQmBZT9RalxxF2z2OGDPcRTuqcaFPkgtdGaw1BFEIX+kGe3Itz2GlaKLPnQBHwcp+ODj8
OdgvD4wZqYkvsjaDx1ck2spHHVxLEh/7ybexJL3f1zatqPJkK2fJuOeeUz3Ip74sPqhKn3QA
5Q5E4JUHlvh3l4TDFrbmEIMntRqrJ+LaG2JCQ2G9hfEUvxeo3Zr6y88IdG+d7Hbp+XJkZYoO
enVItm9z+atzo+NBxdmW8nD00xJAG52xQSwN4HR+qtj0CcnMtj41zXv6ul2E7ltRubqNM3sn
AgMBAAGjggH+MIIB+jASBgNVHRMBAf8ECDAGAQH/AgEBMA4GA1UdDwEB/wQEAwIBBjARBgNV
HSAECjAIMAYGBFUdIAAwHQYDVR0OBBYEFMUrU5MXg8n1RkLtQ2rftoCmR/LgMB8GA1UdIwQY
MBaAFEm3xs/oPR9/6kR7Eyn38QpwPt5kMBwGA1UdEQQVMBOBEXBraUB0dS1kcmVzZGVuLmRl
MIGIBgNVHR8EgYAwfjA9oDugOYY3aHR0cDovL2NkcDEucGNhLmRmbi5kZS9nbG9iYWwtcm9v
dC1jYS9wdWIvY3JsL2NhY3JsLmNybDA9oDugOYY3aHR0cDovL2NkcDIucGNhLmRmbi5kZS9n
bG9iYWwtcm9vdC1jYS9wdWIvY3JsL2NhY3JsLmNybDCB1wYIKwYBBQUHAQEEgcowgccwMwYI
KwYBBQUHMAGGJ2h0dHA6Ly9vY3NwLnBjYS5kZm4uZGUvT0NTUC1TZXJ2ZXIvT0NTUDBHBggr
BgEFBQcwAoY7aHR0cDovL2NkcDEucGNhLmRmbi5kZS9nbG9iYWwtcm9vdC1jYS9wdWIvY2Fj
ZXJ0L2NhY2VydC5jcnQwRwYIKwYBBQUHMAKGO2h0dHA6Ly9jZHAyLnBjYS5kZm4uZGUvZ2xv
YmFsLXJvb3QtY2EvcHViL2NhY2VydC9jYWNlcnQuY3J0MA0GCSqGSIb3DQEBCwUAA4IBAQCJ
hMBD4Oh4PXhRwECrWgomDDnELDDFh4FN1e2g0gYbKLg/kA0gw6RKImh4GhTRAbENxW2My+tH
aKFjtwQdBaanilk4DN581jqxjo37jPEwDmNNzT8U4ssiwmkMD2bWM2vTcc7lDj2g7w+sRzIJ
8zi1AtCV43bJT8xBVj0PQpFuqYVvYzgMq+KNtGn4YyiBAMyDY1EzPEgtOovN7sqXb3jGDa71
gqdHWIKf9orfDWCZ/Y8d+Y+rSqtBAHj0fnAzjnIgtJvUIif+Afx/4Rvxy0MHj3q6uHhPFcZ9
QBPm+vxX2nWXEMlJcf1A/Igdah5hUpkmAQIUUJso8QbE4gXBS/BPMIIFpDCCBIygAwIBAgIH
FyxZ1i7USDANBgkqhkiG9w0BAQUFADCBhTELMAkGA1UEBhMCREUxKDAmBgNVBAoTH1RlY2hu
aXNjaGUgVW5pdmVyc2l0YWV0IERyZXNkZW4xDDAKBgNVBAsTA1pJSDEcMBoGA1UEAxMTVFUg
RHJlc2RlbiBDQSAtIEcwMjEgMB4GCSqGSIb3DQEJARYRcGtpQHR1LWRyZXNkZW4uZGUwHhcN
MTQwMjI1MTgwOTExWhcNMTcwMjI0MTgwOTExWjBdMQswCQYDVQQGEwJERTEoMCYGA1UEChMf
VGVjaG5pc2NoZSBVbml2ZXJzaXRhZXQgRHJlc2RlbjEMMAoGA1UECxMDWklIMRYwFAYDVQQD
Ew1UaG9tYXMgSWxzY2hlMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAzxoc9lcS
97ONeAVS1Y361WCBX3sCjHlopnPOgLGsscTI3jd75BxiAeSCvFwu9POGs2vsIHeiKKQyu+3F
s3QHKbewYH/E9D5dcJ8VtKFBL0jU7NaXm8jLY/0nPOOX1t8OGdykV1Hio7KH5RyyOX/XZ6cs
DNRFNACcOMyMTHuSIcMX4htxPmiLsNBXTQ0Ohf/7WClIRIXxYO0EMMA/4Fb3WC23YdPSedJr
RRU/cs0nKcV4g6O14ZfvzN3hQFqs06TBhde3Mv+yUyKHalaOoggNlBqjRXh6KyCYDZnou6Bm
S1EQs+UchWU6jo8WXaKbadJpaIxL3HtcV5JFHZOibtmzJQIDAQABo4ICPjCCAjowLwYDVR0g
BCgwJjARBg8rBgEEAYGtIYIsAQEEAwEwEQYPKwYBBAGBrSGCLAIBBAMBMAkGA1UdEwQCMAAw
CwYDVR0PBAQDAgXgMB0GA1UdJQQWMBQGCCsGAQUFBwMCBggrBgEFBQcDBDAdBgNVHQ4EFgQU
tl3TKO1q/IByitqlWh99jrj7AagwHwYDVR0jBBgwFoAUxStTkxeDyfVGQu1Dat+2gKZH8uAw
JgYDVR0RBB8wHYEbdGhvbWFzLmlsc2NoZUB0dS1kcmVzZGVuLmRlMIGLBgNVHR8EgYMwgYAw
PqA8oDqGOGh0dHA6Ly9jZHAxLnBjYS5kZm4uZGUvdHUtZHJlc2Rlbi1jYS9wdWIvY3JsL2df
Y2FjcmwuY3JsMD6gPKA6hjhodHRwOi8vY2RwMi5wY2EuZGZuLmRlL3R1LWRyZXNkZW4tY2Ev
cHViL2NybC9nX2NhY3JsLmNybDCB2QYIKwYBBQUHAQEEgcwwgckwMwYIKwYBBQUHMAGGJ2h0
dHA6Ly9vY3NwLnBjYS5kZm4uZGUvT0NTUC1TZXJ2ZXIvT0NTUDBIBggrBgEFBQcwAoY8aHR0
cDovL2NkcDEucGNhLmRmbi5kZS90dS1kcmVzZGVuLWNhL3B1Yi9jYWNlcnQvZ19jYWNlcnQu
Y3J0MEgGCCsGAQUFBzAChjxodHRwOi8vY2RwMi5wY2EuZGZuLmRlL3R1LWRyZXNkZW4tY2Ev
cHViL2NhY2VydC9nX2NhY2VydC5jcnQwDQYJKoZIhvcNAQEFBQADggEBADkeZ80dWsjpjOkn
/Rk/1nBWHj139rRsPNCrwr2CZLHLiO9pB6SYTx9W5/7v5hg8883E9ProF/h+nhKiaLtNxsBw
jx8a1v8Uz4buJSeYsFs0wEl3sOoCsfwVNjgJ++AcYu8zsOaalIzeBc4dOiP7gMyN6vyODX3H
HJSySzuffl+ywGQCJWcsjNrOnrRYw99vmKcLB9aI728AMNr/ugJcIGcEfu6ABtECHDhsgYKS
iS+KElT7Yqak4Up7Ji+Q03l4r0s6e9NjT+nScN5ap8g30j0PRWdsQ/fxpM5cwP8nP3if7i5p
3Qy5GEnIEusfkLFckPVLJhRYtL1+kJOVsUs+S4gxggPUMIID0AIBATCBkTCBhTELMAkGA1UE
BhMCREUxKDAmBgNVBAoTH1RlY2huaXNjaGUgVW5pdmVyc2l0YWV0IERyZXNkZW4xDDAKBgNV
BAsTA1pJSDEcMBoGA1UEAxMTVFUgRHJlc2RlbiBDQSAtIEcwMjEgMB4GCSqGSIb3DQEJARYR
cGtpQHR1LWRyZXNkZW4uZGUCBxcsWdYu1EgwCQYFKw4DAhoFAKCCAhcwGAYJKoZIhvcNAQkD
MQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTQwNzI1MTE0MzI0WjAjBgkqhkiG9w0B
CQQxFgQUw3wSl3rSGj/U8thgaDV4+LHubcMwbAYJKoZIhvcNAQkPMV8wXTALBglghkgBZQME
ASowCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMA4GCCqGSIb3DQMCAgIAgDANBggqhkiG9w0D
AgIBQDAHBgUrDgMCBzANBggqhkiG9w0DAgIBKDCBogYJKwYBBAGCNxAEMYGUMIGRMIGFMQsw
CQYDVQQGEwJERTEoMCYGA1UEChMfVGVjaG5pc2NoZSBVbml2ZXJzaXRhZXQgRHJlc2RlbjEM
MAoGA1UECxMDWklIMRwwGgYDVQQDExNUVSBEcmVzZGVuIENBIC0gRzAyMSAwHgYJKoZIhvcN
AQkBFhFwa2lAdHUtZHJlc2Rlbi5kZQIHFyxZ1i7USDCBpAYLKoZIhvcNAQkQAgsxgZSggZEw
gYUxCzAJBgNVBAYTAkRFMSgwJgYDVQQKEx9UZWNobmlzY2hlIFVuaXZlcnNpdGFldCBEcmVz
ZGVuMQwwCgYDVQQLEwNaSUgxHDAaBgNVBAMTE1RVIERyZXNkZW4gQ0EgLSBHMDIxIDAeBgkq
hkiG9w0BCQEWEXBraUB0dS1kcmVzZGVuLmRlAgcXLFnWLtRIMA0GCSqGSIb3DQEBAQUABIIB
ALn73xqlpzaU+2jm4Vx2lO7XPsNoOW3gnSqfN9DiiG8cZ8vfDnbE7Ud0TiiMDTkYqGXuQuhV
+Zi6IPNPz7+GpYWBAqjlEVfCqnve77aLEejONHpe1DaIWZJWJPdZThABLuYK9XkR1TUIlunZ
ETodPua6lCZEs0Xwsf9kMrUneUFN0piBvFen43TktMcQB72+CtTt67jDKHyf2FVUB2gpgSSy
2G5ak1ATeonM8fV9CLLkYwnuOxns17Ns+6TRWCltN1QqIPbWSfDfxadrw9KUIkr3wKQ4A9BM
yKkagCH1jM7n9oahcXxSoI7La3gNmUO22bmjmZS9E0JuKCW8oJ919ywAAAAAAAA=
--------------ms090802080603000406090605--
