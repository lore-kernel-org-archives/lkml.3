Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752640AbaBNTDz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 14:03:55 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:33005 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772AbaBNTDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 14:03:53 -0500
Message-ID: <52FE6888.80703@canonical.com>
Date: Fri, 14 Feb 2014 20:03:36 +0100
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
References: <52FB5669.7090506@canonical.com> <20140212115412.GW27965@twins.programming.kicks-ass.net> <52FCFA23.4060701@canonical.com> <20140213173852.GH6835@laptop.programming.kicks-ass.net> <52FD090C.7010408@canonical.com> <20140213182605.GC14089@laptop.programming.kicks-ass.net> <20140214133428.GB26356@pd.tnic> <52FE2709.3050505@canonical.com> <20140214144700.GC26356@pd.tnic> <52FE4C28.1080500@canonical.com> <20140214173333.GA6953@pd.tnic> <52FE5F0C.5000901@canonical.com>
In-Reply-To: <52FE5F0C.5000901@canonical.com>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="o3cvjHQF8LojPiLSO19IoVenGjaojOrdX"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--o3cvjHQF8LojPiLSO19IoVenGjaojOrdX
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 14.02.2014 19:23, Stefan Bader wrote:
> On 14.02.2014 18:33, Borislav Petkov wrote:
>> On Fri, Feb 14, 2014 at 06:02:32PM +0100, Stefan Bader wrote:
>>> Okaaay, I think I did what you asked. So yes, there is sse2 in the cp=
u info. And
>>> there is a mfence in the disassembly:
>>
>> Btw, I just realized booting the kernel in the guest was a dumb idea,
>> because, doh, the guest is not baremetal. The only reliable thing we
>> can say is that sse2 is present and that MFENCE alternative replacemen=
t
>> works :)
>>
>> But for simplicity's sake let's just assume the machine can do MFENCE
>> just fine and it gets replaced by the alternatives code.
>>
>> Besides, if that weren't true, we'd have a whole lot of other problems=

>> on those boxes.
>>
>>> Thinking about it, I guess Peter is quite right saying that I likely
>>> will end on the patch that converted preempt_count to percpu.
>>
>> Yeah, c2daa3bed53a81171cf8c1a36db798e82b91afe8 et al.
>>
>>> One thing I likely should do is to reinstall the exact same laptop
>>> with 64bit kernel and userspace... maybe only 64bit kernel first...
>>> and make sure on my side that this does not show up on 64bit, too. I
>>> took the word of reporters for that (and the impression that otherwis=
e
>>> many more people would have complained).
>>
>> Yeah, that should be a prudent thing to do.
>>
>> Also, Paolo and I were wondering whether you can trigger this thing
>> without kvm, i.e. virtualization involved... do you have any data on
>> that?
>=20
> Unfortunately no hard evidence. Kvm just happens to be such a good way =
to notice
> this as it is using the reschedule interrupt itself and has this exit b=
efore
> running the guest vcpu to hadnle it in the outer loop by calling cond_r=
esched()
> and repeat.
> I find running kvm seems to make that laptop quite sluggish in respondi=
ng to
> other tasks (in that install) and I got some oddness going on when ligh=
tdm quite
> often refuses to take keyboard input without opening some menu with the=
 mouse
> first... But I could not be sure whether that is the kernel or some new=

> user-space ... errr "feature".
> At least Marcello (iirc that other report came from him directly or ind=
irectly)
> has seen it, too. And he likely has complete different user-space.
>=20
> So I will go and do that different (64bit) kernel and kernel + user-spa=
ce test.
> But like fo Peter, it likely is a Monday thing...
>=20

Ok, it is still Friday... So a quick test (2 boots of a 32bit guest, same=
 as
before) on the 32bit user-space, with the same kernel source, but compile=
d as
64bit (obviously not 100% same config but close). While I see the false
inconsistency messages (I modified the in kernel-test to trigger the trac=
e stop
only if the __vcpu_run loop encounters an inconsistent state three times =
in a
row), I do not see the final stop message. Also (but that is rather feeli=
ng) the
system seems to remain more responsive (switching to other windows, openi=
ng
terminal windows,...) compared to 32bit kernel.



--o3cvjHQF8LojPiLSO19IoVenGjaojOrdX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCgAGBQJS/miIAAoJEOhnXe7L7s6jOssQAM773+XCS3XPEEraC5WvH5F4
I6b+A3jRVRUYKg+dR+bnU70IfgNaeO0H52Sz2AzvRZyV1nNp8GHXtz81njvNsOID
4tRO5gYpHdP+IiB3XeXP6zJRnSZLtNmdQYzeG7eOV+f/qPh9Lkh84OweU0IFClNR
olz8sy974/3iwamUJSgfAJcOaMDfd85Z40aEuVzVj4suYvuozgxbzG4hIeJ6Iwgi
akf9Kyonv8CQhlAzkUEZfhrhv4U8veFv+ziLzLDOCC7mslftMeg5+fnWUWVES8lR
7UcoTjOWwknbtef8SUVMhayueI30QnZhxCdbJGvUJzZumI9oXUi0PCZgf66sx4c9
pXlSH6u/S9Owy0LH5GfwpYfiJxEaSizhJiSAZcDQQ/VNrceQ2RbmK4FWd7wJT+0F
LX3b0DshXOam5RIEnktfWB/IDsuhXxxCNSQyu5oBH3xF4IdwEBFj1fvf8pqSlHTv
InAOR2GjK7MHqrxL8AtXCcPfzIR1F4JqHQbrlX9f+P/xIL4z+ijSJrErSTMbg4Re
Ak3fyFk1zXOjGMk48MnkBtwtD8pFzRYdkTYlJa0ZybFS77dDZ7binkDlXqQ/FMTv
qj489wniUoDHPHKwPDg5LArYBWOVEi5xEVeLNPRSSZnM1GgCDXFjejXvXZzpN99A
wiXmCeaVkL4iDPMShJsi
=0dND
-----END PGP SIGNATURE-----

--o3cvjHQF8LojPiLSO19IoVenGjaojOrdX--
