Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752805AbaD0Evm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 00:51:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36364 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750809AbaD0Evj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 00:51:39 -0400
Date: Sun, 27 Apr 2014 14:51:25 +1000
From: NeilBrown <neilb@suse.de>
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: "Stefan (metze) Metzmacher" <metze@samba.org>,
        Jeff Layton <jlayton@redhat.com>, Rich Felker <dalias@libc.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        samba-technical@lists.samba.org,
        Ganesha NFS List <nfs-ganesha-devel@lists.sourceforge.net>,
        "Carlos O'Donell" <carlos@redhat.com>,
        libc-alpha <libc-alpha@sourceware.org>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] locks: rename file-private locks to file-description
 locks
Message-ID: <20140427145125.21e7e6c6@notabene.brown>
In-Reply-To: <5355F60C.8010004@gmail.com>
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
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/aWe8ffITPbmSbg4Ndm=svXO"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/aWe8ffITPbmSbg4Ndm=svXO
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 22 Apr 2014 06:54:36 +0200 "Michael Kerrisk (man-pages)"
<mtk.manpages@gmail.com> wrote:

> On 04/21/2014 11:15 PM, Stefan (metze) Metzmacher wrote:
> > Am 21.04.2014 21:55, schrieb Jeff Layton:
> >> On Mon, 21 Apr 2014 21:39:12 +0200
> >> "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com> wrote:
> >>
> >>> On 04/21/2014 08:46 PM, Rich Felker wrote:
> >>>> On Mon, Apr 21, 2014 at 08:32:44PM +0200, Michael Kerrisk (man-pages=
) wrote:
> >>>>> On 04/21/2014 06:10 PM, Rich Felker wrote:
> >>>>>> I'm well aware of that. The problem is that the proposed API is us=
ing
> >>>>>> the two-letter abbreviation FD, which ALWAYS means file descriptor=
 and
> >>>>>> NEVER means file description (in existing usage) to mean file
> >>>>>> description. That's what's wrong.
> >>>>>
> >>>>> So, can you *please* answer this question: what do you call (i.e.,=
=20
> >>>>> what  everyday technical language term do use for) the thing
> >>>>> that sits between a file descriptor and an i-node?=20
> >>>>>
> >>>>> (Please don't say 'struct file' -- that is not is an implementation=
=20
> >>>>> detail, and does not qualify as the kind of term that I could use=20
> >>>>> when documenting this feature in man pages.)
> >>>>
> >>>> "Open file description".
> >>>
> >>> Oh! I didn't realize we agreed :-).
> >>>
> >>>>> POSIX uses (or invented, I am not sure which) the term file descrip=
tion
> >>>>> for a good reason: it is unambiguous, and therefore precise. I do a=
gree
> >>>>> that there's a risk of confusion between 'open file descriptor" and=
=20
> >>>>> 'and file description'--it's the same kind of risk as between Engli=
sh=20
> >>>>> terms such as 'arbitrator' and 'arbitration' (and any number of oth=
er
> >>>>> examples), and as language speakers we deal with this every day.
> >>>>
> >>>> There's not a problem when the full word is used. On the other hand,
> >>>> if you use "arb" as an abbreviation for "arbitration" in a context
> >>>> where it was already universally understood as meaning "arbitrator",
> >>>> that would be a big problem.
> >>>>
> >>>> Likewise the problem here isn't that "open file description" is a bad
> >>>> term. It's that using "FD" to mean "[open] file description" is
> >>>> utterly confusing, even moreso than just making up a new completely
> >>>> random word.
> >>>
> >>> Ohh -- I had thought you a problem not just with "FD" but also
> >>> "(open) file description".
> >>>
> >>>>>>> 2) The new API constants (F_SETLKP, F_SETLKPW, F_GETLKP) have nam=
es
> >>>>>>>    that are visually very close to the traditional POSIX lock nam=
es=20
> >>>>>>>    (F_SETLK, F_SETLKW, F_GETLK). That's an accident waiting to ha=
ppen
> >>>>>>>    when someone mistypes in code and/or misses such a misttyping
> >>>>>>>    when reading code. That really must be fixed.
> >>>>>>
> >>>>>> I agree, but I don't think making it worse is a solution.
> >>>>>
> >>>>> I don't agree that it's making it worse. The real problem here is=20
> >>>>> that people use no good unambiguous term for the thing between a fi=
le
> >>>>> descriptor and an inode. POSIX provides us with a solution that may
> >>>>> not seem perfect, but it is unambiguous, and I think it might feel
> >>>>> more comfortable if we used it often enough.
> >>>>
> >>>> I would like to see it used more too, and in particular, I think it
> >>>> belongs in the documentation for these new locking interfaces. But
> >>>> that still doesn't answer the question of what to call them (the
> >>>> macros) unless you want:
> >>>>
> >>>> F_OPEN_FILE_DESCRIPTION_GETLK
> >>>> F_OPEN_FILE_DESCRIPTION_SETLK
> >>>> F_OPEN_FILE_DESCRIPTION_SETLKW
> >>>
> >>> Or just 'F_OFD_*'?
> >>>
> >>>> Perhaps "OP" (for open-private, i.e. private to the particular open)
> >>>> would be a sensible choice; OTOH people are likely to misread it as
> >>>> OPeration. The general principle I have in mind though is that it
> >>>> might be nice to highlight the word "open" in "open file description"
> >>>
> >>> (Fair enough.)
> >>>
> >>>> since it (1) contrasts with file descriptor, despite file descriptors
> >>>> also dealing with open files, and (2) contrasts well with legacy fcn=
tl
> >>>> locks, which are (this is the whole bug) associated with the
> >>>> underlying file and not the open file description.
> >>>
> >>> Makes sense to me. (We are in more agreement that I realized.)
> >>>
> >>> Cheers,
> >>>
> >>> Michael
> >>>
> >>>
> >>>
> >>
> >> So the motion is to call them "open file description locks" and change
> >> the macros to read *_OFD_*. Does anyone object?
> >=20
> > Works fine for me...
>=20
> And works for me.
>=20
>=20

