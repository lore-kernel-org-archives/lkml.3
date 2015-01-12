Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751893AbbALILj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 03:11:39 -0500
Received: from mout.web.de ([212.227.15.3]:57089 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751745AbbALILf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 03:11:35 -0500
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="pgp-sha256"; boundary="===============8900957341149917359=="
MIME-Version: 1.0
Content-Disposition: inline
To: wei_wang@realsil.com.cn, phihag@phihag.de, ben@decadent.org.uk
References: <20140810225012.3425.19201.reportbug@t4.home.phihag.de>
 <1407715088.3017.73.camel@deadeye.wl.decadent.org.uk>
 <53E81801.8000907@phihag.de>
 <B801BD58FDB66349A47F17A55A52796045FF6429@rsex2.realsil.com.cn>
 <20150111000919.4607.25466@hoothoot>
In-reply-to: <20150111000919.4607.25466@hoothoot>
Cc: 757733@bugs.debian.org, linux-kernel@vger.kernel.org
From: Johannes Schauer <j.schauer@email.de>
Message-ID: <20150112081117.3781.89247@hoothoot>
User-Agent: alot/0.3.6
Subject: Re: Bug#757733: RTS2557 SD card reader does not work
Date: Mon, 12 Jan 2015 09:11:17 +0100
X-Provags-ID: V03:K0:UFVKktYmnLusq7vlp+GL23N40uLxBpYOKo6CSBh8zFUOhEH1ziT
 9zNz9/LYoQrjiRs1pk3+RkTDWGcwdTkWV9InzHmXsBJ8Md9wESV8rbG2ytX8UmFbaLd+i1q
 RRVuSp8x2aWqjqPCFpfd2OtunRi+wTcQrd86rQGRbuWhYur/kxeIA57LMvBYutI2KPr56I1
 QIDZzEe3rgtb1jexsfVRA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--===============8900957341149917359==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Hi,

On Sun, 11 Jan 2015 01:09:19 +0100 Johannes Schauer <j.schauer@email.de> wr=
ote:
> Weirdly, my SD card reader used to work (but presented the SD card as
> /dev/mmcblk0pX). I do not know why it stopped working though as I didn't =
reboot
> my laptop for several months. Running an older kernel version (3.14 for
> example) does not fix the problem. Maybe it is related to other parts of =
my
> (Debian testing) OS. I'll see if I can find a Debian unstable snapshot th=
at
> restores the behaviour I observed last year and try to bisect to find the
> source of the regression.

I spent the past two days trying to reproduce the problem and I'm unable to=
 get
reliable results. Let me explain what I did.

 - December 20 I took a snapshot of my system (but without rebooting) at th=
is
   time my T440s SD card reader worked fine and showed up as /dev/mmcblk0*
 - January 10 (three weeks later) I did a big `apt-get upgrade/dist-upgrade=
` to
   update all the packages to their Jessie or Sid versions, respectively and
   rebooted. The card reader didn't show up anymore. Nothing on dmesg when I
   inserted my sdcard which would before show me the new registered partiti=
ons
 - I put a Debian Sid debootstrap from January 1 2014 on a USB stick and bo=
oted
   that. Same thing, no SD card.
 - I put a Debian Sid debootstrap from January 1 2013 on a USB stick and bo=
oted
   that. Same thing, no SD card.
 - In the hopes that at least the snapshot from December 20 would work and
   somehow allow me to find out which package upgrade broke my system, I put
   this back on my harddisk and booted it. The SD card reader worked and was
   available as /dev/mmcblk0*
 - I upgraded step by step important packages like linux-image-amd64,
   initramfs, udev, while rebooting after every step. The system kept worki=
ng.
 - I added /usr /bin /sbin /var /etc /boot and /lib to a git on my / so tha=
t I
   would always be able to quickly roll back everything and did `apt-get
   upgrade/dist-upgrade` for the rest of my system and rebooted. Everything
   kept working
 - So at this point I executed the same upgrade path which before made a sy=
stem
   that was working not working but in this case the SD card reader kept
   working. I had no explanation as I didn't do anything different.
 - I put the prior non-working snapshot of my system from January 10 back w=
hich
   had all the upgrades already done. And surprise: this time it worked! The
   exact same hard disk image which before leads to my MMC card reader not
   showing up worked fine this time.
 - I installed Debian Jessie (with the daily installer from [1]) on a USB s=
tick
   and booted that. My card reader keeps working
 - I put put a Debian Sid debootstrap from January 1 2014 on a USB stick and
   booted that (this wasn't working before, see above). This time it worked=
 and
   I was able to mount my SD card.

What do you make from this?

Apparently there are situations where, with the exact same root file system=
 (My
January 20 full snapshot and the January 1 2014 Debian Sid debootstrap) it =
at
some point did not work but then worked again.

How can this happen?

What else can I try?

Right now everything works and I'm not able to make it not-working again.
Thoughts?

cheers, josch

[1] http://cdimage.debian.org/cdimage/daily-builds/daily/arch-latest/amd64/=
iso-cd/debian-testing-amd64-netinst.iso

--===============8900957341149917359==
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Description: signature
Content-Type: application/pgp-signature; name="signature.asc"; charset="us-ascii"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJUs4GlAAoJEPLLpcePvYPh1hcP/0Ba9nO9jDwgDm6xincrTajM
FYHF3sQKmIz3DibbMvoBQA3YePHy0PhZgbNUroNMI7OPefe7vQipvcFtFCYxXfsG
+bvLQ+FW4saHk0+1mHw27ozx211jXWW/g1xPejsaVBdlunCIM8bclCjUcJ0tXiPZ
Xd1ECbm8S32uPAhxd+SpWuLq/+EM/oy3x20fiOPW8QJ4Ik6Tt/T+vqY1ZMnmDlU9
VkjpXYZbIUCc26L923o69cDofIRdUUwbZU/OedR1uBD/N6RZe9LcV625pfuPPQB6
t5pdbIR00EwhF14G+JyIcXIpe2qCRneGLztN4jw8Y+nBxM1jltpzVF4qb3pLfXur
isrbCOYQ6JAcO/t735WF0aZaRzcsXaEiFnu/Tb92iZ6Y46o2fO3UvfLBQ7QGPTAr
vfT6vBmCapdccpqA/N7ueTs50UbrM/exX/id8kmo9mU1liVoI64AdArnH16iU5zw
Sn4QlwpIbDeBjV8oh9w05P/r9VjYmuH70eecjBGtAVhuND/dJBW/W34O16XvT+Li
d/n+zwfuLjHPq2bBHtAuNkUMI/B3wCrjNgM86KGB2FSfb2JcpvhWxM62AJ0MkmMQ
vzeTI60gV/ui/1pg9u/AZvhanttyI1G98cXBjbupb+n7U9nt0dHpIgDqmjdU1fTZ
jp4QdMpTisSBSKntrlqp
=gs15
-----END PGP SIGNATURE-----

--===============8900957341149917359==--
