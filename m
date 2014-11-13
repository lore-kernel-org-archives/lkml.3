Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933871AbaKMRs6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 12:48:58 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:37013 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933619AbaKMRsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 12:48:55 -0500
Message-ID: <5464EF03.9020002@suse.cz>
Date: Thu, 13 Nov 2014 18:48:51 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 3.17 023/319] drivers/net: Disable UFO through virtio
References: <20141112010952.553519040@linuxfoundation.org>	 <20141112010956.540146480@linuxfoundation.org> <1415826239.3398.113.camel@decadent.org.uk>
In-Reply-To: <1415826239.3398.113.camel@decadent.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 11/12/2014, 10:03 PM, Ben Hutchings wrote:
> On Wed, 2014-11-12 at 10:12 +0900, Greg Kroah-Hartman wrote:
>> 3.17-stable review patch.  If anyone has any objections, please
>> let me know.
>> 
>> ------------------
>> 
>> From: Ben Hutchings <ben@decadent.org.uk>
>> 
>> [ Upstream commit 3d0ad09412ffe00c9afa201d01effdb6023d09b4 ]
>> 
>> IPv6 does not allow fragmentation by routers, so there is no 
>> fragmentation ID in the fixed header.  UFO for IPv6 requires the
>> ID to be passed separately, but there is no provision for this in
>> the virtio net protocol.
>> 
>> Until recently our software implementation of UFO/IPv6 generated
>> a new ID, but this was a bug.  Now we will use ID=0 for any
>> UFO/IPv6 packet passed through a tap, which is even worse.
>> 
>> Unfortunately there is no distinction between UFO/IPv4 and v6 
>> features, so disable UFO on taps and virtio_net completely until
>> we have a proper solution.
> [...]
> 
> Please drop this patch for 3.14 and 3.17.  It causes problems for 
> migration of VMs and we're probably going to revert part of this.
> The following patch ("drivers/net, ipv6: Select IPv6 fragment
> idents for virtio UFO packets") might no longer apply, in which
> case you can drop that as well until we have this sorted out
> upstream.

The same holds for 3.12, I suppose?

thanks,
- -- 
js
suse labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUZO8DAAoJEL0lsQQGtHBJ6m0QAKtFdrlbdrBszq6o7pR5B+Jz
7ULH2GpXb+s0eGK5jf2Wfrz3IGnpStPZa8wpOVVrCLX/sggccEwgTfTIN9LgDS84
juNP1aHKVMXc62Mf/ZTJpZF7+k1HbRp/M5EnZpFy/QrwHjbn1s+KGtepkLtt7Lsg
QHtmU+kvfoJKI1yOrStwuNYoOVLHl8cfG8gIB/8JLSuii9IzEO5nt4pHLbemW7s1
cwICvtRlQJkRDf7wWLPvy77pvBdlMERg5zqANQPZTyopQvn2nMs9V4h8JMiZYx0l
YR1aw8CrYm1BiOSCscNSCla5ypU3VcWLaNLHGhsaJwMwl12FhR4+4biNrobfHjU7
1dvWTA5VD9Hdz0rf/iqMpOrA7qbyp/ucmYkcpPe+y6BCT7f8VapnsUWrQxPU37N8
WdLYa4D9dgA1uL4zQICiQQpQqoJVTRZRep5W07zuMkjWiQnSVwRbOMiWD3bpee20
wrppKHKSwRskKK25J9wXWgLu+EfgqvskqB5RjzmDU2jZv/bkBqfTf00JY6ar4rlr
lAQHXnVaBHA3agY7yOvRc/95vNGW1BN/z+/fDu0sl/h5JCmapzN7mr5eSLWLQK8N
aVgc+y/z5rYsID2SKPI3gCKTCfIiASYAedNn+e67OiTTrTcNg2d9SWKJctVcsAD+
nBEnS4azRHV/9tyMKIFS
=6NLa
-----END PGP SIGNATURE-----
