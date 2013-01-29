Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590Ab3A2R4B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 12:56:01 -0500
Received: from mga11.intel.com ([192.55.52.93]:40020 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753013Ab3A2R4A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 12:56:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,561,1355126400"; 
   d="p7s'?scan'208";a="283721335"
From: "Woodhouse, David" <david.woodhouse@intel.com>
To: Borislav Petkov <bp@alien8.de>
CC: Kim Phillips <kim.phillips@freescale.com>,
        Russell King <linux@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Daniel Santos <daniel.santos@pobox.com>,
        David Rientjes <rientjes@google.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] arm: use built-in byte swap function
Thread-Topic: [RFC] arm: use built-in byte swap function
Thread-Index: AQHN/cCsyq8jjbGdz0yFuzpMnvmBrphf+6YAgACZEWKAAAODgA==
Date: Tue, 29 Jan 2013 17:55:54 +0000
Message-ID: <1359482147.3529.161.camel@shinybook.infradead.org>
References: <20130128193033.8a0b0a871150c99247f05a95@freescale.com>
	 <20130129083522.GA14302@pd.tnic>
	 <1359478014.3529.157.camel@shinybook.infradead.org>
	 <20130129174249.GB25415@pd.tnic>
In-Reply-To: <20130129174249.GB25415@pd.tnic>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
Content-Type: multipart/signed; micalg=sha1;
	protocol="application/x-pkcs7-signature"; boundary="=-VJHjXIHPm1bnqTLDo4P7"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-VJHjXIHPm1bnqTLDo4P7
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2013-01-29 at 18:42 +0100, Borislav Petkov wrote:
> On Tue, Jan 29, 2013 at 04:46:58PM +0000, Woodhouse, David wrote:
> > If we're really going to have many different architectures depending
> > on different versions of GCC for this (if it wasn't sane to use
> > it from 4.4/4.8 when it got introduced, and depends on some later
> > arch-specific optimisation), then perhaps we'll have the arch
> > provide the corresponding required GCC_VERSION for using each of
> > 64/32/16 bit builtins, instead of just a yes/no flag? Or just define
> > __HAVE_BUILTIN_BSWAPxx__ for itself, perhaps?
>=20
> Damn, there's already the __powerpc__ thing in there.

That's different though. That's because GCC didn't have a generic
__builtin_bswap16() until 4.8, while PowerPC got it in 4.6.

That's a relatively simple and manageable one-off arch-dependency. But
once we get into a mass of "well, it wasn't actually *usable* for ARM
until 4.9", we start wanting to push it into arch code.

> But I liked your other suggestion better to get the offending
> compilers fixed.

That wasn't an *alternative*. It's required if the compiler is doing
something suboptimal, whatever happens. And then we start to *use* the
compiler from the first version that's known to be fixed.

--=20
                   Sent with MeeGo's ActiveSync support.

David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation




