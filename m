Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755857AbaFLDL2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 23:11:28 -0400
Received: from mga09.intel.com ([134.134.136.24]:44031 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752457AbaFLDL1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 23:11:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,462,1400050800"; 
   d="asc'?scan'208";a="556083925"
Date: Wed, 11 Jun 2014 22:42:52 -0400
From: "Chen, Gong" <gong.chen@linux.intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: tony.luck@intel.com, m.chehab@samsung.com, rostedt@goodmis.org,
        linux-acpi@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/7 v7] trace, RAS: Add eMCA trace event interface
Message-ID: <20140612024252.GA18991@gchen.bj.intel.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>, tony.luck@intel.com,
	m.chehab@samsung.com, rostedt@goodmis.org,
	linux-acpi@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
References: <1402475691-30045-1-git-send-email-gong.chen@linux.intel.com>
 <1402475691-30045-6-git-send-email-gong.chen@linux.intel.com>
 <20140611190214.GE14923@pd.tnic>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TB36FDmn/VVEgNH/"
Content-Disposition: inline
In-Reply-To: <20140611190214.GE14923@pd.tnic>
X-PGP-Key-ID: A43922C7
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TB36FDmn/VVEgNH/
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 11, 2014 at 09:02:15PM +0200, Borislav Petkov wrote:
> > +EXPORT_SYMBOL_GPL(cper_mem_err_pack);
>=20
> Why do we export this one and the one below? What .config warrants this?
>=20
> CONFIG_ACPI_EXTLOG=3Dm doesn't need them, AFAICT.
>=20
Right. acpi_extlog doesn't use it. They can be exported later until needed.

> > +	TP_STRUCT__entry(
> > +		__field(u32, err_seq)
> > +		__field(u8, etype)
> > +		__field(u8, sev)
> > +		__field(u64, pa)
> > +		__field(u8, pa_mask_lsb)
> > +		__array(u8, fru_id, 40)
>=20
> How did you come up with this magic number? Why isn't that sizeof(uuid_le=
)?
Cause I want to convert it into a string.

> > +		snprintf(__entry->fru_id, 39, "%pUl", fru_id);
>=20
> Yeah, I didn't catch the reasoning behind why we need to convert the FRU
> into a string and not leave it simply as u8[16]...
Fair enough. It can be compressed a little bit more.


--TB36FDmn/VVEgNH/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTmROsAAoJEI01n1+kOSLHc9gP/jD7NraoIoZOq+Bv/l69ecIt
ig2I1iSQAYgqtOTMp5J2jEY2rXqsJcDKGUnC1cvF10OUNBDH0aQ83IdzkWnQ6wPx
qqTa4XTSMsn1dfRLaE0VAn9SUUXxMoOwHKdsMaAmbWnwAI5XHJ5SBFzMNkAqbFr6
+OFj/B3zxdGahrrHplmO4MG7pExL10ZJCGsKp4BNsjHe2r58I+C9FKX6iVI6ktGw
1PtoUilV2f2+/iPG6Z3/4apxxSEPhyKuIiGfteo51FsXHeN1r8+V9S2tvge9n+37
PttCCzanVHFnDVKOeL/3w2SIOU0dVjQHpWEyokRd+vIEHeKyLa1c6c5g1ZbwzS3j
Inj9+W4XRzz5pN0/2jzeJIGBRKDsQ08UV8WZBQIquaOd54NDzMoljxBgfDxL2+cd
DUuaNgpMT5G7jJhcjTnx3MbeJq5tbO+S2jrD70zcIOvNaIHS0SlJPnVrTKaaq10M
rK41ka+bRPpvOYqeV1jWp7ANANbh1TdNzwOAu7l7R6xYCHY9iOiB1o0zw3B4L3Xs
yCcm3TmNp6vLlLlos71KmbqKVdnzDQo1IQH8wXc9FBSW5YTw50PJAXQQwb8Rp8HB
bK9q18n55Qlm6Zc9gGl6trjuUN7NF+l/AP27v7PmyjA7APv7GlpVQLPUFP20MdIV
KZ8tlDQCXy/zQnOWku+y
=1XHG
-----END PGP SIGNATURE-----

--TB36FDmn/VVEgNH/--
