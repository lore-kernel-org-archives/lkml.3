Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756182Ab3HZHca (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 03:32:30 -0400
Received: from va3ehsobe010.messaging.microsoft.com ([216.32.180.30]:9092 "EHLO
	va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755496Ab3HZHc2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 03:32:28 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -1
X-BigFish: VS-1(zz146fI1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de097hz2dh2a8h839h8e2h8e3h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5hbe9i1155h)
From: Xiubo Li-B47053 <B47053@freescale.com>
To: Thierry Reding <thierry.reding@gmail.com>
CC: Guo Shawn-R65073 <r65073@freescale.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "rob@landley.net" <rob@landley.net>,
        "ian.campbell@citrix.com" <ian.campbell@citrix.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pwm@vger.kernel.org" <linux-pwm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Lu Jingchang-B35083 <B35083@freescale.com>
Subject: RE: [PATCH 1/4] pwm: add freescale ftm pwm driver support
Thread-Topic: [PATCH 1/4] pwm: add freescale ftm pwm driver support
Thread-Index: AQHOnhwdSdSsv5GKTkyhA3muKUAEeJmig5UAgASDWFA=
Date: Mon, 26 Aug 2013 07:32:23 +0000
Message-ID: <1DD289F6464F0949A2FCA5AA6DC23F827E42BD@039-SN2MPN1-012.039d.mgd.msft.net>
References: <1377054462-6283-1-git-send-email-Li.Xiubo@freescale.com>
 <1377054462-6283-2-git-send-email-Li.Xiubo@freescale.com>
 <20130823090523.GF3535@ulmo>
In-Reply-To: <20130823090523.GF3535@ulmo>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.192.208.56]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thierry,

See the comments below.


> I think the correct capitalizations are: "Freescale", "FTM" and "PWM".
> There are other occurrences in the rest of the driver that I haven't
> explicitly pointed out.
> 

Yes, that's much better.


> > +config PWM_FTM
> 
> Perhaps name this PWM_FSL_FTM to match the driver name?
> 

OK.


> And fix this up to be "pwm-fsl-ftm".

Yes, I will.


> > +#define FTM_CSC_BASE        0x0C
> > +#define FTM_CSC(_CHANNEL) \
> > +	(FTM_CSC_BASE + (_CHANNEL * 0x08))
> 
> I prefer lowercase variables in macros:
> 
> 	#define FTM_CSC(channel) \
> 		(FTM_CSC_BASE + (channel * 8))
> 
Yes, That's better.


> > +#define FTM_PWMMODE         (FTMCnSC_MSB)
> > +#define FTM_HIGH_TRUE       (FTMCnSC_ELSB)
> > +#define FTM_LOW_TRUE        (FTMCnSC_ELSA)
> 
> What's the reason for redefining these? Can't you just use the FTMCnSC_*
> defines directly?
> 

Just for more readable and comprehension.
I will revise it by not losing above two key elements. 

> > +#define FTM_CV(_CHANNEL) \
> > +	(FTM_CV_BASE + (_CHANNEL * 0x08))
> 
> Same comment as for FTM_CSC above.
>

Yes.
 
> > +#define FTM_MAX_CHANNEL     0x08
> 
> There should be no need for this. The only place where you use this is
> when assigning it to pwm_chip.npwm, so you may as well use the literal
> there.
> 

I have recoded the driver, and the macro is used more than one time now.


> > +	struct platform_device *pdev;
> 
> You never use this platform_device. And you have to assign &pdev->dev to
> the pwm_chip.dev anyway, so why not just use that consistently and drop
> the pdev field?
>

Yes, I have droped the pdev field now.
 

> > +	unsigned int	cpwm;
> > +	struct fsl_pwm fpwms[FTM_MAX_CHANNEL];
> 
> Please don't do this. Use pwm_set_chip_data()/pwm_get_chip_data() to
> associate per-channel specific data.
>

I have replaced them now.
 
> > +	/* pinctrl handles */
> 
> Nit: it's only a single handle.
> 

Yes.

> > +	struct pinctrl          *pinctrl;
> 
> You also use tabs and spaces inconsistently here. I suggest you use a
> single space between the data type and the field name, that way it's much
> easier to stay consistent.
> 

Now I have revised all about this.

> > +static int fsl_pwm_request_channel(struct pwm_chip *chip,
> > +			       struct pwm_device *pwm)
> 
> The arguments on the trailing line aren't properly aligned. They should
> be aligned with the arguments on the first line.
> 

The same as the above comment.


> > +	ret = clk_prepare_enable(fpc->clk);
> 
> This should probably be just clk_prepare(). Or is there some reason why
> you can't delay clk_enable() to the .enable() operation?
> 

Firstly, we should be clear that the fpc->clk is chip's work clock.
If so, after the .request() is called and before .enable() is called, the custumer will call .config(), 
in which will read/write the pwm chip registers, if the module clock is still disabled, then the system will hang up.


> > +static int fsl_updata_config(struct fsl_pwm_chip *fpc,
> > +			     struct pwm_device *pwm)
> 
> Parameter alignment again. Please also check all other functions.
> 

Yes, I have revise all about this.

> > +{
> > +	int i;
> 
> This should be unsigned int.
> 

I will revise it.

> > +static unsigned long
> > +fsl_rate_to_cycles(struct fsl_pwm_chip *fpc, int time_ns)
> 
> The above two lines are 78 characters when joined, so there's no need to
> split them.
> 

OK, I have revise all about this.

> Perhaps time_ns should be "unsigned long"?
> 

Shouldn't this be same with "int duty_ns" and "int period_ns", which are defined by 
struct pwm_ops {
...
	int (*config)(struct pwm_chip *chip,
                    struct pwm_device *pwm,
                    int duty_ns, int period_ns);
...
}  ?


> > +	ps = (0x01 << fpc->clk_ps);
> 
> This is fairly short, so you could do it along with the variable
> declaration. Also there's no need for the parentheses or the hexadecimal
> prefix (0x01 == 1):
> 
> 	unsigned long ps = 1 << fpc->clk_ps;
> 

OK, I will revise it then.

> > +	/* The module clk is HZ/s, the time_ns parameter
> > +	 * is based nanosecond, so here should divide
> > +	 * 1000000000UL.
> > +	 */
> 
> Block comments should be:
> 
> 	/*
> 	 * ...
> 	 * ...
> 	 */
> 
> Also HZ/s isn't a valid unit for a clock frequency. And time_ns also has
> the _ns suffix to designate the unit, so as a whole that comment doesn't
> add any real information and can just as well be dropped.
> 

I will revise it.

> > +static int fsl_pwm_config_channel(struct pwm_chip *chip,
> 
> I think you can safely drop the _channel suffix from the PWM operations.
> 

By adding _channel suffix just for more comprehensave about the pwm's muti-channel operation.
If this is redundant here, I will drop it.


> > +	fpc = to_fsl_chip(chip);
> > +
> > +	if (WARN_ON(!test_bit(PWMF_REQUESTED, &pwm->flags)))
> > +		return -ESHUTDOWN;
> 
> Erm... how do you think this could ever happen? Users need to request a
> PWM to obtain a struct pwm_device, in which case PWMF_REQUESTED will
> always be set. There are a few other occurrences throughout the rest of
> the driver that I haven't pointed out explicitly.
> 

Does the following case is exist ?
The customer in one thread has .free(pwm_1), while in another thread, 
which maybe had slept in for some reason, will call .config/.enable/.disable?

If so, as I have explained before, if the pwm_1 has been freed, the module clock maybe
disabled too, so if the .config is call the system will hang up.



> > +	fpc->fpwms[pwm->hwpwm].period_cycles = period_cycles;
> > +	fpc->fpwms[pwm->hwpwm].duty_cycles = duty_cycles;
> 
> You use these for the sole purpose of passing them into the
> fsl_updata_config() function, so I wonder why you can't just pass them as
> parameters and get rid of struct fsl_pwm as a bonus?
> 

Before I think the fpc has all the information the fsl_update_config() function needed.

Now, I have dropt the fsl_update_config() function.


> > +	fsl_updata_config(fpc, pwm);
> 
> And now that I think about it: perhaps this was supposed to be called
> fsl_update_config() instead of fsl_updat*a*_config()?
> 
Well, a written mistake.


> > +	reg &= ~(0x01 << pwm->hwpwm);
> 
> This would be slightly more canonical as:
> 
> 	reg &= ~BIT(pwm->hwpwm);
> 

Yes, looks much better.

> > +	reg |= (polarity << pwm->hwpwm);
> 
> And perhaps here it would be better to be explicit. I think it's unlikely
> that enum pwm_polarity will even gain a third entry, but better be safe
> than sorry:
> 
> 	if (polarity == PWM_POLARITY_INVERSED)
> 		reg |= BIT(pwm->hwpwm);
> 	else
> 		reg &= ~BIT(pwm->hwpwm);
> 

I will think it over.
While only the polarity's bit0 is used for polarity's statement. If other bit won't has any other
meaning and purpose in the feature, I will replace it derictly.

> > +static int is_any_other_channel_enabled(struct pwm_chip *chip,
> > +				    unsigned int cur)
> > +{
> > +	int i;
> > +
> > +	for (i = 0; i < chip->npwm; i++) {
> > +		if (i == cur)
> > +			continue;
> > +		if (test_bit(PWMF_ENABLED, &chip->pwms[i].flags))
> > +			return 1;
> > +	}
> > +
> > +	return 0;
> > +}
> 
> This can probably be better done using a reference/enable count. Instead
> of having to iterate over all PWM channels of the chip and checking their
> flags, just keep track of how many times .enable() and .disable() are
> called.
> 
> To make it easier you can probably wrap that into two functions, such as
> fsl_clock_enable() and fsl_clock_disable().
> 
> > +static int fsl_pwm_enable_channel(struct pwm_chip *chip,
> > +			      struct pwm_device *pwm)
> > +{
> [...]
> > +	if (is_any_other_channel_enabled(chip, pwm->hwpwm))
> > +		return 0;
> 
> This is where you'd call fsl_clock_enable()...
> 
> > +	reg = readl(fpc->base + FTM_SC);
> > +	reg &= ~((FTMSC_CLK_MASK << FTMSC_CLK_OFFSET) |
> > +			(FTMSC_PS_MASK << FTMSC_PS_OFFSET));
> > +	/* select system clock source */
> > +	reg |= (FTMSC_CLKSYS | fpc->clk_ps);
> > +	writel(reg, fpc->base + FTM_SC);
> 
> ... and run this code in fsl_clock_enable() if the enable count is 0 to
> select the system clock when the first PWM is enabled.
> 
> > +static void fsl_pwm_disable_channel(struct pwm_chip *chip,
> > +				struct pwm_device *pwm)
> > +{
> [...]
> > +	if (is_any_other_channel_enabled(chip, pwm->hwpwm))
> > +		return;
> 
> Then call fsl_clock_disable() here...
> 
> > +	writel(0xFF, fpc->base + FTM_OUTMASK);
> > +	reg = readl(fpc->base + FTM_SC);
> > +	reg &= ~(FTMSC_CLK_MASK << FTMSC_CLK_OFFSET);
> > +	writel(reg, fpc->base + FTM_SC);
> 
> ... and run this code in fsl_clock_disable() if the enable count reaches
> 0 so that the clock is disabled when no PWM channels remain on.
> 

I will think it over and recode about this.


> > +static int fsl_pwm_parse_dt(struct fsl_pwm_chip *fpc) {
> [...]
> > +	int ret = 0;
> > +	u32 chs[FTM_MAX_CHANNEL];
> > +	struct device_node *np = fpc->pdev->dev.of_node;
> > +
> > +	ret = of_property_read_u32(np, "fsl,pwm-clk-ps",
> > +				   &fpc->clk_ps);
> > +	if (ret < 0) {
> > +		dev_err(&fpc->pdev->dev,
> > +				"failed to get pwm "
> > +				"clk prescaler : %d\n",
> > +				ret);
> 
> Perhaps it's more useful to mention the missing property explicitly in
> the error message:
> 
> 		dev_err(fpc->chip.dev,
> 			"failed to parse \"fsl,pwm-clk-ps\" property: %d\n",
> 			ret);
> 

Whil I think the following is better in code. 
 
 		dev_err(fpc->chip.dev,
 			"failed to parse <fsl,pwm-clk-ps> property: %d\n",
 			ret);



> 
> > +		return ret;
> > +	}
> > +	if (fpc->clk_ps > 7 || fpc->clk_ps < 0)
> 
> clk_ps is unsigned and therefore can't be < 0. And a blank line would be
> useful between the previous line ("}") and this line.
> 

I will revise it.

> > +static int fsl_pwm_probe(struct platform_device *pdev) {
> > +	int ret = 0;
> > +	struct fsl_pwm_chip *fpc;
> > +	struct resource *res;
> > +
> > +	fpc = devm_kzalloc(&pdev->dev, sizeof(*fpc), GFP_KERNEL);
> > +	if (!fpc) {
> > +		dev_err(&pdev->dev,
> > +				"failed to allocate memory\n");
> 
> I don't think that's very useful either. If this should indeed ever fail,
> then the driver core will complain about the probe failing and include
> the error code. Since it's the only location where you return that error
> code you know immediately what went wrong.
> 

Yes, for the devm_kzlloc() have print out the fail reason, this will be redundant.
I have revised all about this.

> > +		return -ENOMEM;
> > +	}
> > +
> > +	mutex_init(&fpc->lock);
> > +
> > +	fpc->pdev = pdev;
> > +
> > +	ret = fsl_pwm_parse_dt(fpc);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > +	fpc->base = devm_ioremap_resource(&pdev->dev, res);
> > +	if (IS_ERR(fpc->base)) {
> > +		dev_err(&pdev->dev,
> > +				"failed to ioremap() registers\n");
> 
> No need for this error message. devm_ioremap_resource() prints out errors
> already on failure.
> 

The same comment as the last one.

> > +	fpc->chip.dev = &pdev->dev;
> > +	fpc->chip.ops = &fsl_pwm_ops;
> > +	fpc->chip.of_xlate = of_pwm_xlate_with_flags;
> > +	fpc->chip.of_pwm_n_cells = 3;
> > +	fpc->chip.base = -1;
> > +
> > +	ret = pwmchip_add(&fpc->chip);
> > +	if (ret < 0) {
> > +		dev_err(&pdev->dev,
> > +				"failed to add ftm0 pwm chip %d\n",
> > +				ret);
> 
> dev_err() will already include the device name in the error message, so I
> don't think you need the "ftm0" here. Also make sure to use the correct
> capitalization for "PWM". And there is no need to split this over so many
> lines, it all fits on a single line just fine. There are other
> occurrences of this, so please double-check.
> 

Yes.
I have revise all about this.



Thanks very much.

--
Best Regards.
Xiubo

