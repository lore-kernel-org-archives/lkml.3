Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751574AbaCFGmi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 01:42:38 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:24179 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972AbaCFGmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 01:42:36 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-ce-531818d8dc1c
Message-id: <531818D6.3080500@samsung.com>
Date: Thu, 06 Mar 2014 07:42:30 +0100
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
 <20140305185439.GC5453@core.coreip.homeip.net>
In-reply-to: <20140305185439.GC5453@core.coreip.homeip.net>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEIsWRmVeSWpSXmKPExsVy+t/xK7o3JCSCDb7ulrdYcvEqu8XUh0/Y
	LI7unMhkcf3Lc1aLSU/eM1scXvSC0WLiysnMFq9fGFrc/3qU0eLblQ4mi5ufvrFaXN41h81i
	65t1jBZrj9xlt7jduILN4tre48wWu3c9ZbXY39nBaHG6m9VB2GPnrLvsHnsmnmTz2LxCy2PT
	qk42jzvX9rB5zDsZ6LFn/g9Wj74tqxg9ps/7yeTxeZOcx/otW5kCuKO4bFJSczLLUov07RK4
	Mrp2xBTcZ6u4+uQ3ewPjBtYuRk4OCQETiddvlrBD2GISF+6tZ+ti5OIQEljKKDG99RWU85FR
	4tyffqYuRg4OXgEtiT0LVEBMFgFViff/c0F62QR0JLZ8n8AIYosKREjMnbiZDcTmFRCU+DH5
	HguILSKgL7F99i9GkJHMAgeZJTZP2AJ2hLCAi8TmO0+ZQWwhgTKJ1R2nwAZxClhLfL70HWwQ
	M9CC/a3ToGx5ic1r3jJPYBSYhWTHLCRls5CULWBkXsUomlqaXFCclJ5rqFecmFtcmpeul5yf
	u4kREo9fdjAuPmZ1iFGAg1GJh3eDn3iwEGtiWXFl7iFGCQ5mJRHeh0+AQrwpiZVVqUX58UWl
	OanFhxiZODilGhhnels/kWp6VntpC8/+jJ8Gf3ret2/1W+o371GMV8ad2Hca5avuV1gy3DZI
	Zvxvc0ysS2r9q8sMe0PVgnS69xVLC0TzBWerB6c1F7Q/fNbkULEzo7VYeMuB+N3sXvOZW7uL
	WpUXH6+J1/kumJX9dts15UgGFfu91XWLnD+k6+0/qC3a8KpvpRJLcUaioRZzUXEiANMZHq2l	AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 03/05/2014 07:54 PM, Dmitry Torokhov wrote:
> Hi Robert,
> 
> On Wed, Mar 05, 2014 at 03:58:17PM +0100, Robert Baldyga wrote:
>>  
>> -int max8997_write_reg(struct i2c_client *i2c, u8 reg, u8 value)
>> +int max8997_write_reg(struct regmap *map, u8 reg, u8 value)
> 
> Why don't you make read/write reg to take struct max8997_dev as argument
> instead of regmap? regmap seems to be the current implementation du jur,
> but that is core's detail, functions do not need to care.
> 
> Thanks.
> 

It's because there are few regmaps in max8997_dev, and read/write reg
functions has no way to check which regmap should be used. I think it
would be clearer if I remove this functions and use regmap_read and
regmap_write instead, because there is no particular purpose for them.

Best regards
Robert Baldyga
Samsung R&D Institute Poland
