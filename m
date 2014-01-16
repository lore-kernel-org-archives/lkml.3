Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752912AbaAPQU7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 11:20:59 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:51826 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752380AbaAPQU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 11:20:57 -0500
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.5+dev
To: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>,
        linux-kernel@vger.kernel.org
Subject: Re: next-20140114 - BUG: spinlock wrong CPU on CPU#3, mount/597
In-Reply-To: Your message of "Thu, 16 Jan 2014 11:39:34 +0100."
             <20140116103934.GA30291@quack.suse.cz>
From: Valdis.Kletnieks@vt.edu
References: <14473.1389810012@turing-police.cc.vt.edu>
            <20140116103934.GA30291@quack.suse.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1389889219_2720P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 16 Jan 2014 11:20:19 -0500
Message-ID: <55555.1389889219@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1389889219_2720P
Content-Type: text/plain; charset=us-ascii

On Thu, 16 Jan 2014 11:39:34 +0100, Jan Kara said:

>   Hum, the complaint is for group->notification_waitq->lock which
> is an internal lock for the wait queue. Actually the corruption seems to be
> only a single bit flip - the whole spinlock structure looks correct, only
> owner_cpu got flipped from 0x3 to 0x23. Ah, do you have patch from Hugh:
>
> fanotify: fix corruption preventing startup
>
> The corruption would match that very well and Andrew queued it just
> recently...

Aha.  It landed after next-20140114 got put together.  WIll try -0116 (which
does have it) and if that doesn't fix it, I'll follow up...


--==_Exmh_1389889219_2720P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBUtgGwwdmEQWDXROgAQIAmg/8CR56hFsTL1Tt/sXe5kxJ6CM5qTzJuk43
VLdjRNAE2g/gKTHYThpwI6cLXFy03PqpyT42KeaJgvlHrrg4uhfxrn6926xpLmzT
bDwDtjhhcknX2GgMo8IxKvlfG1DuGtKES6IbwuofmCSr434NBbNUbmGXnD4sOQsh
3G2MgjW0nxRsXl/J0xxt6KaxhvsXsZzvxTZfNnlV71dGb4WtrFPCQOrU8BS/sWyU
X0IpoK2Wi6qhNQyhLaAKur86M70+swEQQahos+w2S5XF+ERUghtB+F+LIjOwfIwH
j/XqeHbjT6+vJIOvu6oh0miHUliu91WNtjhKqw18lkK080nUuZ0wdvGsQB4E+mHJ
Ef5QBEvCpuQzDppCLdUvCYqQ5QYvXCpvVch0XPcIVxYX4q3v8rURyOIzoxkzsmEG
oYagH5YbCRrClUbseqFSLvvS8JzvI9VfAYY4O5cc9qx8GmsQiVH/v6vrFSsCi+rA
g5UO9r86TG3v0cVitDU5Wt+6Dv3lT8OdtzVe3e/vZMmGfrqb4D7K/rsvOtOzqv6E
e/zVPpZDR4SFIITk3xC2LS+vTUFMA2i8HKaUn5q7B8mEyOD0R73J4OYUU4Z8lnB4
OMZFrHWRcxOBpQSX2KyBhcOZ8fRblBxDt8SI9M3zy2GEOeaj5/w0wnSyDtiNdaHG
uqPeui9nVGE=
=sabb
-----END PGP SIGNATURE-----

--==_Exmh_1389889219_2720P--
