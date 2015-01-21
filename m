Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246AbbAUPj0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 10:39:26 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:61125 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055AbbAUPjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 10:39:17 -0500
Date: Wed, 21 Jan 2015 16:39:12 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Paul Moore <pmoore@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Sabrina Dubroca <sd@queasysnail.net>,
        Guenter Roeck <linux@roeck-us.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-audit@redhat.com, Richard Guy Briggs <rgb@redhat.com>
Subject: Re: linux-next: Tree for Jan 20 -- Kernel panic - Unable to mount
 root fs
Message-ID: <20150121153910.GD22884@ulmo.nvidia.com>
References: <20150120165655.GA10904@kria>
 <20150121110539.GA8924@kria>
 <20150121144214.GA22884@ulmo.nvidia.com>
 <9422577.FVVyjQBZjy@sifl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uxuisgdDHaNETlh8"
Content-Disposition: inline
In-Reply-To: <9422577.FVVyjQBZjy@sifl>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--uxuisgdDHaNETlh8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 21, 2015 at 10:24:11AM -0500, Paul Moore wrote:
> On Wednesday, January 21, 2015 03:42:16 PM Thierry Reding wrote:
> > On Wed, Jan 21, 2015 at 12:05:39PM +0100, Sabrina Dubroca wrote:
> > > 2015-01-21, 04:36:38 +0000, Al Viro wrote:
> > > > On Tue, Jan 20, 2015 at 08:01:26PM -0800, Guenter Roeck wrote:
> > > > > With this patch:
> > > > >=20
> > > > > sys_mkdir .:40775 returned -17
> > > > > sys_mkdir usr:40775 returned 0
> > > > > sys_mkdir usr/lib:40775 returned 0
> > > > > sys_mkdir usr/share:40755 returned 0
> > > > > sys_mkdir usr/share/udhcpc:40755 returned 0
> > > > > sys_mkdir usr/bin:40775 returned 0
> > > > > sys_mkdir usr/sbin:40775 returned 0
> > > > > sys_mkdir mnt:40775 returned 0
> > > > > sys_mkdir proc:40775 returned 0
> > > > > sys_mkdir root:40775 returned 0
> > > > > sys_mkdir lib:40775 returned 0
> > > > > sys_mkdir lib/modules:40775 returned 0
> > > > > ...
> > > > >=20
> > > > > and the problem is fixed.
> > >=20
> > > This patch also works for me.
> > >=20
> > > > ... except that it simply confirms that something's fishy with
> > > > getname_kernel() of ->name of struct filename returned by getname()=
=2E=20
> > > > IOW, I still do not understand the mechanism of breakage there.
> > >=20
> > > I'm not so sure about that.  I tried to copy name to a new string in
> > > do_path_lookup and that didn't help.
> > >=20
> > > Now, I've removed the
> > >=20
> > >         putname(filename);
> > >=20
> > > line from do_path_lookup and I don't get the panic.
> >=20
> > That would indicate that somehow the refcount got unbalanced. Looking
> > more closely it seems like the various audit_*() function do take a
> > reference, but maybe that's not enough.
>=20
> I'm thinking the same thing and I think the problem may be that=20
> __audit_reusename() is not bumping the filename->refcnt.  Can someone who=
 is=20
> seeing this problem bump the refcnt in __audit_reusename()?
>=20
>   struct filename *
>   __audit_reusename(const __user char *uptr)
>   {
>         struct audit_context *context =3D current->audit_context;
>         struct audit_names *n;
>=20
>         list_for_each_entry(n, &context->names_list, list) {
>                 if (!n->name)
>                         continue;
>                 if (n->name->uptr =3D=3D uptr) {
> +                       n->name->refcnt++;
>                         return n->name;
>                 }
>         }
>         return NULL;
>   }

That doesn't seem to help, at least in my case.

Thierry

--uxuisgdDHaNETlh8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUv8geAAoJEN0jrNd/PrOh244P/RqSLeB7+EtQ7SIjB+oq4ps/
bPklOiNKjmgUWv5ZxJQIy6kR5geEvPb/1oRN+48+0+Tb+oUd/kZhCJbKya1lJ6FY
v0E2s9KWxJsSzzHl0nYnc8OAgy8dmFa3GiZ4+t+Pnaj3Ydso4ZnPmtvqGjEHgRgh
Sq73ZVN3fcvAL54EKAkQOIo23zxlUBcC4sBuFjJJwot6DMADvdFgmdeQB6dkzyIF
fKbKPwtiGzrxqme4j9AbDqPFbbbnQOi6+yaZsL2ocQPsPeAiqozqp4dZWXbu+Spg
XMQ1ml0CUWtCL/TG9C5SOFV9plWQ3cPCQVNid/yhZ1bVhGWFrx1mvNrBmf4oXFh/
/2Dp+cNF6DqlI9fkEg5RXuPPHCnWUb3odDq7Lm0zlXXyyW9Wi39UU0m22+mqu2Gc
ZBjHBp6ogwzZX/pXdpg5aXVu4igCyk8+Hg0naIlytwtaca2p7PpJk7XRgJMy8yl7
M9rNzcQTyukJ1r3L9J7WOqn0OaJC3UfYkfnFA8ZPTbOR/A0QxTVm0wxr044rbxcC
mO9tObrqlpRhrWuRlrhd5KSBHixyt3Q05gICNbr0QioG1ABTFOJxURdPI7UqwGu2
2sek+IZVXJAp8YtYmyVquSnrom73EUgSpShc1kbvLobquZkG42c/MM2BUFJWbG6U
jFWSkFoWJgOG+cZBLJob
=4Hgz
-----END PGP SIGNATURE-----

--uxuisgdDHaNETlh8--
