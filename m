Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754458AbaB0AUG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 19:20:06 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:54043 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752867AbaB0AUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 19:20:04 -0500
Message-ID: <530E84B3.8020608@codeaurora.org>
Date: Wed, 26 Feb 2014 16:20:03 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Josh Cartwright <joshc@codeaurora.org>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 1/9] Input: pmic8xxx-pwrkey - Migrate to regmap APIs
References: <1393441562-685-1-git-send-email-sboyd@codeaurora.org> <1393441562-685-2-git-send-email-sboyd@codeaurora.org> <20140226235959.GD18563@joshc.qualcomm.com> <530E8154.9060403@codeaurora.org> <20140227001358.GF18563@joshc.qualcomm.com>
In-Reply-To: <20140227001358.GF18563@joshc.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/26/14 16:13, Josh Cartwright wrote:
> On Wed, Feb 26, 2014 at 04:05:40PM -0800, Stephen Boyd wrote:
>> On 02/26/14 15:59, Josh Cartwright wrote:
>>> On Wed, Feb 26, 2014 at 11:05:54AM -0800, Stephen Boyd wrote:
>>>> Use the regmap APIs for this driver instead of custom pm8xxx
>>>> APIs. This breaks this driver's dependency on the pm8xxx APIs and
>>>> allows us to easily port it to other bus protocols in the future.
>>>>
>>>> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
>>>> ---
>>>>  drivers/input/misc/pmic8xxx-pwrkey.c | 4 ++++
>>>>  1 file changed, 4 insertions(+)
>>>>
>>>> diff --git a/drivers/input/misc/pmic8xxx-pwrkey.c b/drivers/input/misc/pmic8xxx-pwrkey.c
>>>> index 0e1a05f95858..cf6125dc3b51 100644
>>>> --- a/drivers/input/misc/pmic8xxx-pwrkey.c
>>>> +++ b/drivers/input/misc/pmic8xxx-pwrkey.c
>>>> @@ -120,6 +120,10 @@ static int pmic8xxx_pwrkey_probe(struct platform_device *pdev)
>>>>  		return -ENOMEM;
>>>>  	}
>>>>  
>>>> +	regmap = dev_get_regmap(pdev->dev.parent, NULL);
>>>> +	if (!regmap)
>>>> +		return -ENODEV;
>>>> +
>>> This looks really weird.  A previous version of patch was included in
>>> v3.14-rc1 (1e63bd9cc4), which already included a very similar hunk...
>>>
>>> Maybe the fact that the hunk isn't identical is why a rebase didn't drop
>>> it (and instead, now if this gets merged, we'll have unnecessary
>>> duplication).
>>>
>> Ah yeah, sorry about that. This patch should just be ignored. I don't
>> think it affects anything else in the series?
> Yep, I think this can be safely ignored.
>
> However, I think it needs to be made clear that your if "Modernize pm8921
> with irqdomains, regmap, DT" lands before this patchset, this will start
> breaking randconfig builds.  It isn't clear to me how this dependency
> should be handled.
>

Hmm? If pm8921 lands before this what build breakage is there? The
pm8xxx_read/write APIs are still exposed.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

