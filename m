Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755215Ab3C0FnY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 01:43:24 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52621 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751760Ab3C0FnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 01:43:23 -0400
Message-ID: <1364362994.3520.54.camel@deadeye.wl.decadent.org.uk>
Subject: Re: Build breakage in 3.8.4 [was: Linux 3.8.4]
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Kees Cook <keescook@chromium.org>, Jiri Slaby <jslaby@suse.cz>,
        Sebastian Gottschall <s.gottschall@dd-wrt.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 27 Mar 2013 05:43:14 +0000
In-Reply-To: <20130326161810.GB18581@kroah.com>
References: <20130320201554.GA18281@kroah.com> <kidd01$2o6$1@ger.gmane.org>
	 <514F5480.6040501@suse.cz>
	 <CAGXu5jJdbDabBjNoaZUeqCT6a6yHqHcQNnqXNM6T1S=bwig8Fw@mail.gmail.com>
	 <20130326161810.GB18581@kroah.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-hAtNRfSOvLBHzGbxQPy3"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:e40a:77e1:ece1:499b
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-hAtNRfSOvLBHzGbxQPy3
Content-Type: multipart/mixed; boundary="=-b7+xJ2hN91PTT7wKDQfv"


--=-b7+xJ2hN91PTT7wKDQfv
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2013-03-26 at 09:18 -0700, Greg KH wrote:
> On Tue, Mar 26, 2013 at 08:56:20AM -0700, Kees Cook wrote:
> > On Sun, Mar 24, 2013 at 12:31 PM, Jiri Slaby <jslaby@suse.cz> wrote:
> > > On 03/20/2013 11:25 PM, Sebastian Gottschall wrote:
> > >
> > >> Am 20.03.2013 21:15, schrieb Greg KH:
> > >>> I'm announcing the release of the 3.8.4 kernel.
> > > ...
> > >>>        signal: always clear sa_restorer on execve
> > >> consider that this kernel is not compileable on mips targets due the
> > >> patch in kernel/signal.c
> > >>
> > >> SA_RESTORER is defined in mips, but sa_restorer does not exist on th=
at
> > >> platform
> > >
> > > The same for ia64...
> > >
> > > kernel/signal.c: In function 'flush_signal_handlers':
> > > kernel/signal.c:441: error: 'struct sigaction' has no member named
> > > 'sa_restorer'
> > >
> > > Do we need this in 3.0, 3.4, 3.8 too?
> > > commit 522cff142d7d2f9230839c9e1f21a4d8bcc22a4a
> > > Author: Andrew Morton <akpm@linux-foundation.org>
> > > Date:   Wed Mar 13 14:59:34 2013 -0700
> > >
> > >     kernel/signal.c: use __ARCH_HAS_SA_RESTORER instead of SA_RESTORE=
R
> > >
> > >     __ARCH_HAS_SA_RESTORER is the preferred conditional for use in 3.=
9 and
> > >     later kernels, per Kees.
> >=20
> > Hrm, if so, we'll need to also backport the changes that aded
> > __ARCH_HAS_SA_RESTORER...
>=20
> Ok, well, can someone provide me the needed patches?  Otherwise I will
> have to revert the offending change from the stable releases.

For the third time... use the attached patch followed by Andrew's commit
522cff142d7d2f9230839c9e1f21a4d8bcc22a4a.

Ben.

--=20
Ben Hutchings
I'm not a reverse psychological virus.  Please don't copy me into your sig.

--=-b7+xJ2hN91PTT7wKDQfv
Content-Disposition: attachment;
	filename*0=signal-define-__arch_has_sa_restorer-so-we-know-whether-to-cl;
	filename*1=ear-3.8.patch
Content-Type: text/x-patch;
	name*0=signal-define-__arch_has_sa_restorer-so-we-know-whether-to-clear-;
	name*1=3.8.patch; charset="UTF-8"
Content-Transfer-Encoding: base64

