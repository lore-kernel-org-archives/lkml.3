Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751880Ab3HPHB6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 03:01:58 -0400
Received: from www.linutronix.de ([62.245.132.108]:37775 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149Ab3HPHB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 03:01:57 -0400
Message-ID: <520DCE5F.1040402@linutronix.de>
Date: Fri, 16 Aug 2013 09:01:51 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130630 Icedove/17.0.7
MIME-Version: 1.0
To: Kent Overstreet <kmo@daterainc.com>
CC: Steven Rostedt <rostedt@goodmis.org>,
        Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, John Kacur <jkacur@redhat.com>
Subject: Re: [ANNOUNCE] 3.10.6-rt3
References: <20130812163413.GI23040@linutronix.de> <520D212F.7030400@localhost> <20130815152210.5ed93696@gandalf.local.home>
In-Reply-To: <20130815152210.5ed93696@gandalf.local.home>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/15/2013 09:22 PM, Steven Rostedt wrote:
> On Thu, 15 Aug 2013 11:42:55 -0700
> Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU> wrote:
> 
>> On 08/12/2013 09:34 AM, Sebastian Andrzej Siewior wrote:
>>> Dear RT folks!
>>>
>>> I'm pleased to announce the v3.10.6-rt3 patch set.
>>
>> I'm getting this when trying to build:
>>
>> drivers/md/bcache/request.c: In function 'cached_dev_write_complete':
>> drivers/md/bcache/request.c:1008:2: error: implicit declaration of 
>> function 'up_read_non_owner' [-Werror=implicit-function-declaration]
>>    up_read_non_owner(&dc->writeback_lock);
>>    ^
>> drivers/md/bcache/request.c: In function 'request_write':
>> drivers/md/bcache/request.c:1034:2: error: implicit declaration of 
>> function 'down_read_non_owner' [-Werror=implicit-function-declaration]
>>    down_read_non_owner(&dc->writeback_lock);
>>    ^
>> cc1: some warnings being treated as errors
>>
> 
> Can you send us your config.

The problem is that bcache is using new semaphore functions which it
just introduced which rt does not know about. The comment above their
definition says that it is wrong to use them and completion is the
right way to do it.
So my question is, why don't we use completion but this nasty hack?

> 
> Thanks,
> 
> -- Steve

Sebastian
