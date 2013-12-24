Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758231Ab3LXEyX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 23:54:23 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:50024 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752976Ab3LXEyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 23:54:21 -0500
X-AuditID: 85900ec0-d3b2cb9000001514-cd-52b9137958f3
Message-ID: <52B91374.9000307@hitachi.com>
Date: Tue, 24 Dec 2013 13:54:12 +0900
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120604 Thunderbird/13.0
MIME-Version: 1.0
To: Kay Sievers <kay@vrfy.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Eiichi Tsukata <eiichi.tsukata.xh@hitachi.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Tejun Heo <tj@kernel.org>,
        yrl.pp-manager.tt@hitachi.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Joe Perches <joe@perches.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Subject: Re: Re: Re: [PATCH 0/2] [BUGFIX] printk: Fix message continuation
 breakage involved with structured printk
References: <20131220094134.24233.2969.stgit@yunodevel> <CAPXgP11H7EB5Sfezf_7NkKzXT4n4EnPPyE2wWV9YQmR=3LsbAw@mail.gmail.com> <52B8F678.2090604@hitachi.com> <CAPXgP11FbLbWs3GoHpYngAGJ+whe8PZ=5dXqR8ufdMkLT5AX0Q@mail.gmail.com>
In-Reply-To: <CAPXgP11FbLbWs3GoHpYngAGJ+whe8PZ=5dXqR8ufdMkLT5AX0Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/12/24 12:00), Kay Sievers wrote:
> On Tue, Dec 24, 2013 at 3:50 AM, Yoshihiro YUNOMAE
> <yoshihiro.yunomae.ez@hitachi.com> wrote:
>> (2013/12/20 20:29), Kay Sievers wrote:
>>>
>>> On Fri, Dec 20, 2013 at 10:41 AM, Yoshihiro YUNOMAE
>>> <yoshihiro.yunomae.ez@hitachi.com> wrote:
>>>
>>>> This patch set fixes message continuation breakage involved with
>>>> structured
>>>> printk. A SCSI driver may output two continuation error messages like
>>>>       scmd_printk("foo");
>>>>       printf("bar\n");
>>>
>>>
>>> Which is the absolutely wrong thing to do. Structured logging and racy
>>> printk continuation must never be mixed. Userspace needs to be sure
>>> that dictionary entries are not subject to racy continuation hackery,
>>> and that these mwssages atomic, whole and intact.
>>
>>
>> I see.
>> As you say, user tools need to support messages output in multiple lines
>> for SMP environments even if this patch set is introduced.
>
> They cannot really, they can try to re-construct, but Information and
> context is sometimes lost with  the use of continuation lines.
> Structured logging need to be reliable and trustable, and it it is not
> "best effort", hence it cannot use continuation lines.
>
> Continuation lines are a nice debugging tool for humans only.
> Structured logging carries the human readable string but also
> machine-readable context and that alwasy needs to be safely
> machine-readable and recognizable.

I understand. I think if we make machine(user tools) handle important
messages, those messages need to be output in single line even if those
are not structured printk.

>>> Please do not mix the both and do not apply these patches.
>>
>> OK, I'll make important messages with KERN_CONT or no-prefix printk()
>> output those in single line.
>
> Yes, it should use the plain printk versions and not the one which add
> structured data.
>
> If structured logging is really wanted for more complex continuation
> lines, it might be the simplest to buffer the line locally, instead of
> the single printk-owned buffer, before the line is emitted to printk.

Yes, I'll do that.

Thanks,
Yoshihiro YUNOMAE

-- 
Yoshihiro YUNOMAE
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: yoshihiro.yunomae.ez@hitachi.com


