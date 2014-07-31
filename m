Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932292AbaGaIX5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 04:23:57 -0400
Received: from mga02.intel.com ([134.134.136.20]:19967 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932073AbaGaIXz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 04:23:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,770,1400050800"; 
   d="asc'?scan'208";a="581600369"
Date: Thu, 31 Jul 2014 03:52:34 -0400
From: "Chen, Gong" <gong.chen@linux.intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, tglx@linutronix.de,
        paulus@samba.org, benh@kernel.crashing.org, tony.luck@intel.com,
        hpa@zytor.com, jkosina@suse.cz, rafael.j.wysocki@intel.com,
        linux@arm.linux.org.uk, ralf@linux-mips.org, schwidefsky@de.ibm.com,
        davem@davemloft.net, viro@zeniv.linux.org.uk, fweisbec@gmail.com,
        cl@linux.com, akpm@linux-foundation.org, axboe@kernel.dk,
        JBottomley@parallels.com, neilb@suse.de, christoffer.dall@linaro.org,
        rostedt@goodmis.org, rric@kernel.org, gregkh@linuxfoundation.org,
        mhocko@suse.cz, david@fromorbit.com
Subject: Re: [RFC PATCH v1 13/70] x86, x2apic_cluster: _FROZEN Cleanup
Message-ID: <20140731075234.GA26585@gchen.bj.intel.com>
References: <1406080786-3938-1-git-send-email-gong.chen@linux.intel.com>
 <1406080786-3938-14-git-send-email-gong.chen@linux.intel.com>
 <20140723203628.GJ21707@pd.tnic>
 <20140730062415.GA5100@gchen.bj.intel.com>
 <20140730084852.GA10213@pd.tnic>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="45Z9DzgjV8m4Oswq"
Content-Disposition: inline
In-Reply-To: <20140730084852.GA10213@pd.tnic>
X-PGP-Key-ID: A43922C7
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--45Z9DzgjV8m4Oswq
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 30, 2014 at 10:48:52AM +0200, Borislav Petkov wrote:
> Date: Wed, 30 Jul 2014 10:48:52 +0200
> From: Borislav Petkov <bp@alien8.de>
> To: "Chen, Gong" <gong.chen@linux.intel.com>
> Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, tglx@linutronix.de,
>  paulus@samba.org, benh@kernel.crashing.org, tony.luck@intel.com,
>  hpa@zytor.com, jkosina@suse.cz, rafael.j.wysocki@intel.com,
>  linux@arm.linux.org.uk, ralf@linux-mips.org, schwidefsky@de.ibm.com,
>  davem@davemloft.net, viro@zeniv.linux.org.uk, fweisbec@gmail.com,
>  cl@linux.com, akpm@linux-foundation.org, axboe@kernel.dk,
>  JBottomley@parallels.com, neilb@suse.de, christoffer.dall@linaro.org,
>  rostedt@goodmis.org, rric@kernel.org, gregkh@linuxfoundation.org,
>  mhocko@suse.cz, david@fromorbit.com
> Subject: Re: [RFC PATCH v1 13/70] x86, x2apic_cluster: _FROZEN Cleanup
> User-Agent: Mutt/1.5.23 (2014-03-12)
> Well, look at the original code. What do you think happens if another
> _FROZEN action comes in which we don't handle in the switch-case?
>=20
> Take a piece of paper and play it through slowly if you don't see it.
> Hint: err =3D 0.
>=20
> > It looks like not quite comply with original logic. Once
> > new FROZEN logic is added, we have to update this code again. How
> > about using following code snippet:
> >=20
> > +       if ((action & CPU_TASKS_FROZEN) &&
> > +           ((action & ~CPU_TASKS_FROZEN) =3D=3D CPU_UP_CANCELED)) {
> > +               __update_clusterinfo(this_cpu);
> > +               return NOTIFY_OK;
>=20
> No, this is different now from the original logic.
>=20
I'm silly. You are right. I will use your patch directly(I should do
it at the beginning :-)).

--45Z9DzgjV8m4Oswq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT2fXCAAoJEI01n1+kOSLHw1wP/jtMD6qvvlqL+4ZHrVG+lNHR
VxvpglqdwZsY867BrOIHYjgx96Yjskteyn0xnV2IfOCE96on/Rs39Cfr+QdbtQj/
cKi9DAKKYGD9a8CUvWfXuXtm/SGxjYZOhlKt/GSwpuhhfUmUTEab/xXm6FwD+3YQ
8swyWojbYJtvgFHN0qsf3Q/lEHmlZMC4kbpXrMYCF0ObovIxvcjzc65u5RhkozTp
HdQYr+oPrc7lpcA3q6PtM/4tITnU1gacrfgmI+Dxo0Ou8zDkMFkTo/1fIRX1NpIr
ckfFr/c4uTt2vkw546roKwRe05AKyvGKFI3OSnETVxbo8aavcGFD526FCzsJi832
9RCEwsFc26C2T+ALO6G1+Nj8cOBvZgJfxpVmirMyZ6QbJUxVWEedQwYCIYFvgaP5
NsHuabL/DmRwpwpwP6aXT3XTPo4cghCzDopJ19/dsfrfS9Kh3kPpf0EF4ljp3rds
afBI2KTvJGLB+hS7XJJP9KuKuvpEy4vMwdRvvLBHyy+DSrorE5N6UlzpwkE8oQPE
QQQFMzJHfWUJ2OAkTgoP8i/zhggBk6D/cSXR8spo/YQwrVraVWlGBoOYgSF1d5Ju
nZurfOn7g97+kDG97o1NiXWGLEtz3Y3J7O4KqDn26hL+AL49Rl+kcUHlSKq2pZUg
jI3WGzvLOYiOtEBZoUWN
=RCwn
-----END PGP SIGNATURE-----

--45Z9DzgjV8m4Oswq--
