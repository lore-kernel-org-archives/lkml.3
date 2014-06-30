Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618AbaF3PFN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 11:05:13 -0400
Received: from mout.web.de ([212.227.15.14]:61710 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751005AbaF3PFJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 11:05:09 -0400
Message-ID: <53B17C5D.5050407@web.de>
Date: Mon, 30 Jun 2014 17:03:57 +0200
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>
CC: Gleb Natapov <gleb@kernel.org>, Borislav Petkov <bp@alien8.de>,
        lkml <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, x86-ml <x86@kernel.org>,
        kvm@vger.kernel.org,
        =?windows-1252?Q?J=F6rg_?= =?windows-1252?Q?R=F6del?= 
	<joro@8bytes.org>
Subject: Re: [PATCH] KVM: SVM: Fix CPL export via SS.DPL
References: <53AFE2B3.5080300@web.de> <20140629102403.GE18167@minantech.com> <53AFEB16.5040608@web.de> <20140629105339.GF18167@minantech.com> <53AFF192.7020801@web.de> <20140629115143.GA4362@pd.tnic> <53B0050B.90104@web.de> <20140629131443.GA5199@pd.tnic> <20140629134247.GG18167@minantech.com> <20140629140104.GB12528@pd.tnic> <20140629142722.GH18167@minantech.com> <53B02395.8030505@web.de> <53B027E0.7040003@web.de> <53B02CEB.7010607@web.de> <53B17BDD.5030301@redhat.com>
In-Reply-To: <53B17BDD.5030301@redhat.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="mXhX4n0huw4C0Av9lOoPnfJDJoistk8im"
X-Provags-ID: V03:K0:5xCE8fQ6JO54HNPgadVpuoJeCRtD2ruvHg56uas8mU7aRVJ5ZWS
 kThpiJH4Apm5SCzxwVv9gzHLImJtaETbTbxDKUuFt9pIliUrMvLe0vUpp2k75QxgRtfY0fv
 rffXpQNhNbD49uqC+XE8BV5/UPpaskHTwd6bMaisSpiii/mzxRiy8iY/7dkXpkc526DeTiT
 9J2I4JzWQr/0UVZhxL/aQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--mXhX4n0huw4C0Av9lOoPnfJDJoistk8im
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 2014-06-30 17:01, Paolo Bonzini wrote:
> Il 29/06/2014 17:12, Jan Kiszka ha scritto:
>> From: Jan Kiszka <jan.kiszka@siemens.com>
>>
>> We import the CPL via SS.DPL since ae9fedc793. However, we fail to
>> export it this way so far. This caused spurious guest crashes, e.g. of=

>> Linux when accessing the vmport from guest user space which triggered
>> register saving/restoring to/from host user space.
>>
>> Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
>> ---
>>
>> Just in time for the next match :D
>>
>>  arch/x86/kvm/svm.c | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
>> index ec8366c..b5e994a 100644
>> --- a/arch/x86/kvm/svm.c
>> +++ b/arch/x86/kvm/svm.c
>> @@ -1462,6 +1462,7 @@ static void svm_get_segment(struct kvm_vcpu *vcp=
u,
>>           */
>>          if (var->unusable)
>>              var->db =3D 0;
>> +        var->dpl =3D to_svm(vcpu)->vmcb->save.cpl;
>>          break;
>>      }
>>  }
>>
>=20
> Thanks.  In theory this is not necessary, the SS.DPL should be the same=

> as the CPL according to the manuals (the manual say that the SS.DPL
> "should match" the CPL, and that's the only reason why I included the
> import in ae9fedc793).  But apparently this is not the case.

15.5.1:

"When examining segment attributes after a #VMEXIT:
[...]
=95 Retrieve the CPL from the CPL field in the VMCB, not from any segment=

DPL."

Jan



--mXhX4n0huw4C0Av9lOoPnfJDJoistk8im
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlOxfGAACgkQitSsb3rl5xScMQCgqzbTHsMUBTE8lyvumWZaAQL5
l7sAoJ3sT35win58oY7HArovCxhE6CGG
=xIz3
-----END PGP SIGNATURE-----

--mXhX4n0huw4C0Av9lOoPnfJDJoistk8im--
