Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751902AbaD0Mtr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 08:49:47 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:40252 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbaD0Mtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 08:49:45 -0400
Message-ID: <535CFCE1.5000507@hitachi.com>
Date: Sun, 27 Apr 2014 21:49:37 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
        Steven Rostedt <rostedt@goodmis.org>, fche@redhat.com,
        mingo@redhat.com, systemtap@sourceware.org,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH -tip v9 25/26] kprobes: Introduce kprobe cache to reduce
 cache misshits
References: <20140417081636.26341.87858.stgit@ltc230.yrl.intra.hitachi.co.jp> <20140417081931.26341.47154.stgit@ltc230.yrl.intra.hitachi.co.jp> <20140424090134.GC7768@gmail.com> <5358F7A3.1000108@hitachi.com> <20140425082056.GB24829@gmail.com> <535A2E41.40005@hitachi.com> <20140426071214.GA2374@gmail.com>
In-Reply-To: <20140426071214.GA2374@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/04/26 16:12), Ingo Molnar wrote:
> 
> * Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
> 
>> (2014/04/25 17:20), Ingo Molnar wrote:
>>>
>>> * Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
>>>
>>>>> So I don't think this should be a Kconfig entry, just enable it 
>>>>> unconditionally. That will further simplify the code.
>>>>
>>>> Hmm, it consumes some amount of memory (36KB/core) just for the 
>>>> case of several thousand of kprobes. On enterprise servers and 
>>>> desktop it's OK, no problem. But I think, some embedded systems 
>>>> with small resources will not want that. [...]
>>>
>>> They'll just disable kprobes in general.
>>
>> No, I'd like to provide kprobes (and dynamic events) to them 
>> (including me) for debugging and dynamic monitoring, instead of 
>> modifying code for adding events on their kernel. To solve some 
>> specific issues, specific events (not generic events) are required. 
>> Making local patches to add such events is an option, but it 
>> increases maintenance cost for rebasing. It is better to pay cost to 
>> maintain this kconfig on upstream as the maintainer for me instead 
>> of paying such ugly local cost. :(
>>
>> Anyway, this option is not easy for beginners, I think it should be 
>> defined with "if EXPERT" option and make it enabled by default.
>>
>>> Really, at this point complexity is our main concern.
>>
>> Agreed about complexity issue. However, even if we remove the 
>> Kconfig, we can just save 6 lines of the code, and one #ifdef block. 
>> Can that really solve the complexity problem?
> 
> It's more about the mental picture about how kprobes works. The fewer 
> binary state flags, the better.

OK, how much the amount of code is changed is not a matter.

Hmm, at this point, I'll update it to remove the Kconfig. And also I'd like
to add a note that this makes kprobes bigger, since without kpcache kprobe
hash table is just 4KB, but with kpcache, it consumes 4KB + 36KB/core
(10 times bigger at single core.)
Of course, it is still enough small for many systems which have 256MB or
more DRAM.

And I'll give smaller systems (such as controller/sensor boards for IoT etc.)
an out-of-tree kconfig patch to disable kpcache if they need... That's better
than maintaining additional-event patches.

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


