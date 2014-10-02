Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753110AbaJBOWq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 10:22:46 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:52634 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752498AbaJBOWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 10:22:45 -0400
Message-ID: <542D5FB1.3090307@codeaurora.org>
Date: Thu, 02 Oct 2014 17:22:41 +0300
From: Tanya Brokhman <tlinder@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Richard Weinberger <richard@nod.at>,
        "Bityutskiy, Artem" <artem.bityutskiy@intel.com>
CC: "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dedekind1@gmail.com" <dedekind1@gmail.com>
Subject: Re: [PATCH 4/4] UBI: Fastmap: Ensure that only one fastmap work is
 scheduled
References: <1412029248-22454-1-git-send-email-richard@nod.at>		 <1412029248-22454-5-git-send-email-richard@nod.at>	 <1412059523.3904.11.camel@sauron.fi.intel.com> <542A54E4.2060407@nod.at> <1412062762.2379.2.camel@sauron.fi.intel.com> <542A5F64.5000302@nod.at>
In-Reply-To: <542A5F64.5000302@nod.at>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/30/2014 10:44 AM, Richard Weinberger wrote:
> Am 30.09.2014 09:39, schrieb Bityutskiy, Artem:
>> On Tue, 2014-09-30 at 08:59 +0200, Richard Weinberger wrote:
>>> Am 30.09.2014 08:45, schrieb Bityutskiy, Artem:
>>>> On Tue, 2014-09-30 at 00:20 +0200, Richard Weinberger wrote:
>>>>> +       spin_lock(&ubi->wl_lock);
>>>>> +       ubi->fm_work_scheduled = 0;
>>>>> +       spin_unlock(&ubi->wl_lock);
>>>>
>>>> Andrew Morton once said me that if I am protecting an integer change
>>>> like this with a spinlock, I have a problem in my locking design. He was
>>>> right for my particular case.
>>>>
>>>> Integer is changes atomic. The only other thing spinlock adds are the
>>>> barriers.
>>>
>>> I've added the spinlock to have a barrier in any case.
>>
>> Examples of any?
>
> You mean a case where the compiler would reorder code and the barrier is needed?
> I don't have one, but I'm not that creative as a modern C compiler.
> If you say that no barrier is needed I'll trust you. :-)

we just implemented the same thing :) It's being tested....
Why not use atomic_t fm_work_scheduled and save the spin_lock?

>
> Thanks,
> //richard
>
>
> ______________________________________________________
> Linux MTD discussion mailing list
> http://lists.infradead.org/mailman/listinfo/linux-mtd/
>


-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, 
hosted by The Linux Foundation
