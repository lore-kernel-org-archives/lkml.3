Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753538AbaCGOkv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 09:40:51 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:31523 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930AbaCGOkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 09:40:49 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-4a-5319da6eee98
Message-id: <5319DA6C.1050204@samsung.com>
Date: Fri, 07 Mar 2014 15:40:44 +0100
From: Robert Baldyga <r.baldyga@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.3.0
MIME-version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: sameo@linux.intel.com, lee.jones@linaro.org, myungjoo.ham@samsung.com,
        cw00.choi@samsung.com, cooloney@gmail.com, rpurdie@rpsys.net,
        dbaryshkov@gmail.com, dwmw2@infradead.org, lgirdwood@gmail.com,
        broonie@kernel.org, a.zummo@towertech.it, paul.gortmaker@windriver.com,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        linux-leds@vger.kernel.org, rtc-linux@googlegroups.com,
        m.szyprowski@samsung.com, k.kozlowski@samsung.com
Subject: Re: [PATCH v2] mfd: max8997: use regmap to access registers
References: <1394031497-16648-1-git-send-email-r.baldyga@samsung.com>
 <20140305185439.GC5453@core.coreip.homeip.net> <531818D6.3080500@samsung.com>
 <20140306162951.GA14318@core.coreip.homeip.net>
In-reply-to: <20140306162951.GA14318@core.coreip.homeip.net>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEIsWRmVeSWpSXmKPExsVy+t/xq7p5tySDDVZ/4rdYcvEqu8XUh0/Y
	LI7unMhkcf3Lc1aLSU/eM1scXvSC0WLiysnMFq9fGFrc/3qU0eLblQ4mi5ufvrFaXN41h81i
	65t1jBZrj9xlt7jduILN4tre48wWu3c9ZbXY39nBaHG6m9VB2GPnrLvsHnsmnmTz2LxCy2PT
	qk42jzvX9rB5zDsZ6LFn/g9Wj74tqxg9ps/7yeTxeZOcx/otW5kCuKO4bFJSczLLUov07RK4
	Mqb/P8ZecISrYv5BxQbGbRxdjJwcEgImEocvP2GGsMUkLtxbzwZiCwksZZSYN4Wzi5ELyP7I
	KPFo+QXGLkYODl4BLYnHG9lATBYBVYkLbxNBytkEdCS2fJ/ACGKLCkRIzJ24GWwMr4CgxI/J
	91hAbBEBfYnts38xgoxkFjjILLF5whZWkISwgIvE5jtPmSF2HWeU2HFlIVgHp4CNxN+O/WDH
	MQNt2N86jQ3ClpfYvOYt8wRGgVlIlsxCUjYLSdkCRuZVjKKppckFxUnpuYZ6xYm5xaV56XrJ
	+bmbGCHx+GUH4+JjVocYBTgYlXh4DRZIBAuxJpYVV+YeYpTgYFYS4eVZLRksxJuSWFmVWpQf
	X1Sak1p8iJGJg1OqgbG74Khw/iWW3TKCWVvXTHqVpLtJU07owac1iglH93hqagl6+Nx5+13S
	iGubjdT8L0Uhv+623gubHD9R+ohh+OSm0ghpw2s1nOk8F47V652YaPL9eRyLSPfudoeiKs3L
	tV+dT+X9/ZSTavFz4tWu5odld2WPKJwsXCC34noIv9nqzSLpkt29m5RYijMSDbWYi4oTAQDi
	p7elAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06/2014 05:29 PM, Dmitry Torokhov wrote:
> On Thu, Mar 06, 2014 at 07:42:30AM +0100, Robert Baldyga wrote:
>> Hi,
>>
>> On 03/05/2014 07:54 PM, Dmitry Torokhov wrote:
>>> Hi Robert,
>>>
>>> On Wed, Mar 05, 2014 at 03:58:17PM +0100, Robert Baldyga wrote:
>>>>  
>>>> -int max8997_write_reg(struct i2c_client *i2c, u8 reg, u8 value)
>>>> +int max8997_write_reg(struct regmap *map, u8 reg, u8 value)
>>>
>>> Why don't you make read/write reg to take struct max8997_dev as argument
>>> instead of regmap? regmap seems to be the current implementation du jur,
>>> but that is core's detail, functions do not need to care.
>>>
>>> Thanks.
>>>
>>
>> It's because there are few regmaps in max8997_dev, and read/write reg
>> functions has no way to check which regmap should be used. I think it
>> would be clearer if I remove this functions and use regmap_read and
>> regmap_write instead, because there is no particular purpose for them.
> 
> I see.. Then another question - why do the regmaps belong to the core
> of the driver instead of individual functions? Why haptic regmap, for
> example, can not be initialized in haptic code instead?
> 

It looks like it would not be a big problem. I will try to prepare new
version of this patch including this.

Best regards
Robert Baldyga
Samsung R&D Institute Poland
