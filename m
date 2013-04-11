Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762512Ab3DKKJG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 06:09:06 -0400
Received: from [133.145.228.50] ([133.145.228.50]:38936 "EHLO
	mailxx.hitachi.co.jp" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753887Ab3DKKJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 06:09:04 -0400
X-AuditID: 85900ec0-d4ccab900000151e-bf-51668b131072
Message-ID: <51668B14.9090800@hitachi.com>
Date: Thu, 11 Apr 2013 19:06:12 +0900
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120604 Thunderbird/13.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org, yrl.pp-manager.tt@hitachi.com
Subject: Re: Re: [PATCH 2/2] trace-cmd: Support trace_clock extraction
References: <20130405015439.19807.43932.stgit@yunodevel>  <20130405015444.19807.91495.stgit@yunodevel> <1365523237.25498.70.camel@gandalf.local.home>
In-Reply-To: <1365523237.25498.70.camel@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

Thank you for reviewing my patch set.

(2013/04/10 1:00), Steven Rostedt wrote:
> On Fri, 2013-04-05 at 10:54 +0900, Yoshihiro YUNOMAE wrote:
>> In this patch, trace-cmd reads trace_clock on debugfs in the report/extract
>> modes and outputs the data to trace.dat file. Then, in the report mode,
>> trace-cmd reads trace_clock data from the file and switches outputting format
>> of timestamp for each trace_clock.
>>
>> Note that by applying this patch, the binary format of trace.data is changed
>> as follows:
>>
>> <Current binary format>
>> ...
>> [size of saved_cmdlines]
>> [saved_cmdlines contents]
>> [total cpu number]
>> ...
>>
>> <Changed binary format>
>> ...
>> [size of saved_cmdlines]
>> [saved_cmdlines contents]
>> [size of trace_clock]  <== add
>> [trace_clock contents] <== add
>> [total cpu number]
>> ...
>
> Hi Yoshihiro,
>
> I don't mind the feature addition, but I don't like the implementation.
> This will break backward compatibility with the trace.dat file, which
> I've been working hard not to have happen.

Yeah, I agree with you.
It is important that trace-cmd keeps backward compatibility.

> That doesn't mean that you can't implement this feature. This is what
> the options section is for. You can add an option that includes the
> trace_clock contents, or just simply say what type of clock is being
> used. Then a new trace-cmd can show the output like you want it to, and
> the old version will still work but show the old way, as trace-cmd is
> made to simply ignore options it does not know about.

Sounds good.
Maintenance of the implementation will be easier than that of my
implementation.

> I think it's time for me to push my latest updates to trace-cmd. As this
> will probably end up being the 3.0 version. I have examples there that
> use the options feature for more extensions that you can look at.

Thank you for pushing your latest patches!
I'll use your patches as a reference and submit the revised patches
using the options feature.

Thanks,
Yoshihiro YUNOMAE

-- 
Yoshihiro YUNOMAE
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: yoshihiro.yunomae.ez@hitachi.com


