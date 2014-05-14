Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180AbaENJIO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 05:08:14 -0400
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:46382 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753772AbaENJIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 05:08:06 -0400
Date: Wed, 14 May 2014 11:07:46 +0200
From: Michael Mueller <mimu@linux.vnet.ibm.com>
To: Eric Blake <eblake@redhat.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, Gleb Natapov <gleb@kernel.org>,
        Alexander Graf <agraf@suse.de>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        "Jason J. Herne" <jjherne@linux.vnet.ibm.com>,
        Cornelia Huck <cornelia.huck@de.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andreas Faerber <afaerber@suse.de>,
        Richard Henderson <rth@twiddle.net>
Subject: Re: [Qemu-devel] [PATCH v1 RFC 09/10] QEMU: s390: cpu model QMP
 query-cpu-model
Message-ID: <20140514110746.42b6b814@bee>
In-Reply-To: <53723A61.4020601@redhat.com>
References: <1399993222-16339-1-git-send-email-mimu@linux.vnet.ibm.com>
	<1399993222-16339-10-git-send-email-mimu@linux.vnet.ibm.com>
	<53723A61.4020601@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.13; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/C/Ftq.Q4daj=rjN5fcS=J4="; protocol="application/pgp-signature"
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14051409-8372-0000-0000-000009ABB8B5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/C/Ftq.Q4daj=rjN5fcS=J4=
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 13 May 2014 09:29:37 -0600
Eric Blake <eblake@redhat.com> wrote:

Hi Eric,

> On 05/13/2014 09:00 AM, Michael Mueller wrote:
> > This patch implements a new QMP request named "query-cpu-model". It ret=
urns
> > the cpu model of cpu 0. eg:
> >=20
> > request: '{"execute" : "query-cpu-model" }
> > answer:  '{"return" : {"name": "2827-ga2"}}
> >=20
> > Alias names are resolved to their respective machine type and GA names
> > already during cpu instantiation. Thus, also a cpu name like "host",
> > which is implemented as alias, will return its normalized cpu model nam=
e.
> >=20
>=20
> > +    }
> > +    cpu_model =3D g_try_malloc0(sizeof(*cpu_model));
>=20
> It's simpler to just use g_malloc0 and rely on glibc's exit-on-OOM
> behavior than to try and deal with NULL - this isn't user input (so
> unlikely to be so huge as to cause OOM), and would be more in line with
> what most other QMP code does.  But that said...
>=20
> > +    if (!cpu_model) {
> > +        goto out_no_mem;
> > +    }
> > +    cpu_model->name =3D g_try_malloc0(CPU_MODEL_NAME_LEN);
> > +    if (!cpu_model->name) {
> > +        goto out_no_mem;
> > +    }
> > +    snprintf(cpu_model->name, CPU_MODEL_NAME_LEN - 1, "%04x-ga%u",
> > +             cc->proc->type, cc->mach->ga);
>=20
> ...why not just use g_strdup_printf() instead of trying to size a buffer
> yourself?  In other words, skip the g_try_malloc0 to begin with.

I will use that function and I think I can use it with "query-cpu-definitio=
ns"
as well.

>=20
> The fact that you are packing two pieces of information into one string
> is a bit worrisome - that means that the client of the QMP command has
> to parse the string back into two pieces of information if they ever
> need either item in isolation.  If the user never has a need to split
> the name down into parts, you are okay; I don't know S390 well enough to

I see your point, but I consider it as a name only, which needs to be unique
to identify different configurations but has no meaning on the management
interface level.

> know whether anyone will care about type separate from ga.  But if
> someone DOES care, then the QMP command should return the parts already
> split, as in { "type": 2827, "ga": 2 }, or even as convenience provide
> both split and combined forms: { "name": "2827-ga2", "type": 2827, "ga": =
2 }
>=20

Offering both options seems to be desirable but I have to talk with libvirt=
 if that
could be done in a transparent form for them.

Thanks a lot for your comments
Michael

--Sig_/C/Ftq.Q4daj=rjN5fcS=J4=
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJTczJiAAoJELPcPLQSJsKQI5kP/39fScXk99oIs042U7nhoDsQ
T6MEgzPGy0RgO+PsFPABtrhBxIvMtVf6DxUMTHOBnJ6NKnUZt1q5HAmgm2n9KIBC
+Eb5JTphsRxh7jWzmr3Q9RQW40Atbh3aMzVZNCvSmoQ5AyxHGUnCu/ZqQNbOa7SI
iK6dNok9ZsLkPcnVgjvvDnmuDKWBH4vpI5G4sMY1NQUB783RrRp2itiYQTnZDaL7
IrIw68RzFMe2RVXyHQCKFj/YivzXpMSbvyIosX0Cv2cAEViOeQJPqqqY20upMr+m
CCh8KZOy7martSg1p/8tDZV/hFfFftTqPwSDC2XPLgHGxIl57X0ezfdZAN+1gep8
3CbRFJdw0P3QgBAL2NSN2oNSD3BRlUQTarzUEe2ETqdmjYWw0ygkPxjgrFRvfeZm
HpFayYK3JQYzGo5E1Sf8F68d0S+YVLwiYM1xBZMbqmqUtIKJsnFFHR7v4rAcWBnt
Eo10FLz2mFjn/P0Yq3HwDyJ/Xxrfwbs8Rgs/NG6bLmCtGJqrE4HrnUs1myuizXg3
cRbOnm2BlhLcjg/o9aNdZDmVeLbSc3RYpea6yPkM1obAVY3wbH1YBKsRIlGRfs34
FlDFPK4SopESIKQODeNT35Kbm0S+wpzeR0Y3ygd28gwy3BvlUlQ5hg/zT+nJs9IN
WWpNv0YgURWHHqPD31iX
=uWfH
-----END PGP SIGNATURE-----

--Sig_/C/Ftq.Q4daj=rjN5fcS=J4=--

