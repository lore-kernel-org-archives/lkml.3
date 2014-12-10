Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755680AbaLJLR1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 06:17:27 -0500
Received: from mout.kundenserver.de ([212.227.17.10]:49754 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817AbaLJLRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 06:17:25 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "arm@kernel.org" <arm@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL 8/9] ARM: SoC defconfig changes for 3.19
Date: Wed, 10 Dec 2014 12:16:44 +0100
Message-ID: <2480052.Mq2bie8eJI@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAMuHMdW35QRFmTMvtfx_1ZHn1W8a_LMPFFWuZgtXGfKEQDddzQ@mail.gmail.com>
References: <4491193.a6KEQb1tZH@wuerfel> <3558682.jkN2tlsPNy@wuerfel> <CAMuHMdW35QRFmTMvtfx_1ZHn1W8a_LMPFFWuZgtXGfKEQDddzQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:XjtH1vx4x0musnm7z3PyMFpPn2g12V43VePvLZBlo4g5kwKL+qT
 Y79sMVNTpczr2+k+mDoj5al3uD53iwR40GJ/qa4S9kSZLcoQ49Zi2N5F8wZmIcnJPZF2Fkb
 ZJ/s6ZZF/tKcau/9NHyUS8Kb9eJyofyW99LYV8MjK7tXmLZMIGanzEPsXCYDV4E83Z9qfvb
 06V8/p2zDl7fXJp+9DJRw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 10 December 2014 09:56:55 Geert Uytterhoeven wrote:
> Hi Arnd,
> 
> On Tue, Dec 9, 2014 at 10:43 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> > The following changes since commit f114040e3ea6e07372334ade75d1ee0775c355e1:
> >
> >   Linux 3.18-rc1 (2014-10-19 18:08:38 -0700)
> >
> > are available in the git repository at:
> >
> >   git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/defconfig-for-linus
> 
> On https://git.kernel.org/cgit/linux/kernel/git/arm/arm-soc.git/, the
> "Download" column for all tags shows "tag <abbrev>...".
> Clicking on any of them gives e.g.:
> 
>     https://git.kernel.org/cgit/linux/kernel/git/arm/arm-soc.git/tag/?id=066ae43e621090340384ab3751b68306c49cd503
>     Bad tag reference: 066ae43e621090340384ab3751b68306c49cd503
> 
> In other repositories
> (e.g. http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/), the
> "Download" column for tags shows "commit <abbrev>...", and the links behind
> them do work.
> 
> Note that if I s/tag/commit/ in the URL, it does work.
> 
> Is this an issue with your repository? Or does cgit on kernel.org needs to
> be updated for a new feature?

Very interesting. I suspect it's because I did something funny, but I don't
know if what I did was actually wrong or if cgit is wrong here, or possibly
both.

This is what I did:

- I wrote the tag descriptions on my main build machine, as an annotated but
  not signed tag, since this machine does not have my gpg key on it,
  using git-2.1.0

- I uploaded the unsigned tags to the arm-soc git tree and downloaded them
  on the machine that does have my signing keys.

- For each tag I did 'git tag -fs $TAG $TAG' and signed the existing tag
  description with my gpg key, using git-1.8.1.2

- I uploaded the updated tags back to the public tree

>From looking at the tag now (e.g. git show arm64-for-linus), it seems
the third step ended up signing a tag that points to another tag instead
of a commit:

> tag arm64-for-linus
> Tagger: Arnd Bergmann <arnd@arndb.de>
> Date:   Tue Dec 9 17:31:38 2014 +0100
> 
> ARM64: SoC changes for 3.19
> 
> This adds support for two new ARM64 platforms:
> 
> * ARM Juno
> * AMD Seattle
> 
> We had submissions for a number of additional platforms
> from Samsung, Freescale and Spreadtrum but are still working
> out the best process for getting these merged.
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.4.12 (GNU/Linux)
> 
> iQIVAwUAVIcj62CrR//JCVInAQKv9w/+LXBBfJbNetHE17PoeV10O+ni6a3Xuv7F
> ZIkx+GgxEYT/8JPBeORUs0Boa6llpsUpn+GqCuqhMmFAPImxoQJ1ULmf6SFfbppB
> b7FRNoaW5GPUsi6mDfat4w3yXZK3LX0qlPprym1d9yGOXN9hnH8LkvnSsqZM1Ntn
> 4jnj7nQJyn/BG5OyFDWnTsyO7dIYMLm90s/VnVPxu7VGacDEnhAXdvqQkzkmavTK
> K9zOBYa4vGhfYM7Wy/3xQrJfHTZOkLOQh4TGwfCQjDoFxvhCXrDo7fU+TKdawq10
> KGHbxj8rhCaAUhc0Gqn77/Cri3LXGJyw+97VZeh9KWR1a1YAV5nsCvz3sZuQY78J
> qbTOwMq9xQ3nQnerkmGPeGV/UyouvdxO/SnOyZnTU0OaYJlFIbsdu8mIUH4xHkGm
> +7DceBhuDk+iVgDtULKpz0RA4XNsUV81Cb6FyVgmEcnuThRtCDetrN7RpMKmqynA
> ZQ/VM/0qtnzQp+XYIxJf7A6iexVtJp00Yffw7y0F8QaoBCwWEsPA1TMk4wPirCYn
> tsQ9C0jYKAWAI8scYpThiTOK8IoBvDIv5OMoxqwtvr4RZQqO9CZQcgtlHOAYNMtX
> zhh+r/1B27vFXoGva065AKIyGPbQSeUJesfVxwN9+RbWplWusaqLPuwfbyNttacf
> mkkNrudQ9g4=
> =yqur
> -----END PGP SIGNATURE-----
> 
> tag arm64-for-linus
> Tagger: Arnd Bergmann <arnd@arndb.de>
> Date:   Tue Dec 9 16:32:04 2014 +0100
> 
> ARM64: SoC changes for 3.19
> 
> This adds support for two new ARM64 platforms:
> 
> * ARM Juno
> * AMD Seattle
> 
> We had submissions for a number of additional platforms
> from Samsung, Freescale and Spreadtrum but are still working
> out the best process for getting these merged.
> 70bcc9b arm64: amd-seattle: Fix PCI bus range due to SMMU limitation

and both have the same text in them, which is not what I had expected.

	Arnd
