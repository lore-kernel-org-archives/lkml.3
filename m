Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756594Ab3JJQvN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 12:51:13 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:62020 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756510Ab3JJQvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 12:51:10 -0400
Date: Thu, 10 Oct 2013 17:51:00 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: "broonie@kernel.org" <broonie@kernel.org>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "sbkim73@samsung.com" <sbkim73@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH 1/2] regulator: s5m8767: Modify parse_dt function to
 parse data related to ramp
Message-ID: <20131010165100.GA3910@e106331-lin.cambridge.arm.com>
References: <1381369296-17101-1-git-send-email-cw00.choi@samsung.com>
 <20131010102826.GG26954@e106331-lin.cambridge.arm.com>
 <52568B3D.7020209@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52568B3D.7020209@samsung.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 10, 2013 at 12:10:53PM +0100, Chanwoo Choi wrote:
> On 10/10/2013 07:28 PM, Mark Rutland wrote:
> > On Thu, Oct 10, 2013 at 02:41:35AM +0100, Chanwoo Choi wrote:
> >> This patch parse 'buck[2-4]_ramp_enable and buck_ramp_delay' platform data
> >> from dts file.
> > 
> > Why?
> > 
> > What do these describe? Why do we need them?
> 
> Turn on ramp control of buck2/3/4.

Ok, but why does this need to be in the dt?

> 
> > 
> >>
> >> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> >> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> >> ---
> >>  drivers/regulator/s5m8767.c | 16 ++++++++++++++++
> >>  1 file changed, 16 insertions(+)
> >>
> >> diff --git a/drivers/regulator/s5m8767.c b/drivers/regulator/s5m8767.c
> >> index c24448b..cb6cdb3 100644
> >> --- a/drivers/regulator/s5m8767.c
> >> +++ b/drivers/regulator/s5m8767.c
> >> @@ -640,6 +640,22 @@ static int s5m8767_pmic_dt_parse_pdata(struct platform_device *pdev,
> >>  		return -EINVAL;
> >>  	}
> >>  
> >> +	if (of_get_property(pmic_np, "s5m8767,pmic-buck2-ramp-enable", NULL))
> >> +		pdata->buck2_ramp_enable = true;
> > 
> > Please describe what this is and why we need it.
> 
> buck2/3/4_ramp_enable is used to protect the chip from the in-rush current.

Ok. Could we not always set these in the driver? Under what
circumstances do we need this?

> 
> > 
> > For reading boolean proeprties, use of_property_read_bool.
> 
> I'll fix it.
> 
> > 
> >> +
> >> +	if (of_get_property(pmic_np, "s5m8767,pmic-buck3-ramp-enable", NULL))
> >> +		pdata->buck3_ramp_enable = true;
> >> +
> >> +	if (of_get_property(pmic_np, "s5m8767,pmic-buck4-ramp-enable", NULL))
> >> +		pdata->buck4_ramp_enable = true;
> >> +
> >> +	if (pdata->buck2_ramp_enable || pdata->buck3_ramp_enable
> >> +			|| pdata->buck4_ramp_enable) {
> >> +		if (of_property_read_u32(pmic_np, "s5m8767,pmic-buck-ramp-delay",
> >> +				&pdata->buck_ramp_delay))
> >> +			pdata->buck_ramp_delay = 0;
> > 
> > Why not initialise pdata->buck_ramp_delay to 0 beforehand?
> > 
> > That way you don't need to check the return value of
> > of_property_read_u32 here.
> > 
> > I note that pdata->buck_ramp_delay is an int, not a u32. Please use a
> > u32 temporary variable.
> 
> I'll fix it
> 
> > 
> >> +	}
> >> +
> > 
> > NAK. None of these seem to be documented in mainline's
> > Documentation/devicetree/bindings/regulator/s5m8767-regulator.txt, nor
> > does documentation seem to be added here. Until there's some description
> > of what these are and why they're needed, I don't think they're
> > suitable.
> 
> I'll add description about this patch.

Cheers.

Mark.
