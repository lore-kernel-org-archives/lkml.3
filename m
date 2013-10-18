Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932255Ab3JRTyL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 15:54:11 -0400
Received: from smtp.newsguy.com ([74.209.136.69]:49640 "EHLO smtp.newsguy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932206Ab3JRTyH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 15:54:07 -0400
Message-ID: <526191C5.7060705@newsguy.com>
Date: Fri, 18 Oct 2013 12:53:41 -0700
From: Mike Dunn <mikedunn@newsguy.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.6
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>
CC: Richard Purdie <rpurdie@rpsys.net>, Jingoo Han <jg1.han@samsung.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, linux-pwm@vger.kernel.org,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Robert Jarzmik <robert.jarzmik@free.fr>,
        Marek Vasut <marex@denx.de>
Subject: Re: [PATCH v2] pwm-backlight: allow for non-increasing brightness
 levels
References: <1379869196-19377-1-git-send-email-mikedunn@newsguy.com> <20131018074623.GA22291@ulmo.nvidia.com>
In-Reply-To: <20131018074623.GA22291@ulmo.nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/18/2013 12:46 AM, Thierry Reding wrote:
> On Sun, Sep 22, 2013 at 09:59:56AM -0700, Mike Dunn wrote:
>> Currently the driver assumes that the values specified in the
>> brightness-levels device tree property increase as they are parsed from
>> left to right.  But boards that invert the signal between the PWM output
>> and the backlight will need to specify decreasing brightness-levels.
>> This patch removes the assumption that the last element of the array is
>> the maximum value, and instead searches the array for the maximum value
>> and uses that in the duty cycle calculation.
>>
>> Signed-off-by: Mike Dunn <mikedunn@newsguy.com>
>> ---
>> Changelog:
>> v2: 
>> - commit message reworded; correct line wrap used
>> - 'max_level' variable renamed to 'scale'
>> - loop counter variable type changed to unsigned int
>> - value held in scale changed from array index to actual maximum level
>> - blank lines added around loop for readability
>>
>>  drivers/video/backlight/pwm_bl.c | 12 ++++++++++--
>>  1 file changed, 10 insertions(+), 2 deletions(-)
> 
> Hey Mike,
> 
> I've pushed a slightly different version of this patch which gets rid of
> the intermediate max variable and uses the new scale field exclusively
> to pass the same information around. Could you look at the patch from my
> for-next branch in the PWM tree and see whether that still works for the
> specific hardware that you need this for?


Yes looks good.

I also tested the current HEAD of for-next on the Palm Treo 680, including the
enable-gpios DT node property.  I will have to do more work and investigation
before I will be able to try the power-supply property, though.

Thanks,
Mike

