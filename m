Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751128Ab3HSRYH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 13:24:07 -0400
Received: from smtp1.Stanford.EDU ([171.67.219.81]:48535 "EHLO
	smtp.stanford.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750862Ab3HSRYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 13:24:06 -0400
Message-ID: <521254A0.6050603@localhost>
Date: Mon, 19 Aug 2013 10:23:44 -0700
From: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Kent Overstreet <kmo@daterainc.com>,
        Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, John Kacur <jkacur@redhat.com>
Subject: Re: [ANNOUNCE] 3.10.6-rt3
References: <20130812163413.GI23040@linutronix.de> <520D212F.7030400@localhost> <20130815152210.5ed93696@gandalf.local.home> <520DCE5F.1040402@linutronix.de>
In-Reply-To: <520DCE5F.1040402@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/16/2013 12:01 AM, Sebastian Andrzej Siewior wrote:
> On 08/15/2013 09:22 PM, Steven Rostedt wrote:
>> On Thu, 15 Aug 2013 11:42:55 -0700
>> Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU> wrote:
>>
>>> On 08/12/2013 09:34 AM, Sebastian Andrzej Siewior wrote:
>>>> Dear RT folks!
>>>>
>>>> I'm pleased to announce the v3.10.6-rt3 patch set.
>>>
>>> I'm getting this when trying to build:
>>>
>>> drivers/md/bcache/request.c: In function 'cached_dev_write_complete':
>>> drivers/md/bcache/request.c:1008:2: error: implicit declaration of
>>> function 'up_read_non_owner' [-Werror=implicit-function-declaration]
>>>     up_read_non_owner(&dc->writeback_lock);
>>>     ^
>>> drivers/md/bcache/request.c: In function 'request_write':
>>> drivers/md/bcache/request.c:1034:2: error: implicit declaration of
>>> function 'down_read_non_owner' [-Werror=implicit-function-declaration]
>>>     down_read_non_owner(&dc->writeback_lock);
>>>     ^
>>> cc1: some warnings being treated as errors
>>>
>>
>> Can you send us your config.
>
> The problem is that bcache is using new semaphore functions which it
> just introduced which rt does not know about. The comment above their
> definition says that it is wrong to use them and completion is the
> right way to do it.
> So my question is, why don't we use completion but this nasty hack?

In the meanwhile, any hope of a patch to be able to compile and test 
with my current configuration?
Thanks,
-- Fernando
