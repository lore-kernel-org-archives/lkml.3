Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754714Ab3HMFlT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 01:41:19 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:43076 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879Ab3HMFlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 01:41:18 -0400
Date: Tue, 13 Aug 2013 15:41:06 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: linux-next: manual merge of the tty tree with the devicetree tree
Message-Id: <20130813154106.f89661732443289013035481@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__13_Aug_2013_15_41_06_+1000_tTQsGXWOOk+xNmHL"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__13_Aug_2013_15_41_06_+1000_tTQsGXWOOk+xNmHL
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the tty tree got a conflict in include/linux/of=
.h between commit 2adfffa22350 ("OF: make of_property_for_each_{u32|string}=
() use parameters if OF is not enabled") from the devicetree tree and commi=
t 5c19e95216b9 ("OF: Add helper for matching against linux,stdout-path") fr=
om the tty tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

Out of interest, why does of_device_is_stdout_path() not return bool?
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc include/linux/of.h
index 90a8811,429e168..0000000
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@@ -331,7 -337,14 +331,9 @@@ const __be32 *of_prop_next_u32(struct p
   *         printk("String value: %s\n", s);
   */
  const char *of_prop_next_string(struct property *prop, const char *cur);
 -#define of_property_for_each_string(np, propname, prop, s)	\
 -	for (prop =3D of_find_property(np, propname, NULL),	\
 -		s =3D of_prop_next_string(prop, NULL);		\
 -		s;						\
 -		s =3D of_prop_next_string(prop, s))
 =20
+ int of_device_is_stdout_path(struct device_node *dn);
+=20
  #else /* CONFIG_OF */
 =20
  static inline const char* of_node_full_name(struct device_node *np)
@@@ -494,20 -507,17 +496,25 @@@ static inline int of_machine_is_compati
  	return 0;
  }
 =20
 +static inline const __be32 *of_prop_next_u32(struct property *prop,
 +		const __be32 *cur, u32 *pu)
 +{
 +	return NULL;
 +}
 +
 +static inline const char *of_prop_next_string(struct property *prop,
 +		const char *cur)
 +{
 +	return NULL;
 +}
 +
+ static inline int of_device_is_stdout_path(struct device_node *dn)
+ {
+ 	return 0;
+ }
+=20
  #define of_match_ptr(_ptr)	NULL
  #define of_match_node(_matches, _node)	NULL
 -#define of_property_for_each_u32(np, propname, prop, p, u) \
 -	while (0)
 -#define of_property_for_each_string(np, propname, prop, s) \
 -	while (0)
  #endif /* CONFIG_OF */
 =20
  #ifndef of_node_to_nid

--Signature=_Tue__13_Aug_2013_15_41_06_+1000_tTQsGXWOOk+xNmHL
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSCcb2AAoJEECxmPOUX5FEY/YP/1EoYAlxQ3EB0YZ2hsIQOnr3
cu9bZIqno1gVeJYeas3bN8+d6VsBFBTERJ9x6lNdKP9DGuUYjBE1WA++hHnyAhYi
Rjqkggn6FgVVdG9ZFJViEvYcqE/ZT6EB4j1PrpeYTTndh4ZfW9x+k3evRUbTVJba
CTUn/od2WXf2eAZJgEI3rP7TLuw/41U2MbijAltLUSiJlJ7zCCIYoNRK+NIzgbXl
Q3fQRcSAYWSr8b28hvGX5gIUdr4xCjvLG82kWDBjDOuEMO75AIJGPIDr2knf8ZjK
n+6oyPHk4QZOBlfwM9RZmHoTeMJ4KzVaLFG7TAOeCg22iDK3LQCeaLHTMkvnWqu6
+CWUARZo/hk/ktnTQcCXbfCH5aAwYcgO11oft//2IXyWJSx1r/wMLImX/03UVyuX
cMJ5rSUigxcRttEtZvAgdCmdp2uy/H/c7dLWhRcy2IwakplpU3zR7XhRsHJ67PVa
P2qZ8UAQaYbDmZpxDPL98zEerFTpFBBcNPamhS0MlUj6kPyL1QNvYFoNxBhEp1Mg
c43TZeYdY9Yxq11eLiWiHKh6pUx2AY7s8DRHS7FBnaPd5xO3FQdH/EVReC2hAFAv
UFsgoBroZumIqibhgYjYgyTHtv6pQYHbdE44zQqT4pt6/4bD270f2WawGJTgdPjG
Dvvpa7qotF+j9cW+RBDE
=4Z8c
-----END PGP SIGNATURE-----

--Signature=_Tue__13_Aug_2013_15_41_06_+1000_tTQsGXWOOk+xNmHL--
