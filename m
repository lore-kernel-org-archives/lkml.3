Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751135AbaGZIoe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 04:44:34 -0400
Received: from mout.web.de ([212.227.17.12]:59962 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750774AbaGZIob (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 04:44:31 -0400
Message-ID: <53D36A51.1050000@web.de>
Date: Sat, 26 Jul 2014 10:44:01 +0200
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Tang Chen <tangchen@cn.fujitsu.com>, gleb@kernel.org, mtosatti@redhat.com,
        nadav.amit@gmail.com
CC: kvm@vger.kernel.org, laijs@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com,
        guz.fnst@cn.fujitsu.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 6/6] kvm, mem-hotplug: Reload L1's apic access page
 if it is migrated when L2 is running.
References: <1406144530-23002-1-git-send-email-tangchen@cn.fujitsu.com> <1406144530-23002-7-git-send-email-tangchen@cn.fujitsu.com>
In-Reply-To: <1406144530-23002-7-git-send-email-tangchen@cn.fujitsu.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="0P86VGMd6sWkABaOiHRrXcVG2l9hWHq7C"
X-Provags-ID: V03:K0:LuYPMVDTwgdYjM539GLjI8WXpSRClhOnNKREYn0AvtMAbeCxXBq
 AphNXCSqHyFKYt9IwsDdURiOQXUBV078TOeVP9j/m2EE67zxAM1i4S8ZrnKY2G7OJwNM4/2
 8fJ7IEaQnAvrEaqJUAs6JjGl46mNmrFcGwTvWTFY2ZZFy5p4UsStELs+3ZOtvKvnuHz+45m
 MQ8JUOZqQM3sD2NhGIHUA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--0P86VGMd6sWkABaOiHRrXcVG2l9hWHq7C
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

On 2014-07-23 21:42, Tang Chen wrote:
> This patch only handle "L1 and L2 vm share one apic access page" situat=
ion.
>=20
> When L1 vm is running, if the shared apic access page is migrated, mmu_=
notifier will
> request all vcpus to exit to L0, and reload apic access page physical a=
ddress for
> all the vcpus' vmcs (which is done by patch 5/6). And when it enters L2=
 vm, L2's vmcs
> will be updated in prepare_vmcs02() called by nested_vm_run(). So we ne=
ed to do
> nothing.
>=20
> When L2 vm is running, if the shared apic access page is migrated, mmu_=
notifier will
> request all vcpus to exit to L0, and reload apic access page physical a=
ddress for
> all L2 vmcs. And this patch requests apic access page reload in L2->L1 =
vmexit.

Shouldn't this patch come before we allow apic access page migration?

Jan



--0P86VGMd6sWkABaOiHRrXcVG2l9hWHq7C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlPTalgACgkQitSsb3rl5xQrCwCcCf64LHe41JFtoRnNCHNYnh/0
z/AAoJJ0ta46rkaoGnvl/bbtg60xGWAh
=8zDW
-----END PGP SIGNATURE-----

--0P86VGMd6sWkABaOiHRrXcVG2l9hWHq7C--
