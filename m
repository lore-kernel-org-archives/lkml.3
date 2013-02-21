Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277Ab3BUT66 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 14:58:58 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55240 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752068Ab3BUT64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 14:58:56 -0500
Date: Thu, 21 Feb 2013 19:58:54 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Shawn Joo <sjoo@nvidia.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: core: use regulator name for sysfs
Message-ID: <20130221195854.GB16870@opensource.wolfsonmicro.com>
References: <1361433237-3217-1-git-send-email-sjoo@nvidia.com>
 <51267454.5040607@wwwdotorg.org>
 <20130221194302.GA16870@opensource.wolfsonmicro.com>
 <51267A46.8030105@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bCsyhTFzCvuiizWE"
Content-Disposition: inline
In-Reply-To: <51267A46.8030105@wwwdotorg.org>
X-Cookie: Caution: Keep out of reach of children.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bCsyhTFzCvuiizWE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 21, 2013 at 12:49:26PM -0700, Stephen Warren wrote:
> On 02/21/2013 12:43 PM, Mark Brown wrote:

> > It's certainly insane to change this based on the driver and given
> > that sysfs is supposed to be an ABI it's questionable if we should
> > do it at all.  We certainly can't use the descriptor name as that's
> > very likely to clash if you have more than one PMIC.  Taking a
> > glance through sysfs on my system what we're doing at the minute is
> > pretty idiomatic, sysfs isn't really intended for humans but rather
> > for machines to prettify.

> Does the ABI describe just the layout of the sysfs filesystem, or also
> the names of instances? Certainly the list of names of regulators

Turns out we didn't bother documenting the directory naming.

> won't be in any ABI documentation. That said, I suppose for existing
> platforms it'd probably be legitimate for someone to have looked there
> and seen the names and assumed they would never change on that
> particular platform, so changing them would break an implicit ABI.

Indeed, plus the information is all there.  Like I say the current
pattern seems idiomatic for sysfs but really the issue with the current
patch is the per driver thing which just doesn't make sense.

> >> Another place a similar change might be useful is debugfs.

> > debugfs already uses more human readable names, it uses the supply
> > name (which is what we should be using if we were going to do
> > anything as it really ought to be unique already).

> Oh so it does. Was this a recent change? I could have sworn I saw lots
> of regulator.n there, but perhaps I'm remembering sysfs.

It's always been the same.

--bCsyhTFzCvuiizWE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRJnx2AAoJELSic+t+oim991wP/1g6v6hnSuxrJ6AxDi7DhPni
NGXECOgWsBmIJmHLQq+IuVkvNclhLoIL2JGqPcvn4jTL57z9zMvY5hTAtvTOBim5
kXe7/g1cbAWHiKheGlB2O7mkVMkDgTBlMOwUUrLiAvX8okwGmpfDYGHcZ0CoTfhr
Wwmc7wRS75ZfkJUcGOdNEKIb61XI3niv7w45qktbZ7feO6A8xFeKNChP80U3eQog
apSPBjvZ1Q/fHtrZ0FVd4JPjAF9ojVb8J5UtTpKCMFl1wraWnCcUDzS64Cq1t4jn
MZC7UL0IoIw2lcDmhXR31pKSMqylayYuwI1HLfOfhshvkICNbLCKMUbJ+URnN3L1
h4oohKGdn7JBSFWAjEXD4zBPPMBU3XL8IAlN5CPAf1DAn6p/wJ3mqy4d8w+1FP3q
ysEFYMoCkyEFsnxU1TD6vx0UOmv7BSYfeUAGX6o2kofSIKYL03V4T482Xg3xyUwv
VdKLc/5VZ+6KXvGTl7iujVhL7oK6Pv72UuEfIKudGOAxpa6jERnt2zBunbqapa8T
+ZjnZD2cG/fNz77TtuGj69zQPdqAB/shRVPd9TpbmmeVhVdLPYTwetdSoLQywLc+
bA5ZBhwCTT/eeC6Px6FyRez002yoWVN45HiDXV0L+Fzflio0DnIVKduHduUUFh4o
kxLYYBEA6q+Ks3ty7wit
=syoU
-----END PGP SIGNATURE-----

--bCsyhTFzCvuiizWE--
