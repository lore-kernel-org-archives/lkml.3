Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754975AbaD1KYU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 06:24:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38725 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754252AbaD1KYS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 06:24:18 -0400
Date: Mon, 28 Apr 2014 06:23:21 -0400
From: Jeff Layton <jlayton@redhat.com>
To: NeilBrown <neilb@suse.de>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        "Stefan (metze) Metzmacher" <metze@samba.org>,
        Rich Felker <dalias@libc.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, samba-technical@lists.samba.org,
        Ganesha NFS List <nfs-ganesha-devel@lists.sourceforge.net>,
        "Carlos O'Donell" <carlos@redhat.com>,
        libc-alpha <libc-alpha@sourceware.org>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] locks: rename file-private locks to file-description
 locks
Message-ID: <20140428062321.7442881d@tlielax.poochiereds.net>
In-Reply-To: <20140427145125.21e7e6c6@notabene.brown>
References: <1398087935-14001-1-git-send-email-jlayton@redhat.com>
	<20140421140246.GB26358@brightrain.aerifal.cx>
	<535529FA.8070709@gmail.com>
	<20140421161004.GC26358@brightrain.aerifal.cx>
	<5355644C.7000801@gmail.com>
	<20140421184640.GD26358@brightrain.aerifal.cx>
	<535573E0.9080106@gmail.com>
	<20140421155520.3b33fbef@ipyr.poochiereds.net>
	<53558A73.3010602@samba.org>
	<5355F60C.8010004@gmail.com>
	<20140427145125.21e7e6c6@notabene.brown>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/F2ThGorKWIWXa3yQ4UN=+fk"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/F2ThGorKWIWXa3yQ4UN=+fk
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 27 Apr 2014 14:51:25 +1000
NeilBrown <neilb@suse.de> wrote:

> On Tue, 22 Apr 2014 06:54:36 +0200 "Michael Kerrisk (man-pages)"
> <mtk.manpages@gmail.com> wrote:
>=20
> > On 04/21/2014 11:15 PM, Stefan (metze) Metzmacher wrote:
> > > Am 21.04.2014 21:55, schrieb Jeff Layton:
> > >> On Mon, 21 Apr 2014 21:39:12 +0200
> > >> "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com> wrote:
> > >>
> > >>> On 04/21/2014 08:46 PM, Rich Felker wrote:
> > >>>> On Mon, Apr 21, 2014 at 08:32:44PM +0200, Michael Kerrisk (man-pag=
es) wrote:
> > >>>>> On 04/21/2014 06:10 PM, Rich Felker wrote:
> > >>>>>> I'm well aware of that. The problem is that the proposed API is =
using
> > >>>>>> the two-letter abbreviation FD, which ALWAYS means file descript=
or and
> > >>>>>> NEVER means file description (in existing usage) to mean file
> > >>>>>> description. That's what's wrong.
> > >>>>>
> > >>>>> So, can you *please* answer this question: what do you call (i.e.=
,=20
> > >>>>> what  everyday technical language term do use for) the thing
> > >>>>> that sits between a file descriptor and an i-node?=20
> > >>>>>
> > >>>>> (Please don't say 'struct file' -- that is not is an implementati=
on=20
> > >>>>> detail, and does not qualify as the kind of term that I could use=
=20
> > >>>>> when documenting this feature in man pages.)
> > >>>>
> > >>>> "Open file description".
> > >>>
> > >>> Oh! I didn't realize we agreed :-).
> > >>>
> > >>>>> POSIX uses (or invented, I am not sure which) the term file descr=
iption
> > >>>>> for a good reason: it is unambiguous, and therefore precise. I do=
 agree
