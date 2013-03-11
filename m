Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752309Ab3CKHTA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 03:19:00 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:62896 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047Ab3CKHS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 03:18:58 -0400
Date: Mon, 11 Mar 2013 08:18:51 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Terje =?utf-8?Q?Bergstr=C3=B6m?= <tbergstrom@nvidia.com>
Cc: Arto Merilainen <amerilainen@nvidia.com>,
        "airlied@linux.ie" <airlied@linux.ie>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv5,RESEND 3/8] gpu: host1x: Add channel support
Message-ID: <20130311071851.GA6033@avionic-0098.mockup.avionic-design.de>
References: <1358250244-9678-1-git-send-email-tbergstrom@nvidia.com>
 <1358250244-9678-4-git-send-email-tbergstrom@nvidia.com>
 <20130225152457.GA29545@avionic-0098.mockup.avionic-design.de>
 <512C84E2.5090201@nvidia.com>
 <513A0ED0.4070701@nvidia.com>
 <20130308204301.GA30742@avionic-0098.mockup.avionic-design.de>
 <513D79E7.5000801@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jRHKVT23PllUwdXP"
Content-Disposition: inline
In-Reply-To: <513D79E7.5000801@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:051iJyMF5YE09iIjxAKX6ZCDXCT81CwdM7j1FT+y4PV
 Sup56eA+OVb5S6b4tSgkWOen0Sx7lnCjsF0UqFvm5GRZ3Lhekq
 V9xFkKUv0pJsWDYg76grqH/277t3HlwEe2+3msRGKyuHpCz+T1
 Q7YKvy6SiU/SDw94xgTyQbhs2oGZyW0ZENH0l6lsEbWYdk8Rc4
 JWWvXCbG3rnY8ZGsMCwZ+aYnAGOAJ+k3Ax0uRo93jJ2GW/tDl9
 wh+exG4TdRlMiiLe0193iU6RotmW/B8RdwPZvOAlDn3/Lz9WM5
 LAydCWxJMqpHFBLgXr9phnIvth/v66Q9mPXy1WrzDyE2EmIXWK
 /gBWTimsJwregtzsdl4AgulAgGSJEfCWYBAYc/BwN9NFbO2hpw
 ctJWM2D8zz8+u0G50ROrQ7UMm2mX74+sf0IWZXMR1+P/HHhimo
 RmjS7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jRHKVT23PllUwdXP
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 11, 2013 at 08:29:59AM +0200, Terje Bergstr=C3=B6m wrote:
> On 08.03.2013 22:43, Thierry Reding wrote:
> > A bo is just a buffer object, so I don't see why the name shouldn't
> > be used. The name is in no way specific to DRM or GEM. But the point
> > that I was trying to make was that there is nothing to suggest that
> > we couldn't use drm_gem_object as the underlying scaffold to base all
> > host1x buffer objects on.
> >=20
> > Furthermore I don't understand why you've chosen this approach. It
> > is completely different from what other drivers do and therefore
> > makes it more difficult to comprehend. That alone I could live with
> > if there were any advantages to that approach, but as far as I can
> > tell there are none.
>=20
> I was following the plan we agreed on earlier in email discussion with
> you and Lucas:
>=20
> On 29.11.2012 11:09, Lucas Stach wrote:
> > We should aim for a clean split here. GEM handles are something which
> > is really specific to how DRM works and as such should be constructed
> > by tegradrm. nvhost should really just manage allocations/virtual
> > address space and provide something that is able to back all the GEM
> > handle operations.
> >=20
> > nvhost has really no reason at all to even know about GEM handles.
> > If you back a GEM object by a nvhost object you can just peel out
> > the nvhost handles from the GEM wrapper in the tegradrm submit ioctl
> > handler and queue the job to nvhost using it's native handles.
> >=20
> > This way you would also be able to construct different handles (like
> > GEM obj or V4L2 buffers) from the same backing nvhost object. Note
> > that I'm not sure how useful this would be, but it seems like a
> > reasonable design to me being able to do so.
>=20
> With this structure, we are already prepared for non-DRM APIs. Tt's a
> matter of familiarity of code versus future expansion. Code paths for
> both are as simple/complex, so neither has a direct technical
> superiority in performance.
>=20
> I know other DRM drivers have opted to hard code GEM dependency
> throughout the code. Then again, host1x hardware is managing much more
> than graphics, so we need to think outside the DRM box, too.

