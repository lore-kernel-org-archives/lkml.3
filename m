Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751137AbaHQGTo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 02:19:44 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:39408 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818AbaHQGTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 02:19:42 -0400
Content-Type: multipart/signed; boundary="Apple-Mail=_7A6157D6-7076-47A7-A4DE-FADB8C4AD908"; protocol="application/pgp-signature"; micalg=pgp-sha1
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: Overriding -Werror
From: Mark D Rustad <mrustad@gmail.com>
In-Reply-To: <20140816043415.GL11952@brian-ubuntu>
Date: Sat, 16 Aug 2014 23:19:37 -0700
Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-kbuild@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>,
        Artem Bityutskiy <dedekind1@gmail.com>
Message-Id: <0A4C8E0B-AE00-4979-A961-08FD3A810956@gmail.com>
References: <20140814222119.GD18411@ld-irv-0074> <CAL3LdT7-Ai7Dv93vrDP1o2BSVrmFAyTN=UAwE8n5+PVjpN1h0Q@mail.gmail.com> <20140815193144.GG18411@ld-irv-0074> <46D9023C-636A-4A09-88DC-9061567B1BAC@gmail.com> <20140816043415.GL11952@brian-ubuntu>
To: Brian Norris <computersforpeace@gmail.com>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Apple-Mail=_7A6157D6-7076-47A7-A4DE-FADB8C4AD908
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Aug 15, 2014, at 9:34 PM, Brian Norris <computersforpeace@gmail.com> =
wrote:

> Hi Mark,
>=20
> (BTW, your mailer is creating some pretty long, unwrapped lines. I've
> rewrapped them when quoting below.)

Sorry about that. I'll try to remember to deal with it on my end.

> On Fri, Aug 15, 2014 at 08:36:07PM -0700, Mark D Rustad wrote:
>> On Aug 15, 2014, at 12:33 PM, Brian Norris =
<computersforpeace@gmail.com> wrote:
>>> On Fri, Aug 15, 2014 at 02:30:49AM -0700, Jeff Kirsher wrote:
>>>> Funny that you bring this up because I have ~60 patches in my queue =
to
>>>> resolve several thousand of these warnings.  Half of the patches
>>>> actually resolve warnings that can be resolved and the other half
>>>> implement compiler diagnostic control macros to help silence =
warnings.
>>>> All these were the work of a co-worker Mark Rustad, below is the =
patch
>>>> he put together to implement the compiler diagnostic control =
macros.
>>>=20
>>> While fixing warnings is usually a good thing (at least when done =
right;
>>> there are plenty of ways to fight with the compiler over silly =
things,
>>> but that's another discussion),
>>=20
>> I have said at some presentations on the subject that resolving
>> warnings is not something you want an intern to do.
>=20
> Nice.
>=20
>>> I think that my issue is still
>>> orthogonal to the one you're addressing. In my estimation, it is
>>> impossible to guarantee that the entire kernel (including drivers) =
will
>>> build without any warnings, across all levels of warning verbosity.
>>> Thus, even with a valiant effort to fix or annotate all warnings, we
>>> still won't get to the point where I can build 'make ARCH=3Dmips =
W=3D1', if
>>> -Werror is active.
>>=20
>> Actually, some years ago, I got a MIPS Linux kernel to compile clean
>> with even more warnings than W=3D12 provides.
>=20
> Congrats!
>=20
>> It can be done, but it certainly is not a state that is required and
>> cannot be maintained across all configurations, architectures and
>> compiler versions. This is the real world.
>=20
> Right, and this is the crux of why I would like to have the option of
> disabling -Werror systematically.
>=20
>>> Besides, when testing *new* code, it's even more likely to have new
>>> warnings, and I'd like to see as many as possible, without -Werror
>>> getting in the way.
>>=20
>> I have to say that I rather like -Werror.
>=20
> It has its uses. I think it can be a pretty good option whenever the
> compiler's warning level is kept to a reasonable level.
>=20
> -Wextra, for instance, enables a lot of warnings that can be =
problematic
> for little practical benefit (like -Wsign-compare, which notably is
> explicitly overridden for x86).

Hmm. I wasn't aware that x86 had that disabled. Sign-compare actually =
does
find some kinds of bugs. Those warnings are worth resolving for that =
reason.
Being explicit about whether you want the signed or unsigned comparison =
is
a good thing.

>> One thing that not a lot of people are aware of is that you can
>> selectively allow some warnings. -Wno-error=3Dshadow would allow =
shadow
>> warnings to be reported without being treated as errors.
>=20
> That's interesting. I glazed over this option because I misinterpreted
> the second sentence of this note in the gcc manpage:
>=20
>  "Note that specifying -Werror=3Dfoo automatically implies -Wfoo.
>  However, -Wno-error=3Dfoo does not imply anything."
>=20
> [ Really, -Wno-error=3Dfoo doesn't imply anything? So why does it =
exist? ;) ]

