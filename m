Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755294AbaD1Ka6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 06:30:58 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:37680 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755192AbaD1Kay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 06:30:54 -0400
Message-ID: <535E2DD5.3020501@linaro.org>
Date: Mon, 28 Apr 2014 11:30:45 +0100
From: Daniel Thompson <daniel.thompson@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: kgdb-bugreport@lists.sourceforge.net,
        Jason Wessel <jason.wessel@windriver.com>, patches@linaro.org,
        linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, John Stultz <john.stultz@linaro.org>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Colin Cross <ccross@android.com>, kernel-team@android.com
Subject: Re: [RFC v3 7/9] kdb: Categorize kdb commands (similar to SysRq categorization)
References: <1396453440-16445-1-git-send-email-daniel.thompson@linaro.org>	<1398443370-12668-1-git-send-email-daniel.thompson@linaro.org>	<1398443370-12668-8-git-send-email-daniel.thompson@linaro.org> <20140425125735.334add30@gandalf.local.home>
In-Reply-To: <20140425125735.334add30@gandalf.local.home>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/04/14 17:57, Steven Rostedt wrote:
>> +	KDB_ENABLE_ALL_NO_ARGS = KDB_ENABLE_ALL << 16,
>> +	KDB_ENABLE_MEM_READ_NO_ARGS = KDB_ENABLE_MEM_READ << 16,
>> +	KDB_ENABLE_MEM_WRITE_NO_ARGS = KDB_ENABLE_MEM_WRITE << 16,
>> +	KDB_ENABLE_REG_READ_NO_ARGS = KDB_ENABLE_REG_READ << 16,
>> +	KDB_ENABLE_REG_WRITE_NO_ARGS = KDB_ENABLE_REG_WRITE << 16,
>> +	KDB_ENABLE_INSPECT_NO_ARGS = KDB_ENABLE_INSPECT << 16,
>> +	KDB_ENABLE_FLOW_CTRL_NO_ARGS = KDB_ENABLE_FLOW_CTRL << 16,
>> +	KDB_ENABLE_SIGNAL_NO_ARGS = KDB_ENABLE_SIGNAL << 16,
>> +	KDB_ENABLE_REBOOT_NO_ARGS = KDB_ENABLE_REBOOT << 16,
>> +	KDB_ENABLE_ALWAYS_SAFE_NO_ARGS = KDB_ENABLE_ALWAYS_SAFE << 16,
>> +	KDB_ENABLE_MASK_NO_ARGS = KDB_ENABLE_MASK << 16,
> 
> I would recommend defining a KDB_NO_ARGS_SHIFT to be 16 and use that
> instead of having a magic number 16 to deal with. This also makes it
> easier if you need to shift a bit more in the future.
> 
> 	KDB_ENABLE_ALL_NO_ARGS = KDB_ENABLE_ALL << KDB_NO_ARGS_SHIFT,

Good point. I will fix this (and reduce KDB_NO_ARGS_SHIFT to the proper
value).

> Although, I'm not sure why you just didn't have a KDB_ENABLE_ARGS flag,
> and then you don't need to repeat all the flags again. Seems rather
> silly.
> 
> KDB_ENABLE_ALL_NO_ARGS would then be just
> KDB_ENABLE_ALL|KDB_ENABLE_NO_ARGS.
> 
> Or can you have multiple settings? That is, MEM_READ and
> MEM_WRITE_NO_ARGS both set such that you can't just have a simple args
> or no args command for the entire flags?

That's basically it. Some commands change classification if they have an
argument ('go' is the best example; it changes from always-safe to
register-write because if an argument is given it gets copied to the PC).

Actually only two of the _NO_ARGS values are currently used, however
having a shift relationship between the flags makes it much simpler to
do the permissions check.


Daniel.
