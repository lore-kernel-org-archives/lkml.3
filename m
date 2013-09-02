Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758021Ab3IBCXf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 22:23:35 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:47788 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753785Ab3IBCXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 22:23:34 -0400
Date: Mon, 2 Sep 2013 10:23:24 +0800
From: Kevin Hao <haokexin@gmail.com>
To: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linuxppc <linuxppc-dev@lists.ozlabs.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] jump_label: factor out the base part of jump_label.h
 to a separate file
Message-ID: <20130902022324.GA28673@pek-khao-d1.corp.ad.wrs.com>
References: <1377414952-15995-1-git-send-email-haokexin@gmail.com>
 <1377414952-15995-2-git-send-email-haokexin@gmail.com>
 <20130830163732.GA2353@hpx.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pWyiEgJYm5f9v55/"
Content-Disposition: inline
In-Reply-To: <20130830163732.GA2353@hpx.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pWyiEgJYm5f9v55/
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 30, 2013 at 06:37:33PM +0200, Radim Kr=C4=8Dm=C3=A1=C5=99 wrote:
> 2013-08-25 15:15+0800, Kevin Hao:
> > We plan to use the jump label in the cpu/mmu feature check on ppc.
> > This will need to include the jump_label.h in several very basic header
> > files of ppc which seems to be included by most of the other head
> > files implicitly or explicitly. But in the current jump_label.h,
> > it also include the "linux/workqueue.h" and this will cause recursive
> > inclusion. In order to fix this, we choose to factor out the base
> > part of jump_label.h to a separate header file and we can include
> > that file instead of jump_label.h to avoid the recursive inclusion.
> > No functional change.
>=20
> "linux/workqueue.h" was included because of deferred keys and they are
> split into "linux/jump_label_ratelimit.h" to solve the same problem in
> paravirt ticket spinlock series.
> (still in -next: 851cf6e7 jump_label: Split jumplabel ratelimit)

OK. I will respin a new version based on this patch. Thanks for the
information Radim.

Thanks,
Kevin

--pWyiEgJYm5f9v55/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQEcBAEBAgAGBQJSI/acAAoJEJNY7TDerrFxQ5MH/3MX9C7Y8a9pfs45qTowt82/
DMu9LMxdh8HouK1yHU5r4Lpfdzm0KXj31vqW/MCdKbvJdaYLx/GC9bDYTHetEveT
ZiIA+w6Acs2xNoE318TAeJqlpOxbQInwVmbtIyYXpefXf3QtxNL1o4ITaiq1c2E7
lz3UJ65nEymAW4JFNtJqpfFfFyRGu5KtyIV1hhAffo5MYr9uWbNpkWTlYKgKau2m
wIwFrSD1mqZ6juQEGNKUXbgawp9ypVqCBq0LR9VuNuv/4eRrfCmx8IZGWcz12GHW
ivWLo0pY/eh5Zfx4ViXBJ00ycyQPVHPzL/afuOLrA2O5TpM8LMAI9IJk1oF14g8=
=aEQx
-----END PGP SIGNATURE-----

--pWyiEgJYm5f9v55/--
