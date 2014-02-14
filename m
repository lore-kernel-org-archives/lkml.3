Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752672AbaBNSXg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 13:23:36 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:32812 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951AbaBNSXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 13:23:35 -0500
Message-ID: <52FE5F0C.5000901@canonical.com>
Date: Fri, 14 Feb 2014 19:23:08 +0100
From: Stefan Bader <stefan.bader@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Peter Zijlstra <peterz@infradead.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        MASAO TAKAHASHI <masao-takahashi@kanno.co.jp>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: Another preempt folding issue?
References: <52FB5669.7090506@canonical.com> <20140212115412.GW27965@twins.programming.kicks-ass.net> <52FCFA23.4060701@canonical.com> <20140213173852.GH6835@laptop.programming.kicks-ass.net> <52FD090C.7010408@canonical.com> <20140213182605.GC14089@laptop.programming.kicks-ass.net> <20140214133428.GB26356@pd.tnic> <52FE2709.3050505@canonical.com> <20140214144700.GC26356@pd.tnic> <52FE4C28.1080500@canonical.com> <20140214173333.GA6953@pd.tnic>
In-Reply-To: <20140214173333.GA6953@pd.tnic>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="9LEPuv2Fs5bodd6i64UP2OR0ljvu9gIUo"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--9LEPuv2Fs5bodd6i64UP2OR0ljvu9gIUo
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 14.02.2014 18:33, Borislav Petkov wrote:
> On Fri, Feb 14, 2014 at 06:02:32PM +0100, Stefan Bader wrote:
>> Okaaay, I think I did what you asked. So yes, there is sse2 in the cpu=
 info. And
>> there is a mfence in the disassembly:
>=20
> Btw, I just realized booting the kernel in the guest was a dumb idea,
> because, doh, the guest is not baremetal. The only reliable thing we
> can say is that sse2 is present and that MFENCE alternative replacement=

> works :)
>=20
> But for simplicity's sake let's just assume the machine can do MFENCE
> just fine and it gets replaced by the alternatives code.
>=20
> Besides, if that weren't true, we'd have a whole lot of other problems
> on those boxes.
>=20
>> Thinking about it, I guess Peter is quite right saying that I likely
>> will end on the patch that converted preempt_count to percpu.
>=20
> Yeah, c2daa3bed53a81171cf8c1a36db798e82b91afe8 et al.
>=20
>> One thing I likely should do is to reinstall the exact same laptop
>> with 64bit kernel and userspace... maybe only 64bit kernel first...
>> and make sure on my side that this does not show up on 64bit, too. I
>> took the word of reporters for that (and the impression that otherwise=

>> many more people would have complained).
>=20
> Yeah, that should be a prudent thing to do.
>=20
> Also, Paolo and I were wondering whether you can trigger this thing
> without kvm, i.e. virtualization involved... do you have any data on
> that?

Unfortunately no hard evidence. Kvm just happens to be such a good way to=
 notice
this as it is using the reschedule interrupt itself and has this exit bef=
ore
running the guest vcpu to hadnle it in the outer loop by calling cond_res=
ched()
and repeat.
I find running kvm seems to make that laptop quite sluggish in responding=
 to
other tasks (in that install) and I got some oddness going on when lightd=
m quite
often refuses to take keyboard input without opening some menu with the m=
ouse
first... But I could not be sure whether that is the kernel or some new
user-space ... errr "feature".
At least Marcello (iirc that other report came from him directly or indir=
ectly)
has seen it, too. And he likely has complete different user-space.

So I will go and do that different (64bit) kernel and kernel + user-space=
 test.
But like fo Peter, it likely is a Monday thing...





--9LEPuv2Fs5bodd6i64UP2OR0ljvu9gIUo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCgAGBQJS/l8MAAoJEOhnXe7L7s6jt94QANuG1p6VLcwoCG1+sH6EJyvd
2Y3O4PY4DSFcX6yOgR8rI21flKeLKf7KsK9J7Y+GyGH3QedowJXxjQ3DcqudBJGe
4f4fxOIrShlwNptpByd/QFp2Mo29eUL7C7+WLUw0z3z7UyDRiuCmlW+jwaRh4+uF
IyoS7vQCBzCVxU27kBpUvEEA1aAbTsjRN3JEMrfWe0aVYKk/RSh3RpmrRJSN9y6q
1KQ+mGnbyisXgnYfiDvRoFX3hiQud2PWkWgTFQkSB5QyeVoUrZHKZYsJuz8pIKGe
p5T260ABDbktn9gN1z/dWiFt3Ss6Any6d8sqXO2yc2pv1IZcjC5l08M4s0RdM+PX
eGGEOdhNL+VJRaeR9+j43vGk3i4M7CWQM4nhH22qYOnVN+m4zn1YZlH/0Sp5XFD1
X+peKzO7ePrZv5BhdG53leEFiPlAAarIXYtC7Gd8zX3NUCbOHjkY8f70XTaNTHep
7ej/MOguPRvUAsHkptz5LNkXjaQHeGGHeLTGYT0bpgJ+ju9SEXY5DCh7xxO3DfOA
TQxIUGVwnDab8XKtFHODBtMoLyaFf7gRVGSdWaRagjm0KRNIPdr6y+2ZjCTHe2TG
wossOsOM/CXLBNyK4NgWjVZIvLaL0dfoKffAui8b5UK35seLDQO55rVKZm6Hphte
qcos/47OyJ0xsOARKrIK
=DClF
-----END PGP SIGNATURE-----

--9LEPuv2Fs5bodd6i64UP2OR0ljvu9gIUo--
