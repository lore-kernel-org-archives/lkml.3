Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754549AbaDFSBb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 14:01:31 -0400
Received: from mout.gmx.net ([212.227.17.20]:52694 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754079AbaDFSB1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 14:01:27 -0400
Message-ID: <53419674.7010509@gmx.de>
Date: Sun, 06 Apr 2014 20:01:24 +0200
From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Roger Heflin <rogerheflin@gmail.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: NFS V4 calls for a NFS v3 mount
References: <53418E98.8030505@gmx.de> <CAAMCDec1OJFPKWPz-qnFedYiHXpag3=2qRYPwNHdQCC4tqaQ_Q@mail.gmail.com>
In-Reply-To: <CAAMCDec1OJFPKWPz-qnFedYiHXpag3=2qRYPwNHdQCC4tqaQ_Q@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:kHqNVnoUlYObWZY21Q9Gez2rcQDVIZ/Bje82oabJwnDt9n3lz+y
 fjWPFZAN5LmQ+9ik6wj419c7HwBIFWhfl0+7pXmyOookwPdsFdumFnkwUzg++wm3LvwmC6H
 qda3eMTt/SYs4AAaRGLCzYwYRwrVkw5CjWRXGDCQ066ltkcPbEv+3bOLA53Kfp0IvBlecIW
 aXMUEELxv4c7mV+zBIl2w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

On 04/06/2014 07:57 PM, Roger Heflin wrote:
> No where in the mount command did you tell it that this was a 
> nfsversion 3 only mount, the mount name itself means nothing to
> mount, so it tired nfs version 4 first then nfs version 3.
> 
> Note this in the man page for nfs: nfsvers=n      The NFS protocol
> version number used to contact the server's NFS service.  If the
> server does  not  support the  requested  version, the mount
> request fails.  If this option is not specified, the client
> negotiates a suitable version with the server, trying version 4
> first, version 3 second, and version 2 last.
> 

ick, I misunderstand the key word "nfs4" in /etc/fstab - I thought
that (and only that) would activate any NFS v4 Calls :

Hre all of my setting
$ grep nfs /etc/fstab
n22:/mnt/ramdisk    /mnt/nfsv2      nfs     auto,bg,intr,soft,nfsvers=2
n22:/mnt/ramdisk    /mnt/nfsv3      nfs     auto,bg,intr,soft
n22:                /mnt/nfsv4      nfs4    auto,bg,intr,soft


Thx for explanation.


> On Sun, Apr 6, 2014 at 12:27 PM, Toralf Förster
> <toralf.foerster@gmx.de> wrote: Probably a question better suited
> for a NFS noobs mailing list (is there any around ?) ...
> 
> While playing with kernel 3.13.x, wireshark and NFS I realized,
> that mounting a NFS v3 share results in NFS V4 Calls - is this
> indented or a wireshark dissector issue ?
> 
> 
> $ cat /etc/exports # /etc/exports: NFS file systems being exported.
> See exports(5). /mnt/ramdisk
> 192.168.0.0/16(rw,fsid=0,insecure,no_subtree_check,async,no_root_squash)
>
> 
> 
> $ grep nfsv3 /etc/fstab n22:/mnt/ramdisk    /mnt/nfsv3      nfs
> auto,bg,intr,soft
> 
- -- 
MfG/Sincerely
Toralf Förster
pgp finger print:1A37 6F99 4A9D 026F 13E2 4DCF C4EA CDDE 0076 E94E
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlNBlnQACgkQxOrN3gB26U41HQD8D/KROgItC324iDevD33vJ6QS
PcSWPcBTzimC0cMOfzkA/04ejAWOGGqyqNedV5Ps235rxqbxDWoiUS7M7iQtu/Wz
=jJAD
-----END PGP SIGNATURE-----
