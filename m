Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751435AbaCMFzz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 01:55:55 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58618 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751034AbaCMFzw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 01:55:52 -0400
Date: Thu, 13 Mar 2014 16:55:41 +1100
From: NeilBrown <neilb@suse.de>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        David Herrmann <dh.herrmann@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>, Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH] fs: fix i_writecount on shmem and friends
Message-ID: <20140313165541.2b23dc96@notabene.brown>
In-Reply-To: <20140313042934.GM18016@ZenIV.linux.org.uk>
References: <1393859798-1407-1-git-send-email-dh.herrmann@gmail.com>
	<CA+55aFwzBoTc+09jZTGjfTQTfkgZwrN5m09snb+F9inLaDn0OA@mail.gmail.com>
	<20140312181925.GK18016@ZenIV.linux.org.uk>
	<20140313150800.07878c80@notabene.brown>
	<20140313042934.GM18016@ZenIV.linux.org.uk>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/k/aLF6EE3uAwsOkzbPYO_VP"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/k/aLF6EE3uAwsOkzbPYO_VP
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 13 Mar 2014 04:29:34 +0000 Al Viro <viro@ZenIV.linux.org.uk> wrote:

> On Thu, Mar 13, 2014 at 03:08:00PM +1100, NeilBrown wrote:
> > +		inode =3D mddev->bitmap_info.file->f_mapping->host;
> > +		if (!S_ISREG(inode->i_mode)) {
> > +			printk(KERN_ERR "%s: error: bitmap file must be a regular file\n",
> > +			       mdname(mddev));
> > +			fput(mddev->bitmap_info.file);
> > +			mddev->bitmap_info.file =3D NULL;
> > +			return -EBADF;
> > +		}
> > +		if (atomic_read(&inode->i_writecount) !=3D 1) {
>=20
> Umm...  I think you ought to check more than that.  At the very least you
> want to check that you have it opened for write - you don't want e.g.
> a filesystem containing that puppy remounted r/o under you.  Another thing
> is, what happens if it's not a buffer cache backed one?  Hell, what happe=
ns
> if it's a file on NFS?  You are relying on bmap() working, right?  So it
> looks like you ought to check if ->bmap() is there.  And I really wonder
> how well does it play with journalling fs...

Can we do direct writes from kernel space yet?  If so I'll change the code =
to
do that so that it will work with any filesystem (which supports direct
writes).
(The documentation says we that bitmap files should only be used on ext2 or
ext3.  Most people use bitmaps on the raw devices so hopefully the few who
have a need for files will read the documentation :-)

(and yes, I check for FMODE_WRITE)

Thanks,
NeilBrown

--Sig_/k/aLF6EE3uAwsOkzbPYO_VP
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUyFIXTnsnt1WYoG5AQLDZw/9ED8X2oPceT4VTevWXa8GOh/l3q7Ai6wL
alTnmoSqkhr9CHf86UYnRTKP2U79L215eusBpE8yEEQtbHJ8F1kzAg3cUn3D/g5W
H6ySc9dbF1M8X+RRln2Nvh3eBCmmrTw3TsUekQuH8i94nRppVldmxtcoTVmciopr
ccF9EGzUIM+55BTuB/7ZKAt9HMV5AGtW5jpTvoB+lL6mw4rgnsPfvWSTubhmHx/G
md14qBl+sWEeXQnvJkh1DE4BRA2i6dYdbdh/b1mk1xfAg9HbHg5BdcfSBv0SUZ5H
lsY3jy7HBG8Ja8Rh+Vm4YUVqDeAi4J5p4yINs30816qewBl9/RvLnO1KluvjRS4g
ev34lEMFdF9pLAXtu2EiRB6CGUElrlz2bVyzKziEvWy0K8ombLbd5iVWPox/jsST
f9fqHrK2sKab6jn6TlnMSYUyHs27cnmVRcM8JgFk0Z5riy7Gt1M8+ta0IVBcGOtv
zeX7KQdRjduyi9q85irqRnnmiiqFZBfnjtQBRHdamefPo9TL97qbEO3P4CISnLwj
6UBgpTxUIRAtIPyPZhvq5TCvy384GFNvTq4ppLE9bFs8pq+1xpW9p6/N5R1lwPKi
9uftwrAxz4kI9mgt2FPosuVWbBc+moaA+I0KqBnRyxj+eGQow/dmLYuDZRI1AXsg
LfG9EJrSEMc=
=Qupa
-----END PGP SIGNATURE-----

--Sig_/k/aLF6EE3uAwsOkzbPYO_VP--
