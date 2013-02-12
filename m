Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761368Ab3BLPUn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 10:20:43 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:60173 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758429Ab3BLPUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 10:20:41 -0500
Date: Tue, 12 Feb 2013 16:20:37 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] of: Fix locking when calling
 of_get_next_available_child()
Message-ID: <20130212152037.GA21685@avionic-0098.mockup.avionic-design.de>
References: <1360621157-23570-1-git-send-email-grant.likely@secretlab.ca>
 <51197E36.8080704@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2oS5YaxWCcQjTEyO"
Content-Disposition: inline
In-Reply-To: <51197E36.8080704@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:IXXw3WS7u2SM+9pJN78Cd2U81IwhfL4MKPMoC5Y+cwC
 WGeWfaNOf+uj4REoX0KIaruxTvI6326wpU+wnqheMCVbxZ2SAI
 OxNJXpyY+OCRGQgV3zFXeOvRX0TbevIe+2i2wTKuYYHTF2EfHD
 HDq9reUOz0BDxpNbXkm7btgPvqpUyhcpdaba/jPIGSwLM5Osoi
 zn4dRKigOJdMhqLdVPKPr2zlLgbGkP65F7qgxGGjbDUJ3Gzc7f
 ygTMCgZh7sQ3FApLnub58+SQ1HqOViCq1eVO8XIKLR1V5wouDu
 +apD6IEOwP/efQmpP3BWITQF0qHQnXnR7eLE2Kdw323R+uyUOc
 2QTTETVE+P3XTICoyuO6Qvbk+qObgQ0QxWofzfSnkbPzv7m5+E
 5enzEkkV2dvOEm5B0K+7OM5r3FiNWmrCMyck59cZSULsWqQ7+a
 E7OVM
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2oS5YaxWCcQjTEyO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 11, 2013 at 04:26:46PM -0700, Stephen Warren wrote:
> On 02/11/2013 03:19 PM, Grant Likely wrote:
> > of_get_next_available_child() obtains the devtree_lock and then calls
> > of_device_is_available() which also attempts to claim the lock. This is
> > obviously incorrect and causes a deadlock on boot. Fix issue by adding
> > an variant of of_device_is_available() which doesn't obtain the lock.
>=20
> This patch forgets to update __of_device_is_available() to call
> __of_get_property() rather than of_get_property() and hence doesn't
> actually solve the problem.

Yes, please. of_get_property() called from __of_device_is_available()
pretty much defeats the purpose of having the non-locked version.

Thierry

--2oS5YaxWCcQjTEyO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRGl3FAAoJEN0jrNd/PrOh3l0QAL8VKB0tJtgB5Cfzm7ogl5VK
TYTI3xZWUXLu6f7Oo0tbR1dHuDE+NDy7f3BRARQxd+gTBWg/bleHqLIEBVPp7K4n
5A0UAjUdbyCJEkf5ywi2NEsuMkmOOyxJLJOzNTnHzxu+vOoOyiprvUbR6z1OS1DR
CND1PzDGAoqOpbw7ONzYPTQ/RWD/48ggpIx2BDkNH2OfvLsXs0JlPRilppGUklh4
rBO4isQFaFhlXWc00g/1DqrOtywcGx3wfuST1MuOHDqf7HmC8IHcHFMNB3ZIy88h
HFXzQRH+AEKObnDkOtKVk6EmVKwij+XkFTa0wrwvh5u6UMP13dZq2NOgPDjSutVL
LRYsHZ4HjxPtxW6SdwqAWr+yf62mpFZRn7hocYgPzp/Ff/9rejGsf6F9mM8EgCP7
yLC85cAWyj306qOIru7Hf2BXloSMvJ8PqsRemk9/XcgTbeLnzOOQ6TkkEveeRWeB
fiEw/jI3uKPF9fYEC8IgveyR9uLUYrhL/vCYQ3pHalzqPW9esXDt10ZXvGqjbak2
GogM5XcK+werjD5kfKDdBHZnyV10u7r3brU8FAGtCRmc85Y8EYDzWgGuXf0QmJwi
NZ6saScboyTdD3/ehyab11/ZCM3QYKBVY89yjr7AJEdtX6A06bNiQwNQoMWSpoSE
kcazQ9jO6bi1M/fDqkNT
=3rVv
-----END PGP SIGNATURE-----

--2oS5YaxWCcQjTEyO--
