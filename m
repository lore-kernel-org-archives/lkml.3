Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522AbaE3DYU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 23:24:20 -0400
Received: from mga14.intel.com ([192.55.52.115]:32114 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752421AbaE3DYT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 23:24:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="asc'?scan'208";a="349799276"
Date: Thu, 29 May 2014 22:56:32 -0400
From: "Chen, Gong" <gong.chen@linux.intel.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Borislav Petkov <bp@alien8.de>, tony.luck@intel.com, m.chehab@samsung.com,
        linux-acpi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/7 v6] trace, RAS: Add eMCA trace event interface
Message-ID: <20140530025632.GA16788@gchen.bj.intel.com>
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
 <20140529074345.GA23484@gchen.bj.intel.com>
 <20140529091251.70178abe@gandalf.local.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BOKacYhQ+x31HxR3"
Content-Disposition: inline
In-Reply-To: <20140529091251.70178abe@gandalf.local.home>
X-PGP-Key-ID: A43922C7
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BOKacYhQ+x31HxR3
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 29, 2014 at 09:12:51AM -0400, Steven Rostedt wrote:
> What do you think gets recorded in the ring buffer? The pointer to the
> string? No! You copy the entire string into the ring buffer, with
> markers and all. How big is that string? 60 chars? 80? I see you
> recording meta data there too:
I'm not the expert of trace. If I am wrong please fix me. So it looks
like all trace data shhould be pushed into the ring buffer as raw
material and when it is needed to be printed via TP_printk, these
raw data will be expanded(unzip them as you told) into another
temp buffer, maybe kernel printk buffer directly.

[...]
> > #define show_dimm_location(type)                                \
> >         __print_symbolic(type,                                  \
> >         { CPER_MEM_VALID_NODE,          "node" },               \
> >         { CPER_MEM_VALID_CARD,          "card" },               \
> >         { CPER_MEM_VALID_MODULE,        "module" },             \
> >         ...
> >=20
>=20
> I'm not sure you could use that, as you save an array of data. The
> print_symbolic() wont work with an array.
Just FWIW, call it again and again. But it looks too awkward I will
use other style.

>=20
> You can still use the same code for both the tracepoint (perf and
> ftrace) and for dmesg. You need to write a packed array that is
> returned as well as a way to convert that array into a human readable
> string for later processing. The dmesg version would just have them
> both together where as the tracepoint records the packed version on the
> ring buffer and the TP_printk() will use the extraction.
>=20
> That is, dmesg has the compress and extraction in one place where the
> tracepoint has them in two different places.
>=20
> Understand?
Yes, I feel the same way. Zip/unzip is unavoidable.

--BOKacYhQ+x31HxR3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTh/NgAAoJEI01n1+kOSLHBgEP/03l+cSTiUrtyZbnCA0Zm3Xo
ZxRjhzuDpB35j8uny8TnXgDUsfYFConwyk7n4/GCejzWSN16jQ1HgxC4pgP3HFY+
bdBWKuaSCo03Lg/zc1Y6JoOcBAmYdZbGzbQmTqrGJ56cOoS/KSP7gbyND1bt3Gp7
8aY9qfo2fxmtr/OPN5G/px4hCP46UZMWWcZGW7NwoMbjetGWnS0whF8jO6XfIPH+
bxCwMEkmMxkuaNdlOL272tenw9zRj0mTKaVuc4MdACoUMHz1KPuLyEIcyaKItg9F
i+flHBquixyKtiad97YNA9NA4ECmL1XpmwEl0ZLp3rqh+5cp/ERDd3+s4B0mkJTI
VQF5vF4v5RFWKrqp0mn9Y6kYT/yPM9xbHfy2LE8Jt81EdxdzcAjH/8LHa03YfWs5
Iul6C9quzMoj8J3MqSla6JGQVnRyPbSS/lWtK5r+ZeUUh5UO9xWfRQgpOGrwquMe
LdYfOWLM6wjvVhc5WpnVs7uHvhI7mycyHj0GFXsH0zzXaTbObQNwnwAmMrysXJ68
ly+7ozWuPrv9cTWcZCTAw7E+fEWHI5gRbjuYw94RK8Q/4cXNSwHI3tYek/5x3C9S
9GmELUvKIQzKW6eE+KXckK+kGFS3oEEcBftWMFrxDJCGg6e7CiNqc27SwXoIw134
Q/XuKE+mpx4u5AKFPNEG
=+rFN
-----END PGP SIGNATURE-----

--BOKacYhQ+x31HxR3--