RnJvbTogQmVuIEh1dGNoaW5ncyA8YmVuQGRlY2FkZW50Lm9yZy51az4NCkRhdGU6IFN1biwgMjUg
Tm92IDIwMTIgMjI6MjQ6MTkgLTA1MDANClN1YmplY3Q6IHNpZ25hbDogRGVmaW5lIF9fQVJDSF9I
QVNfU0FfUkVTVE9SRVIgc28gd2Uga25vdyB3aGV0aGVyIHRvIGNsZWFyIHNhX3Jlc3RvcmVyDQoN
CmZsdXNoX3NpZ25hbF9oYW5kbGVycygpIG5lZWRzIHRvIGtub3cgd2hldGhlciBzaWdhY3Rpb246
OnNhX3Jlc3RvcmVyDQppcyBkZWZpbmVkLCBub3Qgd2hldGhlciBTQV9SRVNUT1JFUiBpcyBkZWZp
bmVkLiAgRGVmaW5lIHRoZQ0KX19BUkNIX0hBU19TQV9SRVNUT1JFUiBtYWNybyB0byBpbmRpY2F0
ZSB0aGlzLg0KDQpWYWd1ZWx5IGJhc2VkIG9uIHVwc3RyZWFtIGNvbW1pdCA1NzRjNDg2NmUzM2Qg
J2NvbnNvbGlkYXRlIGtlcm5lbC1zaWRlDQpzdHJ1Y3Qgc2lnYWN0aW9uIGRlY2xhcmF0aW9ucycu
DQoNClNpZ25lZC1vZmYtYnk6IEJlbiBIdXRjaGluZ3MgPGJlbkBkZWNhZGVudC5vcmcudWs+DQpD
YzogQWwgVmlybyA8dmlyb0B6ZW5pdi5saW51eC5vcmcudWs+DQotLS0NCi0tLSBhL2FyY2gvYXJt
L2luY2x1ZGUvYXNtL3NpZ25hbC5oDQorKysgYi9hcmNoL2FybS9pbmNsdWRlL2FzbS9zaWduYWwu
aA0KQEAgLTI5LDYgKzI5LDcgQEAgc3RydWN0IHNpZ2FjdGlvbiB7DQogCV9fc2lncmVzdG9yZV90
IHNhX3Jlc3RvcmVyOw0KIAlzaWdzZXRfdCBzYV9tYXNrOwkJLyogbWFzayBsYXN0IGZvciBleHRl
bnNpYmlsaXR5ICovDQogfTsNCisjZGVmaW5lIF9fQVJDSF9IQVNfU0FfUkVTVE9SRVINCiANCiBz
dHJ1Y3Qga19zaWdhY3Rpb24gew0KIAlzdHJ1Y3Qgc2lnYWN0aW9uIHNhOw0KLS0tIGEvYXJjaC9h
dnIzMi9pbmNsdWRlL2FzbS9zaWduYWwuaA0KKysrIGIvYXJjaC9hdnIzMi9pbmNsdWRlL2FzbS9z
aWduYWwuaA0KQEAgLTI5LDYgKzI5LDcgQEAgc3RydWN0IHNpZ2FjdGlvbiB7DQogCV9fc2lncmVz
dG9yZV90IHNhX3Jlc3RvcmVyOw0KIAlzaWdzZXRfdCBzYV9tYXNrOwkJLyogbWFzayBsYXN0IGZv
ciBleHRlbnNpYmlsaXR5ICovDQogfTsNCisjZGVmaW5lIF9fQVJDSF9IQVNfU0FfUkVTVE9SRVIN
CiANCiBzdHJ1Y3Qga19zaWdhY3Rpb24gew0KIAlzdHJ1Y3Qgc2lnYWN0aW9uIHNhOw0KLS0tIGEv
YXJjaC9jcmlzL2luY2x1ZGUvYXNtL3NpZ25hbC5oDQorKysgYi9hcmNoL2NyaXMvaW5jbHVkZS9h
c20vc2lnbmFsLmgNCkBAIC0yOSw2ICsyOSw3IEBAIHN0cnVjdCBzaWdhY3Rpb24gew0KIAl2b2lk
ICgqc2FfcmVzdG9yZXIpKHZvaWQpOw0KIAlzaWdzZXRfdCBzYV9tYXNrOwkJLyogbWFzayBsYXN0
IGZvciBleHRlbnNpYmlsaXR5ICovDQogfTsNCisjZGVmaW5lIF9fQVJDSF9IQVNfU0FfUkVTVE9S
RVINCiANCiBzdHJ1Y3Qga19zaWdhY3Rpb24gew0KIAlzdHJ1Y3Qgc2lnYWN0aW9uIHNhOw0KLS0t
IGEvYXJjaC9oODMwMC9pbmNsdWRlL2FzbS9zaWduYWwuaA0KKysrIGIvYXJjaC9oODMwMC9pbmNs
dWRlL2FzbS9zaWduYWwuaA0KQEAgLTI5LDYgKzI5LDcgQEAgc3RydWN0IHNpZ2FjdGlvbiB7DQog
CXZvaWQgKCpzYV9yZXN0b3Jlcikodm9pZCk7DQogCXNpZ3NldF90IHNhX21hc2s7CQkvKiBtYXNr
IGxhc3QgZm9yIGV4dGVuc2liaWxpdHkgKi8NCiB9Ow0KKyNkZWZpbmUgX19BUkNIX0hBU19TQV9S
RVNUT1JFUg0KIA0KIHN0cnVjdCBrX3NpZ2FjdGlvbiB7DQogCXN0cnVjdCBzaWdhY3Rpb24gc2E7
DQotLS0gYS9hcmNoL20zMnIvaW5jbHVkZS9hc20vc2lnbmFsLmgNCisrKyBiL2FyY2gvbTMyci9p
bmNsdWRlL2FzbS9zaWduYWwuaA0KQEAgLTIyLDYgKzIyLDcgQEAgc3RydWN0IHNpZ2FjdGlvbiB7
DQogCV9fc2lncmVzdG9yZV90IHNhX3Jlc3RvcmVyOw0KIAlzaWdzZXRfdCBzYV9tYXNrOwkJLyog
bWFzayBsYXN0IGZvciBleHRlbnNpYmlsaXR5ICovDQogfTsNCisjZGVmaW5lIF9fQVJDSF9IQVNf
U0FfUkVTVE9SRVINCiANCiBzdHJ1Y3Qga19zaWdhY3Rpb24gew0KIAlzdHJ1Y3Qgc2lnYWN0aW9u
IHNhOw0KLS0tIGEvYXJjaC9tNjhrL2luY2x1ZGUvYXNtL3NpZ25hbC5oDQorKysgYi9hcmNoL202
OGsvaW5jbHVkZS9hc20vc2lnbmFsLmgNCkBAIC0yOSw2ICsyOSw3IEBAIHN0cnVjdCBzaWdhY3Rp
b24gew0KIAlfX3NpZ3Jlc3RvcmVfdCBzYV9yZXN0b3JlcjsNCiAJc2lnc2V0X3Qgc2FfbWFzazsJ
CS8qIG1hc2sgbGFzdCBmb3IgZXh0ZW5zaWJpbGl0eSAqLw0KIH07DQorI2RlZmluZSBfX0FSQ0hf
SEFTX1NBX1JFU1RPUkVSDQogDQogc3RydWN0IGtfc2lnYWN0aW9uIHsNCiAJc3RydWN0IHNpZ2Fj
dGlvbiBzYTsNCi0tLSBhL2FyY2gvbW4xMDMwMC9pbmNsdWRlL2FzbS9zaWduYWwuaA0KKysrIGIv
YXJjaC9tbjEwMzAwL2luY2x1ZGUvYXNtL3NpZ25hbC5oDQpAQCAtMzksNiArMzksNyBAQCBzdHJ1
Y3Qgc2lnYWN0aW9uIHsNCiAJX19zaWdyZXN0b3JlX3Qgc2FfcmVzdG9yZXI7DQogCXNpZ3NldF90
IHNhX21hc2s7CQkvKiBtYXNrIGxhc3QgZm9yIGV4dGVuc2liaWxpdHkgKi8NCiB9Ow0KKyNkZWZp
bmUgX19BUkNIX0hBU19TQV9SRVNUT1JFUg0KIA0KIHN0cnVjdCBrX3NpZ2FjdGlvbiB7DQogCXN0
cnVjdCBzaWdhY3Rpb24gc2E7DQotLS0gYS9hcmNoL3Bvd2VycGMvaW5jbHVkZS9hc20vc2lnbmFs
LmgNCisrKyBiL2FyY2gvcG93ZXJwYy9pbmNsdWRlL2FzbS9zaWduYWwuaA0KQEAgLTEsNiArMSw3
IEBADQogI2lmbmRlZiBfQVNNX1BPV0VSUENfU0lHTkFMX0gNCiAjZGVmaW5lIF9BU01fUE9XRVJQ
Q19TSUdOQUxfSA0KIA0KKyNkZWZpbmUgX19BUkNIX0hBU19TQV9SRVNUT1JFUg0KICNpbmNsdWRl
IDx1YXBpL2FzbS9zaWduYWwuaD4NCiANCiAjZW5kaWYgLyogX0FTTV9QT1dFUlBDX1NJR05BTF9I
ICovDQotLS0gYS9hcmNoL3MzOTAvaW5jbHVkZS9hc20vc2lnbmFsLmgNCisrKyBiL2FyY2gvczM5
MC9pbmNsdWRlL2FzbS9zaWduYWwuaA0KQEAgLTM0LDYgKzM0LDcgQEAgc3RydWN0IHNpZ2FjdGlv
biB7DQogICAgICAgICB2b2lkICgqc2FfcmVzdG9yZXIpKHZvaWQpOw0KICAgICAgICAgc2lnc2V0
X3Qgc2FfbWFzazsgICAgICAgICAgICAgICAvKiBtYXNrIGxhc3QgZm9yIGV4dGVuc2liaWxpdHkg
Ki8NCiB9Ow0KKyNkZWZpbmUgX19BUkNIX0hBU19TQV9SRVNUT1JFUg0KIA0KIHN0cnVjdCBrX3Np
Z2FjdGlvbiB7DQogICAgICAgICBzdHJ1Y3Qgc2lnYWN0aW9uIHNhOw0KLS0tIGEvYXJjaC9zcGFy
Yy9pbmNsdWRlL2FzbS9zaWduYWwuaA0KKysrIGIvYXJjaC9zcGFyYy9pbmNsdWRlL2FzbS9zaWdu
YWwuaA0KQEAgLTI2LDUgKzI2LDcgQEAgc3RydWN0IGtfc2lnYWN0aW9uIHsNCiAJdm9pZAkJCV9f
dXNlciAqa2FfcmVzdG9yZXI7DQogfTsNCiANCisjZGVmaW5lIF9fQVJDSF9IQVNfU0FfUkVTVE9S
RVINCisNCiAjZW5kaWYgLyogIShfX0FTU0VNQkxZX18pICovDQogI2VuZGlmIC8qICEoX19TUEFS
Q19TSUdOQUxfSCkgKi8NCi0tLSBhL2FyY2gveDg2L2luY2x1ZGUvYXNtL3NpZ25hbC5oDQorKysg
Yi9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9zaWduYWwuaA0KQEAgLTMxLDYgKzMxLDkgQEAgdHlwZWRl
ZiBzaWdzZXRfdCBjb21wYXRfc2lnc2V0X3Q7DQogI2luY2x1ZGUgPHVhcGkvYXNtL3NpZ25hbC5o
Pg0KICNpZm5kZWYgX19BU1NFTUJMWV9fDQogZXh0ZXJuIHZvaWQgZG9fbm90aWZ5X3Jlc3VtZShz
dHJ1Y3QgcHRfcmVncyAqLCB2b2lkICosIF9fdTMyKTsNCisNCisjZGVmaW5lIF9fQVJDSF9IQVNf
U0FfUkVTVE9SRVINCisNCiAjaWZkZWYgX19pMzg2X18NCiBzdHJ1Y3Qgb2xkX3NpZ2FjdGlvbiB7
DQogCV9fc2lnaGFuZGxlcl90IHNhX2hhbmRsZXI7DQotLS0gYS9hcmNoL3h0ZW5zYS9pbmNsdWRl
L2FzbS9zaWduYWwuaA0KKysrIGIvYXJjaC94dGVuc2EvaW5jbHVkZS9hc20vc2lnbmFsLmgNCkBA
IC0yMSw2ICsyMSw3IEBAIHN0cnVjdCBzaWdhY3Rpb24gew0KIAl2b2lkICgqc2FfcmVzdG9yZXIp
KHZvaWQpOw0KIAlzaWdzZXRfdCBzYV9tYXNrOwkJLyogbWFzayBsYXN0IGZvciBleHRlbnNpYmls
aXR5ICovDQogfTsNCisjZGVmaW5lIF9fQVJDSF9IQVNfU0FfUkVTVE9SRVINCiANCiBzdHJ1Y3Qg
a19zaWdhY3Rpb24gew0KIAlzdHJ1Y3Qgc2lnYWN0aW9uIHNhOw0KLS0tIGEvaW5jbHVkZS91YXBp
L2FzbS1nZW5lcmljL3NpZ25hbC5oDQorKysgYi9pbmNsdWRlL3VhcGkvYXNtLWdlbmVyaWMvc2ln
bmFsLmgNCkBAIC05Myw2ICs5MywxMCBAQCB0eXBlZGVmIHVuc2lnbmVkIGxvbmcgb2xkX3NpZ3Nl
dF90Ow0KIA0KICNpbmNsdWRlIDxhc20tZ2VuZXJpYy9zaWduYWwtZGVmcy5oPg0KIA0KKyNpZmRl
ZiBTQV9SRVNUT1JFUg0KKyNkZWZpbmUgX19BUkNIX0hBU19TQV9SRVNUT1JFUg0KKyNlbmRpZg0K
Kw0KIHN0cnVjdCBzaWdhY3Rpb24gew0KIAlfX3NpZ2hhbmRsZXJfdCBzYV9oYW5kbGVyOw0KIAl1
bnNpZ25lZCBsb25nIHNhX2ZsYWdzOw0K