> > >>>>> that there's a risk of confusion between 'open file descriptor" a=
nd=20
> > >>>>> 'and file description'--it's the same kind of risk as between Eng=
lish=20
> > >>>>> terms such as 'arbitrator' and 'arbitration' (and any number of o=
ther
> > >>>>> examples), and as language speakers we deal with this every day.
> > >>>>
> > >>>> There's not a problem when the full word is used. On the other han=
d,
> > >>>> if you use "arb" as an abbreviation for "arbitration" in a context
> > >>>> where it was already universally understood as meaning "arbitrator=
",
> > >>>> that would be a big problem.
> > >>>>
> > >>>> Likewise the problem here isn't that "open file description" is a =
bad
> > >>>> term. It's that using "FD" to mean "[open] file description" is
> > >>>> utterly confusing, even moreso than just making up a new completely
> > >>>> random word.
> > >>>
> > >>> Ohh -- I had thought you a problem not just with "FD" but also
> > >>> "(open) file description".
> > >>>
> > >>>>>>> 2) The new API constants (F_SETLKP, F_SETLKPW, F_GETLKP) have n=
ames
> > >>>>>>>    that are visually very close to the traditional POSIX lock n=
ames=20
> > >>>>>>>    (F_SETLK, F_SETLKW, F_GETLK). That's an accident waiting to =
happen
> > >>>>>>>    when someone mistypes in code and/or misses such a misttyping
> > >>>>>>>    when reading code. That really must be fixed.
> > >>>>>>
> > >>>>>> I agree, but I don't think making it worse is a solution.
> > >>>>>
> > >>>>> I don't agree that it's making it worse. The real problem here is=
=20
> > >>>>> that people use no good unambiguous term for the thing between a =
file
> > >>>>> descriptor and an inode. POSIX provides us with a solution that m=
ay
> > >>>>> not seem perfect, but it is unambiguous, and I think it might feel
> > >>>>> more comfortable if we used it often enough.
> > >>>>
> > >>>> I would like to see it used more too, and in particular, I think it
> > >>>> belongs in the documentation for these new locking interfaces. But
> > >>>> that still doesn't answer the question of what to call them (the
> > >>>> macros) unless you want:
> > >>>>
> > >>>> F_OPEN_FILE_DESCRIPTION_GETLK
> > >>>> F_OPEN_FILE_DESCRIPTION_SETLK
> > >>>> F_OPEN_FILE_DESCRIPTION_SETLKW
> > >>>
> > >>> Or just 'F_OFD_*'?
> > >>>
> > >>>> Perhaps "OP" (for open-private, i.e. private to the particular ope=
n)
> > >>>> would be a sensible choice; OTOH people are likely to misread it as
> > >>>> OPeration. The general principle I have in mind though is that it
> > >>>> might be nice to highlight the word "open" in "open file descripti=
on"
> > >>>
> > >>> (Fair enough.)
> > >>>
> > >>>> since it (1) contrasts with file descriptor, despite file descript=
ors
> > >>>> also dealing with open files, and (2) contrasts well with legacy f=
cntl
> > >>>> locks, which are (this is the whole bug) associated with the
> > >>>> underlying file and not the open file description.
> > >>>
> > >>> Makes sense to me. (We are in more agreement that I realized.)
> > >>>
> > >>> Cheers,
> > >>>
> > >>> Michael
> > >>>
> > >>>
> > >>>
> > >>
> > >> So the motion is to call them "open file description locks" and chan=
ge
> > >> the macros to read *_OFD_*. Does anyone object?
> > >=20
> > > Works fine for me...
> >=20
> > And works for me.
> >=20
> >=20
>=20
> I think the word "open" is important here.
> I find that "description" is not a word I would have every thought was
> relevant here - it is obviously too long since I have read the man pages.
>=20
> I would prefer
>   per-open locks
> which are contrasted with
>   per-process locks
>=20
> An alternative might be "flock-like" as locks created with "flock" have
> exactly the property we are trying to describe.  Reading the man page for
> "flock" then suggests "open file table entry locks" which is even more of=
 a
> mouthful.  "oftel" is pronounceable though.  Then we could talk about "of=
tel
> locks" in the same sentence as "pin numbers" and "RAM memory".
>=20
> But maybe I came too late to this party, and the boat has sailed?
>=20
> Note to Michael: The text
>    flock() does not lock files over NFS.
> in flock(2) is no longer accurate.  The reality is ... complex.
> See nfs(5), and search for "local_lock".
>=20
>=20
> NeilBrown
>=20
> (I don't care what the macros are - XX would work as well any anything el=
se
> for me).

I sent a pull request to Linus last week and he merged the patches over
the weekend. So yes, this ship has sailed unless someone feels strongly
enough about it to roll up the patches to change it.

I think we'll probably come to know these as "O.F.D. locks" over the long
run. Not a wonderful name, but I can live with it.

Thanks,
--=20
Jeff Layton <jlayton@redhat.com>

--Sig_/F2ThGorKWIWXa3yQ4UN=+fk
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTXiwqAAoJEAAOaEEZVoIV15IP/RUovTKouhb2DvQJ0HQfx3s+
NKGSgoL1c3+oAJggfFwLMCKulSfOqOnTxgRUnaVZTwezx9DUZd8ZF0P08Sm9Onev
So8phudkb3+OHLyyXOWk1lMKY1mykZkmVUujOQ8rc165mhI5gXlwGwrjHJ1HoWhd
2h/rlV42z87K3HNVZrqlnQg5bLQmBCw5ezqlsBdWpUzsQBRgl6Pvo0sSjbJbEprO
VEUVFxXfER+K9x2oynIf2kRPLWxjF4sLBSdjtWlzFBrpljTSsomRFhFHqhS/MwZs
CwLs4s6zsmlxJW2rO+vnjgwEI+48/h/Ea5PIVS5h+JzSneBBSIHWl0kZyY/t4f1D
G09NElB5KAmVwJq12JiybCHqjwjTaaAz78np7dbZy/QwljIhxykJAGbisaOuQpJr
I2zGGiMk8UuZ6gKvf6U/JAC4lLDtL96MwRcx//mT6uIBGbhNsbizv6a7ydbt8Rv7
BvqUjTUfCe/zEcwjPzQrWesByh9zPqINXiDaZTXIFVk6yDXLap8bs0gq0yQTZ4Wr
0lAdh7AEtC9WfGgzkivUTTZvmA5EY6roOKV5TTViTS5FP8Axs8qNkVfD19M7eIJ4
yPdXjZpLb7Ow9JMI9WCXsa1VsNswyLYn0/l/OEcFr9nC6joP+Qi3EZLT3bIbHEj5
uaj5948fFCwRLQz9Ja00
=8Sw4
-----END PGP SIGNATURE-----

--Sig_/F2ThGorKWIWXa3yQ4UN=+fk--
