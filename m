Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752147AbaKDHv6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 02:51:58 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:11863 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989AbaKDHvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 02:51:54 -0500
X-AuditID: cbfec7f5-b7f956d000005ed7-c9-54588597e62e
Message-id: <1415087510.2389.4.camel@AMDC1943>
Subject: Re: [PATCH v3 08/14] mfd: max77686/802: Remove support for board files
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Chanwoo Choi <cw00.choi@samsung.com>
Date: Tue, 04 Nov 2014 08:51:50 +0100
In-reply-to: <20141103170128.GD12011@x1>
References: <1414668053-31370-1-git-send-email-k.kozlowski@samsung.com>
 <1414668053-31370-9-git-send-email-k.kozlowski@samsung.com>
 <20141103170128.GD12011@x1>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu2
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDLMWRmVeSWpSXmKPExsVy+t/xq7rTWyNCDC5d0LfYOGM9q8WkdQeY
	LKY+fMJmcf3Lc1aL+UfOsVoc/V1g0bvgKpvF2aY37Bb3vx5ltPh2pYPJYtPja6wWl3fNYbOY
	cX4fk8Xty7wWa4/cZbc43c3qIODR0tzD5vH3+XUWj7+rXjB77Jx1l91j06pONo871/awecw7
	GeixeUm9R9+WVYwenzfJBXBFcdmkpOZklqUW6dslcGX0bBEuOMlVseK/YQPjLI4uRg4OCQET
	iecnxboYOYFMMYkL99azdTFycQgJLGWU+PFrCxOE85lR4teTvYwgVbwCehJ/lq9gA7GFBfwl
	Xr5bB2azCRhLbF6+hA1kqIiAisS5N+YgvcwC91kktq//C1bDIqAqcfvERnYQm1NAQ2LP4//s
	EAsWM0p8P/GSGSTBLKAuMWneImaI65QlGvvdIPYKSvyYfI8FokReYvOat8wTGAVmIemYhaRs
	FpKyBYzMqxhFU0uTC4qT0nON9IoTc4tL89L1kvNzNzFCYuzrDsalx6wOMQpwMCrx8K6IjwgR
	Yk0sK67MPcQowcGsJMK7ugooxJuSWFmVWpQfX1Sak1p8iJGJg1OqgdGk7d3SHblff0k5/6io
	njnj+vJHR+cfVTdd8PBT+t6yJ1eLbh7j1A5qXPpBv+X9mj2PH9x+NMP0DKOo343pbDIJnC+v
	8gV+mupY6KC/7WYJ99ydIZP2r7/iKlK5IML3X6v79IZvrL6alxYsz+XnN94i4n+v/d+aI/O/
	5L69ZmrI0GOftVva9m+OEktxRqKhFnNRcSIAa4frho8CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On pon, 2014-11-03 at 17:01 +0000, Lee Jones wrote:
> On Thu, 30 Oct 2014, Krzysztof Kozlowski wrote:
> 
> > The driver is used only on Exynos based boards with DTS support.
> > Convert the driver to DTS-only version. This simplifies a little the
> > code:
> > 1. No dead (unused) entries in platform_data structure.
> > 2. More code removed.
> > 3. Regulator driver does not depend on allocated memory
> >    from MFD driver.
> > 4. It makes also easier extending the regulator driver.
> > 
> > Add to the max77686 MFD driver dependency on CONFIG_OF because without
> > DTS the regulator drivers won't bind.
> > 
> > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > Reviewed-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
> > ---
> >  drivers/mfd/Kconfig                  |  1 +
> >  drivers/mfd/max77686.c               | 23 -----------------------
> >  include/linux/mfd/max77686-private.h |  1 -
> >  include/linux/mfd/max77686.h         | 28 ----------------------------
> >  4 files changed, 1 insertion(+), 52 deletions(-)
> 
> Applied, thanks.


Noooo, don't apply it. It depends on previous patches removing the board
file support from regulators.

If the patch looks OK, please only ack it. I would like to push
everything through regulator tree.

Best regards,
Krzysztof


