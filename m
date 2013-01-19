Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752232Ab3ASSDL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2013 13:03:11 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:56389 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088Ab3ASSDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2013 13:03:10 -0500
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.4-dev
To: Hugo Mills <hugo-lkml@carfax.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: btrfs userspace question - where's the utility to dump/restore?
In-Reply-To: Your message of "Thu, 17 Jan 2013 22:18:19 +0000."
             <20130117221819.GA5406@carfax.org.uk>
From: Valdis.Kletnieks@vt.edu
References: <6196.1358453135@turing-police.cc.vt.edu>
            <20130117221819.GA5406@carfax.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1358618550_2156P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sat, 19 Jan 2013 13:02:30 -0500
Message-ID: <8544.1358618550@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=zidane.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A010205.50FADFB7.0117,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2011-07-25 19:15:43,
	dmn=2011-05-27 18:58:46,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1358618550_2156P
Content-Type: text/plain; charset=us-ascii

On Thu, 17 Jan 2013 22:18:19 +0000, Hugo Mills said:

> On Thu, Jan 17, 2013 at 03:05:35PM -0500, Valdis Kletnieks wrote:
> > So I'm looking at playing with btrfs, and I start looking at the
> > userspace pieces I'll need.  What I can't find is an equivalent
> > of the ext[34] "dump/restore" package to dump data to an external
> > backup device. Is 'tar cf --acls --selinux --xattrs /external/fs.dump'
> > as good as it gets, or is something else recommended?
>
>    tar doesn't handle reflinks(+), so the above won't quite give you a
> complete duplicate. In the btrfs tool, there's send/receive, which
> should(*) be sufficient to deal with reflinks.

So I decided to try it out on the filesystem that I stash all my music
(mostly because I can survive without that filesystem if I trash it, and
I have a known good backup).

Apparently, send/receive isn't in the manpage, which is why I didn't
see it.  Fortunately, there's --help

[~] btrfs send --help
usage: btrfs send <command> <args>

    btrfs send [-v] [-i <subvol>] [-p <parent>] <subvol>
        Send the subvolume to stdout.

[~] btrfs send -v /mp3 > /disk2/backups/mp3.btrfs
ERROR: /mp3 is not read-only.
[~] mount -o remount,ro /mp3
[~] btrfs send -v /mp3 >| /disk2/backups/mp3.btrfs
ERROR: /mp3 is not read-only.

Bah. Obviously this isn't anywhere near as easy as it is for ext4.

/me wanders off to find more caffeine...

--==_Exmh_1358618550_2156P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBUPrftgdmEQWDXROgAQIBaBAAngFD1ot3xSKDVyVLTmAUT4ZAUEeHhxSH
ughBr8bs0Y3BQf4rMNJl25EFGcjXTpoP4nrXl2vHpMvgOvC46Ap1mJrkqHcGFSd2
Gml95bOftbE2mdTHIbVWbwxDAWzUYBrsaWQVy8IbPpYkz+Kf9XJE0KaRCBRN7Rso
vw3mZaS4H0b0aXpcutYRoIjf5tH16UctiAaU/uoFNkyZ/54GJapRZIN7fzgM0up/
YEt02QtSxQirR1gmfhYadrNlg7uz6r/va63ru6XRK0Y6kkDvXTv25oOxjqm9wi20
dPEEqbakluzw6UUa866yF9wYTkQTtmcu9KPJ6AW373oKoqf6bL5AVlXNqw+D+mE1
0BBtlRfQqT70kgpbhAf20ua9RaoG7QPmG/6tsxe379uCRBbYd71TTHP/L2V6ZFGy
az8qyZGenEs01rply4BZmgtGqhrthSgFxpJc+F2gUKebXHXBIVYGLkBM2xbm9rtt
wY8JXpiGopVzIMhk8XRk+hg5BV5niLxtQFc0+dg1zG5XYSBvd7xoETAd5DE5SMne
6hZRl/SdpLo00qctvy5KoV2P+LZe3LC3un70JQbsRp+2blgS/jw7gKy6tVrofcYE
hO3xi8585RCUenbuIfb5LqJPeqWc89ezrCPthfAIDzUMA6NUx0RZ9psq1Y8vZkiI
v4eyv33FbGw=
=AxLq
-----END PGP SIGNATURE-----

--==_Exmh_1358618550_2156P--

