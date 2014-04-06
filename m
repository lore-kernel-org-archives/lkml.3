Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616AbaDFWdy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 18:33:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36220 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753191AbaDFWdw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 18:33:52 -0400
Date: Mon, 7 Apr 2014 08:33:38 +1000
From: NeilBrown <neilb@suse.de>
To: Toralf =?UTF-8?B?RsO2cnN0ZXI=?= <toralf.foerster@gmx.de>
Cc: Roger Heflin <rogerheflin@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: NFS V4 calls for a NFS v3 mount
Message-ID: <20140407083338.351db1c7@notabene.brown>
In-Reply-To: <53419674.7010509@gmx.de>
References: <53418E98.8030505@gmx.de>
	<CAAMCDec1OJFPKWPz-qnFedYiHXpag3=2qRYPwNHdQCC4tqaQ_Q@mail.gmail.com>
	<53419674.7010509@gmx.de>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s36MXwPd001163

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On Sun, 06 Apr 2014 20:01:24 +0200 Toralf FÃ¶rster <toralf.foerster@gmx.de>
wrote:

> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA256
> 
> On 04/06/2014 07:57 PM, Roger Heflin wrote:
> > No where in the mount command did you tell it that this was a 
> > nfsversion 3 only mount, the mount name itself means nothing to
> > mount, so it tired nfs version 4 first then nfs version 3.
> > 
> > Note this in the man page for nfs: nfsvers=n      The NFS protocol
> > version number used to contact the server's NFS service.  If the
> > server does  not  support the  requested  version, the mount
> > request fails.  If this option is not specified, the client
> > negotiates a suitable version with the server, trying version 4
> > first, version 3 second, and version 2 last.
> > 
> 
> ick, I misunderstand the key word "nfs4" in /etc/fstab - I thought
> that (and only that) would activate any NFS v4 Calls :
> 
> Hre all of my setting
> $ grep nfs /etc/fstab
> n22:/mnt/ramdisk    /mnt/nfsv2      nfs     auto,bg,intr,soft,nfsvers=2
> n22:/mnt/ramdisk    /mnt/nfsv3      nfs     auto,bg,intr,soft
> n22:                /mnt/nfsv4      nfs4    auto,bg,intr,soft

That was used to indicate nfsv4 early in development, possibly to make sure
it didn't get used by default, but it was quickly realised that having a
separate filesystem type was confusing.

So while "nfs4" does still work an selected vers=4, it is deprecated.  You
should  always use "nfs" if possible.

BTW the nfs list is "linux-nfs@vger.kernel.org" - suitable for "noobs",
developers, and everyone in between.

NeilBrown


> 
> 
> Thx for explanation.
> 
> 
> > On Sun, Apr 6, 2014 at 12:27 PM, Toralf FÃ¶rster
> > <toralf.foerster@gmx.de> wrote: Probably a question better suited
> > for a NFS noobs mailing list (is there any around ?) ...
> > 
> > While playing with kernel 3.13.x, wireshark and NFS I realized,
> > that mounting a NFS v3 share results in NFS V4 Calls - is this
> > indented or a wireshark dissector issue ?
> > 
> > 
> > $ cat /etc/exports # /etc/exports: NFS file systems being exported.
> > See exports(5). /mnt/ramdisk
> > 192.168.0.0/16(rw,fsid=0,insecure,no_subtree_check,async,no_root_squash)
> >
> > 
> > 
> > $ grep nfsv3 /etc/fstab n22:/mnt/ramdisk    /mnt/nfsv3      nfs
> > auto,bg,intr,soft
> > 
> - -- 
> MfG/Sincerely
> Toralf FÃ¶rster
> pgp finger print:1A37 6F99 4A9D 026F 13E2 4DCF C4EA CDDE 0076 E94E
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v2.0.22 (GNU/Linux)
> Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/
> 
> iF4EAREIAAYFAlNBlnQACgkQxOrN3gB26U41HQD8D/KROgItC324iDevD33vJ6QS
> PcSWPcBTzimC0cMOfzkA/04ejAWOGGqyqNedV5Ps235rxqbxDWoiUS7M7iQtu/Wz
> =jJAD
> -----END PGP SIGNATURE-----
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU0HWQjnsnt1WYoG5AQLr+Q//az/LlGyQRBKGCcrNAEUxeI7msLur6aAR
6j/ecJkjNtI+D4o3WuUZQlkxnvjZ7uA9RacRbLc7UHDh7kWpJjsoCl/s6SkS1RY2
y3KHOY/vm6+jwBXRknbGPMjPDNDA34s0cok2/so6ELyL82Uxd/Zsrhua6/yxoj8D
6J2p2KLY6DqgmJnicTAmZf5F2gVCnL0cwuv16wKCsCrf24O0d9eXqjStYUV62jLX
m3JrzB8JxovT7LmU9jsH1ChE7PW6sAd92R1lzrgQM7XNLoy4Q3bggWBNcLOATRNp
V5uGXCOXW+mnnPCdwhQkK7hoJf4dpkodU+BDydZO/oet2kE84eQYM0oyl5Ebz+mR
nOKQwp7Y2Zitj4ZzAfa9KrxteZ6Pa5ISv0Olbjw/3W0aL148Y3UmEo9cT4kUzhAm
hiNzN7K2835vOVZvtCW3Woq+sN66v7Jp9Ig/6ZNAsAizH2oMl9F9k/fH6u8P9bV4
4Lc9nc9yo6IzFVlJYbM3wPMod70gQz9QNCNXvRH9m6ospV+wY/TFfvqYNCAE9msk
tjbKnfYCNoAdGgPSW2tHbpqM42ZwYpy6wu7gG3Io98CtsoUiJbG7meMj6FkkWOno
6dW8CVovxdGrdQP1cLQbyVUKX4XYDRzI2eCJI7sUH11Sn8o+Ft0rRtxzeLpE4s4t
3vGS4lERy+U=
=EiAW
-----END PGP SIGNATURE-----
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
