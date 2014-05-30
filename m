Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932906AbaE3JuW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 05:50:22 -0400
Received: from mga02.intel.com ([134.134.136.20]:40711 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932685AbaE3JuU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 05:50:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,940,1392192000"; 
   d="asc'?scan'208";a="548835410"
Date: Fri, 30 May 2014 05:22:32 -0400
From: "Chen, Gong" <gong.chen@linux.intel.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Borislav Petkov <bp@alien8.de>, tony.luck@intel.com, m.chehab@samsung.com,
        linux-acpi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/7 v6] trace, RAS: Add eMCA trace event interface
Message-ID: <20140530092232.GA13495@gchen.bj.intel.com>
Mail-Followup-To: Steven Rostedt <rostedt@goodmis.org>,
	Borislav Petkov <bp@alien8.de>, tony.luck@intel.com,
	m.chehab@samsung.com, linux-acpi@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>
References: <1400142646-10127-1-git-send-email-gong.chen@linux.intel.com>
 <1401247938-22125-1-git-send-email-gong.chen@linux.intel.com>
 <1401247938-22125-2-git-send-email-gong.chen@linux.intel.com>
 <20140528112832.5f83c66b@gandalf.local.home>
 <20140528163452.GF17196@pd.tnic>
 <20140528125625.6f6dcf7f@gandalf.local.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mYCpIKhGyMATD0i+"
Content-Disposition: inline
In-Reply-To: <20140528125625.6f6dcf7f@gandalf.local.home>
X-PGP-Key-ID: A43922C7
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mYCpIKhGyMATD0i+
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 28, 2014 at 12:56:25PM -0400, Steven Rostedt wrote:
> Instead of making that a huge string, what about a dynamic array of
> special structures?
>=20
>=20
> struct __attribute__((__packed__)) cper_sec_mem_rec {
> 	short type;
> 	int data;
> };
>=20
>=20
HI, Steven & Boris

We have two big chunk string. One for memory error location, the other
for DIMM error location. Since DIMM error location depends on some
other conditions, how about just converting memory error location
to a compact mode but leaving DIMM error location alone?=20

For memory error location, I will utilize type offset to save one
more byte, furthermore, I want to drop requestor_id, responder_id
and target_id. 1) They are very rare (I've never seen them by now)
2) They are u64 but not u16. So to keep whole struct clean I want
to use following struct. We can extend it later when necessary.

struct __attribute__((__packed__)) cper_sec_mem_rec {
	u8 type;
	u16 data;
};

So whole struct is just 3 bytes. Even if all fields are valid, we
have 3 * 9 =3D 27 bytes in total for a record in the ring buffer.

Make sense?

--mYCpIKhGyMATD0i+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTiE3YAAoJEI01n1+kOSLH6XkP/3xmspuz1m4VaEux5kkIiiP3
TD7xiE7GCFDOK50amJ61VGyI8HvMwG6zEHUj6ntPv070SddgCK6P36QF0OmbHiSa
FwsZanT/ie/O7nqnvzLwB+XH48nf+k4mbR4e3hfCsx8+2UfEEVePpHlnETMWiU80
h7Huy2ECSNIk7rJpc/bJusEB7vVNSa9gIUIUSULl3q7ulfdmraKd7TFsKOnR8KgA
FEOuCs8qjrYiiBlzwPGyd2UmXLrQrArKknVvhkAxBDA9Ng2DVSgLCYVsUhoJreqy
F3YdtB3KT4kWJPuR2sur7U3W/Q3pZ9ivdvhTsxCXOK5eXinlYpu7eOuv+NhB/W+/
8TSFAmHX8D/jKf9fi/xDJnCdHY5q8bPK3uBrvm11F6wILxKZuCQywlvyVLsNqPZj
qrK5BilDzPsnR4LvYi2Zq3p7p9+1HJLUJFyOaNTTasfbkIcXHYljfhN3b1EkZBqk
n2OWj8oWM83toC2nakMUMZFqNOzO5x2WQTCUJyPqyYjQOthhmP+QTz01mPcLWC5/
D0ZuiTXfulR1mkwz4WOoCYm+myBNoLpRl8uyYb4L1KJ7GBWudTTaqMgJH3IyYDOg
0s6Zm4qkPWgxHDFkETw72fOP0nKN073NBrOClb57tCzGk8w0L4VZk+yQdsUMXVIz
jPE4rcUjz9siPfFWXIcO
=DaMg
-----END PGP SIGNATURE-----

--mYCpIKhGyMATD0i+--
