Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758516AbaDKOBz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 10:01:55 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:51062 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752415AbaDKOBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 10:01:53 -0400
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.5+dev
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jason Low <jason.low2@hp.com>, "Kirill A. Shutemov" <kirill@shutemov.name>,
        "Michael L. Semon" <mlsemon35@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: 3.14.0+/x86: lockdep and mutexes not getting along
In-Reply-To: Your message of "Thu, 10 Apr 2014 16:15:59 +0200."
             <20140410141559.GE13658@twins.programming.kicks-ass.net>
From: Valdis.Kletnieks@vt.edu
References: <alpine.LNX.2.11.1404060059020.8208@bpserver.ds> <20140409121940.GA12890@node.dhcp.inet.fi> <1397108579.2586.15.camel@j-VirtualBox> <20140410091824.GL10526@twins.programming.kicks-ass.net>
            <20140410141559.GE13658@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1397224782_3165P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 11 Apr 2014 09:59:42 -0400
Message-ID: <3615.1397224782@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1397224782_3165P
Content-Type: text/plain; charset=us-ascii

On Thu, 10 Apr 2014 16:15:59 +0200, Peter Zijlstra said:
> On Thu, Apr 10, 2014 at 11:18:24AM +0200, Peter Zijlstra wrote:
> > So I managed to reproduce, and the below makes it go away. I just don't
> > understand why though. will stare more.
>
> /me kicks himself.. bloody obvious fail there :-)
>
> Not unlocking the lock after a lockdep trigger will make things get
> stuck real fast :-)
>
> ---
>  kernel/locking/mutex-debug.c | 19 +++++++++----------
>  1 file changed, 9 insertions(+), 10 deletions(-)

Confirming that this makes next-20140409 boot without hanging for me.
Feel free to stick a Tested-by: on it. ;)

--==_Exmh_1397224782_3165P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBU0f1TgdmEQWDXROgAQJrWQ/+LtUfovTVLCNbRP7GpidlfJbn33IMVBdZ
NyzVNDI9HfT/yIixOm/nJxBnL1YkKMq3INSzujqN1o0BearOkigxAUDImmA2d5ef
yGkH8fkW+tUHU0Ydf30ZYsWyXu7xy3SnGUsaibxyBzJ6uaEmm5hhjd38ZmRCz4sm
zATiChMsllReunfIWbmzpt6MXjA+bKjzVBTxrBR8OI2nHW1FcguaXQ9zJ2k/rQJV
4z07VmEsJ1//0GuC2dh51fXSMVz/MDed9eYMNMD5DTfsuHmeouS17zLJpNEN1Asv
GncOud0JiyRnm5WPKwwkMHCnC/tnu8ZKY/W3B/7GGxYoemVR1cG73Cxl6Mk/sOy2
tVC8STxpTHNAzGjY87av8K95Kf3DD1UFHoQNvTS7jSmzqoWc5m3RRdk+oA+gkjJf
qSqOUDnvfRMZ2hZmLW1zgkzQum5Fsky1BOt04GdYT6X2INMxUxvqETeg9KdF75Ek
AqfKQULy4qfTWpjPA/ZadGhvQICo8eT6Ao46zhocDKKOg+fZEkCVp+dlwFhTdo6p
4HiIeaJgrX8F2TYkf9lmpxySYL7HSnHGUqsEK4r18zIHPuuON2s/uNe6rk63PzF7
htcTW15em77YvZO9hFOwZpKpZQ4j45IJHlv7se0+2pwtCI8MsxSuVFXN+t6coUF/
MWbdFpV4Yig=
=2zaP
-----END PGP SIGNATURE-----

--==_Exmh_1397224782_3165P--
