Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932780AbaICNcF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 09:32:05 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:48125 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932321AbaICNcC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 09:32:02 -0400
Date: Wed, 3 Sep 2014 14:31:46 +0100
From: Mark Brown <broonie@kernel.org>
To: Daniel Vetter <daniel.vetter@ffwll.ch>, <intel-gfx@lists.freedesktop.org>,
        <dri-devel@lists.freedesktop.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <20140903143146.88d4b3ada1e3098989139540@kernel.org>
X-Mailer: Sylpheed 3.5.0beta1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__3_Sep_2014_14_31_46_+0100_jUvYtdnv1WHmpfT5"
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@kernel.org
Subject: linux-next: manual merge of the drm-intel tree with the  tree
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__3_Sep_2014_14_31_46_+0100_jUvYtdnv1WHmpfT5
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the drm-intel tree got a conflict which I'm not=
 really sure of and commit b47d1189da119e ("drm/i915: Use dev_priv as first=
 argument of for_each_pipe()") from the drm-intel tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

@@ -3923,7 +3942,9 @@ static void valleyview_irq_uninstall(struct drm_devic=
e *dev)
=20
 	I915_WRITE(VLV_MASTER_IER, 0);
=20
-	for_each_pipe(pipe)
+	intel_hpd_irq_uninstall(dev_priv);
+
+	for_each_pipe(dev_priv, pipe)
 		I915_WRITE(PIPESTAT(pipe), 0xffff);
=20
 	I915_WRITE(HWSTAM, 0xffffffff);

--Signature=_Wed__3_Sep_2014_14_31_46_+0100_jUvYtdnv1WHmpfT5
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUBxhCAAoJELSic+t+oim9FA0P/1+354RULGdrMhEf9syQks4A
J6POATmnC1l4SgVlyyu5DKTYjefVUkt2B6SLgFhSi0E33n3Co6gblnoiyRftT5Jz
fLTcjRH+7CL+KUx9uUnq86DzWO0eMExStUB1AKDSDcpLeoyvlz3U9Si94EAR93ye
vdAwiXVh8wpPwl7Gqap7UmrCoVj0IfxVvY9IeA6SpCl4WpMH7fms6nq6HnWXPf99
mrtfT47FTY32AN/hx+bdx8vD5b9sVzNASH5rmye8WiWf0reIxjYxHk4vnqe5qXLM
RmPRul0FzAzW7U3y+wfz3yF+msyBDPoNMPf7pNgS7vbdXDNPF7Tt5+lPQ3PKzmxe
XRKJEilZJUpATuXyDg+958U2ku1ekqXgStmkpqQtLtz5KwRBVLi0Ljc4ctBTiV89
o9dgehRjwMThC889ZvZhqq7UHtybLO6e8loKg+fv1JhmYh5+MDNsVW9B4VNIpzEs
2Sqr3tRDdvsPgC1bKhcYLrvQMHsNyEW61/eYhiEjEOo5TvVbCSyGa0jE8qwSSwuo
ezNjvDdEls27BSskq6ZArU5U5jrFKdbKQKMUeYV5gMIzcuLIu063e72O9JgxFKks
pGwvlhbdQ/eWiad29bvfsQGkmOC7xvpVgoR16kKCyQznB/mZIjA+SzcPRIxKrXmR
nMlUATv2MlqsTFom47SC
=J4ZH
-----END PGP SIGNATURE-----

--Signature=_Wed__3_Sep_2014_14_31_46_+0100_jUvYtdnv1WHmpfT5--
