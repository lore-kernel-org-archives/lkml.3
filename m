Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755863AbaFPVf1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 17:35:27 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:42266 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521AbaFPVfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 17:35:25 -0400
MIME-Version: 1.0
In-Reply-To: <539F5702.5050104@nod.at>
References: <539F1C59.6070308@gmx.de> <CAFLxGvyqPzbmfz1-WxP7z02=V-V5=p5b09HYPOFOS7Qj8eUHGw@mail.gmail.com>
 <CALCETrXqjHPvKw=wcdnxQWO0Y140B=a0E7eh4+PoERvU=z909w@mail.gmail.com>
 <539F297F.7010904@nod.at> <CALCETrU+TmaEjPSHz1LwQJvVDp8fqoDs3O4b+3gS_ewthiwnMA@mail.gmail.com>
 <539F2B2D.6050105@gmx.de> <CALCETrVw6f7iy4qTMgSt8k9N4rOWJ_mm9LbrtVZ9YFORacriSQ@mail.gmail.com>
 <539F3077.7040005@gmx.de> <CALCETrUUC6g_y4nJkSYo7MrKB8ehyXgnnuBHxGCDrq1d4zp2BQ@mail.gmail.com>
 <539F35A0.2050002@gmx.de> <CALCETrVseO=n6TH-msfTHRqB-OMPs_32nRELVYc=V1ZDmvFXVA@mail.gmail.com>
 <539F567F.2050802@gmx.de> <539F5702.5050104@nod.at>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 16 Jun 2014 14:35:03 -0700
Message-ID: <CALCETrW7U4AHG-a9oPbOt31z3wgzhjSu8b+yGpdM4+vNinKgsA@mail.gmail.com>
Subject: Re: 3.15: kernel BUG at kernel/auditsc.c:1525!
To: Richard Weinberger <richard@nod.at>, "H. Peter Anvin" <hpa@zytor.com>,
        X86 ML <x86@kernel.org>
Cc: =?UTF-8?Q?Toralf_F=C3=B6rster?= <toralf.foerster@gmx.de>,
        Eric Paris <eparis@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=001a11c249260edec804fbface80
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001a11c249260edec804fbface80
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

[cc: hpa, x86 list]

On Mon, Jun 16, 2014 at 1:43 PM, Richard Weinberger <richard@nod.at> wrote:
> Am 16.06.2014 22:41, schrieb Toralf F=C3=B6rster:
>> Well, might be the mail:subject should be adapted, b/c the issue can be =
triggered in a 3.13.11 kernel too.
>> Unfortunately it does not appear within an UML guest, therefore an autom=
ated bisecting isn't possible I fear.
>
> You could try KVM. :)

Before you do that, just to clarify:

What bitness is your kernel?  That is, are you on 32-bit or 64-bit kernel?

What bitness is your test case?  'file a.out' will say.

What does /proc/cpuinfo say in flags?

Can you try the attached patch?  It's only compile-tested.

To hpa, etc:  It appears that entry_32.S is missing any call to the
audit exit hook on the badsys path.  If I'm diagnosing this bug report
correctly, this causes OOPSes.

The the world at large: it's increasingly apparent that no one (except
maybe the blackhats) has ever scrutinized the syscall auditing code.
This is two old severe bugs in the code that have probably been there
for a long time.

--Andy

--=20
Andy Lutomirski
AMA Capital Management, LLC

--001a11c249260edec804fbface80
Content-Type: text/x-patch; charset=UTF-8; 
	name="0001-x86_32-entry-Fix-badsys-paths.patch"
Content-Disposition: attachment; 
	filename="0001-x86_32-entry-Fix-badsys-paths.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hwiau4al0

