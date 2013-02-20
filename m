Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935521Ab3BTOxw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 09:53:52 -0500
Received: from mga02.intel.com ([134.134.136.20]:45378 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934942Ab3BTOxv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 09:53:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,702,1355126400"; 
   d="p7s'?scan'208";a="265103985"
From: "Woodhouse, David" <david.woodhouse@intel.com>
To: Nicolas Pitre <nico@fluxnic.net>
CC: Kim Phillips <kim.phillips@freescale.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Borislav Petkov <bp@alien8.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Daniel Santos <daniel.santos@pobox.com>,
        David Rientjes <rientjes@google.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robherring2@gmail.com>
Subject: Re: [RFC] arm: use built-in byte swap function
Thread-Topic: [RFC] arm: use built-in byte swap function
Thread-Index: AQHOBNEeAGqv37iTaki0VQignhSLCJhus/aAgAGxes+AAC2C8IAAKGEAgAAi1ICAETzsgIAADQYAgACs2L2AAAieT4AADOQA
Date: Wed, 20 Feb 2013 14:53:30 +0000
Message-ID: <1361372008.13482.280.camel@i7.infradead.org>
References: <20130129181046.GC25415@pd.tnic>
	 <20130131145947.f62474a0600848df86548b96@freescale.com>
	 <20130201011712.GF23505@n2100.arm.linux.org.uk>
	 <1359703995.23531.6.camel@shinybook.infradead.org>
	 <20130205210436.670c62e26d2121330e87af35@freescale.com>
	 <1360141322.6066.4.camel@shinybook.infradead.org>
	 <20130206191905.ac8eb6743e69425f30888704@freescale.com>
	 <20130207181315.GM17833@n2100.arm.linux.org.uk>
	 <1360344301.6066.263.camel@shinybook.infradead.org>
	 <alpine.LFD.2.02.1302081503430.6300@xanadu.home>
	 <1360363233.6066.283.camel@shinybook.infradead.org>
	 <alpine.LFD.2.02.1302081745500.6300@xanadu.home>
	 <20130208191208.2ef3d78bda71aa7b44d00d7b@freescale.com>
	 <alpine.LFD.2.02.1302082102380.6300@xanadu.home>
	 <20130219203115.114eab79e8d2099c6306d921@freescale.com>
	 <alpine.LFD.2.03.1302192151280.6419@syhkavp.arg>
	 <1361356696.13482.269.camel@i7.infradead.org>
	 <alpine.LFD.2.03.1302200835380.6419@syhkavp.arg>
	 <1361367842.13482.279.camel@i7.infradead.org>
	 <alpine.LFD.2.03.1302200905300.6419@syhkavp.arg>
In-Reply-To: <alpine.LFD.2.03.1302200905300.6419@syhkavp.arg>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
Content-Type: multipart/signed; micalg=sha1;
	protocol="application/x-pkcs7-signature"; boundary="=-aoHSNwq8vuh+AKasJ4Vd"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-aoHSNwq8vuh+AKasJ4Vd
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2013-02-20 at 09:06 -0500, Nicolas Pitre wrote:
> On Wed, 20 Feb 2013, Woodhouse, David wrote:
>=20
> > On Wed, 2013-02-20 at 08:36 -0500, Nicolas Pitre wrote:
> > > You'll have the same issue wrt the above whether or not the source
> > > file is C or assembly.
> >=20
> > Hm, true. I was thinking of the code itself (which is
> > position-independent anyway), rather than the flags in the object file.
> >=20
> > So just ship a .S file and for the decompressor (if we need it at all)
> > rebuild it just the same as we do the *other* libgcc code like ashldi3.=
S
> > etc.
>=20
> ... in which case there is no harm shipping a .c file and trivially=20
> enforcing -O2, the rest being equal.

For today's compilers, unless the wind changes.

--=20
                   Sent with MeeGo's ActiveSync support.

David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

--=-aoHSNwq8vuh+AKasJ4Vd
Content-Type: application/x-pkcs7-signature; name="smime.p7s"
Content-Disposition: attachment; filename="smime.p7s"
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIVTDCCAz0w
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
j9/HEKo+mktp2A2S5sIwCKlw8nYOaYKe1dpmYtXKfVoOIIZ/LaVEB/XEIEC1x/oPbrH/MIIGXjCC
BUagAwIBAgIKEI638AABAABfajANBgkqhkiG9w0BAQUFADBWMQswCQYDVQQGEwJVUzEaMBgGA1UE
ChMRSW50ZWwgQ29ycG9yYXRpb24xKzApBgNVBAMTIkludGVsIEV4dGVybmFsIEJhc2ljIElzc3Vp
bmcgQ0EgM0EwHhcNMTEwNDEyMTI0MDM5WhcNMTQwMzI3MTI0MDM5WjBFMRkwFwYDVQQDExBXb29k
aG91c2UsIERhdmlkMSgwJgYJKoZIhvcNAQkBFhlkYXZpZC53b29kaG91c2VAaW50ZWwuY29tMIIB
IjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAsm0RhbzQLRYFSlgFDKSsMvzFctyPQbT8P55g
gj3ZQuklaFo8CLXd3rODycyKauFT/IxEq8udUyanZXLSWdWQuuhrkG9bMnkDy1+KQSaEqgKPHMUT
1sYMyGFoDr4YDnmGLfpQWrBHUT+hwFuBUAqQRndQZbZK8TaOAX55hjNJEVWzXzaJNFb0ZFiaJ8Tl
SY+RA7NS0jv7gsCvV2LamrDZJ0Ht0YZLOenhDzVjph4dUY/2XFv2ceGZSUOyrMiVdkC7hpira+4e
CY5BKboFZluzg+URRnRd/EH08ilHzGxEaKheC99QVCgVl6qI0GguHnTReIU+QBN6D6Aj3kTbUZSw
ywIDAQABo4IDPTCCAzkwCwYDVR0PBAQDAgQwMD0GCSsGAQQBgjcVBwQwMC4GJisGAQQBgjcVCIbD
jHWEmeVRg/2BKIWOn1OCkcAJZ4S52UGHhP9OAgFkAgEMMEQGCSqGSIb3DQEJDwQ3MDUwDgYIKoZI
hvcNAwICAgCAMA4GCCqGSIb3DQMEAgIAgDAHBgUrDgMCBzAKBggqhkiG9w0DBzAdBgNVHQ4EFgQU
anqVzAq92pn3diJlPhvbx6wENA0wHwYDVR0jBBgwFoAUqhZmr7c9VlNgrg3C7fPuB8tRYH4wgc8G
A1UdHwSBxzCBxDCBwaCBvqCBu4ZXaHR0cDovL3d3dy5pbnRlbC5jb20vcmVwb3NpdG9yeS9DUkwv
SW50ZWwlMjBFeHRlcm5hbCUyMEJhc2ljJTIwSXNzdWluZyUyMENBJTIwM0EoMSkuY3JshmBodHRw
Oi8vY2VydGlmaWNhdGVzLmludGVsLmNvbS9yZXBvc2l0b3J5L0NSTC9JbnRlbCUyMEV4dGVybmFs
JTIwQmFzaWMlMjBJc3N1aW5nJTIwQ0ElMjAzQSgxKS5jcmwwgfUGCCsGAQUFBwEBBIHoMIHlMGwG
CCsGAQUFBzAChmBodHRwOi8vd3d3LmludGVsLmNvbS9yZXBvc2l0b3J5L2NlcnRpZmljYXRlcy9J
bnRlbCUyMEV4dGVybmFsJTIwQmFzaWMlMjBJc3N1aW5nJTIwQ0ElMjAzQSgxKS5jcnQwdQYIKwYB
BQUHMAKGaWh0dHA6Ly9jZXJ0aWZpY2F0ZXMuaW50ZWwuY29tL3JlcG9zaXRvcnkvY2VydGlmaWNh
dGVzL0ludGVsJTIwRXh0ZXJuYWwlMjBCYXNpYyUyMElzc3VpbmclMjBDQSUyMDNBKDEpLmNydDAf
BgNVHSUEGDAWBggrBgEFBQcDBAYKKwYBBAGCNwoDBDApBgkrBgEEAYI3FQoEHDAaMAoGCCsGAQUF
BwMEMAwGCisGAQQBgjcKAwQwTwYDVR0RBEgwRqApBgorBgEEAYI3FAIDoBsMGWRhdmlkLndvb2Ro
b3VzZUBpbnRlbC5jb22BGWRhdmlkLndvb2Rob3VzZUBpbnRlbC5jb20wDQYJKoZIhvcNAQEFBQAD
ggEBAIPoSUpUKiFzHvdhFZZAOQkn8UkNJu7E2TWKvlry/gpFf9Ra257sBA4s15nUGuS59M3bmnCe
n9C36IDHuQS3PQeY/DQ2lq26ZVZIiQScz/5hREJ1ZgvSlBJqwwdWEiy6BCKRInFpLfE7fMo3PmML
UcRaFDmYby1BcigEZP14fwa5kGZMOEJGicqeG76jftkAN03RXy0fQaTe2AdvSR/oAYbuY4hn6w8V
3XBcAxUHN9DIzgawtAnj5X5Lal9nOoq3jgAYGGL0upc5dEMNvygjFwzVVFnow1qaT8os8+UP/hla
Y33P2418t7KgL8M0AjtGOE1kUKZmGaV3ppkHI4ms9s4xggLYMIIC1AIBATBkMFYxCzAJBgNVBAYT
AlVTMRowGAYDVQQKExFJbnRlbCBDb3Jwb3JhdGlvbjErMCkGA1UEAxMiSW50ZWwgRXh0ZXJuYWwg
QmFzaWMgSXNzdWluZyBDQSAzQQIKEIhPUAABAABfaTAJBgUrDgMCGgUAoIIBSTAYBgkqhkiG9w0B
CQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0xMzAyMjAxNDUzMjhaMCMGCSqGSIb3DQEJ
BDEWBBSh4v4oAuFLduTC2S1GvFj8kvW0GTBzBgkrBgEEAYI3EAQxZjBkMFYxCzAJBgNVBAYTAlVT
MRowGAYDVQQKExFJbnRlbCBDb3Jwb3JhdGlvbjErMCkGA1UEAxMiSW50ZWwgRXh0ZXJuYWwgQmFz
aWMgSXNzdWluZyBDQSAzQQIKEI638AABAABfajB1BgsqhkiG9w0BCRACCzFmoGQwVjELMAkGA1UE
BhMCVVMxGjAYBgNVBAoTEUludGVsIENvcnBvcmF0aW9uMSswKQYDVQQDEyJJbnRlbCBFeHRlcm5h
bCBCYXNpYyBJc3N1aW5nIENBIDNBAgoQjrfwAAEAAF9qMA0GCSqGSIb3DQEBAQUABIIBABos6eUQ
ToQCBX3hebB1YV2+p2nfZKmcs0h5bBaSihPSCbVHBkGFcGfgIA9vyMOceHhYXEo8SzGXdomuxZK6
yxEDW2rWumPVinrbNcJTFfRC/S9Dv8LSeLDQxTohxrghvq7EvuAxxPuqdYvZb3AWOahnq5T9uF23
Uq1zvflOJnVbYI2NnXAP2t1drfw7qqWJ5b+Urvsng290V73dfV6xPmD5+2M/Jb8TK599hKbKHy3X
VcqDGm2c6r/y3Q2xVeOsGBUPMoto3JxjxtjxIf8tfJboLG+g4dUEdcpEhMm0v2U+6ZCbKQr7lt2G
JLoldndLD6w9riCRklpd9GCGCs3w0msAAAAAAAA=


--=-aoHSNwq8vuh+AKasJ4Vd--
