Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314AbaATP1S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 10:27:18 -0500
Received: from mailout2.w2.samsung.com ([211.189.100.12]:42407 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807AbaATP1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 10:27:16 -0500
X-AuditID: cbfec37d-b7ff46d000005528-3f-52dd4052416c
Message-id: <52DD4045.4050902@samsung.com>
Date: Mon, 20 Jan 2014 08:27:01 -0700
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.2.0
MIME-version: 1.0
To: Jingoo Han <jg1.han@samsung.com>,
        "'Rafael J. Wysocki'" <rjw@rjwysocki.net>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Florian Tobias Schandinat'" <FlorianSchandinat@gmx.de>,
        "'Jean-Christophe PLAGNIOL-VILLARD'" <plagnioj@jcrosoft.com>,
        "'Tomi Valkeinen'" <tomi.valkeinen@ti.com>,
        "'Rafael J. Wysocki'" <rafael.j.wysocki@intel.com>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Shuah Khan'" <shuahkhan@gmail.com>,
        Shuah Khan <shuah.kh@samsung.com>
Subject: Re: [PATCH v2] backlight: Convert from Legacy pm ops to dev_pm_ops
References: <2236505237-3336-1-git-send-email-shuah.kh@samsung.com>
 <15798389.lgk83XnI1i@vostro.rjw.lan>
 <001f01cf157f$ca2e8530$5e8b8f90$%han@samsung.com>
In-reply-to: <001f01cf157f$ca2e8530$5e8b8f90$%han@samsung.com>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.34.6]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEIsWRmVeSWpSXmKPExsVy+t9hX90gh7tBBr8uKll0zrzGaHF54SVW
	ixN9H1gtLu+aw2ax7uELJovHK96yW5w5DZTYvespq8XXnw4W6+ffYnPg8tg56y67x4ePcR6L
	97xk8nh14Q6Lx5ar7Swee+b/YPXo27KK0eP4je1MHp83yQVwRnHZpKTmZJalFunbJXBlfDm4
	m61gC0/FxG+T2BsYu7i6GDk5JARMJB6d/8IIYYtJXLi3nq2LkYtDSGAZo8Tizs1QTi+TxJUD
	S9khnA2MEq3H5zODtPAKaEnsbv7GAmKzCKhKPD/QygpiswmoS3x+vYMdxBYSkJNoWrIarF5U
	IELi1dmJLBC9ghI/Jt8Ds0UE/CW2ftzBArKAWaCDWeLZ0UawBmEBb4mOM2uYIDbPY5TYdvYY
	0AYODk4BO4l/y21BapgFzCQetaxjhrDlJTavecsMsVhZ4s/lU0wQvylIPLrayj6BUWQWkt2z
	kLTPQtK+gJF5FaNYaXFyQXFSemqFiV5xYm5xaV66XnJ+7iZGSDzW7mC8/9XmEKMAB6MSD6+B
	250gIdbEsuLK3EOMEhzMSiK8QTZ3g4R4UxIrq1KL8uOLSnNSiw8xMnFwSjUwphzUNZicNKF7
	apJVp/zy+50R6xevjhJbfVL3/83EugstqWsV2k7MrrqzxP/Pj8D9esw5PAx3+FyXaPhFp2aJ
	3F0q/er0Rc/IfEHDgxotxaG99nJpymvqu7I+PKh/E3GKxWGHqmTfx8/ivgsO2fy8N1dyaWDI
	9kjbvQt3zJDV/LeUZY3pO9sgJZbijERDLeai4kQA45j2mqUCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/19/2014 06:34 PM, Jingoo Han wrote:
> On Monday, January 20, 2014 12:37 AM, Rafael J. Wysocki wrote:
>> On Wednesday, November 14, 2040 04:27:17 AM Shuah Khan wrote:
>>> Convert drivers/video/backlight/class to use dev_pm_ops for power
>>> management and remove Legacy PM ops hooks. With this change, rtc class
>>> registers suspend/resume callbacks via class->pm (dev_pm_ops) instead of
>>> Legacy class->suspend/resume. When __device_suspend() runs call-backs,
>>> it will find class->pm ops for the backlight class.
>>>
>>> Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
>>> Cc: Shuah Khan <shuahkhan@gmail.com>
>>
>> Can you please resend the patches that nobody took with CCs to
>> linux-pm@vger.kernel.org?  If the original maintainers don't care, I'll be
>> able to pick those patches up then (if they look good).
>
> I already gave the comment, and am waiting v3 patch.
> However, Shuah Khan did not send the v3 patch yet.
>
> Currently, backlight subsystem patches go through mm-tree
> With my acked-by.
>
> Shuah Khan,
> Will you send the v3 patch? As I said, there is the typo in
> commit message. Please fix it.
>     s/rtc class/backlight class
>

Rafael/Jingoo Han,

I did send the v3 patch with the typo fixed. Here is the link:

http://lkml.indiana.edu/hypermail/linux/kernel/1306.0/00219.html

This is a while back. I will rebase and res-test and send it.

thanks,
-- Shuah

-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
