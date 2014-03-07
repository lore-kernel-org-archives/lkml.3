Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753005AbaCGMo7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 07:44:59 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:39646 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752895AbaCGMo5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 07:44:57 -0500
Message-ID: <5319BF40.70305@ti.com>
Date: Fri, 7 Mar 2014 14:44:48 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: David Herrmann <dh.herrmann@gmail.com>
CC: "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Ingo Molnar <mingo@kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        Dave Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Tom Gundersen <teg@jklm.no>
Subject: Re: [PATCH 00/11] SimpleDRM & Sysfb
References: <1390486503-1504-1-git-send-email-dh.herrmann@gmail.com>	<53145591.4070004@ti.com>	<CANq1E4QJqB0CSNeSh2jsp90ZtcLwFwfSG=qjodSLdV_aGbL3BQ@mail.gmail.com>	<53145D42.9080806@ti.com>	<CANq1E4QYuMsj3W80jiyOfeYr+Xm=J096idyvgCUpFhADWR1ZvA@mail.gmail.com>	<531465FF.1000201@ti.com> <CANq1E4TmACNwyANaUsWufJL1ne4pk4Gv+g4y7b6xeO=Po-SN9g@mail.gmail.com>
In-Reply-To: <CANq1E4TmACNwyANaUsWufJL1ne4pk4Gv+g4y7b6xeO=Po-SN9g@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="C6qausoGgW38blqKUTrj8lJQFoDkmUw90"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--C6qausoGgW38blqKUTrj8lJQFoDkmUw90
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 06/03/14 14:16, David Herrmann wrote:
> Hi Tomi
>=20
> On Mon, Mar 3, 2014 at 12:22 PM, Tomi Valkeinen <tomi.valkeinen@ti.com>=
 wrote:
>> On 03/03/14 13:09, David Herrmann wrote:
>>
>>>> What do you think, would it be possible to keep the sysfb stuff in
>>>> arch/x86, and still be able to do the rest of the stuff here? And th=
en
>>>> move the sysfs from arch/x86 to drivers/video later?
>>>
>>> I don't think there's any need for that. Linus does conflict
>>> resolution all day long, so a short hint in Dave's pull-request (plus=

>>> an example merge) should be enough. Same is true for -next, I think.
>>
>> True, but, well, the conflict with this one is not a few lines. "git
>> diff |wc -l" gives 2494 lines for the conflict. It's not really comple=
x
>> to resolve that one, though, as it's really about copying all the stuf=
f
>> into its new place.
>>
>> So I'm not sure if that makes Linus think "this is simple one, 30 secs=

>> and done" or "who the f*** sends me this crap" ;). Especially for two
>> reasons:
>>
>> - The fb-reogranization is not very critical, and often clean-ups are
>> not worth it (although I think this one is good one, of course).
>> - Conflicting fbdev changes coming from another tree
>>
>>> And this is really just a mechanical thing, nothing hard to do. But o=
f
>>> course, it's your decision. However, keeping the code in x86 is the
>>> wrong thing to do. As discussed with Ingo, the patch that extends
>>
>> Yes, I didn't mean keeping the code in x86 for good, but just for one
>> kernel version to make merging easier.
>>
>>> x86/sysfb is only provided for easier backporting. The followup patch=

>>> immediately removes it again and adds proper video/sysfb. I'd dislike=

>>> splitting these just to avoid merge conflicts. I can also maintain a
>>> merge-fixup branch in my tree, if anyone wants that.
>>
>> You can have a try at merging. If you think it's trivial, maybe it is
>> and we can just let Linus handle it:
>>
>> git://git.kernel.org/pub/scm/linux/kernel/git/tomba/linux.git
>> work/fb-reorder
>=20
> Ok, I'm fine with delaying this one more merge-window. However, to
> make things easier, could you pick up the two fbdev cleanups? These
> are:
>   fbdev: efifb: add dev->remove() callback
>   fbdev: vesafb: add dev->remove() callback
>=20
> They only add ->remove() callbacks which are never triggered currently
> except with my sysfb series. But I'd like to drop both to make the
> series smaller.

Yes, I can take them if they work fine without the rest of the patches.

I could also take all the patches up to patch #6 via fbdev tree. Some of
the patches are for arch x86, but they seem to be still about
framebuffers. But maybe that causes conflicts with x86 tree, then =3D).

Then again, maybe we should just go forward and let Linus handle the
conflict. I'm planning to send the "normal" fbdev changes and the
fbdev-reorg separately (just in case Linus doesn't like the reorg), and
that already causes conflicts, very similar to what this series causes.

So in any case Linus has to handle that conflict, or use a resolution
offered by me. So if fbdev changes and this series are merged in
relatively early phase, I can then send the reorg series a bit later and
offer a conflict resolution that solves the conflicts for both series.

That way this series doesn't get delayed needlessly in the case that
Linus rejects the reorg series.

 Tomi



--C6qausoGgW38blqKUTrj8lJQFoDkmUw90
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTGb9AAAoJEPo9qoy8lh71a/oQAI5TfidrnZVh+QGcJg+3/YHh
CuhT7kQBZVW0qH/nBMnfgSefXAQl+yDtS7aqiL8HUcQVTGKuJbY9jouHN8ONy6Ix
sChadrUjLWJGJkZR68CILOeK1f96PH6q44Z+gxP1BsTrpKohgTokOXl3e2Or8iBs
/Fc8qds+cGGbDXTD+8zsKKs1enNw0XIn5RTose96gtuD3+IeOrBafmkGOdjjhuIF
RV5adEcpS/v7gJshwLsnPdgpvbmtX5CVS98dfr8cv1wL7YRfFHvCsl7GA6FQwgOw
DlxFoRqolDI/rjoXVpJusFYs8/zhDCG+jaTRA7GdRqigdXAdp49YRTLQhpJTw36s
IGdGdF3WREAv4VrPskG9DmRKjCJl8I8yWnZz1K3FUG5LYdWW0SsCin5GnlBm9UmT
Pl9cBDXXR3P2RqIS6+j9FXtZu4ro7DhzHs0X2E56UVEGHP2GfrTPKuWUrpM06/nq
VtWv8iZFqCAggrwNTI8Nqw66cxkYBrh0I1UaJNu0Afk7sp9f/gMldkUZexX2CmDM
khPuKzuFnlA2v7SoMIuQp5QncVW/FNxPEuip9nanm720vNWqGQ53ndYKdNFDDkK6
Kk8/Aq8APSofhlW+Hv44CK3v/YQ5K/13bZy74Jh3+UT2BEjPmUhyMuyafOgRjXRi
Al3FGT1ToUYhf5hVHMM1
=OJD3
-----END PGP SIGNATURE-----

--C6qausoGgW38blqKUTrj8lJQFoDkmUw90--
