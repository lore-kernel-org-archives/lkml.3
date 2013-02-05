Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579Ab3BECOW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 21:14:22 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56744 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753114Ab3BECOV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 21:14:21 -0500
Message-ID: <51106AF1.4030804@suse.com>
Date: Mon, 04 Feb 2013 21:14:09 -0500
From: Jeff Mahoney <jeffm@suse.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, Dave Kleikamp <shaggy@kernel.org>
Subject: Re: [RFC] setxattr bugs
References: <20130203043046.GR4503@ZenIV.linux.org.uk>
In-Reply-To: <20130203043046.GR4503@ZenIV.linux.org.uk>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 2/2/13 11:30 PM, Al Viro wrote:
> * JFS, since 2005: setxattr(name, "system.posix_acl_access", NULL,
> 0, 0) succeeds, creating an empty EA with "system.posix_acl_access"
> as name. Validity checks should apply _after_ if (value == NULL) {
> /* empty EA, do not remove */ value = ""; value_len = 0; } and not
> before it. * reiserfs, since 2009: setxattr(name, attr_name, NULL,
> 0, 0) is treated as removexattr(name, attr_name), not as emptying
> given xattr.
> 
> The question is, does either of those cross into "established 
> weirdness in ABI" or are they still at the "bugs to be fixed"
> stage?

Since the behavior changed once already in 2009 I'd call it a bug.
That code was in the SLES kernel for a while before then and I still
haven't seen a bug report on it.

- -Jeff

> FWIW, I'm seriously tempted to stop passing NULL as the third
> argument of ->setxattr(), essentially taking all those if (!value)
> value = ""; pieces from individual ->setxattr() instances to
> __vfs_setxattr_noperm() (all other callers of ->setxattr() never 
> pass NULL data or 0 size, so it's irrelevant for them).  Would fix 
> both jfs and reiserfs weirdness....
> 
> Objections?




- -- 
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.18 (Darwin)
Comment: GPGTools - http://gpgtools.org

iQIcBAEBAgAGBQJREGrwAAoJEB57S2MheeWyHvMP/3kpy3Y4U0KNavnPaeL12LXe
RC6vIb/dPkoSemFiZ5om26aT70M7MdXJY2ZPCwgtlNpKV6aT0NFchtwiWos2lLLN
XndvFZ4M/kQLd9yDEmlcTDZn7p4fhU2Tn7FYrhPLRmOO3zP6fnUxLozSebOnGTO/
xEwV7Qtx7D4Au37khFW/hJvsAJE2Q3NrLgueIJLiTmFvSiOourZNmriNcB73MUeb
vYx5gc/bJexS2oFWeQqD6WiL8UQXg4XEKRk4inNVrJWpLV365w45Kpf2zBlvCQwQ
W8mdHcHoityOcQJtiXvnVDurUNpFwsthrhVquVgIopovlcvOjNtcpffH8YI9khP/
yol7+57ZDuVx2TY5DrEOa+TOTUrg5ghqagSSmOVDsOVeMngpdFNs8351QcX0IWBn
Xt8/eq46g/R7EHI3I1eYJHlMIie0hP1GDc66OP94hcKEWaHbPeKwkSTOlqYH++4h
ncSJcxHXWLUTGuV4b61whYTlJ2vBWwEvIteVaQmmXKaOTr41lajZBCWZDeUlzna8
XyJHE5FrcKDLzTNP1R7UNEj863fN0OUma1AKaT/6jNYMqFXOk39emTgZL5QfxP9X
uLWG1OVDf87uw5nYOKubNQiORpxl8iSIsQWvZeF9SvvmFA/JzpgZgtLlNqYa78Yv
oEq501m9BSEWVSGKxHcu
=G2cU
-----END PGP SIGNATURE-----
