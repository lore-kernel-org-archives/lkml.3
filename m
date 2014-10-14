Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195AbaJNBLZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 21:11:25 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:34698 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753961AbaJNBLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 21:11:23 -0400
Date: Tue, 14 Oct 2014 10:11:12 +0900
From: Gyungoh Yoo <gyungoh@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: sameo@linux.intel.com, lee.jones@linaro.org, jg1.han@samsung.com,
        cooloney@gmail.com, lgirdwood@gmail.com, jack.yoo@skyworksinc.com,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        grant.likely@linaro.org, robh+dt@kernel.org, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        pawel.moll@arm.com, heiko@sntech.de, jason@lakedaemon.net,
        shawn.guo@freescale.com, treding@nvidia.com, florian.vaussard@epfl.ch,
        trivial@kernel.org, linux@roeck-us.net, andrew@lunn.ch,
        jic23@kernel.org
Subject: Re: [RESUBMIT PATCH v4 7/8] regulator: sky81452: Add compatible
 string for device binding
Message-ID: <20141014011112.GB2751@jack-ThinkPad-T520>
References: <1412657745-7812-1-git-send-email-jack.yoo@skyworksinc.com>
 <1413179262-27636-1-git-send-email-jack.yoo@skyworksinc.com>
 <1413179262-27636-8-git-send-email-jack.yoo@skyworksinc.com>
 <20141013103512.GJ27755@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141013103512.GJ27755@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 13, 2014 at 12:35:12PM +0200, Mark Brown wrote:
> On Mon, Oct 13, 2014 at 02:47:41PM +0900, Gyungoh Yoo wrote:
> 
> > -	np = of_get_child_by_name(dev->parent->of_node, "regulator");
> > -	if (unlikely(!np)) {
> > +	if (!np) {
> >  		dev_err(dev, "regulator node not found");
> > -		return NULL;
> > +		return ERR_PTR(-ENODATA);
> >  	}
> 
> If you're doing anything here you should convert the code to use the
> simplified interface for parsing regulator data based on putting the
> subnode name and regualtor name in the regulator descriptor.

Thank you for the review.

The driver has of_device_id.

static const struct of_device_id sky81452_reg_of_match[] = {
        { .compatible = "skyworks,sky81452-regulator", },
        { }
};

And the MFD adds the driver with of_compatible="skyworks,sky81452-regulator".
MFD core maps the device node and the regulator driver does
not need to parse the subnode name.

Thanks.
