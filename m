Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934214AbaFCWSn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 18:18:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49795 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933038AbaFCWSl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 18:18:41 -0400
Date: Wed, 4 Jun 2014 00:18:37 +0200
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Johannes Berg <johannes@sipsolutions.net>,
        Liraz Perelmooter <liraz.perelmooter@intel.com>
Cc: Rostislav Lisovy <lisovy@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Sojka <sojkam1@fel.cvut.cz>, s.sander@nordsys.de,
        jan-niklas.meier@volkswagen.de,
        Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>,
        wireless-regdb@lists.infradead.org, green@qti.qualcomm.com
Subject: Re: [RFC 1/4] cfg80211: Add channel flags limiting availability to
	OCB mode only
Message-ID: <20140603221837.GU26450@wotan.suse.de>
References: <1401468984-24575-1-git-send-email-rostislav.lisovy@fel.cvut.cz> <1401468984-24575-2-git-send-email-rostislav.lisovy@fel.cvut.cz> <1401825693.4157.44.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ALfTUftag+2gvp1h"
Content-Disposition: inline
In-Reply-To: <1401825693.4157.44.camel@jlt4.sipsolutions.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ALfTUftag+2gvp1h
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 03, 2014 at 10:01:33PM +0200, Johannes Berg wrote:
> On Fri, 2014-05-30 at 18:56 +0200, Rostislav Lisovy wrote:
> > IEEE 802.11p operates in its own 5.9GHz band. When there will
> > be a record for the 5.9GHz band in the regulatory daemon,
> > it must be limited to the OCB mode only -- using the newly
> > added flags.
>=20
> Is this really a *regulatory* limitation? Rather than a limitation
> elsewhere, e.g. the spec?

Our engaged and capable *real* regulatory folks in the community are:

  * Liraz Perelmooter <liraz.perelmooter@intel.com>
  * Michael Green <green@qti.qualcomm.com>

Additionally we have the wireless-regdb mailing list [0] which we should
Cc for inquiries and verification on things like this. We hope for their
participation as they are our real experts who grind away at the specs.

Rostislav, can you provide documentation references which would clarify
the stance on 802.11p and restrictions for only allowing  OCB mode?
Also your patches seem to refer to the 802.11p ammendment work to 802.11,
but it is now merged as of IEEE 802.11-2012 as per Jouni's last update to us
on the standards work [1]. As per Jouni's slides 802.11p-2010 made it as an
ammendment into 802.11-2012 and this work is rerrred to as "Wireless  Access
for the Vehicular Environent". It would be *useful* if you'd refer to the I=
EEE
802.11-2012 standard then and document as part of your patches the exact
sections and references that about Wireless Access for the Vehicular
Environment.

For reference to others this comes in as a full patch series by Rostislav
to add some form of "802.11p" support using OCB (Outside the Context of BSS)
mode. This mode of operation allows devices to send frames not connected
to a BSS. The patch in question above is for the regulatory flag that is
being proposed to be added, the full series of the other patches can be
seen on the mailing list archive [2]. Rostislav clarifies that when OCB
mode is used all the STAs communicate with each other without the need
for a coordinator. The 5.9 GHz band is being clarified to be used for 802.1=
1p,
the patch series also is specifying that when 5.9 GHz is enabled only
OCB mode of operation is allowed on that band. No references are made to
the specific 802.11 ammendment / IEEE 802.11 sections or more importantly i=
t is
not being made clear if the OCB mode is something that differs depending
on regulatory bodies at this point.

Since 802.11p was designed for cars in mind I suspect regulatory bodies
likely do want proper rules followed, but its unclear what countries
that follow either IEEE 802.11 or the ISO equivalent want OCB mode of
operation and if they also have the same restrictions of only allowing
5.9 GHz operation only for OCB. I can also imagine for example of regulatory
bodies that may want to allow 5.9 GHz for non OCB mode, specially if they
need the spectrum. One particular use case which provides a compromise
could be for example to have APs/P2P GOs look for OCB communication and
if its detected to disallow it. Not like I would recommend this given
that it would then introduce crazy regulatory compliance silliness
such as seen with DFS and that pushed crazy implementation and designs,
but -- its certainly possible.

So is this an IEEE compliance thing or regulatory thing? If its a generally
accepted IEEE compliance thing for 802.11-2012 then I don't see why we
don't just hard code this restriction on cfg80211 for the band. That
after all would be the much more saner thing to do than all the silly
mess of discrepencies betwen regulatory bodies. After all cfg80211 is for
802.11, and if we follow the specs and if its mentioned clearly there I
see no resason why not to hard code this. If folks want to override this
(I envision university environments doing research on this) the patch can
add a Kconfig option that depends on CONFIG_CFG80211_CERTIFICATION_ONUS
which will make the check permissive on 5.9 GHz instead of fully enforced.

[0] http://lists.infradead.org/mailman/listinfo/wireless-regdb
[1] http://wireless.kernel.org/en/developers/Summits/Barcelona-2012?action=
=3DAttachFile&do=3Dview&target=3Dieee80211-barcelona-2012.pdf
[2] http://comments.gmane.org/gmane.linux.kernel.wireless.general/121022

  Luis

--ALfTUftag+2gvp1h
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iQIcBAEBAgAGBQJTjkm9AAoJEPep4JnvMe6zlAgQAK9cqZAghwqYaOMzrKgHKGDV
3LNyzwoYpOq17xJQ9/75y2ePrjhIo0eYtBu9wjdoYtUXdP6IoTZkRhi6fMLOIrQW
45jeO8gL0rlkarsb5Ydp2q8VVvlsdbgkcn4Vk8Cz6a4HqZPITJLBDCmDUrCZUkKQ
AEcBh1rhejtengnAKkUUww1Q89AdjJld1cLD7mHPSm3P4u/lAVRdTjm1qhEbQU8p
6JFZGNWnjxrD+oQQW+s3ow+KKxJO2xG9/yJiBab4XTN7jRxB7NUlBmKruQ82lmy2
fXUt37p0gsqkkQ/TpbGHBQn0t89lKIwdxMfE5VKyB2SIeEBfr5xaweElF+YYLyqN
XpaowWl09hhl6bZQNWfSK1jfB2k0y49Soxga41QjUMPDat7kl34wOjmHJ/Xpu7hC
y4vcd4dkaZQqsOJv3dTdUpdqHMcFPie1pAVGe8ZS/PGOCpAmCZGFKT3MqhDUw1GA
Tzo0fJi4kINsH7/4PI+0qgJhGUr16/kScxe+MG+zamIq6t9V3iK8j1jbe4egaO/h
2LqzVJSfkhk5Mtze5LkzVWzigy+MkdohaQDpdfDcrreHD+Rmh3Y6o0Ten0wH14b+
1tLdB58z/R0t5GLVJORHX5eYaf74Z4ClBuqc01LyQ4GaSKSg0fMVlPo07E9S9pJT
R+JhVaXOl1d7bCZJQkEh
=Alqy
-----END PGP SIGNATURE-----

--ALfTUftag+2gvp1h--