--=-VJHjXIHPm1bnqTLDo4P7
Content-Type: application/x-pkcs7-signature; name="smime.p7s"
Content-Disposition: attachment; filename="smime.p7s"
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIO6jCCAz0w
ggKmoAMCAQICAwWw/zANBgkqhkiG9w0BAQUFADBOMQswCQYDVQQGEwJVUzEQMA4GA1UEChMHRXF1
aWZheDEtMCsGA1UECxMkRXF1aWZheCBTZWN1cmUgQ2VydGlmaWNhdGUgQXV0aG9yaXR5MB4XDTA2
MDIxNjE4MDEzMFoXDTE2MDIxOTE4MDEzMFowUjELMAkGA1UEBhMCVVMxGjAYBgNVBAoTEUludGVs
IENvcnBvcmF0aW9uMScwJQYDVQQDEx5JbnRlbCBFeHRlcm5hbCBCYXNpYyBQb2xpY3kgQ0EwggEi
MA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDBpd/XOb9QVqEZ8mQ1042TdOIq3ATDIsV2xDyt
30yLyMR5Wjtus0bn3B+he89BiNO/LP6+rFzEwlD55PlX+HLGIKeNNG97dqyc30FElEUjZzTZFq2N
4e3kVJ/XAEEgANzV8v9qp7qWwxugPgfc3z9BkYot+CifozexHLb/hEZj+yISCU61kRZvuSQ0E11y
YL4dRgcglJeaHo3oX57rvIckaLsYV5/1Aj+R8DM1Ppk965XQAKsHfnyT7C4S50T4lVn4lz36wOdN
Zn/zegG1zp41lnoTFfT4KuKVJH5x7YD1p6KbgJCKLovnujGuohquBNfdXKpZkvz6pGv+iC1HawJd
AgMBAAGjgaAwgZ0wDgYDVR0PAQH/BAQDAgEGMB0GA1UdDgQWBBQaxgxKxEdvqNutK/D0Vgaj7TdU
DDA6BgNVHR8EMzAxMC+gLaArhilodHRwOi8vY3JsLmdlb3RydXN0LmNvbS9jcmxzL3NlY3VyZWNh
LmNybDAfBgNVHSMEGDAWgBRI5mj5K9KylddH2CMgEE8zmJCf1DAPBgNVHRMBAf8EBTADAQH/MA0G
CSqGSIb3DQEBBQUAA4GBABMQOK2kVKVIlUWwLTdywJ+e2O+PC/uQltK2F3lRyrPfBn69tOkIP4Sg
DJOfsxyobIrPLe75kBLw+Dom13OBDp/EMZJZ1CglQfVV8co9mT3aZMjSGGQiMgkJLR3jMfr900fX
ZKj5XeqCJ+JP0mEhJGEdVCY+FFlksJjV86fDrq1QMIIFijCCBHKgAwIBAgIKYR6AtwAAAAAABzAN
BgkqhkiG9w0BAQUFADBSMQswCQYDVQQGEwJVUzEaMBgGA1UEChMRSW50ZWwgQ29ycG9yYXRpb24x
JzAlBgNVBAMTHkludGVsIEV4dGVybmFsIEJhc2ljIFBvbGljeSBDQTAeFw0wOTA1MTUxOTI1MTNa
Fw0xNTA1MTUxOTM1MTNaMFYxCzAJBgNVBAYTAlVTMRowGAYDVQQKExFJbnRlbCBDb3Jwb3JhdGlv
bjErMCkGA1UEAxMiSW50ZWwgRXh0ZXJuYWwgQmFzaWMgSXNzdWluZyBDQSAzQTCCASIwDQYJKoZI
hvcNAQEBBQADggEPADCCAQoCggEBAMGPgGLnOO5IOzlHRfr1XfCVb97V4BR2QVpPZ7CrcIQ+FGa2
KHD/6dPjwxOIrtFTdfW4BYikdFmxUZVBWRWZ5Vye2cCdGzFWqIEOE1e17nNx1jM8Z6GZEqbDUS+v
BuPlBFHKQoVm5BaNIHpyn2XZxqwjV9j5/crIfPrCGstk+2ztUhVS8OHEgzO784PgD9pOgBnnAbZH
mEM1FYYmQ6ibS+gVCHzobDYG+YReRiHpFKWBxpUuP+X0WYFw/Ja1JW7N8pELAFDw0UFBWFgiv1QI
usdLvSy8mcsLJ5wy050OVcxShqoUxhw/wvyuuoQxvmEPjhRa1C2oSCmGN0003GMhQWMCAwEAAaOC
AlwwggJYMA8GA1UdEwEB/wQFMAMBAf8wHQYDVR0OBBYEFKoWZq+3PVZTYK4Nwu3z7gfLUWB+MAsG
A1UdDwQEAwIBhjASBgkrBgEEAYI3FQEEBQIDAQABMCMGCSsGAQQBgjcVAgQWBBTCKwhTx+hdMsKC
gOmWwLgjQsAV+TAZBgkrBgEEAYI3FAIEDB4KAFMAdQBiAEMAQTAfBgNVHSMEGDAWgBQaxgxKxEdv
qNutK/D0Vgaj7TdUDDCBvQYDVR0fBIG1MIGyMIGvoIGsoIGphk5odHRwOi8vd3d3LmludGVsLmNv
bS9yZXBvc2l0b3J5L0NSTC9JbnRlbCUyMEV4dGVybmFsJTIwQmFzaWMlMjBQb2xpY3klMjBDQS5j
cmyGV2h0dHA6Ly9jZXJ0aWZpY2F0ZXMuaW50ZWwuY29tL3JlcG9zaXRvcnkvQ1JML0ludGVsJTIw
RXh0ZXJuYWwlMjBCYXNpYyUyMFBvbGljeSUyMENBLmNybDCB4wYIKwYBBQUHAQEEgdYwgdMwYwYI
KwYBBQUHMAKGV2h0dHA6Ly93d3cuaW50ZWwuY29tL3JlcG9zaXRvcnkvY2VydGlmaWNhdGVzL0lu
dGVsJTIwRXh0ZXJuYWwlMjBCYXNpYyUyMFBvbGljeSUyMENBLmNydDBsBggrBgEFBQcwAoZgaHR0
cDovL2NlcnRpZmljYXRlcy5pbnRlbC5jb20vcmVwb3NpdG9yeS9jZXJ0aWZpY2F0ZXMvSW50ZWwl
MjBFeHRlcm5hbCUyMEJhc2ljJTIwUG9saWN5JTIwQ0EuY3J0MA0GCSqGSIb3DQEBBQUAA4IBAQCU
Y/1d0MS6VPTlIcOho1XWh193PD5kJDJSPdphLHQdM1oKA+whMdIBoY1VzTDDK+C+Ey4Jcyna7fpC
8uVmn/Rz/i9MZtyc7qezPtZTn9UyORvJmddH+Ox/RycGwe3ags8jUdspECorYOkJyZksnDIlTVUv
bR7wyY+gGJYqxWXqrcVFEiMsWu8/OIlf7F2gAYMBw1kZ55dn4lWBIM0WqvReWpPvhYeN7Y+3MKEd
SMkQ7TZiNbfdZ5D/8KfWNMTJ4VHltOgCL1lA5tx/F4R1920skpL5eu3Sj650RUe3rOXsaV5NyJzB
wB31+1zsmleVdFD0k/Fw9HxXbAQE35ucN/7CMIIGFzCCBP+gAwIBAgIKEIhPUAABAABfaTANBgkq
hkiG9w0BAQUFADBWMQswCQYDVQQGEwJVUzEaMBgGA1UEChMRSW50ZWwgQ29ycG9yYXRpb24xKzAp
BgNVBAMTIkludGVsIEV4dGVybmFsIEJhc2ljIElzc3VpbmcgQ0EgM0EwHhcNMTEwNDEyMTIzMzQx
WhcNMTQwMzI3MTIzMzQxWjBFMRkwFwYDVQQDExBXb29kaG91c2UsIERhdmlkMSgwJgYJKoZIhvcN
AQkBFhlkYXZpZC53b29kaG91c2VAaW50ZWwuY29tMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIB
CgKCAQEAvxW1JMLaZUeM6Cg2OVV1nfsZOt9x/CjVJ7SBlapefSjUoNT48n58zLK+Q00YxPkIxnwl
m57dAxSUf/Dqg+C6DOdLknVQILrGeWNSZdC8GQ8HlHz+D5ldgTDY9L1vDM65p1wbXW4R5QfMbooZ
IQKlyUivGkggwBUpTeeXDOfz5f4m2UW5aCnyG8yhiBUHISAQyXLwQg+iVhBpTqsVvvojybQY8lGF
Z7U+kgbgBY0HCqOuEmT7Iz/tm4W3dpfh8mFluZUn1fMBvCaC+cdKVV/1lpeUdtMNREH+jKUU49lt
BblH1qXmEViOvMT4itbfkUSWeWgeI9umMOK4eL31LLepCQIDAQABo4IC9jCCAvIwCwYDVR0PBAQD
AgeAMDwGCSsGAQQBgjcVBwQvMC0GJSsGAQQBgjcVCIbDjHWEmeVRg/2BKIWOn1OCkcAJZ4HevTmV
8EMCAWQCAQgwHQYDVR0OBBYEFMcuq9ocKJ7EbWcVlAWTYVXwOsrHMB8GA1UdIwQYMBaAFKoWZq+3
PVZTYK4Nwu3z7gfLUWB+MIHPBgNVHR8EgccwgcQwgcGggb6ggbuGV2h0dHA6Ly93d3cuaW50ZWwu
Y29tL3JlcG9zaXRvcnkvQ1JML0ludGVsJTIwRXh0ZXJuYWwlMjBCYXNpYyUyMElzc3VpbmclMjBD
QSUyMDNBKDEpLmNybIZgaHR0cDovL2NlcnRpZmljYXRlcy5pbnRlbC5jb20vcmVwb3NpdG9yeS9D
UkwvSW50ZWwlMjBFeHRlcm5hbCUyMEJhc2ljJTIwSXNzdWluZyUyMENBJTIwM0EoMSkuY3JsMIH1
BggrBgEFBQcBAQSB6DCB5TBsBggrBgEFBQcwAoZgaHR0cDovL3d3dy5pbnRlbC5jb20vcmVwb3Np
dG9yeS9jZXJ0aWZpY2F0ZXMvSW50ZWwlMjBFeHRlcm5hbCUyMEJhc2ljJTIwSXNzdWluZyUyMENB
JTIwM0EoMSkuY3J0MHUGCCsGAQUFBzAChmlodHRwOi8vY2VydGlmaWNhdGVzLmludGVsLmNvbS9y
ZXBvc2l0b3J5L2NlcnRpZmljYXRlcy9JbnRlbCUyMEV4dGVybmFsJTIwQmFzaWMlMjBJc3N1aW5n
JTIwQ0ElMjAzQSgxKS5jcnQwHwYDVR0lBBgwFgYIKwYBBQUHAwQGCisGAQQBgjcKAwwwKQYJKwYB
BAGCNxUKBBwwGjAKBggrBgEFBQcDBDAMBgorBgEEAYI3CgMMME8GA1UdEQRIMEagKQYKKwYBBAGC
NxQCA6AbDBlkYXZpZC53b29kaG91c2VAaW50ZWwuY29tgRlkYXZpZC53b29kaG91c2VAaW50ZWwu
Y29tMA0GCSqGSIb3DQEBBQUAA4IBAQBxLiiAAGnWEDYYtUaje48WjSbMx8O+TsKX2x1sgi/ilnUR
evhznvvFGx9hRrTtQ4Sz+hU7nWvoxbSLDVx6vDQ7+wyGo6SzE0MYqwB3EzwO/P8MnpgZTlEmgDeP
GjYX2IFzp5fG7NNvc6byf8pLjXgn+2wqRLUqrh2PZZ5KKIiicVNT+UOlRIbB2T1WuSVHBMQxhQBr
rzwwYuyoawJCHHo+eKUE51cSSzkT95K+m0Q6XYGC8tQ3i94nBIaLMIg/GM6K2cYKH3vdu/otvGPl
j9/HEKo+mktp2A2S5sIwCKlw8nYOaYKe1dpmYtXKfVoOIIZ/LaVEB/XEIEC1x/oPbrH/MYIB6jCC
AeYCAQEwZDBWMQswCQYDVQQGEwJVUzEaMBgGA1UEChMRSW50ZWwgQ29ycG9yYXRpb24xKzApBgNV
BAMTIkludGVsIEV4dGVybmFsIEJhc2ljIElzc3VpbmcgQ0EgM0ECChCIT1AAAQAAX2kwCQYFKw4D
AhoFAKBdMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTEzMDEyOTE3
NTU0N1owIwYJKoZIhvcNAQkEMRYEFCVQDaZs3gBQZMcBx/04EOiRoalaMA0GCSqGSIb3DQEBAQUA
BIIBAESV5CFAWbRs3UBA3lxy+1Xo/3eb6oMdJrciXk+aykL8YlHfKaKmeUifdbg9452OL9fbWK8S
5lgzH+0fhk18gUeMsdPmYztQdTx1ZnNo9lShtfxhnT+Qdww22gRIxXI2soYypvi1eXzXoBc3xV53
io+cN53RppPPfM+WdFmPbUwsJm4RHpdhMw5cP+o5r+1RUNjY9hr8p71NaTEn4tphYepzAGx8bsg6
7y+PlZG+Zod4adGpf03ljJOZ2djthCPeMrh8HYAtCLMsRH25zFB7PZP5RBu/jayVpveQX0CCD4/g
OsJPRCdJTBnbQaGawEhe2bvQ08kjCXAAMhDLKkKwYhQAAAAAAAA=


--=-VJHjXIHPm1bnqTLDo4P7--
