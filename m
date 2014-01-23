Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752862AbaAWBPq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 20:15:46 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:46211 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276AbaAWBPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 20:15:45 -0500
Message-ID: <52E06D2A.30509@huawei.com>
Date: Thu, 23 Jan 2014 09:15:22 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: John Stultz <john.stultz@linaro.org>, <linux-kernel@vger.kernel.org>,
        Hanjun Guo <guohanjun@huawei.com>
Subject: Re: [PATCH] clocksource: fix some comments typo in clocksource.c
References: <1388653000-9944-1-git-send-email-wangyijing@huawei.com> <alpine.DEB.2.02.1401222201260.24986@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1401222201260.24986@ionos.tec.linutronix.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.27.212]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/1/23 5:05, Thomas Gleixner wrote:
> On Thu, 2 Jan 2014, Yijing Wang wrote:
> 
>> Fix some trivial comments typo in kernel/time/clocksource.c
> 
> That's not a typo. Thats a left over. The function simply cannot fail
> anymore. So the subject of that patch should be something like:
> 
> clocksource: Remove outdated comments

Hi Thomas, sorry for my poor English, I will update this patch title and changelog.

> 
> And the changelog should explain, that the functions always return 0,
> so the comment is just pointless. A nice follow up on that would be to
> actually make the function void instead of returning a pointless int,
> but that requires to check all call sites.

You are right, it's pointless to return 0, I will try to change the function type to void
in a separate patch, thanks!

>  
>> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
>> ---
>>  kernel/time/clocksource.c |    3 ---
>>  1 files changed, 0 insertions(+), 3 deletions(-)
>>
>> diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
>> index ba3e502..9951575 100644
>> --- a/kernel/time/clocksource.c
>> +++ b/kernel/time/clocksource.c
>> @@ -779,8 +779,6 @@ EXPORT_SYMBOL_GPL(__clocksource_updatefreq_scale);
>>   * @scale:	Scale factor multiplied against freq to get clocksource hz
>>   * @freq:	clocksource frequency (cycles per second) divided by scale
>>   *
>> - * Returns -EBUSY if registration fails, zero otherwise.
>> - *
>>   * This *SHOULD NOT* be called directly! Please use the
>>   * clocksource_register_hz() or clocksource_register_khz helper functions.
>>   */
>> @@ -805,7 +803,6 @@ EXPORT_SYMBOL_GPL(__clocksource_register_scale);
>>   * clocksource_register - Used to install new clocksources
>>   * @cs:		clocksource to be registered
>>   *
>> - * Returns -EBUSY if registration fails, zero otherwise.
>>   */
>>  int clocksource_register(struct clocksource *cs)
>>  {
>> -- 
>> 1.7.1
>>
>>
>>
> 
> 


-- 
Thanks!
Yijing

