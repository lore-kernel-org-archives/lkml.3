Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753756Ab3AXRX1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 12:23:27 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:50645 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150Ab3AXRXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 12:23:25 -0500
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.4-dev
To: Hillf Danton <dhillf@gmail.com>
Cc: Benjamin LaHaise <bcrl@kvack.org>,
        Kent Overstreet <koverstreet@google.com>, linux-kernel@vger.kernel.org,
        linux-aio@kvack.org
Subject: Re: next-20130117 - kernel BUG with aio
In-Reply-To: Your message of "Wed, 23 Jan 2013 20:10:03 +0800."
             <CAJd=RBCHRDzyjY_hOZCj6rHBXzb3f5wWxdqXYuLbQXLe2n4JeA@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <3544.1358774694@turing-police.cc.vt.edu> <CAJd=RBBBbv07aoOTF=PNy1FpCyuRV7fnQEGX_DXEYFSSknKtqQ@mail.gmail.com> <2553.1358890098@turing-police.cc.vt.edu>
            <CAJd=RBCHRDzyjY_hOZCj6rHBXzb3f5wWxdqXYuLbQXLe2n4JeA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1359048141_1950P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 24 Jan 2013 12:22:21 -0500
Message-ID: <13450.1359048141@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020201.51016DCE.0076,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2011-07-25 19:15:43,
	dmn=2011-05-27 18:58:46,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1359048141_1950P
Content-Type: text/plain; charset=us-ascii

On Wed, 23 Jan 2013 20:10:03 +0800, Hillf Danton said:

> Try again?
> ---
>
> --- a/fs/aio.c	Tue Jan 22 21:37:54 2013
> +++ b/fs/aio.c	Wed Jan 23 20:06:14 2013

Now seeing this:

[ 2941.495370] ------------[ cut here ]------------
[ 2941.495379] WARNING: at fs/aio.c:336 put_ioctx+0x1cb/0x252()

Same warn location, but different traceback?

[ 2941.495407] Call Trace:
[ 2941.495415]  [<ffffffff8102f5ad>] warn_slowpath_common+0x7e/0x97
[ 2941.495419]  [<ffffffff8102f5db>] warn_slowpath_null+0x15/0x17
[ 2941.495423]  [<ffffffff8115247b>] put_ioctx+0x1cb/0x252
[ 2941.495428]  [<ffffffff81617fc3>] ? sub_preempt_count+0x33/0x46
[ 2941.495433]  [<ffffffff81050448>] ? abort_exclusive_wait+0x89/0x89
[ 2941.495438]  [<ffffffff81152529>] kill_ioctx_work+0x27/0x2b
[ 2941.495443]  [<ffffffff81603ded>] process_one_work+0x26f/0x4be
[ 2941.495447]  [<ffffffff81603d27>] ? process_one_work+0x1a9/0x4be
[ 2941.495453]  [<ffffffff810483c5>] ? spin_lock_irq+0x9/0xb
[ 2941.495457]  [<ffffffff8104b0f9>] worker_thread+0x1b6/0x28e
[ 2941.495461]  [<ffffffff8104af43>] ? rescuer_thread+0x1a5/0x1a5
[ 2941.495466]  [<ffffffff8104f7cc>] kthread+0x9d/0xa5
[ 2941.495471]  [<ffffffff8104f72f>] ? __kthread_parkme+0x60/0x60
[ 2941.495475]  [<ffffffff8161b06c>] ret_from_fork+0x7c/0xb0
[ 2941.495479]  [<ffffffff8104f72f>] ? __kthread_parkme+0x60/0x60
[ 2941.495483] ---[ end trace 8e545cd216c853ec ]---

Obviously VirtualBox 4.2.6 on my laptop is going out of its way to
get indigestion at this patch series. :)


--==_Exmh_1359048141_1950P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBUQFtzQdmEQWDXROgAQLikA//cuDTlWj2VBWMJ8abZMPTLGtJNLa55BVn
3crAVj+Mv9iznmZ2+vwOsPDHZCO4tehhNrCWWiAX7n3rnhb04OLsppy3lgkSQWTB
YCL5LmhG1VAgUNp7lsrVJpani2erPRLr4zPdu1DjEGpjFfBIgOHuts+RA23xFu8l
L/BQYWCP1WvhV7ksPbP7UyltPOac0CzkdZdE3BjlA70vcFMywH/L/I/ZVAg7Ti1e
FZO/ZXN0dK8YougTc/ebSN6Tn03tquA1GhrQ/qGCMXdLHf4Kn+byFtNJvau88b/N
Tzjg7sr9gPNVHzipUhWzl1K7efobnDO6tCsZXc7d3Pv8anxtugbRDraDAuGtahDk
gdxuCD9NlKvhdyu+v0sdVydssjSo7WZ3QEV0W5yRDnzHHgqU+XPA4UdyTEpIZvm1
o7Gj3LRGb5aFeQr8oaGuYBAcop2IDLz0AwGYsUFgD5i+3QuSXNSghKMW6Qa5e/SZ
Z4Fk3+OrvYWwv+NnJPED0/pLE+g17fil8gIAdlcX/WczM2oM+mOgAc9SFeELYx2X
kthvjMcHIRqsG9/+lhPvBouzKCrnIaskuBQjTTxwQcugn9mHsJpKB6iMRjp0gW24
3eySm+l5vB0P5KA7i89ZBP8AVozwas0jPaP/JFvTzb/U8dxFYOHt+nP7b54I7TU9
wuCb7C1D6T0=
=+dZw
-----END PGP SIGNATURE-----

--==_Exmh_1359048141_1950P--

