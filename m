Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762284Ab3IDKTS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 06:19:18 -0400
Received: from mail-bk0-f43.google.com ([209.85.214.43]:39771 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756041Ab3IDKTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 06:19:16 -0400
Date: Wed, 4 Sep 2013 12:18:28 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Gleb Natapov <gleb@redhat.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, pbonzini@redhat.com
Subject: Re: [GIT PULL] KVM changes for 3.12
Message-ID: <20130904101826.GA2744@ulmo>
References: <20130903121046.GE22899@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="d6Gm4EdcadzBjdND"
Content-Disposition: inline
In-Reply-To: <20130903121046.GE22899@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--d6Gm4EdcadzBjdND
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Sep 03, 2013 at 03:10:46PM +0300, Gleb Natapov wrote:
[...]
> Aneesh Kumar K.V (5):
>       mm/cma: Move dma contiguous changes into a seperate config

Hi Gleb,

This commit is going to cause runtime regressions on various ARM
platforms because it renames a symbol but fails to update all default
configurations that select the symbol. A quick grep shows that three ARM
platforms are affected:

	$ git grep CONFIG_CMA=y
	arch/arm/configs/keystone_defconfig:CONFIG_CMA=y
	arch/arm/configs/omap2plus_defconfig:CONFIG_CMA=y
	arch/arm/configs/tegra_defconfig:CONFIG_CMA=y

I've been digging around a bit and it seems like the original patch from
Aneesh had the defconfig changes but they were dropped because they "...
require separate handling to avoid pointless merge conflicts."[0]

While I can't speak for Keystone or OMAP, at least on Tegra this causes
issues because we use CMA for framebuffer allocation. Since we only have
CMA selected but not the new DMA_CMA, large DMA allocations will fail.

Can we have the defconfig changes added back to this patch, please? I
suspect that Linus can handle any resulting merge conflicts.

Thierry

[0]: http://permalink.gmane.org/gmane.linux.kernel.mm/102707

--d6Gm4EdcadzBjdND
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSJwjyAAoJEN0jrNd/PrOh/ngP/RXk8IXhq7+WtS7OZ2L/igC0
j7SpGALd/9M5RPsDd2BknVvcbTOirl9eCq7/UOakxEiYxD+XQwIjSh2ERcvyYJz6
yPsGO84vUEncUJ/5//WOgFppQnMLd2KuKSNcDkJ4PfzqLXp3e34JgD2KstZ8+1A9
d4pRj4p/y+9abWNQQmtI3HpXFEr1Dvh4s1RidkWlzZxXJ8wYb4vqX33r7xIh8q+e
zew6aNqNTiEtxFpjJh825Fr3LEtSoKHq3CNHH8cAyhwH2ci5L196zAm52xlhjPc+
CXDZsYZfOujZ6mNqzHAS/wadK4XvUCNLpjfCOq7KplwDx2/eCy97PN1lmUilHFbJ
WXCNylOfwMj1xwdrD2/5pMXunEobz8Zz9s+YYyf+IkG9bABc/O0SEgLSRW9A39Op
zlWBMH0XUh3lMRuSF7QpuqBDbJmV44vrlKVJiG6kkDvlEpJhfolN8MCFXDcRjbft
pUKADxKqo0Mq4XSwp8U6Gt5KJI3Jz9aZ8H5AkBbkecJ0e++tBsPrSGG9ADdifVUf
jfXMJERijSEcT5ygMttsg+oyc6hb+i6QH91SebLZI3uljogzlwBVb4Zqk2r7LtfK
gUZBKyp96x1frhgLntNjyWJHjQ3Cy0ds+zsZqdAT90HAlU5A1USMCnuU5wgRoqak
zWyU/KHTVAhdT1BjxMUy
=Q+5W
-----END PGP SIGNATURE-----

--d6Gm4EdcadzBjdND--
