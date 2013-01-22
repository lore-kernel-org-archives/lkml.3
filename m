Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756028Ab3AVV3Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 16:29:24 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:52783 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267Ab3AVV3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 16:29:23 -0500
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.4-dev
To: Hillf Danton <dhillf@gmail.com>
Cc: Benjamin LaHaise <bcrl@kvack.org>,
        Kent Overstreet <koverstreet@google.com>, linux-kernel@vger.kernel.org,
        linux-aio@kvack.org
Subject: Re: next-20130117 - kernel BUG with aio
In-Reply-To: Your message of "Tue, 22 Jan 2013 21:43:27 +0800."
             <CAJd=RBBBbv07aoOTF=PNy1FpCyuRV7fnQEGX_DXEYFSSknKtqQ@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <3544.1358774694@turing-police.cc.vt.edu>
            <CAJd=RBBBbv07aoOTF=PNy1FpCyuRV7fnQEGX_DXEYFSSknKtqQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1358890098_2218P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 22 Jan 2013 16:28:18 -0500
Message-ID: <2553.1358890098@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020206.50FF0473.0055,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2011-07-25 19:15:43,
	dmn=2011-05-27 18:58:46,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1358890098_2218P
Content-Type: text/plain; charset=us-ascii

On Tue, 22 Jan 2013 21:43:27 +0800, Hillf Danton said:
> On Mon, Jan 21, 2013 at 9:24 PM, Valdis Kletnieks
> <Valdis.Kletnieks@vt.edu> wrote:
> > Am seeing a reproducible BUG in the kernel with next-20130117
> > whenever I fire up VirtualBox.  Unfortunately, I hadn't done that
> > in a while, so the last 'known good' kernel was next-20121203.
> >
> > I'm strongly suspecting one of Kent Overstreet's 32 patches against aio,
> > because 'git blame' shows those landing on Jan 12, and not much else
> > happening to fs/aio.c in ages.
> >
> Take a try?
> ---
> --- a/fs/aio.c	Tue Jan 22 21:37:54 2013
> +++ b/fs/aio.c	Tue Jan 22 21:43:58 2013
> @@ -683,6 +683,9 @@ static inline void kioctx_ring_unlock(st
>  {
>  	struct aio_ring *ring;
>
> +	if (!ctx)
> +		return;
> +
>  	smp_wmb();
>  	/* make event visible before updating tail */

Well, things are improved - at least now it doesn't BUG :)

[  534.879083] ------------[ cut here ]------------
[  534.879094] WARNING: at fs/aio.c:336 put_ioctx+0x1cb/0x252()
[  534.879121] Call Trace:
[  534.879129]  [<ffffffff8102f5ad>] warn_slowpath_common+0x7e/0x97
[  534.879133]  [<ffffffff8102f5db>] warn_slowpath_null+0x15/0x17
[  534.879137]  [<ffffffff811521f0>] put_ioctx+0x1cb/0x252
[  534.879142]  [<ffffffff8105bee3>] ? __wake_up+0x3f/0x48
[  534.879146]  [<ffffffff8115229e>] ? kill_ioctx_work+0x27/0x2b
[  534.879150]  [<ffffffff811531a5>] sys_io_destroy+0x40/0x50
[  534.879156]  [<ffffffff8161b112>] system_call_fastpath+0x16/0x1b
[  534.879159] ---[ end trace a2c46a8bc9058404 ]---

Hopefully that tells you and Kent something. :)

--==_Exmh_1358890098_2218P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBUP8EcgdmEQWDXROgAQKiYBAAuxMvlQeISZO/OK7eiP8t2tfnseA3XrHm
efJv23scId1FCPgHJCVUeunZyo9KZlDS+Nv5LloGU+FuZIjgCdnfjjOfGaw5lv/t
YkylepqNMeiJoSC5QqUTEZtgaLMzPzMd6VthZDZtehYFu1m/UMnwJqYbXq40sEf9
lzWup1/i922StucC6MsJt2Tmqr0mv3qGFnlJaqxJl5Y6la1GbBEm8DwcYaN5ljZn
WsXTe9OpWLX6h0nFxO/FS5qC0rDyFEdTG1vB5u9iSl28eTOeSZnnC+3vok8EfMD/
RF586YXIR7tlNkYY6dlnpWg3rsU97CW2aBOu3RaQNwevCWeeod8slpJaWoRtkcN8
Syp5yYjExuq9tR5NS1bhGkqrDIHoFsqBLmSUvfLeHNEA6dXP/mY/D5HAsIqWO2pk
I4XedXXo+vOpqXQ2GmXWzDo78JS1vweRH2NNWyfQjfCkUN624PaO90cfBZejYtpy
9uDeJSf8j/tgATEJVhaO60bkmCNxBF8UxG5PhW3tb4EHFsFKYzfZthd250vQ5hvm
w5Nhil1hmBSiftZBOwjixj66efapTTQLQGHBxcE2HzAz4rI6uIj8HHIEIcO608g4
/Xmie0lsw4Yt+pUY59XlOx0kfULHwh+Xn94oQjjfnEsZVaI1IAPUVkWx8qTPayF7
Jf0+YKestgM=
=hGOC
-----END PGP SIGNATURE-----

--==_Exmh_1358890098_2218P--