I think the word "open" is important here.
I find that "description" is not a word I would have every thought was
relevant here - it is obviously too long since I have read the man pages.

I would prefer
  per-open locks
which are contrasted with
  per-process locks

An alternative might be "flock-like" as locks created with "flock" have
exactly the property we are trying to describe.  Reading the man page for
"flock" then suggests "open file table entry locks" which is even more of a
mouthful.  "oftel" is pronounceable though.  Then we could talk about "oftel
locks" in the same sentence as "pin numbers" and "RAM memory".

But maybe I came too late to this party, and the boat has sailed?

Note to Michael: The text
   flock() does not lock files over NFS.
in flock(2) is no longer accurate.  The reality is ... complex.
See nfs(5), and search for "local_lock".


NeilBrown

(I don't care what the macros are - XX would work as well any anything else
for me).

--Sig_/aWe8ffITPbmSbg4Ndm=svXO
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU1yMzTnsnt1WYoG5AQJhuQ/6Ax9QVfOi4m1GfFmQ7W86YVI57FYvCVU8
Hl+fAuIpxuKgOOZ0Bj+jiDUULFhUrgdQFMKuhYEdQb2bxkZLedLyqhRnGsj/u4Xr
fiElRhdkcyZMRUkXrfFjvRrtTV8w6GIlGgd9E3d+vargRFu+VBGba2csubtmF2Rw
heMq7IS1OHBNoAGBm/KjlGK5Q1sX0XdHvCmmRQbIzrE68r4W5W/8Rooj5MTMEgu0
RJzYOFRWCjXwOixo9TEGngtmQp9E9jYnvA/DQRM+j+/pW6YD+KYtf8D2e67TLQ1C
B+7AqWUn6+53bhgSjvsa1aw8TmH6lbJkAOwZjIGgjT1JEOqWW8TK6XFqO8/dOZfH
Q4c8SZsWRaEuCXtzVteEMO8Tqsmj55T+0yKciijuBBgj9nfCkSt46JJPTFC4Qfzy
j8Cn4Lqc+BoJ100SiCAS95tff9u4cNMkEF/JYoNTcclofvwysJgW0vhLrl413WQf
2D2jjZ36F9o4JvISVdSg244t5U3sdD3ywe0Id5yM2rJ3JDGy196Wywx/bcjsl3SE
0L3c+IPDWxymeokbKszWvoQMcBNYlIzIMmQabilR43mAHcSYSzKPwhPwLt1S7REd
WdXSdU2SdsbeKDj13YeG14ozbTQM7bstL3RGJViAu0+SAuUuwywzqihYGna2hkv6
Ud+KOaNkJ0o=
=v1P3
-----END PGP SIGNATURE-----

--Sig_/aWe8ffITPbmSbg4Ndm=svXO--
