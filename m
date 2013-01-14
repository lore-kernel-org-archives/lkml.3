Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755295Ab3ANHJJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 02:09:09 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:49259 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753125Ab3ANHJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 02:09:07 -0500
Date: Mon, 14 Jan 2013 08:08:56 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Philip Avinash <avinashphilip@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org, nsekhar@ti.com,
        gururaja.hebbar@ti.com
Subject: Re: [PATCH 1/2] pwm: pwm-tiehrpwm: Low power sleep support
Message-ID: <20130114070855.GA21994@avionic-0098.adnet.avionic-design.de>
References: <1357823024-17585-1-git-send-email-avinashphilip@ti.com>
 <1357823024-17585-2-git-send-email-avinashphilip@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+HP7ph2BbKc20aGI"
Content-Disposition: inline
In-Reply-To: <1357823024-17585-2-git-send-email-avinashphilip@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:T1QS1xNbz6/vZEjxfNOhDHNkiBpX1DBXBAC5OJrVkyH
 TvO6xTQLQXYHQy4y/xKcWMSe95CANILQqA989GYzEZmx4trTP1
 cVEPYRnNMVqH2uFUdfke50ARu4RjyCN9Dtr8CtJeWuU71iGTeG
 cnq91Z2pOGwvHs44kUqXI8PY5PGIMeZrCprZjdQjBmbmQNaVdf
 VAvTjOpuggSoY9KnQbtd/5ZTJsb8DiDa30wmnDS8XnWEJcowok
 mApg6dXVSBuBDVpVV8/yiKhuzlYvsma7d3jNKoQ3oB5647r5gc
 HQopyAXBUgURSPrnCWgPjzWEnGEM26zc5QK2dB42CO74ViH7HT
 b1YK2DKGKW52hCdXUTQI8EGAx0nTAtFcZzd5tdF43n2dADDfyp
 FNy/jqpP7vFulf8myBWFiUxTnyuc8//5Cw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+HP7ph2BbKc20aGI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 10, 2013 at 06:33:43PM +0530, Philip Avinash wrote:
[...]
> diff --git a/drivers/pwm/pwm-tiehrpwm.c b/drivers/pwm/pwm-tiehrpwm.c
[...]
> +static int ehrpwm_pwm_suspend(struct device *dev)
> +{
> +	struct ehrpwm_pwm_chip *pc = dev_get_drvdata(dev);
> +
> +	ehrpwm_pwm_context_save(pc);
> +	pm_runtime_put_sync(dev);
> +	return 0;
> +}
> +
> +static int ehrpwm_pwm_resume(struct device *dev)
> +{
> +	struct ehrpwm_pwm_chip *pc = dev_get_drvdata(dev);
> +
> +	pm_runtime_get_sync(dev);
> +	ehrpwm_pwm_context_restore(pc);
> +	return 0;
> +}

According to Documentation/power/runtime_pm.txt, the PM core runs the
pm_runtime_get_noresume() and pm_runtime_put_sync() before executing the
.suspend() and .resume() callbacks. Are you sure you need to call them
here explicitly?

Thierry

--+HP7ph2BbKc20aGI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQ868GAAoJEN0jrNd/PrOh1ecP/2BiUloIaHU05MVuLhyBeBKU
VumB5tqYR3hVG060XcVPeA0daFSDODNTf+Ld5kQrVYCdAdhEpmVFgYCXQt9OW7e6
P7msrz8dpJJeXQrO1H9ZnvYUvsrs8dcERTLvgtvUSzYchoaVeAueyoc6uS+GZxaF
iizOKqFqUb+fsKBBP+yxtjKP5+bhm5xMQvaGKbOwugY+NliBNB/B09wko/oCCEsb
SxhsLa5cS0jNbbi77YhdjrOaUlCn7ZEZ2iGltWzBO15TnxcmuPfQDjCEDH7FEpQ3
G10KkVF1I1juoOKu/C+jmmQALtp/WTXVSJWnmAWzBp+WuewUwApIWR1as1fFpEdA
hEHas22MAjMm16OYpq0Zzj8bXpXY6Fd7vT2CsKkk9qKnVfmSPjs+78uj0cnGfzBw
KXwQA3IgLZuipW0vydnXQ577qzfguv40xhoiGXXcGKX7fLGub7MVJ7HhxJzLmN/U
/aJBMwNbTOPebdiCts2e3IKpt9HN7jbK3S+yqF2ZM9WfD9Mc+0Ucz/hen0I3dFfS
SHPYcQKWLOTcB3Wi39Tg/bwKHaLcgZ9ixekQ3pd2h+FpD6/Wq+8z99ZtvYQdGhQj
3tklNktNhTLv0zIFvaliiR748JtvMYKF0OvQNRWGreXLxFab3HMGyWgqDNVBJewF
YTX7Wi+RnMNvvuBiGfIf
=ZNgT
-----END PGP SIGNATURE-----

--+HP7ph2BbKc20aGI--
