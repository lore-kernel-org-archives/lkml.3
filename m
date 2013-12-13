Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752529Ab3LMJwY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 04:52:24 -0500
Received: from mout.gmx.net ([212.227.15.19]:60030 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752262Ab3LMJwW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 04:52:22 -0500
Message-ID: <52AAD8D4.2060807@gmx.de>
Date: Fri, 13 Dec 2013 10:52:20 +0100
From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: UML devel <user-mode-linux-devel@lists.sourceforge.net>,
        Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: why does index in truncate_inode_pages_range() grows so much
 ?
References: <529217CD.1000204@gmx.de> <20131203140214.GB31128@quack.suse.cz> <529E3450.9000700@gmx.de> <20131203230058.GA24037@quack.suse.cz> <20131204130639.GA31973@quack.suse.cz> <52A36389.7010103@gmx.de> <20131211202639.GE1163@quack.suse.cz>
In-Reply-To: <20131211202639.GE1163@quack.suse.cz>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:SazQRlDn0hTbo40H0rwTuPnNFqlT5AYb24vr4MRV5p1D9WeWTaH
 DjvQTuMnPh5pCCOMoe0pu6WQUwzFbX3x6jrnjjMGiDG+DMWFqnkpqlQdxHIfO4/omzGeiKb
 E3XOu0fkpDkKvDZsLUf8DjsIDVaGJykFrGMD3C6iXk/bW3Pu6len0S0pkWhWMQ5RTDW145y
 0otm6WtSeX6JM+oeDf+aw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

On 12/11/2013 09:26 PM, Jan Kara wrote:
> Thanks! So this works more or less as expected - trinity issued a
> read at absurdly high offset so we created pagecache page a that
> offset and tried to read data into it. That failed. We left the
> page in the pagecache where it was for reclaim to reclaim it when
> free pages are needed. Everything works as designed except we could
> possibly argue that it's not the most efficient way to use
> pages...
> 
> Patch 'vfs: fix a bug when we do some dio reads with append dio
> writes' (http://www.spinics.net/lists/linux-fsdevel/msg70899.html)
> should actually change the situation and we won't unnecessarily
> cache these pages.
> 
confirmed - applied to latest git tree of Linus I helps.

- -- 
MfG/Sincerely
Toralf Förster
pgp finger print:1A37 6F99 4A9D 026F 13E2 4DCF C4EA CDDE 0076 E94E
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlKq2NQACgkQxOrN3gB26U5LJgD/f0jU9NXrgVw7UthV613FrCMX
zUTRpvoNy8oKgpyiejwA/R2oVVwYXhKTcs0XHstQ9w3mjBcjp9t2ub2GAWa8hDnb
=KAh4
-----END PGP SIGNATURE-----
