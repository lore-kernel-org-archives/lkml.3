Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209Ab3BDLYF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 06:24:05 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:61631 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753188Ab3BDLYC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 06:24:02 -0500
Date: Mon, 4 Feb 2013 12:23:48 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Terje Bergstrom <tbergstrom@nvidia.com>
Cc: amerilainen@nvidia.com, airlied@linux.ie, dri-devel@lists.freedesktop.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv5,RESEND 6/8] gpu: host1x: Remove second host1x driver
Message-ID: <20130204112348.GB595@avionic-0098.mockup.avionic-design.de>
References: <1358250244-9678-1-git-send-email-tbergstrom@nvidia.com>
 <1358250244-9678-7-git-send-email-tbergstrom@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Yylu36WmvOXNoKYn"
Content-Disposition: inline
In-Reply-To: <1358250244-9678-7-git-send-email-tbergstrom@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:TL02M5LcCAwmacIzbddYReV2CHgFXGQ4wxGtZJRBwWj
 cXLCZ+ul/CpbtXF+45WLzQ0cCVQu+5f2UPQNZRL/lMbLzM1IcC
 BLP0v44kuzhZ69+kh4664SKEEEL4/8u4yU0GhfsksIMkNOEs9/
 goEk7zrbgyybGYrljLz6WxD5rrCOpstQcHQbHAa96orz5m51GV
 z6Bon5XO7NTWtrNlJ5BzHQyJK8miE7qxnyM9de5iGC0j72gqX0
 8t1NtyOX5ZNmG1GdeouLFGnTYBRILkyFaDGXi20IGgtGTllSgy
 01H+AeGOmq59S3w+q+NCMkt2+klIXdCQdd19lff2RTQs6J0PW7
 +nYRUCsZWn3d13lzjmM0RyFJOPzo+shPe/psnQwzW+F8YmGWAw
 bLDXs2HFRMdxQNEaLZoM+iMKk60CizPFMQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Yylu36WmvOXNoKYn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 15, 2013 at 01:44:02PM +0200, Terje Bergstrom wrote:
[...]
> +void host1x_set_drm_data(struct platform_device *pdev, void *data)
> +{
> +	struct host1x *host1x = platform_get_drvdata(pdev);
> +	host1x->drm_data = data;
> +}
> +
> +void *host1x_get_drm_data(struct platform_device *pdev)
> +{
> +	struct host1x *host1x = platform_get_drvdata(pdev);
> +	return host1x->drm_data;
> +}

Passing around struct device * should be enough and avoids the need for
the explicit cast to struct platform_device.

It is a bit unfortunate that we have now have two structures called
host1x, but I think we can live with it for now. We can clean that up
once the code has been merged.

Thierry

--Yylu36WmvOXNoKYn
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRD5pEAAoJEN0jrNd/PrOhD1gP/08Yf8YdNq2HNCTORy/oVRt7
yZpxzmEq6gtYBzQAz9gDLQPEEAxfBveZSYjgbb/SSMDIhd14IH7xbFlpz0xi4aCk
UsrrxMt1CKCsUZ22mMXt7IByNVwINmUfQ7qlK2I1Nk165zsOreb5cWcoH40oMwf8
IyylVpp/smtym8ctDjmx9S/BXFUCuChyR1dagD1y52OV4947ma/nT5HjoeE1aQE4
bIngbnwZdYXxiMX6lijDC2lmGFdAFe8sSVuUUlgdXFxRllxDOKDun/VaotoU7aps
HGDW/ib9dQG2o14hWYSmcM8WPZlBLu8lnXnhiv+g2iBrSvcggLXa1p+he5qh2A6T
k0DNztD0cHZ1CEo1+vDkizEJj4HB3HAnPuxwcRODJOqruEyV9yCF4waaiQLxBynV
9NMvqp5Ef3tif5sWkfjM39eUq2dAMwERmkUuY2ie8VsvmzaRqQ6dqEtEV+DIfGrA
YBJAx5HJEMr/4nf1E6GNghXimy7UfWfKQ443beLdMdlJa7oU0GJ8/XG00DqC+4Oa
i0S8ztNC2uVa3RxDIJNdGwxp+7AlVD6WNDZayq9y0JHZdZy5Dx/jZDH5OhfeWb/J
+LrmhFvhEHzblEcX4j2+H6KDN73dbLKUb1Y4DxU+Rhg1NZgkVBpRhmJ53SSZ+3Ne
KYsSgmr7DTsVDMMbi9Gs
=vRt2
-----END PGP SIGNATURE-----

--Yylu36WmvOXNoKYn--
