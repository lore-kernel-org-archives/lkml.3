Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754905AbaI2NiK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 09:38:10 -0400
Received: from mail.kapsi.fi ([217.30.184.167]:52447 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754654AbaI2NiH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 09:38:07 -0400
Message-ID: <542960B2.1010200@kapsi.fi>
Date: Mon, 29 Sep 2014 16:37:54 +0300
From: Mikko Perttunen <mikko.perttunen@kapsi.fi>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>
CC: Mikko Perttunen <cyndis@kapsi.fi>, edubezval@gmail.com,
        swarren@wwwdotorg.org, linux-pm@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, juha-matti.tilli@iki.fi,
        Mikko Perttunen <mperttunen@nvidia.com>
Subject: Re: [PATCH v6 4/4] thermal: Add Tegra SOCTHERM thermal management
 driver
References: <1411724593-4037-1-git-send-email-cyndis@kapsi.fi> <1411724593-4037-5-git-send-email-cyndis@kapsi.fi> <20140926114533.GN31106@ulmo> <5425CC6F.2020309@kapsi.fi> <20140929082904.GF12506@ulmo>
In-Reply-To: <20140929082904.GF12506@ulmo>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:708:30:12d0:beee:7bff:fe5b:f272
X-SA-Exim-Mail-From: mikko.perttunen@kapsi.fi
X-SA-Exim-Scanned: No (on mail.kapsi.fi); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/29/2014 11:29 AM, Thierry Reding wrote:
> On Fri, Sep 26, 2014 at 11:28:31PM +0300, Mikko Perttunen wrote:
>> On 09/26/2014 02:45 PM, Thierry Reding wrote:
> [...]
>>> I think a more idiomatic way to write this would be:
>>>
>>> static int
>>> calculate_tsensor_calibration(const struct tegra_tsensor *sensor,
>>> 			      struct tsensor_shared_calibration shared,
>>> 			      u32 *calib)
>>
>> If I do that, it will go over the 80 character limit by quite a few
>> characters, which is why I didn't use that style. Personally I'm fine with
>> either style.
>
> The above doesn't exceed the 80 character limit. Putting the return
> value and the static keyword on a separate line is a pretty common way
> to reduce line length.

Good point, I didn't think of doing that. I usually never use the above 
style, but clearly here it is the best choice.

>
>>>
>>> While at it, perhaps make shared a const * instead of passing it in by
>>> value?
>>
>> That is possible, but I'm not sure what the difference would be. Is there a
>> style rule forbidding by-value compound types? (Also if I change the style,
>> it would go over 80 characters by even more.)
>
> No it doesn't. The below fits within 80 characters per line just fine:
>
> static int
> calculate_tsensor_calibration(const struct tegra_tsensor *sensor,
> 			      const struct tsensor_shared_calibration *shared,
> 			      u32 *calib)
>
> Thierry
>

