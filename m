Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757848AbaFYSLV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 14:11:21 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:60623 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752600AbaFYSLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 14:11:19 -0400
Message-ID: <53AB10C0.9050803@collabora.co.uk>
Date: Wed, 25 Jun 2014 20:11:12 +0200
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Doug Anderson <dianders@chromium.org>
CC: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Kukjin Kim <kgene.kim@samsung.com>, Olof Johansson <olof@lixom.net>,
        Sjoerd Simons <sjoerd.simons@collabora.co.uk>,
        Daniel Stone <daniels@collabora.com>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 02/14] mfd: max77686: Allow the max77686 rtc to wakeup
 the system
References: <1403202040-12641-1-git-send-email-javier.martinez@collabora.co.uk>	<1403202040-12641-3-git-send-email-javier.martinez@collabora.co.uk>	<1403690742.22107.7.camel@AMDC1943>	<53AAA4A3.50400@collabora.co.uk> <CAD=FV=UQfJfUUN4rnnCw2Pah-5BukL2SzhTskRVcvvzp8f+isA@mail.gmail.com>
In-Reply-To: <CAD=FV=UQfJfUUN4rnnCw2Pah-5BukL2SzhTskRVcvvzp8f+isA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2014 07:24 PM, Doug Anderson wrote:
> Hi,
> 
> On Wed, Jun 25, 2014 at 3:29 AM, Javier Martinez Canillas
> <javier.martinez@collabora.co.uk> wrote:
>> Yes, the original Chrome OS 3.8 max77xxx also called the irq worker thread to
>> ack the interrupt.
>>
>> So the real problem is that an interrupt occurs before the I2C bus controller is
>> resumed and so the interrupt handler is not able to access the registers over I2C.
>>
>> Doug posted the following patches [0,1] that AFAIU solves the issue by making
>> I2C controllers to be resumed in the noirq time to ensure that drivers will be
>> able to use the I2C bus to handler their wakeup.
> 
> Yup, that's the solution as far as I know.  I know that in ChromeOS we
> still have the extra call to the worker thread (despite the controller
> waking up early), but that might be related to some other problem?
> 
> I was able to successfully suspend/resume multiple times once I woke
> the i2c controller up earlier.
> 
> If you feel like adding Reviewed-by / Tested-by to my i2c patch then
> feel free!  ;)
> 
> 

Done :)

>> In fact, Doug's original patch had this as a part of the commit message:
>>
>> NOTE: due to wakeup ordering problems this patch alone doesn't work so
>> well on exynos5250-snow.  You also need something that brings the i2c
>> bus up before the max77686 wakeup runs.
>>
>> I removed that note since I (probably wrong) thought that he didn't mean it to
>> be part of the commit message but just was side information.
> 
> I probably would have left that in the patch, but I'm not objecting to
> you taking it out.  :)
> 

Yes, I should had left that as well. I'll send a v4 shortly and will include the
note again.

Best regards,
Javier
