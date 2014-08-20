Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753508AbaHTLzA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 07:55:00 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:38380 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752222AbaHTLy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 07:54:58 -0400
Message-ID: <53F48C8B.4020707@codeaurora.org>
Date: Wed, 20 Aug 2014 17:24:51 +0530
From: Chintan Pandya <cpandya@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111108 Thunderbird/3.1.16
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH v3 2/2] ksm: provide support to use deferrable timers
 for scanner thread
References: <1406793591-26793-2-git-send-email-cpandya@codeaurora.org> <1406793591-26793-3-git-send-email-cpandya@codeaurora.org> <alpine.LSU.2.11.1408110332350.1500@eggly.anvils> <53EA3FF5.1050709@codeaurora.org>
In-Reply-To: <53EA3FF5.1050709@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hugh,

>>> + unsigned long enable;
>>> + int err;
>>> +
>>> + err = kstrtoul(buf, 10,&enable);
>>> + if (err< 0)
>>> + return err;
>>> + if (enable>= 1)
>>> + return -EINVAL;
>>
>> I haven't studied the patch itself, I'm still worrying about the concept.
>> But this caught my eye just before hitting Send: I don't think we need
>> a tunable which only accepts the value 0 ;)
>
> Okay. I can correct this to accept any non-zero value. Is that okay ?

I missed that to reply earlier. This was suggested by Andrew. And I 
think that is okay as displaying any non-zero value to user via this 
knob may not be completely right.

>
>>
>>> + use_deferrable_timer = enable;
>


-- 
Chintan Pandya

QUALCOMM INDIA, on behalf of Qualcomm Innovation Center, Inc. is a
member of the Code Aurora Forum, hosted by The Linux Foundation