This sound a bit over-engineered at this point in time. DRM is currently
the only user. Is anybody working on any non-DRM drivers that would use
this?

Even that aside, I don't think host1x_mem_handle is a good choice of
name here. The objects are much more than handles. They are in fact
buffer objects, which can optionally be attached to a handle. I also
think that using a void * to store the handle specific data isn't such a
good idea.

So how about the following proposal, which I think might satisfy both of
us:

	struct host1x_bo;

	struct host1x_bo_ops {
		struct host1x_bo *(*get)(struct host1x_bo *bo);
		void (*put)(struct host1x_bo *bo);
		dma_addr_t (*pin)(struct host1x_bo *bo, struct sg_table **sgt);
		...
	};

	struct host1x_bo *host1x_bo_get(struct host1x_bo *bo);
	void host1x_bo_put(struct host1x_bo *bo);
	dma_addr_t host1x_bo_pin(struct host1x_bo *bo, struct sg_table **sgt);
	...

	struct host1x_bo {
		const struct host1x_bo_ops *ops;
		...
	};

	struct tegra_drm_bo {
		struct host1x_bo base;
		...
	};

That way you can get rid of the host1x_memmgr_create_handle() helper and
instead embed host1x_bo into driver-/framework-specific structures with
the necessary initialization.

It also allows you to interact directly with the objects instead of
having to go through the memmgr API. The memory manager doesn't really
exist anymore so keeping the name in the API is only confusing. Your
current proposal deals with memory handles directly already so it's
really just making the naming more consistent.

Thierry

--jRHKVT23PllUwdXP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRPYVbAAoJEN0jrNd/PrOh1zwP/11O6tlCkJxYl7LC+ujY1ZZl
MZB/7Ge+pnzm5bc1Wb2gI4lnwZ3jfCKcqHqUNcifeKO/6JlZhytuH+M0h1oZtp3P
/LR56mFwnq832+qKYvZDNr0ZtosV1Gz/QcqAzwvgBk1fX/r2rTDCAxED05CTxCfe
n2mdHtWDZwBAKlyoE/JyJxmFN9JxXZ6cgIgXq9IcX0u7ZwiTh11ZJRojo4Vqtuhj
Ef2CaPPVx6MNT9WSnV0MohNtGrM+atHwH9FURYGGjsCItM49Yqkg7Y80eLNfyunk
kEWUFx2UElGhokmbL44548Lkcx//bNF7b8D7poBWJM73royLyjCpRU9RpTNYL7Yp
l8Agh7i4xuC6YXxtwVGJy5iNwhpkzPgJHh9qWwJGpcDE3rDTHy1uDrROCYtf8A1m
98W4rXf8tXXZpOqLTCQD8BY3wIccoRUhlv7fsQeiswO4RvOZBHskf7FYJvvih3K5
PbNBK/pPXmsu7Er0+8/pzIlT4jG7XKqYZY8HDdDI8Q3LTkwgQFNLKxrtWcpf+YTu
Fy4Yeh+O0wt0IIOJ5mipFtFZK1MI2XZljAhpmlN/2StdAnmJ2uZLidMVDpJHBLbx
C6MSduyOlFOdyZqM37ngWKVsvQZvIX1Nk1QZLkc8gt3FLZBoQQidAKVrd3LBfl5a
TZhh7FWkDw2ipz4by2AR
=O5tA
-----END PGP SIGNATURE-----

--jRHKVT23PllUwdXP--
