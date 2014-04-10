Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965631AbaDJQva (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 12:51:30 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:52378 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965331AbaDJQvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 12:51:25 -0400
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.5+dev
To: Tony Luck <tony.luck@gmail.com>, Madper Xie <cxie@redhat.com>
Cc: Kees Cook <keescook@chromium.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: pstore wierdness on Dell Latitude E6530.
In-Reply-To: Your message of "Wed, 09 Apr 2014 14:02:04 -0700."
             <CA+8MBb+Od9wRT-L4KhrNgqwCyHx_R4vS_k1gouAjaxMZPaLKFg@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <9443.1397067600@turing-police.cc.vt.edu>
            <CA+8MBb+Od9wRT-L4KhrNgqwCyHx_R4vS_k1gouAjaxMZPaLKFg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1397148610_2025P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 10 Apr 2014 12:50:10 -0400
Message-ID: <8490.1397148610@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1397148610_2025P
Content-Type: text/plain; charset=us-ascii

On Wed, 09 Apr 2014 14:02:04 -0700, Tony Luck said:

> Take a look at this thread: https://lkml.org/lkml/2013/10/30/83
>
> I think there were some bugs in the console-efi code a while
> back - perhaps you ran a kernel had the bug and made all these
> duplicate entries?

The cited patch pair isn't in linux-next-20140409, but applied with a few
1-line offsets.  Boothing the result was much better.  'git blame' doesn't
indicate anything changed between next-0303 (busted) and next-0409, so
I have to conclude that Madper Xie's patch is an improvement.

Madper:  Feel free to stick this on the patch:
Tested-By: Valdis Kletnieks <valdis.kletnieks@vt.edu>

The gory details:

I now have different filenames and inodes, with different contents, rather than
duplicates:

ls -li /sys/fs/pstore | head
total 0
8034 -r--r--r--. 1 root root  67 Aug 13  2013 console-efi-0-1376377513
8033 -r--r--r--. 1 root root  51 Aug 13  2013 console-efi-0-1376377515
8032 -r--r--r--. 1 root root  71 Aug 13  2013 console-efi-0-1376377517
8031 -r--r--r--. 1 root root  52 Aug 13  2013 console-efi-0-1376377519
8030 -r--r--r--. 1 root root  67 Aug 13  2013 console-efi-0-1376379570
8029 -r--r--r--. 1 root root  67 Aug 13  2013 console-efi-0-1376379650
8028 -r--r--r--. 1 root root  67 Aug 13  2013 console-efi-0-1376381002
8027 -r--r--r--. 1 root root  97 Aug 13  2013 console-efi-0-1376381189
8026 -r--r--r--. 1 root root  78 Aug 13  2013 console-efi-0-1376381190

grep . * | head
console-efi-0-1376377513:[    4.423745] hda_codec: cannot build controls for #1 (error -16)
console-efi-0-1376377515:[    6.245592] netconsole: network logging started
console-efi-0-1376377517:[    6.676439] ata_id (211) used greatest stack depth: 4408 bytes left
console-efi-0-1376377519:[    8.679546] sd 6:0:0:0: [sdb] Attached SCSI disk
console-efi-0-1376379570:[    2.001350] hda_codec: cannot build controls for #3 (error -16)
console-efi-0-1376379650:[    1.982463] hda_codec: cannot build controls for #3 (error -16)
console-efi-0-1376381002:[    1.983509] hda_codec: cannot build controls for #3 (error -16)
console-efi-0-1376381189:[    0.000000] efi: mem27: type=7, attr=0xf, range=[0x00000000be944000-0x00000000be951000) (0MB)
console-efi-0-1376381190:[    0.620462] ACPI: PCI Interrupt Link [LNKE] (IRQs *3 4 5 6 10 11 12 14 15)
console-efi-0-1376381191:[    3.890372] netconsole: network logging started

And 'rm *' actually removed all 536 remaining entries and they stayed removed.




--==_Exmh_1397148610_2025P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBU0bLwgdmEQWDXROgAQJKkw/9GUEbfPLU+42VW8Mohb/9FjxaEFZpjK+q
dsaImS3wCsRpK58MeG8w8zCv4NQ+waZUnDxra31i5dkJJHPmNDVzJgWWLwG5QMPk
Nj4q7Ge1LU81GedOOtXytHMyGcOV/Sm9+rxidmrN13/2bM49rTCRraNVgZ3HF/8S
WcPqPaMqeEbbL28w/zlhPFlWihMKMqdSQyLl5Skc9R9V2NbhvposYjTbVAPmEc6e
fMxam0IRgCJ5ESMHcAWe8i+GWQqg37kaQ94StDp5PPYrbjb0llMGJZ+nPbr3cbW1
cIJIuJbmjoKKmOWFtttsDyWXYjkHKS1ptppOSQTVPtj/kXRxGZJFm8qdEP+WmcFX
m3n1Z14ZTvBh0Hwrn2Y9xt80l/zenYUFyv+OxquD/8fLqQM8jNAAxfQscKVpJrNO
2fuK78LTht5UUzwg4+1mcd4ut0h0YF2fo+Ee0/NIblSc0kRlA9PDsPnWQNpYd2BI
WbJqLPG5NfwZXLf/BmskZw2hYB66PYfDvhG2FqyKinXvCsnzXf3dD+RQDWY5npB9
LwN9tu7JSSY3MYam9a7J1WeYF1pkKf+DOfUVdcFO11q2ZP/i4HEN7iQ31gIF2AW+
3QP75okpzSBuZqBUz39XXIEOlm0lD+wNGAjUqfd5n5c+CgA2x+kIFqgjUsxv+mio
xlOWULoLDP0=
=sRGD
-----END PGP SIGNATURE-----

--==_Exmh_1397148610_2025P--