Yeah, it means that it doesn't imply anything about whether the warning
is enabled or not. It will neither enable nor disable the warning as a
side-effect, unlike -Werror=3D which will enable it. So you can add -Wno
error=3D... without regard to whether the given warning was enabled or
not. It kind of makes sense, but is not explained very well.

> But now that you mention it, I think it could work as a hack for my
> builds right now, since it isn't overridden by a blanket -Werror found
> later on the command linie. So if I do
>=20
>  make ARCH=3Dmips W=3D1 KCFLAGS=3D"-Wno-error=3D...(long list of =
warnings that break the build)..."

And still be able to see them. Not bad.

> then I can systematically perform the build-tests I'd like.

Yes.

>>> So I still think -Werror is fundamentally wrong in some cases, and I
>>> would like to pursue some approach like in my original post.
>>>=20
>>> BTW, for a little more context: I realize the output of 'make =
W=3D[123]'
>>> may not be very useful on its own, sometimes, but it's actually =
pretty
>>> useful to quickly catch potential issues in new code, by diff'ing =
the
>>> warnings in the before/after build logs. In this case, it's not =
helpful
>>> at all if the first build "fails" due to dubious warnings. I'm doing
>>> this in the context of Aiaiai [1]. Right now, I have to keep around =
a
>>> few local patches to remove -Werror from arch/{mips,sh}.
>>=20
>> The problem is that when a kernel build throws over 125,000 warnings,
>> it just becomes completely useless. That was what kind of set me off.
>=20
> Yeah that's bad. But it *still* can provide a helpful diff for tools
> like Aiaiai. The difference between 125,000 and 125,001 warnings still
> can be determined automatically for new code, although it's not =
helpful
> if every "new" warning is actually just because you used a new core
> header that causes a lot of warnings.

Yes, but it is still a bad situation to have so many. And a lot of them
are trivial things like nested externs in static inline functions in
include files. I'm not wild about the nested externs - it means that
there are multiple sources for the prototype of those functions - but
since that practice has now been used to disentangle include files, we
may as well silence the warnings for those usages. The annotations might
also be a bit of an ongoing reminder that there are issues with having
done that.

