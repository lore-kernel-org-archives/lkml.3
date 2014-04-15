Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456AbaDOBht (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 21:37:49 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:38712 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753327AbaDOBhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 21:37:46 -0400
Message-ID: <534C8D64.2070108@hitachi.com>
Date: Tue, 15 Apr 2014 10:37:40 +0900
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
References: <20140414045158.10846.35462.stgit@ltc230.yrl.intra.hitachi.co.jp> <20140414193153.GC4281@redhat.com>
In-Reply-To: <20140414193153.GC4281@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vivek,

(2014/04/15 4:31), Vivek Goyal wrote:
> On Mon, Apr 14, 2014 at 01:51:58PM +0900, Masami Hiramatsu wrote:
>> Add a "late_kdump" option to run kdump after running panic
>> notifiers and dump kmsg. This can help rare situations which
>> kdump drops in failure because of unstable crashed kernel
>> or hardware failure (memory corruption on critical data/code),
>> or the 2nd kernel is broken by the 1st kernel (it's a broken
>> behavior, but who can guarantee that the "crashed" kernel
>> works correctly?).
>>
>> Usage: add "late_kdump" to kernel boot option. That's all.
>>
>> Note that this actually increases risks of the failure of
>> kdump. This option should be set only if you worry about
>> the rare case of kdump failure rather than increasing the
>> chance of success.
>>
> 
> Masami,
> 
> So what's the alternative to kdump which is more reliable? IOW, what
> action you are planning to take through kmsg_dump() or through
> panic_notifiers?
> 
> I have seen that many a times developers have tried to make the case 
> to save kernel buffers to NVRAM. Does it work well? Has it been proven
> to be more reliable than kdump?

Yeah, one possible option is the NVRAM, but even with the serial,
there are other reasons to kick the notifiers, e.g.
 - dump to ipmi which has a very small amount of non-volatile memory
 - ftrace_dump() to dump "flight recorder" log to serial
 - pvpanic notifies panic to the host.

Anyway, I think the most important reason for linux developers is
that we have a chance to improve such horrible notifiers to safer,
or at least to clarify what notifier or behavior makes kdump unstable. :-)

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


