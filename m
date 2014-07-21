Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509AbaGUG4k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 02:56:40 -0400
Received: from mga02.intel.com ([134.134.136.20]:34329 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751816AbaGUG4j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 02:56:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,698,1400050800"; 
   d="asc'?scan'208";a="576294535"
Date: Mon, 21 Jul 2014 02:25:56 -0400
From: "Chen, Gong" <gong.chen@linux.intel.com>
To: Lan Tianyu <tianyu.lan@intel.com>
Cc: rjw@rjwysocki.net, lenb@kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPI/NVS: Not save NVS region for new machines to
 accelerate S3
Message-ID: <20140721062556.GA23297@gchen.bj.intel.com>
Mail-Followup-To: Lan Tianyu <tianyu.lan@intel.com>, rjw@rjwysocki.net,
	lenb@kernel.org, linux-acpi@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <1405662922-23606-1-git-send-email-tianyu.lan@intel.com>
 <20140718080056.GA2037@gchen.bj.intel.com>
 <53CC7787.2070302@intel.com>
 <20140721050105.GA21503@gchen.bj.intel.com>
 <53CCAB30.405@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cNdxnHkX5QqsyA0e"
Content-Disposition: inline
In-Reply-To: <53CCAB30.405@intel.com>
X-PGP-Key-ID: A43922C7
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cNdxnHkX5QqsyA0e
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 21, 2014 at 01:54:56PM +0800, Lan Tianyu wrote:
> Date: Mon, 21 Jul 2014 13:54:56 +0800
> From: Lan Tianyu <tianyu.lan@intel.com>
> To: rjw@rjwysocki.net, lenb@kernel.org, linux-acpi@vger.kernel.org,
>  linux-kernel@vger.kernel.org, gong.chen@linux.intel.com
> Subject: Re: [PATCH] ACPI/NVS: Not save NVS region for new machines to
>  accelerate S3
> User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:14.0) Gecko/201207=
14
>  Thunderbird/14.0
>=20
> On 2014=E5=B9=B407=E6=9C=8821=E6=97=A5 13:01, Chen, Gong wrote:
> > On Mon, Jul 21, 2014 at 10:14:31AM +0800, Lan Tianyu wrote:
> >> Date: Mon, 21 Jul 2014 10:14:31 +0800
> >> From: Lan Tianyu <tianyu.lan@intel.com>
> >> To: rjw@rjwysocki.net, lenb@kernel.org, linux-acpi@vger.kernel.org,
> >>  linux-kernel@vger.kernel.org, gong.chen@linux.intel.com
> >> Subject: Re: [PATCH] ACPI/NVS: Not save NVS region for new machines to
> >>  accelerate S3
> >> User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:14.0) Gecko/201=
20714
> >>  Thunderbird/14.0
> >>
> >> On 2014=E5=B9=B407=E6=9C=8818=E6=97=A5 16:00, Chen, Gong wrote:
> >>> On Fri, Jul 18, 2014 at 01:55:22PM +0800, Lan Tianyu wrote:
> >>>> Date:	Fri, 18 Jul 2014 13:55:22 +0800
> >>>> From: Lan Tianyu <tianyu.lan@intel.com>
> >>>> To: rjw@rjwysocki.net, lenb@kernel.org
> >>>> Cc: Lan Tianyu <tianyu.lan@intel.com>, linux-acpi@vger.kernel.org,
> >>>>  linux-kernel@vger.kernel.org
> >>>> Subject: [PATCH] ACPI/NVS: Not save NVS region for new machines to
> >>>>  accelerate S3
> >>>> X-Mailer: git-send-email 1.7.9.5
> >>>>
> >>>> NVS region is saved and restored unconditionally for machines without
> >>>> nvs_nosave quirk during S3. Tested some new machines and the operati=
on
> >>>> is not necessary. Saving NVS region also affects S2RAM speed. The ti=
me of
> >>>> NVS saving and restoring depends on the size of NVS region and it co=
nsumes
> >>>> 7~10ms normally.
> >>>>
> >>>> This patch is to make machines produced from 2012 to now not saving =
NVS region
> >>>> to accelerate S3.
> >>>>
> >>> The year 2012 is a mandatory value in the spec?
> >>>
> >>
> >> No, spec indicates that this is only required for S4 and commit 2a6b697
> >> added this behavior because this can fix S3 bug on some machines. But
> >> this isn't necessary for all machines and waster time for S3. So this
> >> patch is to add time base quirk to change default behavior for new mac=
hines.
> >>
> > If so, I don't think a hard-coded valud in the kernel is a good idea.
> > Why not providing a quirk via a command line parameter or module parame=
ter.
> >=20
>=20
> There is already a kernel command "acpi_sleep=3Dnonvs_s3" to do that. But
> this needs to be set by user. Otherwise, saving/restoring NVS region
> also breaks system suspend on some machines and we have added 14
> nonvs quirks in the acpisleep_dmi_table.
>=20
14 quriks! What a terrible BIOS, isn't it? It's time to cleanup so
many hacks. I'm not ACPI expert, but such yet another hack is not
acceptable from my point of view.

--cNdxnHkX5QqsyA0e
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTzLJ0AAoJEI01n1+kOSLHyl0P/3aplafVh2wBfk6EXS9bNeWz
9fJwLo58olMhT9RZquwefAuFXqXoHHV8Dw7pmx40ASJNHSgGnOQkooSBvWYQv/l/
rVFVjw8E6imVYs9P9iEAa6IlJhrLigAu9W8TXdXG2ehl7UQbvoGKmSa2RTk5L2wk
MICfR8KdMMZ3PgL7SKeGVoLhMqHh83GTIa+phhxSSHApAmJW4ExQVxyWGSESrKcZ
GP4D3qj8xV7OpgqoQ/5RYyQ/e+v/4YkAU/Sxtsb8nqmJ1r1SOqAQH0yQeeWPZPPX
TVsbLvR9PVMFyRwlWu5nGFrmXuh0KmZutvzHHlsds3e8s5tSaOO03v2Z8d/+XiAC
duZcnai3Qr3CUmo7adppomTf00icIAK0n45/W00gD8D4XVO4Qnqq1r0Ul4rkRJGI
HKbH91BITreCRSr+C2Y+cE5KHG0lWtufBpBgRjEM0s113HUjW6bw/l2nzjRvgUtB
tgtvpTbSwiA2Sl0am1e6pmtwauGqWtfCrDXm7CPdQySPECVJjfKejT86fihSjklC
JgRBFT3rxWHc6Zpf+UuVPQ24jtAVquGHKz3/J7iDQCcIB1r/Qy3qeG7NlX6nYiKW
GlI1UJ68dY/1X9xPROp1YkUJ24Mp+O+uCKuhpUEaBUl3XM2E36605cg0g55bsKdf
DvpPpPU9wzMipWp6NbEq
=xGEn
-----END PGP SIGNATURE-----

--cNdxnHkX5QqsyA0e--
