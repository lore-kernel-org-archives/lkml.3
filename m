Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753236AbaLDJmu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 04:42:50 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.140]:42247 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751391AbaLDJmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 04:42:49 -0500
Message-ID: <54802C75.9060609@arm.com>
Date: Thu, 04 Dec 2014 09:42:13 +0000
From: Andrew Jackson <Andrew.Jackson@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rajeev Kumar <rajeevkumar.linux@gmail.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Liviu Dudau <Liviu.Dudau@arm.com>
Subject: Re: [PATCH 4/5] ASoC: dwc: Add devicetree support for Designware
 I2S
References: <547F3CAC.9050105@arm.com> <20141203182351.GF7712@sirena.org.uk>
In-Reply-To: <20141203182351.GF7712@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/14 18:23, Mark Brown wrote:
> On Wed, Dec 03, 2014 at 04:39:08PM +0000, Andrew Jackson wrote:
> 
>> Convert to driver to use either platform_data or device-tree for configuration
>> of the device.  When using device-tree, the I2S block's configuration is read
>> from the relevant registers: this reduces the amount of information required in
>> the device tree.
> 
> This really needs to be split into two or more patches, there's a whole
> bunch of refactoring to support this DT stuff which should be separate
> from the DT addition itself.  Right now it's hard to tell what each
> individual bit of the code is supposed to be doing, the patch is far too
> large and doing far too many individual things.

I will have look at how it might be split.  The majority of the new code is in reading and processing the device's configuration: I didn't want to change the platform data handling to do that because some of the comments in the driver suggested that there were ST specific changes to the Designware IP.  I wasn't in a position to know whether, if I changed the configuration reading, the driver would still function correctly on the SPEAR platform.

>> +	if (dev->using_pd) {
>> +		ret = dev->i2s_clk_cfg(config);
>> +		if (ret < 0) {
>> +			dev_err(dev->dev, "runtime audio clk config fail\n");
>> +			return ret;
>> +		}
>> +	} else {
>> +		u32	bitclk;
> 
> Having this whole separate path for using platform data feels icky, we
> don't want to have completely separate flows like this.  Checking for
> the callbacks being there is probably fine but just having totally
> separate code paths is a bit icky.

I wasn't very happy either but making the test explicit seemed reasonable at the time.  I'll change the code to test for the presence of the callback instead.

	Andrew



