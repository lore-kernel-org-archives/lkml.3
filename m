Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755676AbaEAL3S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 07:29:18 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:37855 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753142AbaEAL3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 07:29:15 -0400
Message-ID: <53623004.5010805@linaro.org>
Date: Thu, 01 May 2014 16:59:08 +0530
From: Tushar Behera <tushar.behera@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: alsa-devel@alsa-project.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        devicetree@vger.kernel.org, lgirdwood@gmail.com, robh+dt@kernel.org,
        sbkim73@samsung.com, rdunlap@infradead.org, dianders@chromium.org
Subject: Re: [PATCH V2] ASoC: SAMSUNG: Add sound card driver for Snow board
References: <1398243705-31151-1-git-send-email-tushar.behera@linaro.org> <20140424133920.GA12304@sirena.org.uk> <5359E18B.60600@linaro.org> <20140429222915.GU15125@sirena.org.uk> <5360E5E7.8090807@linaro.org> <20140430180314.GA3245@sirena.org.uk>
In-Reply-To: <20140430180314.GA3245@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/30/2014 11:33 PM, Mark Brown wrote:
> On Wed, Apr 30, 2014 at 05:30:39PM +0530, Tushar Behera wrote:
> 
>> XCLKOUT mux register (0x10040a00) is not part of core clock SFR range,
>> rather it is part of pmu-system-controller node.
> 
>> One option would be to add a clock provider for XCLKOUT. That would
>> require me to extend current clock driver to get the
>> pmu-system-controller phandle which in turn is dependent on the patch to
>> early initialize syscon driver.[1]
> 
>> Will it be okay to configure XCLKOUT in snow sound-card driver by taking
>> the phandle of pmu-system-controller from device tree? The
>> implementation is provided below.
> 
> I can't think of any reason why we'd not want to have this visible as a
> clock?  Ideally we don't want to have any ASoC specific clock APIs when
> we're done, the reason we do at the minute is that the clock API isn't
> available as standard.
> 

Okay, I will extend the existing clock driver to support XCLKOUT.

Of the many parents of XCLKOUT, we need to set XXTI clock as the parent.
Is it okay if we pass two clocks "mclk" (XCLKOUT) and "mclk_parent"
(XXTI) to sound-card driver via DT and do the necessary reparenting
during the sound-card driver probe call?

Else, we can push that change to bootloader (to set the XCLKOUT mux
register) and only enable/disable the clock in sound-card driver.

Let me know your opinion on this.

-- 
Tushar Behera