>> I did wind up pushing this rock further up the hill than I really
>> meant to. Still, I got the build under 1,400 warnings, and I now know
>> how to address most of them in a systematic way.
>>=20
>>>> commit 7b9aace02b2405f0714bc08c424b72e6962f1c2e
>>>> Author: Mark Rustad <mark.d.rustad@intel.com>
>>>> Date:   Fri Aug 15 01:43:44 2014 -0700
>>>>=20
>>>>   compiler: Add diagnostic control macros
>>>>=20
>>>>   Add macros to control diagnostic messages where needed. These
>>>>   are used to silence warning messages that are expected, normal
>>>>   and do not indicate any sort of problem. Reducing the stream
>>>>   of messages in this way helps possible problems to stand out.
>>>>=20
>>>>   The macros provided are:
>>>>       DIAG_PUSH() - to save diagnostic settings
>>>>       DIAG_POP() - to restore diagnostic settings
>>>>       DIAG_IGNORE(option) - to ignore a particular warning
>>>>       DIAG_GCC_IGNORE(option) - DIAG_IGNORE for gcc only
>>>>       DIAG_CLANG_IGNORE(option) - DIAG_IGNORE for clang only
>>>>=20
>>>>   Signed-off-by: Mark Rustad <mark.d.rustad@intel.com>
>>>>=20
>>>> diff --git a/include/linux/compiler-clang.h =
b/include/linux/compiler-clang.h
>>>> index d1e49d5..039b112 100644
>>>> --- a/include/linux/compiler-clang.h
>>>> +++ b/include/linux/compiler-clang.h
>>>> @@ -10,3 +10,29 @@
>>>> #undef uninitialized_var
>>>> #define uninitialized_var(x) x =3D *(&(x))
>>>> #endif
>>>> +
>>>> +/*
>>>> + * Provide macros to manipulate diagnostic messages when possible.
>>>> + * DIAG_PUSH pushes the diagnostic settings
>>>> + * DIAG_POP pops the diagnostic settings
>>>> + * DIAG_IGNORE(x) changes the given diagnostic setting to ignore
>>>> + *
>>>> + * Example:
>>>> + *    DIAG_PUSH DIAG_IGNORE(aggregate-return)
>>>> + *    struct timespec ns_to_timespec(const s64 nsec)
>>>> + *    {
>>>> + *        ...
>>>> + *    }
>>>> + *    DIAG_POP
>>>> + *
>>>> + * Will prevent the warning on compilation of the function. Other
>>>> + * steps are necessary to do the same thing for the call sites.
>>>> + */
>>>=20
>>> While I do not want to disparage your/Mark's work here, my first =
thought
>>> about this kind of annotation is that it seems to be a pretty big =
burden
>>> to have to annotate all code with these sorts of things.
>>=20
>> I wouldn't suggest annotating everything. However note that the
>> annotations can serve as a notice that something has been analyzed =
and
>> deemed ok. That can be useful as long as that is really true. I
>> wouldn't take new code from a new developer that included such
>> annotations.
>=20
> Good points. And I'd recommend framing your argument as such if/when =
you
> post your patches for real. Maybe even add comments near the macro
> definitions; "with great power comes great responsibility."

That is not a bad idea. And I do think that checkpatch ought to warn =
when
they are added. It certainly is a bigger deal than a too long line!

I am contemplating adding a DIAG_ERROR macro to enable an error on a =
warning.
The use case I have come up with is switch-enum. Then, switch statements
that are expected to itemize every value in an enum can force that error =
on
for just those switch statements, because generally that is not needed. =
At
least that is the best possible use I have come up with for that kind of
macro. Haven't tried it yet, but that seems potentially useful to me.

> Thanks for your thoughts,
> Brian

--=20
Mark Rustad, MRustad@gmail.com


--Apple-Mail=_7A6157D6-7076-47A7-A4DE-FADB8C4AD908
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIcBAEBAgAGBQJT8El5AAoJEDwO/+eO4+5uQaUQAIB6UwfoYwkkB1eEmnVcxCl5
ZvQuU1bWOKj3lp5YKcCLeVn2BC4ds7uU5MTWA2BQ75WunXuOkXKrysqd18i0IYIA
Kj5RZpLHZrePEE7lvLiGhlIF289C+UCLCr2ktiG2F1rsS9jUjqPUISQx4eT8nF5Z
aUhYUICZP4vqMwPx0ecEygCeO/WxJCm9D48vjwEmU6MFMD3cbgEAmP68GIpHpyfT
bcSUGRaRbjUfdms8dkPvgp27mfQuKRCGWoR6OckbQuiiExC/9MYbkHMBIlF7tFB5
e0uzWSKYCNLp/JHqqvpGW203pSoWVLcYXRAGw0TxHvOY2vNghlZQs0rXi0QtwDBe
awPWzI2XTx83sei/MrqmueppMQdOu1lixeQ9LcFxKkh9qET/A8KyQS0lgI+sBJUZ
U0jPODg2gC6CONvzwUlrxy7hTSSygxwkEPw1xXHOIPozM0AQjrolqcXLpiKZPITW
carm7b1LGzmbvSDxzMDfOMNQabn5H25NDYoTZkzZ0hdWV2gbkkSq3yO24EAaSGFz
3bplDSYkaHxwAzt5jp5Wd8tQn5zzUgDk9d3sa1T9u20IYE5fcVcNRZdwk1whqVLH
64535BW69DZJz9j/NLGqjwU14A60YOovkAfch+is6uDeUKbVZXyLoMENBG4oS8oh
4SotSweWX4xhU5QGJuCL
=6cXg
-----END PGP SIGNATURE-----

--Apple-Mail=_7A6157D6-7076-47A7-A4DE-FADB8C4AD908--
