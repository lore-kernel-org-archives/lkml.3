Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754385Ab3JYReI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 13:34:08 -0400
Received: from mail.crc.id.au ([203.56.246.92]:36832 "EHLO mail.crc.id.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753123Ab3JYReH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 13:34:07 -0400
X-Greylist: delayed 536 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 Oct 2013 13:34:06 EDT
Message-ID: <526AA96C.8040600@crc.id.au>
Date: Sat, 26 Oct 2013 04:25:00 +1100
From: Steven Haigh <netwiz@crc.id.au>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: aac_write: aac_fib_send failed with status: -12
X-Enigmail-Version: 1.6
OpenPGP: id=7A7D31DC
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="7mEpD3rE0DMSxn4OM59cHJiC0Jseifqg9"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--7mEpD3rE0DMSxn4OM59cHJiC0Jseifqg9
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi all,

Firstly, please CC me as I'm not subscribed to this list.

I seem to be getting some random filesystem corruption on an IBM server
that I use as a Xen Dom0.

*** Specs ***
Vendor: IBM
Version: -[GGE149AUS-1.19]-
Product Name: IBM System x3650 -[7979CBM]-
AAC0: kernel 5.2-0[17003] Jul 25 2011
AAC0: monitor 5.2-0[17003]
AAC0: bios 5.2-0[17003]
AAC0: serial 5AB49E0
scsi0 : ServeRAID
scsi 0:0:0:0: Direct-Access     ServeRA  Dom0_RAID6       V1.0 PQ: 0 ANSI=
: 2
scsi 0:1:0:0: Direct-Access     IBM-ESXS MAY2073RC        T107 PQ: 0 ANSI=
: 5
scsi 0:1:1:0: Direct-Access     IBM-ESXS MAY2073RC        T107 PQ: 0 ANSI=
: 5
scsi 0:1:2:0: Direct-Access     IBM-ESXS MBC2073RC        SC06 PQ: 0 ANSI=
: 5
scsi 0:1:3:0: Direct-Access     IBM-ESXS ST973402SS       B52B PQ: 0 ANSI=
: 5
scsi 0:1:4:0: Direct-Access     IBM-ESXS ST973402SS       B52B PQ: 0 ANSI=
: 5
scsi 0:1:5:0: Direct-Access     IBM-ESXS ST973402SS       B52B PQ: 0 ANSI=
: 5
scsi 0:1:6:0: Direct-Access     IBM-ESXS ST973402SS       B52B PQ: 0 ANSI=
: 5
scsi 0:1:7:0: Direct-Access     IBM-ESXS ST973402SS       B52B PQ: 0 ANSI=
: 5
scsi 0:3:0:0: Enclosure         IBM-ESXS VSC7160          1.07 PQ: 0 ANSI=
: 3

I'm currently running kernel 3.11.4 and before the filesystem corruption
seems to happen, I get a load of these:
aac_write: aac_fib_send failed with status: -12

While this is going on, random things seem to fail. Eventually, I'll
reboot the system and lots of tools will segfault - tracing it back
leads to libraries that seem to have been corrupted.

I can boot the system from rescue media, reinstall all the corrupted
libraries / binaries and the system runs fine again for another few
months before it happens again.

arcconf shows:
# arcconf getconfig 1
Controllers found: 1
----------------------------------------------------------------------
Controller information
----------------------------------------------------------------------
   Controller Status                        : Okay
   Channel description                      : SAS/SATA
   Controller Model                         : IBM ServeRAID 8k
   Controller Serial Number                 : 5AB49E0
   Physical Slot                            : 0
   Installed memory                         : 256 MB
   Copyback                                 : Disabled
   Data scrubbing                           : Enabled
   Defunct disk drive count                 : 0
   Logical drives/Offline/Critical          : 1/0/0
   --------------------------------------------------------
   Controller Version Information
   --------------------------------------------------------
   BIOS                                     : 5.2-0 (17003)
   Firmware                                 : 5.2-0 (17003)
   Driver                                   : 1.2-0 (30200)
   Boot Flash                               : 5.1-0 (17002)
   --------------------------------------------------------
   Controller Battery Information
   --------------------------------------------------------
   Status                                   : Okay
   Over temperature                         : No
   Capacity remaining                       : 100 percent
   Time remaining (at current draw)         : 3 days, 20 hours, 56 minute=
s
   --------------------------------------------------------
   Controller Vital Product Data
   --------------------------------------------------------
   VPD Assigned#                            : 39R8875
   EC Version#                              : J85096
   Controller FRU#                          : 25R8076
   Battery FRU#                             : 25R8088

----------------------------------------------------------------------
Logical drive information
----------------------------------------------------------------------
Logical drive number 1
   Logical drive name                       : Dom0_RAID6
   RAID level                               : 6
   Status of logical drive                  : Okay
   Size                                     : 419400 MB
   Read-cache mode                          : Enabled
   Write-cache mode                         : Enabled (write-back)
   Write-cache setting                      : Enabled (write-back)
   Partitioned                              : Yes
   Number of segments                       : 8
   Stripe-unit size                         : 256 KB
   Stripe order (Channel,Device)            : 0,0 0,1 0,2 0,3 0,4 0,5
0,6 0,7
   Defunct segments                         : No
   Defunct stripes                          : No

Does anyone have any thoughts on this?

--=20
Steven Haigh

Email: netwiz@crc.id.au
Web: https://www.crc.id.au
Phone: (03) 9001 6090 - 0412 935 897
Fax: (03) 8338 0299


--7mEpD3rE0DMSxn4OM59cHJiC0Jseifqg9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (MingW32)

iQIcBAEBAgAGBQJSaql4AAoJEEGvNdV6fTHcRrcP/0PVHuuGCM3rGOWxNSO1RaMY
TCorGDtGPxvVyYfTS5lQIrkZPX08gO6K++OhkM26GqXdyXhJGbt4vRKjaLPYxpSd
ZYIz3Cn8laZ97IO1RlJDiGindv+xXTPmN1OH5Lam7ewS94pf0srrw90RyQj8uf8F
wNRa+KYm794ugk6lBSGoURdoGOPYsM2/oZXjSv6rHL8kiMwE+O1tMoCsO7CBw+1K
Mabi5A1nkf6iSBTNGVixEFxpFOk+JvcBip4Xh5GmtNGIGp8hZOUBeZRXtZC//igE
Hk0jmbdBjEqVesaDpZllZpbk663qUSmGDvi28QL9m/aB0Yv5ZetMqnByk25QhzDN
oeqGXGTRh+6syefUp1bRAnu+tqqiUNDIbs8o3m4XUiDq2IXNG+xrTBxzq34BqBiy
Y3ebkpfXFApnF9kwXuE1wS3+pD2hPe7jzk4GyRWFx0I4R8rcKRMVqEF/YOErP76c
q40P28CA0I4jfEqvvlDB/XQXfrZZT6o5rw4aRhiw5AaCjC7UiZtZa4Jn1syfbqe4
sn1gE3O918pB7qKdx4UI7OWRIHOmKALT7SeY6/d3jX1j0Vd8VKQ0x7zAlCmMv9vG
QR0FYsyi8l2wKAGoIxLok5wumpViyvoH8MXVOinnAjjI1RL6Th5MJ5+UNdUtSYb5
olK9suoA6/sUOiVVyCK7
=40pw
-----END PGP SIGNATURE-----

--7mEpD3rE0DMSxn4OM59cHJiC0Jseifqg9--
