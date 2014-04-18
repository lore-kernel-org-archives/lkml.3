Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751356AbaDRDJe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 23:09:34 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:40787 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970AbaDRDJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 23:09:29 -0400
Message-ID: <53509762.3040908@hitachi.com>
Date: Fri, 18 Apr 2014 12:09:22 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, Satoru MORIYA <satoru.moriya.br@hitachi.com>,
        Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>,
        Takenori Nagano <t-nagano@ah.jp.nec.com>,
        Eric Biederman <ebiederm@xmission.com>,
        Motohiro Kosaki <Motohiro.Kosaki@us.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] kernel/panic: Add "late_kdump" option for kdump in unstable
 condition
References: <20140414045158.10846.35462.stgit@ltc230.yrl.intra.hitachi.co.jp> <20140416134830.GA31074@redhat.com> <534F3572.2040801@hitachi.com> <20140417134338.GB15749@redhat.com>
In-Reply-To: <20140417134338.GB15749@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/04/17 22:43), Vivek Goyal wrote:
> On Thu, Apr 17, 2014 at 10:59:14AM +0900, Masami Hiramatsu wrote:
> 
> [..]
>>>> @@ -112,9 +113,14 @@ void panic(const char *fmt, ...)
>>>>  	/*
>>>>  	 * If we have crashed and we have a crash kernel loaded let it handle
>>>>  	 * everything else.
>>>> -	 * Do we want to call this before we try to display a message?
>>>> +	 * If we want to call this after we try to display a message, pass
>>>> +	 * the "late_kdump" option to the kernel.
>>>>  	 */
>>>> -	crash_kexec(NULL);
>>>> +	if (!late_kdump)
>>>> +		crash_kexec(NULL);
>>>> +	else
>>>> +		pr_emerg("Warning: late_kdump option is set. Please DO NOT "
>>>> +			"report bugs about kdump failure with this option.\n");
>>>
>>> I think above message about DO NOT report bugs seems unnecessary. 
>>
>> OK, so I just notify the option is set as below.
>> "Warning: crash_kexec_post_notifiers is set.\n"
> 
> I would say for the time being don't put any extra message. User will
> think what this warning is supposed to mean. We can introduce one if
> we run into many issues.

Ah, I see.

> For the time being we can just look at kernel logs and look at command
> line options and see whether crash_kexec_post_notifiers was set or not.

Yeah, I know. However since the kernel command line is shown in very early
part of kernel logs, I worried about the case that it is pushed out from
kmsg buffer. And usually users will send a bug report with the very last
of the kernel logs because it becomes too long.

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


