Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755131Ab3H2B5N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 21:57:13 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:52307 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752808Ab3H2B5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 21:57:12 -0400
X-AuditID: 85900ec0-d312bb9000001514-a2-521eaa75decc
Message-ID: <521EAA75.80500@hitachi.com>
Date: Thu, 29 Aug 2013 10:57:09 +0900
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120604 Thunderbird/13.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org, yrl.pp-manager.tt@hitachi.com
Subject: Re: Re: [RFC PATCH 08/11] trace-cmd: Apply the trace-msg protocol
 for communication between a server and clients
References: <20130819094620.26597.79499.stgit@yunodevel> <20130819094639.26597.44449.stgit@yunodevel> <20130820135658.5a5d6e28@gandalf.local.home> <521AB469.40201@hitachi.com> <20130826111105.5d6504e0@gandalf.local.home> <521C7E1C.5060502@hitachi.com> <20130827090509.598591e8@gandalf.local.home> <521DDF49.1090301@hitachi.com> <20130828104249.3533bece@gandalf.local.home>
In-Reply-To: <20130828104249.3533bece@gandalf.local.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/08/28 23:42), Steven Rostedt wrote:
> On Wed, 28 Aug 2013 20:30:17 +0900
> Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com> wrote:
>
>> (2013/08/27 22:05), Steven Rostedt wrote:
>>> On Tue, 27 Aug 2013 19:23:24 +0900
>>> Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com> wrote:
>>>
>>>> OK, let me check that. Even if the old server will receive "V2", the
>>>> server will send port numbers instead of "V2" due to the old protocol.
>>>> In that time, the new client will disconnect from the old server and
>>>> the restarts with the old protocol. Is it OK?
>>>
>>> Yep, that's exactly what I meant ;-)
>>
>> I tried to implement the feature, but I found that sending just "V2"
>> from the new client is inappropriate. This is because the old server
>> doesn't respond to the client before receiving cpu numbers, page size,
>> and options. So, when the new client sends the first message, it should
>> send "V2\0<MAGIC_NUMBER>\00\0", I think. If so, the old server will
>> understand the message as cpus=0, pagesize=<MAGIC_NUMBER>, options=0,
>> and then it will send port numbers(actually \0). Note if <MAGIC_NUMBER>
>> is zero, the old server will die.
>>
>> Can I implement the first message of the new client as
>> "V2\0<MAGIC_NUMBER>\00\0"?
>>
>
> If it works for both old and new server with old and new client (and
> all combinations) I'm fine with it.

OK, I'll submit trace-cmd patches as V2 in a few days.

Thanks,
Yoshihiro YUNOMAE

-- 
Yoshihiro YUNOMAE
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: yoshihiro.yunomae.ez@hitachi.com


