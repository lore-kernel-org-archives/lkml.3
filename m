Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776AbaGHNa4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 09:30:56 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58058 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753402AbaGHNaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 09:30:55 -0400
Message-ID: <53BBF283.40202@canonical.com>
Date: Tue, 08 Jul 2014 15:30:43 +0200
From: Stefan Bader <stefan.bader@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@canonical.com>
Subject: Re: fs/stat: Reduce memory requirements for stat_open
References: <1402578017-16637-1-git-send-email-stefan.bader@canonical.com> <20140708130958.GG6758@twins.programming.kicks-ass.net>
In-Reply-To: <20140708130958.GG6758@twins.programming.kicks-ass.net>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="Sphfo5JFrFJMhOLXWMhSDDdSQVAjKuSgI"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Sphfo5JFrFJMhOLXWMhSDDdSQVAjKuSgI
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 08.07.2014 15:09, Peter Zijlstra wrote:
> On Thu, Jun 12, 2014 at 03:00:17PM +0200, Stefan Bader wrote:
>> When reading from /proc/stat we allocate a large buffer to maximise
>> the chances of the results being from a single run and thus internally=

>> consistent.  This currently is sized at 128 * num_possible_cpus() whic=
h,
>> in the face of kernels sized to handle large configurations (256 cpus
>> plus), results in the buffer being an order-4 allocation or more.
>> When system memory becomes fragmented these cannot be guarenteed, lead=
ing
>> to read failures due to allocation failures.
>=20
>> @@ -184,7 +184,7 @@ static int show_stat(struct seq_file *p, void *v)
>> =20
>>  static int stat_open(struct inode *inode, struct file *file)
>>  {
>> -	size_t size =3D 1024 + 128 * num_possible_cpus();
>> +	size_t size =3D 1024 + 128 * num_online_cpus();
>>  	char *buf;
>>  	struct seq_file *m;
>>  	int res;
>=20
> Old thread, and already solved in the meantime, but note that
> CONFIG_NR_CPUS _should_ have no reflection on num_possible_cpus().
>=20
> The arch (x86 does) should detect at boot time the max possible CPUs th=
e
> actual hardware supports and put num_possible_cpus() to that number. So=

> your typical laptop will mostly have num_possible_cpus() <=3D 4, even
> though CONFIG_NR_CPUS could be 4k.
>=20
> Of course, if you actually do put 256+ cpus in your system, well, then
> the difference between possible and online isn't going to help either.
>=20
> If on the other hand your 'board' reports it can hold 256 CPUs while in=

> fact it cannot, go kick your vendor in the nuts.
>=20

Odd. So at least for the reporter the board must be doing that. For the o=
ther
way round at least back then when we did the change, some of the big hoov=
ers
which end up claiming 64 or so CPUs (including threads) would not boot wi=
th a
too low CONFIG_NR_CPUS. So that seems to have changed at some point.
But at least this would explain why there have not been too many reports.=


Thanks for the detail,
Stefan


--Sphfo5JFrFJMhOLXWMhSDDdSQVAjKuSgI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCgAGBQJTu/KLAAoJEOhnXe7L7s6jym4P/0WRj3036STl3EcnMlxjvzHk
ZlnBIkTP5HAJk/KuAtGVxE4BKt+/rPMimvwn1LkHXEycw8PeZMnyzR12hGExVEtD
8aw9GjxN3WmSIQZEfZuP4unCgurTd4B+PChVsfgy+bnLbylNBIdQoHo5V3Siq5As
YpudGCx10VPH8KsOjQQq9+lC6Lk4nvGpPZt3Yi91GjKu5UpqjuDgtQix8WgeZRGs
g5tE5SB03NuDZXMziMBNLxb77Q/F7LZjDlJxYsLITGrPbbaUyIW16xGiKyWei999
ALYUek/XJseK7wIYD4AeWcVD6qS1z2lvrwNwfvVUu8pOqFAc+vxz1h4D2O83x6p3
lJ3gSFS6f4j/J5w8j/b2ugymcZzpMhsJa+WDeqN3XaArKi48kmAvPvGLz/rFkM3G
BAlrVzDoKG+Zh0HafKWJ/RZXKUu6/oDXeKkbghpWOewFrkO6PpILMDYKPcC716db
QDgXwqIfxE6rX93M6494QVvYNQMqS3V3FqcMepHHaTWRINW9HQL5ec/6K5lvEg/j
IB1r/JTKjXDnznMjjt3FBzL0JhRz3QeDdghdpHOF36hoNN0QqTBfeJckE1rBWLmX
rmHvVCOJxqNPxes0al4CQ5LUUMXY3TB8QqL56wmeZSWSWuOgUQJiROLwoGeepDnI
y7T5eOxtZOcn5Ct7+QXo
=z0U+
-----END PGP SIGNATURE-----

--Sphfo5JFrFJMhOLXWMhSDDdSQVAjKuSgI--
