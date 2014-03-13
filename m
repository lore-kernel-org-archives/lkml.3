Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123AbaCMKxF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 06:53:05 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:39928 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753388AbaCMKxC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 06:53:02 -0400
X-AuditID: cbfec7f5-b7fc96d000004885-ae-53218e0a22ac
Message-id: <53218E09.1040200@samsung.com>
Date: Thu, 13 Mar 2014 11:52:57 +0100
From: Robert Baldyga <r.baldyga@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.3.0
MIME-version: 1.0
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: sameo@linux.intel.com, lee.jones@linaro.org, myungjoo.ham@samsung.com,
        dmitry.torokhov@gmail.com, cooloney@gmail.com, rpurdie@rpsys.net,
        dbaryshkov@gmail.com, dwmw2@infradead.org, lgirdwood@gmail.com,
        broonie@kernel.org, a.zummo@towertech.it, paul.gortmaker@windriver.com,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        linux-leds@vger.kernel.org, rtc-linux@googlegroups.com,
        m.szyprowski@samsung.com, k.kozlowski@samsung.com
Subject: Re: [PATCH v3 0/4] mfd: max8997: add regmap support
References: <1394703532-494-1-git-send-email-r.baldyga@samsung.com>
 <53218786.7010208@samsung.com>
In-reply-to: <53218786.7010208@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMIsWRmVeSWpSXmKPExsVy+t/xK7pcfYrBBmufW1osuXiV3WLqwyds
	Fkd3TmSyuP7lOavFpCfvmS0OL3rBaDFx5WRmi9cvDC3ufz3KaPHtSgeTxc1P31gtLu+aw2ax
	9c06Rou1R+6yW9xuXMFmcW3vcWaL3bueslrs7+xgtDjdzeog7LFz1l12jz0TT7J5bF6h5bFp
	VSebx51re9g85p0M9Ngz/werR9+WVYwe0+f9ZPL4vEnOY/2WrUwB3FFcNimpOZllqUX6dglc
	GXMWvmQrOCxcsWdicAPjRP4uRk4OCQETiUk7VjNB2GISF+6tZ+ti5OIQEljKKHH3/jVmCOcj
	o8STA9PBqngFtCSWPFrNBmKzCKhK9PxYzw5iswnoSGz5PoERxBYViJCYO3EzG0S9oMSPyfdY
	QGwRAQ2JmX+vgNUwCxxllnjfIAdiCwvYSCxqXcoMYgsJpEjM3b4fzOYU0JbY/XYrG0S9jsT+
	1mlQtrzE5jVvmScwCsxCsmIWkrJZSMoWMDKvYhRNLU0uKE5KzzXSK07MLS7NS9dLzs/dxAiJ
	yK87GJceszrEKMDBqMTDG7BUIViINbGsuDL3EKMEB7OSCG9uj2KwEG9KYmVValF+fFFpTmrx
	IUYmDk6pBsZGrln5FY5SOS3B/REh1o8DDu36dPf+qthYrq+THm0S/+17ZNm0VTtnxbr0/M7T
	3Xi1MybRfMM1c12hpZ8CvGdtvTujYbZZ4A6X9tbKhElOea7KNxlONPLlmIv33/iWKnKkVCmn
	aOGFvt+2r4uVOd9Efvtcz7DJatFZppKt+RPmOVz7dEdkMasSS3FGoqEWc1FxIgCsIGv4pgIA	AA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 03/13/2014 11:25 AM, Chanwoo Choi wrote:
> Hi Robert,
> 
> On 03/13/2014 06:38 PM, Robert Baldyga wrote:
>> Hi,
>>
>> This patchset modifies max8997 driver and associated function drivers to use
>> register maps instead of operating directly on i2c bus. This change allowed
>> to simplify irq handling, and to move some initializations to individual
>> function drivers. Hence now when some functions are not enabled, their i2c
>> clients, regmaps and irqs are not registered.
>>
>> Best regards
>> Robert Baldyga
>> Samsung R&D Institute Poland
>>
>> Changelog:
>>
>> v3:
>> - fix error handling
>> - fix deinitializations order
>> - move muic irq enum values renaming to separate patch
>>
>> v2: https://lkml.org/lkml/2014/3/12/237
>> - rebase patches on Lee Jones' MFD tree
>> - add missing selects in Kconfig
>> - add missing deinitializations
>> - add interrupt disabling when suspend
>> - few minor changes and typo fixes
>>
>> v1: https://lkml.org/lkml/2014/3/11/291
>>
>> Robert Baldyga (4):
>>   mfd: max8997: use regmap to access registers
>>   mfd: max8997: handle IRQs using regmap
>>   mfd: max8997: change irq names to upper case
>>   mfd: max8997: move regmap handling to function drivers
>>
>>  drivers/extcon/extcon-max8997.c     |  181 +++++++++++++---
>>  drivers/input/misc/max8997_haptic.c |  121 +++++++++--
>>  drivers/leds/leds-max8997.c         |   13 +-
>>  drivers/mfd/Kconfig                 |    3 +-
>>  drivers/mfd/Makefile                |    2 +-
>>  drivers/mfd/max8997-irq.c           |  387 -----------------------------------
>>  drivers/mfd/max8997.c               |  236 +++++++--------------
>>  drivers/power/max8997_charger.c     |   33 +--
>>  drivers/regulator/max8997.c         |   87 ++++----
>>  drivers/rtc/rtc-max8997.c           |  102 ++++++---
>>  include/linux/mfd/max8997-private.h |   88 ++++++--
>>  11 files changed, 532 insertions(+), 721 deletions(-)
>>  delete mode 100644 drivers/mfd/max8997-irq.c
>>
> 
> This patch fix many parts of previous max8997.
> When I testd kernel build, it is ok. 
> 
> But, I have a question.
> The max8997 is used on trats board based on exynos4210.
> Did you test this patchset?

Yes, I have tested it on this board. Some function drivers requiring
platform data would not work yet, but it's not related to this patchset.
They didn't work before.

I'm actually working on patches for extcon-max8997.

Best regards
Robert Baldyga
