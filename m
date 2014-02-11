Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756204AbaBKUTj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 15:19:39 -0500
Received: from mail-ee0-f50.google.com ([74.125.83.50]:48888 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755478AbaBKUTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 15:19:35 -0500
Date: Tue, 11 Feb 2014 21:19:18 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: Stefan =?iso-8859-1?Q?S=F8rensen?= 
	<stefan.sorensen@spectralink.com>
Cc: grant.likely@linaro.org, robh+dt@kernel.org, mark.rutland@arm.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v2 2/2] dp83640: Get pin and master/slave configuration
 from DT
Message-ID: <20140211201917.GB4254@netboy>
References: <1392132562-23644-1-git-send-email-stefan.sorensen@spectralink.com>
 <1392132562-23644-3-git-send-email-stefan.sorensen@spectralink.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1392132562-23644-3-git-send-email-stefan.sorensen@spectralink.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 04:29:22PM +0100, Stefan Sørensen wrote:

> diff --git a/Documentation/devicetree/bindings/net/dp83640.txt b/Documentation/devicetree/bindings/net/dp83640.txt
> new file mode 100644
> index 0000000..b9a57c0
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/dp83640.txt
> @@ -0,0 +1,29 @@
> +Required properties for the National DP83640 ethernet phy:
> +
> +- compatible : Must contain "national,dp83640"
> +
> +Optional properties:
> +
> +- dp83640,slave: If present, this phy will be slave to another dp83640
> +  on the same mdio bus.

Wouldn't it be more natural to have one "dp83640,master" property
rather than multiple slave properties?

> @@ -949,6 +940,95 @@ static void dp83640_clock_put(struct dp83640_clock *clock)
>  	mutex_unlock(&clock->clock_lock);
>  }
>  
> +#ifdef CONFIG_OF
> +static int dp83640_probe_dt(struct device_node *node,
> +			    struct dp83640_private *dp83640)
> +{
> +	struct dp83640_clock *clock = dp83640->clock;
> +	struct property *prop;
> +	int err, proplen;
> +
> +	dp83640->slave = of_property_read_bool(node, "dp83640,slave");
> +	if (!dp83640->slave && clock->chosen) {
> +		pr_err("dp83640,slave must be set if more than one device on the same bus");

Most of these pr_err lines are a bit _way_ too long for coding style.

> +		return -EINVAL;
> +	}
> +
> +	prop = of_find_property(node, "dp83640,perout-pins", &proplen);
> +	if (prop) {
> +		if (dp83640->slave) {
> +			pr_err("dp83640,perout-pins property can not be set together with dp83640,slave");

(Here especially and in the code that followed.)

Overall the series is looking better. I will try to test the non-DT
case later on this week.

Thanks,
Richard


