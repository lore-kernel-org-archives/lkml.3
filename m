Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753174Ab3H0IHn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 04:07:43 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:42083 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843Ab3H0IHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 04:07:38 -0400
X-AuditID: 85900ec0-d3b2cb9000001514-39-521c5e48dfe1
Message-ID: <521C5E46.9060704@hitachi.com>
Date: Tue, 27 Aug 2013 17:07:34 +0900
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120604 Thunderbird/13.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org, yrl.pp-manager.tt@hitachi.com
Subject: Re: Re: [RFC PATCH 00/11] trace-cmd: Support the feature recording
 trace data of guests on the host
References: <20130819094620.26597.79499.stgit@yunodevel> <20130820120006.1a4118c5@gandalf.local.home> <521AB37E.4050800@hitachi.com> <20130826102229.6e0129fe@gandalf.local.home>
In-Reply-To: <20130826102229.6e0129fe@gandalf.local.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

(2013/08/26 23:22), Steven Rostedt wrote:
> On Mon, 26 Aug 2013 10:46:38 +0900
> Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com> wrote:
>
>>> The --date option is used because the two machines are not in sync with
>>> the trace time stamp. What the date option does, is to sync the
>>> timestamp up with the gettimeofday and the output reports that. This
>>> allows the two boxes to report information that is relatively close to
>>> how the two interacted.
>>
>> Oh, I didn't know the --date option.
>> As you mentioned, we can merge trace data in chronological order by
>> using --date option if the times of those machines are synchronized by
>> NTP.
>>
>>> If the guest and the host have the same clock, then the --date option
>>> is not needed and the two should be able to be merged normally.
>>
>> No, we can not assure that the guest and the host have the same clock
>> even if it is running on the same physical machine, because both kernel
>> doesn't share it, there is some difference between them. So, we still
>> need time synchronizing guest-host by NTP and --date option.
>>
>> However, there are cases that times of those machines cannot be
>> synchronized. For example, although multiple users can run guests on
>> virtualization environments (e.g. multi-tenant cloud hosting), there
>> are no guarantee that they use the same NTP server. Moreover, even if
>> the times are synchronized, trace data cannot exactly be merged because
>> the NTP-synchronized time granularity may not be enough fine for
>> sorting guest-host switching events.
>
> Right, unless there's some other means no synchronize between boxes,
> this is currently the best we have.

I'm considering that trace data use x86-tsc as timestamp in order to
merge trace data. By using x86-tsc, we can merge trace data even if
time of those machines is not synchronized. And the precision will be
enough for understanding operations of guests and host. However, TSC
values on a guest are not equal to the values on the host because
         TSC_guest = TSC_host + TSC_offset.
This series actually doesn't support TSC offset, but I'd like to
add such feature to fix host/guest clock difference in the next series.
TSC offset values can be gotten as write_tsc_offset trace event from
kernel-3.11. (see https://lkml.org/lkml/2013/6/12/72)
How do you think about this merging feature?

Thanks,
Yoshihiro YUNOMAE

-- 
Yoshihiro YUNOMAE
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: yoshihiro.yunomae.ez@hitachi.com


