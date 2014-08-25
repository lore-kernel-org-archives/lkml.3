Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756592AbaHYVog (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 17:44:36 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:48296 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752894AbaHYVof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 17:44:35 -0400
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Subject: Re: Linux UDF support
Date: Mon, 25 Aug 2014 23:44:31 +0200
User-Agent: KMail/1.13.7 (Linux/3.13.0-32-generic; KDE/4.13.2; x86_64; ; )
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org
References: <201408241446.47042@pali> <201408251524.05443@pali> <53FB42A7.3030505@gmail.com>
In-Reply-To: <53FB42A7.3030505@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2279431.u1AyuVjgiO";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201408252344.31771@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2279431.u1AyuVjgiO
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Monday 25 August 2014 16:05:27 Austin S Hemmelgarn wrote:
> On 2014-08-25 09:24, Pali Roh=C3=A1r wrote:
> > Hi,
> >=20
> > On Monday 25 August 2014 14:45:13 Austin S Hemmelgarn wrote:
> >> On 2014-08-24 08:46, Pali Roh=C3=A1r wrote:
> >>> Hi,
> >>>=20
> >>> I would like to know what is state of linux UDF driver. It
> >>> is experimental or is now suitable for storing data?
> >>=20
> >> I know that read support works for every version I have
> >> tested, but I've only tested it reading data from DVD's and
> >> Blu-Ray discs, so I don't know how well it works for other
> >> purposes.
> >=20
> > Ok. I'm thinking about using UDF on HDD and usb flash disks
> > (not on optical medium). And here I need write support too.
> >=20
> >>> According to wikipedia [1] UDF has open specification
> >>> format and can be used also for HDDs (not only optical
> >>> discs).
> >>>=20
> >>> In OS support table is written that all major and other
> >>> minor OSs support UDF FS (without needs for additional
> >>> programs).
> >>>=20
> >>> So it looks like UDF is good candidate for multi OS
> >>> filesystem. Are there any disadvantages for using UDF on
> >>> e.g USB flash disk? (when I want read/write support on
> >>> Linux, Windows 7 and Mac OS X)
> >>=20
> >> If you are going to go that way, make sure to use the
> >> Spared Build, as otherwise you will run in to the same
> >> media wear-out issues that NTFS and FAT have.  Also, keep
> >> in mind that pre-Vista Windows and pre-10.4 OSX don't have
> >> very good support for the newer formats.
> >=20
> > What is Spared Build? And how to use it?
>=20
> Sparse Build is one of the extensions that was added in 1.50.=20
> It provides a table indicating sectors that have worn out and
> therefore should be left unused.  The general idea is that
> rewritable media is almost always limited in the number of
> writes it can handle to a given location, and when you exceed
> that number, you get data corruption at that location.  This
> is usually most noticeable on flash media, but it happens on
> {CD,DVD,BD}-RW discs and hard drives as well.  FAT has no
> provisions for handling this, and NTFS and ext4 just return
> the corrupted data.  UDF however, has sufficient error
> correction ability (because it was designed with optical
> media in mind) that it can usually detect the corruption,
> recover the corrupted data, and then if you are using the
> Sparse Build format, mark that block as unusable, and write
> the new data out elsewhere.
>=20

Looks good. But I think that when I reformat disk I will lost all=20
these data about detected corruption... Or will duplicate mkudffs=20
calls preserve these information about HW errors?

So if I format block device (hdd) with mkudffs and rev 0x0201 it=20
is automatically enabled? Or is something more needed?

> > Problem with NTFS is that linux driver has write support
> > marked as experimental. FAT has problems with big files and
> > for exFAT there is no driver in linux kernel yet...
>=20
> For NTFS, you should be using NTFS-3G, not the kernel driver,
> and I personally wouldn't trust the OS X driver for NTFS for
> anything beyond read-only usage (I only barely trust NTFS-3G
> as it is, and have about as much trust in the Linux kernel
> driver for it as I would in somebody trying to convince me
> that arsenic is good for you).  And for exFAT there is FUSE
> module.  I haven't tested either for much other than
> read-only scenarios, but I can confirm that they are great
> for data recovery.
>=20

I'm not sure if using fuse for anything other then experiments is=20
reasonable. And speed of fuse (ntfs-3g or exfat) is also=20
horrible. And now I think that only usage is read-only data=20
recovery...

So still would like to hear what is state of udf read/write=20
support in kernel (for usb/flash/hdd disks).

> >>> Because lot of manuals say that FAT32 (or NTFS) is only
> >>> one solution for using USB flash disk on more OS.
> >>>=20
> >>> On wikipedia there is one note about linux: Write support
> >>> is only up to UDF version 2.01. Is this restriction still
> >>> valid?
> >>=20
> >> I do know that we support reading UDF 2.60 (I've used linux
> >> to read Blu-Ray discs), but I have no idea about write
> >> support for versions above 2.01.
> >>=20
> >>> What will happen if I try to mount FS with UDF version
> >>> 2.60 in R/W mode on linux? It will fallback to R/O mode?
> >>> Or newly written files will be in previous (2.01)
> >>> versions?
> >>>=20
> >>> And last question: Is there some fsck tool for UDF? Or at
> >>> least tool which print if FS is in inconsistent state?
> >>=20
> >> Most Linux distributions have a package called udftools,
> >> the upstream URL given by portage is
> >> http://sf.net/projects/linux-udf/
> >=20
> > That project does not have udf fsck tool :-(
>=20
> IIRC, there are a lot of issues that UDF will recover from
> gracefully. It has ridiculously good error correction
> abilities, and the newer versions even have the option of
> duplicate copies of filesystem metadata to provide even more
> resilience.
>=20

But this depends on driver implementation, rigth? Is linux kernel=20
driver able to recovery and fix (on the fly) errors at mount time=20
(like ubifs or ext4)? Somebody said that ubifs does not need fsck=20
because kernel driver doing similar job of recovery at mount=20
time... It is same for udf implementation in linux?

> >>> [1] - http://en.wikipedia.org/wiki/Universal_Disk_Format
> >=20
> > Ok, I will wait for response from maintainer Jan, he
> > probably would know more...

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart2279431.u1AyuVjgiO
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlP7rj8ACgkQi/DJPQPkQ1Ki9QCgrbM2Q0hcZgX4Jiuhz12IbArq
a1wAn2j7rNpy8zM7/CLLBwArFHqZaEF0
=ssym
-----END PGP SIGNATURE-----

--nextPart2279431.u1AyuVjgiO--
