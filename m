Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750763AbaEAEDp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 00:03:45 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:47412 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706AbaEAEDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 00:03:44 -0400
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.5+dev
To: Jan Kara <jack@suse.cz>
Cc: Fabio Estevam <festevam@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Warning from kernel/printk/printk.c in linux-next
In-Reply-To: Your message of "Tue, 29 Apr 2014 23:11:28 +0200."
             <20140429211128.GF29634@quack.suse.cz>
From: Valdis.Kletnieks@vt.edu
References: <CAOMZO5Bb3P20S15Hi8fKO1r8-JOQa3j8GekNBiABVb9XXN0hZw@mail.gmail.com>
            <20140429211128.GF29634@quack.suse.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1398916856_2015P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 01 May 2014 00:00:56 -0400
Message-ID: <3758.1398916856@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1398916856_2015P
Content-Type: text/plain; charset=us-ascii

On Tue, 29 Apr 2014 23:11:28 +0200, Jan Kara said:


> > 5dc90cb49691755faa ("printk: enable interrupts before calling
> > console_trylock_for_printk()") I get the following warning:
>   Thanks for report. Attached patch should fix the problem I hope.


> Content-Disposition: attachment; filename="0001-printk-Fix-lockdep-instrument
ation-of-console_sem.patch"
>
> From 02e7e0901329f6b9ac3392be41a72b3cee4ac995 Mon Sep 17 00:00:00 2001
> From: Jan Kara <jack@suse.cz>
> Date: Mon, 28 Apr 2014 21:09:26 +0200
> Subject: [PATCH] printk: Fix lockdep instrumentation of console_sem

I was seeing this same exact traceback on next-20140429.  Can confirm
the message is gone after applying this patch.  If you haven't pushed it
upstream, feel free to add:

Tested-By: Valdis Kletnieks <valdis.kletnieks@vt.edu>

--==_Exmh_1398916856_2015P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBU2HG+AdmEQWDXROgAQJn3g/9EzP6oK00CPXUOdLgizXP/GeZshXMHpV9
sDnqzb6Iu6/78mLO+JguI6GT/VgpjyGWGIo9/oGWFCCzvxAQ+t7Vuc/JAsUd765c
gBvc6eXYw5+lLfrRxvuPhKjzqZBObQDD4MgcP3oPsufclrRu8rM/9eepsdP79KBJ
CDIhcOA9O+/gp56zx/bZWXwaiA7sjVOcouNFffNYQ7Lrk7d4t6XzY+uXg0dOxoIc
qKz/5/WB4FL1QHVqInOu4ZjNgaSCifMBY8Qmv7BTo2c4S9D1NVKHbVbfSRuU6ggQ
WRkZmoxgbiO4UBML8WxfwFcLCMAyr3nSyIBVFS+AkYKD28qyaA2vhQVqcOc38bUR
QJg9rQRxm8Z9zIFNxI2kN62guwuTdWn79quwn5CHnLYHP65LlnqnBVApD17CVZi6
HRaQpa9Kil/5LFbGCxe3BCvEbbsDCnPnMk7AC8elQlGUPpOSXl4S+K4Od9KK+mq1
OBfL9NrvQxZsu0Q+dl02OX18dDtpOTzSjPgfxTeKDHDRXIoxT+HPSa4YhKlVYG9q
K/DaksUb8f3C2VfQ8q18UR8yDew1cU1c8N4312Qt49MGXJiq1XQJMn53xPQd2d6O
xhyoCKX6Uz2UJ5eEv1ORbSuZsLGaz+5tMFsJPzAsa8ebhfapcZUs6f4Usn2YtxDO
73pfPoCxbQY=
=0poZ
-----END PGP SIGNATURE-----

--==_Exmh_1398916856_2015P--