RnJvbSA4YjQzYmQyMTE4ZDg3NmNiMzE2M2U4ZjdkOWNkODI1M2RhNjQ5MzM1IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpNZXNzYWdlLUlkOiA8OGI0M2JkMjExOGQ4NzZjYjMxNjNlOGY3ZDljZDgy
NTNkYTY0OTMzNS4xNDAyOTU0NDA2LmdpdC5sdXRvQGFtYWNhcGl0YWwubmV0PgpGcm9tOiBBbmR5
IEx1dG9taXJza2kgPGx1dG9AYW1hY2FwaXRhbC5uZXQ+CkRhdGU6IE1vbiwgMTYgSnVuIDIwMTQg
MTQ6Mjg6MTkgLTA3MDAKU3ViamVjdDogW1BBVENIXSB4ODZfMzIsZW50cnk6IEZpeCBiYWRzeXMg
cGF0aHMKTUlNRS1WZXJzaW9uOiAxLjAKQ29udGVudC1UeXBlOiB0ZXh0L3BsYWluOyBjaGFyc2V0
PVVURi04CkNvbnRlbnQtVHJhbnNmZXItRW5jb2Rpbmc6IDhiaXQKClRoZSBiYWQgc3lzY2FsbCBu
ciBwYXRocyBhcmUgdGhlaXIgb3duIGluY29tcHJlaGVuc2libGUgcm91dGUKdGhyb3VnaCB0aGUg
ZW50cnkgY29udHJvbCBmbG93LiAgUmVhcnJhbmdlIHRoZW0gdG8gd29yayBqdXN0IGxpa2UKc3lz
Y2FsbHMgdGhhdCByZXR1cm4gLUVOT1NZUy4KClRoaXMgc2hvdWxkIGZpeCBhbiBPT1BTIGluIHRo
ZSBhdWRpdCBjb2RlIHdoZW4gYXVkaXRpbmcgaXMgZW5hYmxlZAphbmQgYmFkIHN5c2NhbGwgbnJz
IGFyZSB1c2VkLgoKUmVwb3J0ZWQtYnk6IFRvcmFsZiBGw7Zyc3RlciA8dG9yYWxmLmZvZXJzdGVy
QGdteC5kZT4KU2lnbmVkLW9mZi1ieTogQW5keSBMdXRvbWlyc2tpIDxsdXRvQGFtYWNhcGl0YWwu
bmV0PgotLS0KIGFyY2gveDg2L2tlcm5lbC9lbnRyeV8zMi5TIHwgMTAgKysrKysrKystLQogMSBm
aWxlIGNoYW5nZWQsIDggaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQg
YS9hcmNoL3g4Ni9rZXJuZWwvZW50cnlfMzIuUyBiL2FyY2gveDg2L2tlcm5lbC9lbnRyeV8zMi5T
CmluZGV4IDk4MzEzZmYuLmViNmUwN2UgMTAwNjQ0Ci0tLSBhL2FyY2gveDg2L2tlcm5lbC9lbnRy
eV8zMi5TCisrKyBiL2FyY2gveDg2L2tlcm5lbC9lbnRyeV8zMi5TCkBAIC00MzEsOSArNDMxLDEw
IEBAIHN5c2VudGVyX3Bhc3RfZXNwOgogCWpueiBzeXNlbnRlcl9hdWRpdAogc3lzZW50ZXJfZG9f
Y2FsbDoKIAljbXBsICQoTlJfc3lzY2FsbHMpLCAlZWF4Ci0JamFlIHN5c2NhbGxfYmFkc3lzCisJ
amFlIHN5c2VudGVyX2JhZHN5cwogCWNhbGwgKnN5c19jYWxsX3RhYmxlKCwlZWF4LDQpCiAJbW92
bCAlZWF4LFBUX0VBWCglZXNwKQorc3lzZW50ZXJfYWZ0ZXJfY2FsbDoKIAlMT0NLREVQX1NZU19F
WElUCiAJRElTQUJMRV9JTlRFUlJVUFRTKENMQlJfQU5ZKQogCVRSQUNFX0lSUVNfT0ZGCkBAIC02
ODcsNyArNjg4LDEyIEBAIEVORChzeXNjYWxsX2ZhdWx0KQogCiBzeXNjYWxsX2JhZHN5czoKIAlt
b3ZsICQtRU5PU1lTLFBUX0VBWCglZXNwKQotCWptcCByZXN1bWVfdXNlcnNwYWNlCisJam1wIHN5
c2NhbGxfZXhpdAorRU5EKHN5c2NhbGxfYmFkc3lzKQorCitzeXNlbnRlcl9iYWRzeXM6CisJbW92
bCAkLUVOT1NZUyxQVF9FQVgoJWVzcCkKKwlqbXAgc3lzZW50ZXJfYWZ0ZXJfY2FsbAogRU5EKHN5
c2NhbGxfYmFkc3lzKQogCUNGSV9FTkRQUk9DCiAvKgotLSAKMS45LjMKCg==
--001a11c249260edec804fbface80--
