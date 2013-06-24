Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751838Ab3FXQUM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 12:20:12 -0400
Received: from mailout2.w2.samsung.com ([211.189.100.12]:58814 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420Ab3FXQUK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 12:20:10 -0400
X-AuditID: cbfec37c-b7f166d000004b4e-63-51c871b8f366
From: Shuah Khan <shuah.kh@samsung.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "pavel@ucw.cz" <pavel@ucw.cz>, "len.brown@intel.com" <len.brown@intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "airlied@linux.ie" <airlied@linux.ie>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>,
        Shuah Khan <shuah.kh@samsung.com>
Subject: Re: [PATCH 1/2] power: add new interface to return pm_transition state
Thread-topic: [PATCH 1/2] power: add new interface to return pm_transition state
Thread-index: AQHOb4S4lWdJl/a6AkWWWqdTWLLL3A==
Date: Mon, 24 Jun 2013 16:20:06 +0000
Message-id: <B8EFE96D1287C24090BAD9D858E15E6172F2C0@sisaex02sj>
References: <1371931874-3220-1-git-send-email-shuah.kh@samsung.com>
 <4133846.I1XZFprb5V@vostro.rjw.lan>
Accept-Language: en-US
Content-language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
X-Originating-IP: [105.144.21.63]
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 8BIT
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNIsWRmVeSWpSXmKPExsVy+t9hX90dhScCDY4cEbboPXeSyeLK1/ds
	Fs2L17NZzJqyl8ni8q45bBafe48wWtw9dZTNon9hL5PF158ODpweO2fdZfdYvOclk8f2bw9Y
	PfbPXcPucb/7OJPHo8UtjB4rVn9n9/i8SS6AI4rLJiU1J7MstUjfLoErY+b7f0wFj4Qr5uzt
	ZG9g3CrQxcjBISFgInFmWVQXIyeQKSZx4d56ti5GLg4hgWWMEjc6W6CcXiaJ77tuM0M48xkl
	Nq35wwTSwiagLvH59Q52EFtEQFViy5P/7CBFzALHmSUObZ3IBpIQFvCX+HN9HQtEUYBE179P
	rBC2nkTrMog4C1Dz8WmPwIbyCthL3F/fxQxiCwlkSjQe7QSzGYHu+35qDVgNs4C4RHPrTRaI
	uwUkluw5zwxhi0q8fPyPFeI1RYntq60gyrUk1u88DtWqLfHk3QVWiFWCEj8m32OZwCg2C8nU
	WUhaZiFpmYWkZQEjyypGsdLi5ILipPTUCmO94sTc4tK8dL3k/NxNjJAIrtnBeO+rzSFGAQ5G
	JR7eD3EnAoVYE8uKK3MPMUpwMCuJ8IaKAIV4UxIrq1KL8uOLSnNSiw8xMnFwSjUwMnyZFaO4
	Yvq9EuN9TFuqD91S3PxK1fB3QMw+qzPHD+dK2PF8dQ+L/XZcxej+9aKOIP9i/3n3Ln+O+Nxa
	eU3uc1KvvaOjJMvplR/PPzURvM2YVTmHp2fSE/P2g8Utovlt1xqLFryMUP36ZdnRr4GHBdyu
	vf2WYh3d3VFcxrBr1eN3DIZcbNLNSizFGYmGWsxFxYkAM6hhoL4CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/22/2013 03:17 PM, Rafael J. Wysocki wrote:
> On Saturday, June 22, 2013 02:11:14 PM Shuah Khan wrote:
>> Add a new interface get_pm_transition() to return pm_transition state.
>> This interface is intended to be used from dev_pm_ops class and type
>> suspend interfaces that call legacy pm ops driver suspend interfaces.
>> Legacy suspend pm_ops take pm_message_t as a parameter.
>>
>> e.g: drm_class_suspend() calls into driver suspend routines
>> via drm_dev->driver->suspend(drm_dev, state).
>>
>> Once drm_class_suspend() is converted to dev_pm_ops, it will no longer
>> have access to pm_transition which it has to pass into driver legacy
>> suspend calls. get_pm_transition() interface addresses this need.
>
> That shouldn't be necessary because each transition has its own callback
> in strict dev_pm_ops.
>
> Thanks,
> Rafael
>

Yes that is correct that there is no need pass in or know pm_transition 
with dev_pm_ops. The issue I am running into is the legacy pm_ops class 
suspend/resume routines call. In the example, I mentioned in my 
changelog, drm_class_suspend() calls legacy pm_ops and passes in state. 
It passes in the state to the driver legacy suspend routine. I have seen 
code paths in drivers that differentiate between PM_EVENT_FREEZE, 
PM_EVENT_SUSPEND, PM_EVENT_SLEEP etc.

I considered passing PM_EVENT_SUSPEND to 
drm_dev->driver->suspend(drm_dev, state) from drm_class_suspend() which 
would eliminate the need for this new interface. However, I am concerned 
about breaking driver legacy suspend routines that key of off the state 
to execute different code paths for PM_EVENT_FREEZE vs. 
PM_EVENT_SUSPEND. Suspend routines get called when state is is 
PM_EVENT_FREEZE based on my testing.

I would rather not add a new interface. Hoping you will have another 
idea on how to pass in the state to legacy suspend/resume without adding 
this new interface. My thinking is that this new interface is temporary 
measure until all of the legacy suspend routines get converted to 
dev_pm_ops and at the tile legacy interface gets removed, this new 
interface can go away as well.

thanks,
-- Shuah

Shuah Khan, Linux Kernel Developer - Open Source Group Samsung Research 
America (Silicon Valley) shuah.kh@samsung.com | (970) 672-0658