--=-b7+xJ2hN91PTT7wKDQfv--

--=-hAtNRfSOvLBHzGbxQPy3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUVKG8ue/yOyVhhEJAQpNuhAAzlM3q2dWNky0r1CfUG7PduY0d0a4L2nT
sfCki7FXWvAkFsoWlyPo4jfNdUZS/1IAYqWCABQX0iLNuZXYVnEI0qXuM0rXl4eV
90ECnxE+wlHhl45E4Xn6ALDw+iGqWlTbSVVBTfhWaMQZDHpA/b4MZiflLJW/u3q2
z5y/RGxDgz5qTs9YDj23aYppQE0YTvXDfYn9YURnQoQ63nm0JNGgJgczgctuVzcX
pT5uyWBSlSJgqxDOZ2X9lFmoXm2dAmjrBKcBTvHLw1UzD2GyB3yyv2ft20I6aNr+
U5UUQaXXk8pjcZSJCqcQ2Jm9q1Ex+jNXlwLkdu5b2U6Th/3mPh7qoBT9Esp1++4H
vw/iKiexzTtggD6SbSeROIevFqyfLZ04RUZfy92cukf6PeaBJp9BZngk84hSrRGV
JQ2jp7IcM1cfWCLabtEXwxful27+2/C5gUqkr7r1hNiyBokStR3+pVEe+l6YczQr
A7jDvgU5ut2vM3kEOg0u86NINNouiC1/TBAZOUCXssByW8TsvJ/VLNO4rjlVInZA
0TrI8zRdbNcKHy9hfcRrXGhz9zg9DxaLLi1zj6rl7QfZ4R+c0SNt+u6JARy8avks
2o9mrcKTZhYyuYERUFp4HQIibij5ARKYHb2MJV8C/mhU50mwbeB/CJAmPO9wvOAl
49h8zsqDBsw=
=fRa7
-----END PGP SIGNATURE-----

--=-hAtNRfSOvLBHzGbxQPy3--
