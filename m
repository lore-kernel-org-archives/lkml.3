Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752410Ab3F3UXp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jun 2013 16:23:45 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:46808 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752295Ab3F3UXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jun 2013 16:23:41 -0400
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu <Valdis.Kletnieks@vt.edu> 0 pass
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu <Valdis.Kletnieks@vt.edu> 0 pass
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu <Valdis.Kletnieks@vt.edu> 0 pass
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu <Valdis.Kletnieks@vt.edu> 0 pass
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu <Valdis.Kletnieks@vt.edu> 0 pass
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu <Valdis.Kletnieks@vt.edu> 0 pass
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu <Valdis.Kletnieks@vt.edu> 0 pass
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu <Valdis.Kletnieks@vt.edu> 0 pass
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu <Valdis.Kletnieks@vt.edu> 0 pass
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu <Valdis.Kletnieks@vt.edu> 0 pass
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu <Valdis.Kletnieks@vt.edu> 0 pass
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu <Valdis.Kletnieks@vt.edu> 0 pass
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu <Valdis.Kletnieks@vt.edu> 0 pass
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu <Valdis.Kletnieks@vt.edu> 0 pass
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu <Valdis.Kletnieks@vt.edu> 0 pass
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.5+dev
To: Oleg Nesterov <oleg@redhat.com>
Cc: Sedat Dilek <sedat.dilek@gmail.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Imre Deak <imre.deak@intel.com>, Lukas Czerner <lczerner@redhat.com>,
        Samuel Ortiz <samuel@sortiz.org>, Wensong Zhang <wensong@linux-vs.org>,
        Simon Horman <horms@verge.net.au>, Julian Anastasov <ja@ssi.bg>,
        Ralf Baechle <ralf@linux-mips.org>
Subject: Re: linux-next: Tree for Jun 28 [ BISECTED: rsyslog/imklog: High CPU usage ]
In-Reply-To: Your message of "Sun, 30 Jun 2013 20:19:45 +0200."
             <20130630181945.GA5171@redhat.com>
From: Valdis.Kletnieks@vt.edu
References: <CA+icZUXo=Z4gDfCMvLqRQDq_fpNAq+UqtUw=jrU=3=kVZP-2+A@mail.gmail.com>
            <20130630181945.GA5171@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1372623427_4671P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sun, 30 Jun 2013 16:17:07 -0400
Message-ID: <4823.1372623427@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1372623427_4671P
Content-Type: text/plain; charset=us-ascii

On Sun, 30 Jun 2013 20:19:45 +0200, Oleg Nesterov said:
>
> Not only "__wait_no_timeout(tout) ?:" was wrong, I didn't bother
> to recheck this logic even after I got the "warning: the omitted
> middle operand in ?:" reports.
>
> Sedat, thanks you very much! Any chance you can try the patch below?

I'm not Sedat, but I had the same problem with rsyslog going nuts,
and I can confirm that the patch fixes the problem.  (Had to hand-apply
it, there was some difference of opinion regarding { } on an else)

Feel free to toss on a Tested-By: if this becomes a separate commit...


--==_Exmh_1372623427_4671P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBUdCSQwdmEQWDXROgAQL5lBAAjtbkNdBAVuKWbG0wP6Nskb2L85CBvY5G
zCmv7o7Fyb4ZyWufDl6cLVi26PsQnv2nZFxy3k1Ivh/0l5s+YPngjKplgUMl+mXD
0X0zuwDx4J2868/rqqIVh91aKMo/wYMAg8Bf6NUAI4hpdOAaj6jo2kfDWzKA/FsR
h24/cPL40aHzwUwxW2QAB0HEp02jxEXxExmTpjWrCGT5fVgM+AXaTTuPDga5KzRp
b5kgsbIg5pqR6sR4jrNKxWiyU+uWIL0aNwD/duI85v7wk/oWDFTe7YF21BpX787H
OjySotC5I+Zj3fxQb773fB4iexhuPz1HcnCo3PJqpRam4JDnjNhGe+NeO+AiKn+d
zMyUBzvb4ruuKzk/zeiEysFlGvz6mhPjUqpRqL4DilqDGvBs5qE/MTtseNh0jEJa
0vou3m7GfxoKob3LSYb+hQugvJOVbJgS+jyVD5YewVJOeyvcCVaGFVe/snzmHYy/
Wu+C4/cVQYKMjv2fem5Y7h2ZFvWEaylqeDKwwtrDzXs3CX08YdbV90gXRF5TkPmK
8nKV+n2qUiG1qvDN3lwfWyxRBVEADEbkRfXHlsQcsx2A8zugbc+Rh/mFyW5zTIS7
l880+R8CKQIUaJMuQswoMd/cy2n9L26n2ZdMSa7Ef36NnMv3R/hLFEUwSaLHkBIT
Xh1Dw+ee9m8=
=8fz0
-----END PGP SIGNATURE-----

--==_Exmh_1372623427_4671P--
