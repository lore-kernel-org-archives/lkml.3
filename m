Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756534AbaGQJFI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 05:05:08 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:56476 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756506AbaGQJFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 05:05:04 -0400
Date: Thu, 17 Jul 2014 11:04:52 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: Bruno Wolff III <bruno@wolff.to>, Josh Boyer <jwboyer@redhat.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Scheduler regression from
 caffcdd8d27ba78730d5540396ce72ad022aff2c
Message-ID: <20140717090452.GH19379@twins.programming.kicks-ass.net>
References: <20140716145546.GA6922@wolff.to>
 <20140716151748.GC2460@hansolo.jdub.homelinux.org>
 <53C6CFCC.2050300@arm.com>
 <20140716195414.GA16401@wolff.to>
 <53C7084C.7090104@arm.com>
 <20140717030947.GA17889@wolff.to>
 <53C79013.1020808@arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gNHJk6zc+1Hn+Z/L"
Content-Disposition: inline
In-Reply-To: <53C79013.1020808@arm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gNHJk6zc+1Hn+Z/L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 17, 2014 at 10:57:55AM +0200, Dietmar Eggemann wrote:
> There is also the possibility that the memory for sched_group sg is not
> (completely) zeroed out:
>=20
>   sg =3D kzalloc_node(sizeof(struct sched_group) + cpumask_size(),
> 			GFP_KERNEL, cpu_to_node(j));
>=20
>=20
>   struct sched_group {
> 	...
> 	 * NOTE: this field is variable length. (Allocated dynamically
> 	 * by attaching extra space to the end of the structure,
> 	 * depending on how many CPUs the kernel has booted up with)
> 	 */
> 	unsigned long cpumask[0];

well kZalloc should Zero the entire allocated size, and the specified
size very much includes the cpumask size as per:
  sizeof(struct sched_group) + cpumask_size()

But yeah, I'm also a bit puzzled why this goes bang. Makes we worry we
scribble it somewhere or so.

--gNHJk6zc+1Hn+Z/L
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTx5G0AAoJEHZH4aRLwOS6niMQAJy2arvVT2ktSLCXh772JKEw
jenDnEDggTE55SZE7qw/NXdGTHHcq+Ml/zR4BPHF9uqlREJJ5U1w/ZfE9xM+EkHy
vuHDo5kTQEcBNQXvY7TDZSP8wM1GdOVRgZoP9eI4EjJpUYWkOvsWD4JHyVsfb3sj
IubQui5mHvn87tquVa26hk3z8gP/1e4oDIfI2MJ6ZrK4sIEG3bk1Xgji1QOAz5TM
r8oitDZ1ErMfUbpsFL2c2npJ59eN9U5m3QU/wkVa07lONbRw8J8xeEARoHDXehJu
wOMLImFhkW0BP+kvhIb//J1RjT9tEYy0DUYkeAxPYDcDlTeAUIg+N73JOHeumh7b
mgEqK4Hz12tq469G7NhiW86DO2+gdVJGSqrwc3rCAV2+QtvX0C1KASwtAbsv7OY1
inESCHzaVEiwqJcUV3Y1SPxeozUdO0Z+v9w54jt7QWGZIQWyjL4m4+H0vswJMatP
K/VUfRN5iS92CoTQt8G1LGP4nXxqIqSK4yKYLm2nnsCQz9dpdN7JB6PYohICuT4V
JRNSWXwiTs4/QFouWo4iw8PfNrJ2mCkgZtHzdUg776fJ+7OxCkkbOvW5EyBOUaJ+
QD1edXaXD9XU6fKQ/Wo7tBT2y70BYrA76rVka2HUl7UBgRz6fKKQ1eEEqRWGKJdI
HC9jYPOW0Bhh+B+1x473
=FvGN
-----END PGP SIGNATURE-----

--gNHJk6zc+1Hn+Z/L--
