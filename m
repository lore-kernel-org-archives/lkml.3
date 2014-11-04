Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751985AbaKDRRy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 12:17:54 -0500
Received: from mga02.intel.com ([134.134.136.20]:10171 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751156AbaKDRRk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 12:17:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,313,1413270000"; 
   d="asc'?scan'208";a="602110387"
From: "Rustad, Mark D" <mark.d.rustad@intel.com>
To: Steven Rostedt <rostedt@goodmis.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Petr Mladek <pmladek@suse.cz>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RFC][PATCH 01/12 v3] x86/kvm/tracing: Use helper function
 trace_seq_buffer_ptr()
Thread-Topic: [RFC][PATCH 01/12 v3] x86/kvm/tracing: Use helper function
 trace_seq_buffer_ptr()
Thread-Index: AQHP+Ejxoqx4IykR8ECnWrUm/ou4UZxRO9yA
Date: Tue, 4 Nov 2014 17:17:08 +0000
Message-ID: <C664BE5A-1B30-454F-B7B8-DE4D5F5DF4B8@intel.com>
References: <20141104155237.228431433@goodmis.org>
 <20141104160221.585025609@goodmis.org>
In-Reply-To: <20141104160221.585025609@goodmis.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [10.24.25.101]
Content-Type: multipart/signed;
	boundary="Apple-Mail=_F5395F0F-829F-42D0-81E6-578EE3AD3C30";
	protocol="application/pgp-signature"; micalg=pgp-sha1
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Apple-Mail=_F5395F0F-829F-42D0-81E6-578EE3AD3C30
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Nov 4, 2014, at 7:52 AM, Steven Rostedt <rostedt@goodmis.org> wrote:

> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
>=20
> To allow for the restructiong of the trace_seq code, we need users
> of it to use the helper functions instead of accessing the internals
> of the trace_seq structure itself.
>=20
> Cc: Mark Rustad <mark.d.rustad@intel.com>
> Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
> arch/x86/kvm/mmutrace.h | 4 ++--
> 1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/arch/x86/kvm/mmutrace.h b/arch/x86/kvm/mmutrace.h
> index 5aaf35641768..ce463a9cc8fb 100644
> --- a/arch/x86/kvm/mmutrace.h
> +++ b/arch/x86/kvm/mmutrace.h
> @@ -22,7 +22,7 @@
> 	__entry->unsync =3D sp->unsync;
>=20
> #define KVM_MMU_PAGE_PRINTK() ({				        =
\
> -	const u32 saved_len =3D p->len;					=
\
> +	const char *saved_ptr =3D trace_seq_buffer_ptr(p);		=
\

I think the above should not be a const char *, because the location =
pointed to is surely being changed. It should either be a char * or a =
char * const.

> 	static const char *access_str[] =3D {			        =
\
> 		"---", "--x", "w--", "w-x", "-u-", "-ux", "wu-", "wux"  =
\
> 	};							        =
\
> @@ -41,7 +41,7 @@
> 			 role.nxe ? "" : "!",				=
\
> 			 __entry->root_count,				=
\
> 			 __entry->unsync ? "unsync" : "sync", 0);	=
\
> -	p->buffer + saved_len;						=
\
> +	saved_ptr;							=
\
> 		})
>=20
> #define kvm_mmu_trace_pferr_flags       \
> --=20
> 2.1.1

--=20
Mark Rustad, Networking Division, Intel Corporation


--Apple-Mail=_F5395F0F-829F-42D0-81E6-578EE3AD3C30
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="signature.asc"
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIcBAEBAgAGBQJUWQoTAAoJEDwO/+eO4+5uI7QQAL8AGJR52CCrS79236Kwusuc
T/FXSamyGjMIr5yScadSsYQNVUADykAHFXj+VP0pWsO+W+zLYg9y9qTBX+WX5cnV
7T/3hFlfKxKjZSpjjrV1ZUkmwStd5sW2am9gBbA8Wzzy/S/3Io3H+FQyNAOX3041
dchDhaHV+0qFOBAHhCZhXCMEjg9VFvLNSyHb7fRkIci+Om8wE2SswdI2Wssdp+ZN
9HLjMFchvqAqO3wAlylnJ01NLTSKmajcMVjP00I8XzGWJWFxjaH9noPU3L5cHEwR
k/r5F/B/DnPNF9RdTDu8DdFOWpnRekTpRW1YXenkSLBTb5K0oXtwL5x6gCfRcIwP
0BOSS11L+fl0ndagHesUZtjPJY72OOKFKYeD5fJdIoz5aziCfI1wVRZelh7DaaIB
xntafr6PMksos9M1jQ6Zr4TpO7REZ0GQBLQTzJPiJ+MdLhDxcgOZrzsChVGV6qt+
eXb+JA6L0wY2mObHbzYslm0EZOSYESsct4pX//5iy/kzjK2V+jGDD3JhZDvupWHg
238uYbr8nQwi8Va99D2imFzlgJOQQk0ZA7DLYjLeE68BsfETVkWgoJlOkLAcY7eW
8WWNui3mqV/ALFLY3cI4/Vs7T0DGGBHvwwKYOdGboNFsucQ3WPcP64hRir/5VUnt
7hujYlrHsJUCFvon0s/V
=X3mD
-----END PGP SIGNATURE-----

--Apple-Mail=_F5395F0F-829F-42D0-81E6-578EE3AD3C30--
