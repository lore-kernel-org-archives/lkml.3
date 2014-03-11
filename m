Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753794AbaCKBsf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 21:48:35 -0400
Received: from mout.web.de ([212.227.15.3]:64744 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752741AbaCKBsd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 21:48:33 -0400
Date: Tue, 11 Mar 2014 02:48:23 +0100
From: Linus =?utf-8?Q?L=C3=BCssing?= <linus.luessing@web.de>
To: Hannes Frederic Sowa <hannes@stressinduktion.org>
Cc: netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        Stephen Hemminger <stephen@networkplumber.org>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        Jan Stancek <jstancek@redhat.com>,
        Florian Westphal <fwestpha@redhat.com>
Subject: Re: [PATCHv2 2/2] bridge: multicast: enable snooping on general
 queries only
Message-ID: <20140311014823.GM5090@Linus-Debian>
References: <1394486725-4992-1-git-send-email-linus.luessing@web.de>
 <1394486725-4992-2-git-send-email-linus.luessing@web.de>
 <20140310225600.GJ5493@order.stressinduktion.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WTO+dqXoBrlfXqg9"
Content-Disposition: inline
In-Reply-To: <20140310225600.GJ5493@order.stressinduktion.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V03:K0:Lt6gihJJdcxaCXc0XLnAcGVJdmPqf1aUxQmaQ2u46Qz61y8bovw
 YnrdShK5q2MbP47Ids4rPSh8BtrJeACebqld++K/9C4s851I+j8bSuA8dNRLvybIfd7TXug
 u6cZTCY0TdGSKyg9jNzp8p9UaUcnf/QrBva85CYVCdW8gyX+AnbJ0ruPL2z1f7XPxvfi2mW
 6EFNM52c3/yvzeRzrrqXg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WTO+dqXoBrlfXqg9
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 10, 2014 at 11:56:00PM +0100, Hannes Frederic Sowa wrote:
> On Mon, Mar 10, 2014 at 10:25:25PM +0100, Linus L=C3=BCssing wrote:
> >  	br_multicast_query_received(br, port, &br->ip6_querier,
> > -				    !ipv6_addr_any(&ip6h->saddr), max_delay);
> > +				    !ipv6_addr_any(&ip6h->saddr),
> > +				    is_general_query, max_delay);
>=20
> Just a small nit, maybe for a later patch:
>=20
> After your change 6565b9eeef194a ("bridge: multicast: add sanity check
> for query source addresses"), which is still in -net only, we could
> replace !ipv6_addr_any(&ip6h->saddr) with '1'?

Aiy, good point, that part is obsolete now and
br_multicast_query_received() could be simplified, right. Going
to do that once we are out of deep-RC territory again and/or
the according commit is available in net-next. Thanks for the
hint!

Cheers, Linus

--WTO+dqXoBrlfXqg9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTHmtmAAoJELxyPiAAt6UvwaEP/2SVjCNTDODWZatGOf+ZvNmp
2ckDn/yNyeoIKwQk+XFLstFZuawS+tetiArWXCxx0kniljVUkMMZLkown4sROBNb
qCfKEKvxp2H2fKQej094nZwT0xOColZxGCXXa4u7z8wUOnbnw67SOgDRpz3yYZ7F
1Veu/cwVP5hW3iur8MbZYWufQ6Yg2+04k4yKyk4gpdfr66EyK5MuxSHQT1gE8o6j
wzc2HuE3YviEUSuiUQIB2hAdxPfK3WO9ByjlW9ohhW6ou48x6nW2N/bm3b68sKN6
hUvSKlujoaK9XkMfrtJG0RQEi/8UA74/2HWV4fTN/cgv5OzjdMb5CnrmkzIbdHUw
UP3Tgi6m+y7od3ZR+TJ5yRAq0Cf50w1meHSXm+m4j4gNGt3fCRCCOGjlEu1w88t9
xQ/i7EwCUSq43NTLJGTIVZhOFae/GbqkNoAsePpdc56/WV1N18AYnxf5ELMlafSE
/CLjcOUQCG73FK0u+FEFMdW/I1vmYXIWUoMFzehMrKHHm8VRp3oe6rC9k7BXf8CP
zPh2H/0eRs6Dtbi+CVMlaqhwmqEy6nCXlqH8puUmSkNnopTCC9F91Lkp1+RncDdC
E5V6t90glH2ybB0Cc0EqVzssl05l1NWkRrmne85yYNSc6fpK/rw7FLnThCdmQETs
mFJtUioNUeQb4DkTRAZW
=CtsF
-----END PGP SIGNATURE-----

--WTO+dqXoBrlfXqg9--
