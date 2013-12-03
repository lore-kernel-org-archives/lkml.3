Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314Ab3LCCk7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 21:40:59 -0500
Received: from mga14.intel.com ([143.182.124.37]:60441 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752510Ab3LCCk5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 21:40:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,814,1378882800"; 
   d="asc'?scan'208";a="393553085"
Date: Mon, 2 Dec 2013 21:23:30 -0500
From: "Chen, Gong" <gong.chen@linux.intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Levente Kurusa <levex@linux.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Luck <tony.luck@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        EDAC <linux-edac@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: mcheck: call put_device on device_register failure
Message-ID: <20131203022330.GA25136@gchen.bj.intel.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Levente Kurusa <levex@linux.com>, Ingo Molnar <mingo@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Tony Luck <tony.luck@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
	x86@kernel.org, EDAC <linux-edac@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <5298F900.9000208@linux.com>
 <20131129205628.GA20144@pd.tnic>
 <52999419.7040600@linux.com>
 <20131130111214.GB4323@pd.tnic>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ibTvN161/egqYuK8"
Content-Disposition: inline
In-Reply-To: <20131130111214.GB4323@pd.tnic>
X-PGP-Key-ID: A43922C7
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ibTvN161/egqYuK8
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 30, 2013 at 12:12:14PM +0100, Borislav Petkov wrote:
> Date:	Sat, 30 Nov 2013 12:12:14 +0100
> From: Borislav Petkov <bp@alien8.de>
> To: Levente Kurusa <levex@linux.com>
> Cc: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
>  Tony Luck <tony.luck@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
>  x86@kernel.org, EDAC <linux-edac@vger.kernel.org>, LKML
>  <linux-kernel@vger.kernel.org>
> Subject: Re: [PATCH] x86: mcheck: call put_device on device_register fail=
ure
> User-Agent: Mutt/1.5.21 (2010-09-15)
>=20
> On Sat, Nov 30, 2013 at 08:30:33AM +0100, Levente Kurusa wrote:
> > No, if the call to put_device gives up the last reference to the
> > device, then device_release gets called which in turn frees the memory
> > associated with it. In this case, mce_device_release() will get
> > called, which is just a simple kfree call.
>=20
> Aah, that's that delayed freeing the driver core does, right. Now you
> made me go and look into detail:
>=20
> device_unregister
> |->put_device
>   |->kobject_put
>      |->kref_put(&kobj->kref, kobject_release)
> 	|->kref_sub(kref, 1, release)
> 	   |->release
> 	   |->kobject_release
> 	      |->kobject_cleanup
> 	         |->t->release
> 		 |->device_release
> 		    |->mce_device_release
>=20
>=20
> Ok, I see it now. :-) :-)
>=20
> Thanks, I'll take your patch as-is.
>=20

I have some concerns about it. if device_register is failed, it will
backtraces all kinds of conditions automatically, including put_device
definately. So do we really need an extra put_device when it returns
failure?

--ibTvN161/egqYuK8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSnUCiAAoJEI01n1+kOSLHdz4P/1BEmCySrRgSWQaQXuWYWc4v
m8X8S2PRVRp0SsgI2GFDDI3muqHqzblPt1lHhXqYyYqSGc/XgygZS0jusVKeK2Wn
MktOzWPDJLAYh0Vd5LMwwII8NAUFdIMdO4Xs83O6oIrgg1Qozlie/xx92jCtopZj
SXZhXYk5cTo81ng3vt7i16r+amSkp7hoHjMOI0/QJABuYkt+ZnOmf5MtCc8RAWBh
o3yIj74Hvw5knosoMG6FpGktxXEBENJPCFprC9KKgQLraVtS95HtNM/MrK8sCPzv
2LYEdF9IxOwtWVqBscr4/ywWh8yi0yJ3v8gZOIywmgfwdw4slMFnzzVmWsxW9856
zhp5UVmlnZk5BiUVb2RgQHpxlNN/Gmrey2LmEtO6Lsmfrfj30XbH8q8BG2AWCoG1
Rz4yQCczZo4H6uID/i8f7W+64OasPN8KpgdMTU7f7+e3kvx/y75narzVbX5ysP9t
e7fEPvUU/6mIgTPwMahnIS4sMaXHRE9Wm0oIYLRKFGj1bFM5GmsCIspg4YoVgJ4Z
EGVVLYmfGNf/FCiEcdi76d0mK932XcJHZAsS+xIpgegmU6pqKKXZkTqjg/RNNGKT
Y75wF8WKshe9jrEd3FQw6506uUEU08JTf+cFLXE1TuQGbJ2H+847toXBemo3OFK7
O7CvkXrGBqGaXihX8dw6
=iCwA
-----END PGP SIGNATURE-----

--ibTvN161/egqYuK8--
