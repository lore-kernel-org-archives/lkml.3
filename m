Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753137AbaF2MWz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 08:22:55 -0400
Received: from mout.web.de ([212.227.17.12]:60160 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752960AbaF2MWx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 08:22:53 -0400
Message-ID: <53B0050B.90104@web.de>
Date: Sun, 29 Jun 2014 14:22:35 +0200
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, x86-ml <x86@kernel.org>,
        kvm@vger.kernel.org, =?UTF-8?B?SsO2cmcgUsO2ZGVs?= <joro@8bytes.org>
Subject: Re: __schedule #DF splat
References: <20140627115545.GC23153@pd.tnic> <53AD5D27.2090505@redhat.com> <20140627121053.GD23153@pd.tnic> <20140628114431.GB4373@pd.tnic> <20140629064626.GD18167@minantech.com> <53AFE2B3.5080300@web.de> <20140629102403.GE18167@minantech.com> <53AFEB16.5040608@web.de> <20140629105339.GF18167@minantech.com> <53AFF192.7020801@web.de> <20140629115143.GA4362@pd.tnic>
In-Reply-To: <20140629115143.GA4362@pd.tnic>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="cGxoe5AvxpA2VUBem5kGog9UNKRqBAXQB"
X-Provags-ID: V03:K0:QY7JsxXqFyho3/FpF+jXGDJ2MRmCbxPYUPS2FtzKDfllTed3b+K
 9fddXNedejaeCD3WpCVJtliB9N8U0uU45C4DHatIxvtuctDq4C48NO5I5V7MF7Pc96lQgIx
 HyCr3olaVDBcvMGZ2Hzojj5O0mwvNWoaf3BvUjeTl6hPG+nu6+HZedzeLvSKtXEmZrlCrxl
 2/Tkdyxg9lcYaOB5pYHGg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--cGxoe5AvxpA2VUBem5kGog9UNKRqBAXQB
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 2014-06-29 13:51, Borislav Petkov wrote:
> On Sun, Jun 29, 2014 at 12:59:30PM +0200, Jan Kiszka wrote:
>> Will see what I can do regarding bisecting. That host is a bit slow
>> (netbook), so it may take a while. Boris will probably beat me in
>> this.
>=20
> Nah, I was about to instrument kvm_multiple_exception() first and am
> slow anyway so... :-)

OK, looks like I won ;): The issue was apparently introduced with "KVM:
x86: get CPL from SS.DPL" (ae9fedc793). Maybe we are not properly saving
or restoring this state on SVM since then.

Need a break, will look into details later.

Jan



--cGxoe5AvxpA2VUBem5kGog9UNKRqBAXQB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEUEARECAAYFAlOwBQsACgkQitSsb3rl5xTahACeMpZF02oYXV/aDVx8rqaMWdeT
wTUAmMPNdNGzc85zJJuGpTm7YWGMmVM=
=/TKs
-----END PGP SIGNATURE-----

--cGxoe5AvxpA2VUBem5kGog9UNKRqBAXQB--
