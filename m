Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755520AbaFTVYO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 17:24:14 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:34744 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431AbaFTVYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 17:24:12 -0400
MIME-Version: 1.0
In-Reply-To: <20140620082520.GC25104@arm.com>
References: <1403122209-26352-1-git-send-email-ccross@android.com>
	<20140620082520.GC25104@arm.com>
Date: Fri, 20 Jun 2014 14:24:11 -0700
X-Google-Sender-Auth: RdomUtiGMyEWKR-DBI4vYAGBuZQ
Message-ID: <CAMbhsRTX6QeJVbzzQ6ds5=QhJE64mMWPoF5e=_f3uB24XtUKTA@mail.gmail.com>
Subject: Re: [PATCH] ARM64: implement TASK_SIZE_OF
From: Colin Cross <ccross@android.com>
To: Will Deacon <will.deacon@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2014 at 1:25 AM, Will Deacon <will.deacon@arm.com> wrote:
> Hi Colin,
>
> On Wed, Jun 18, 2014 at 09:10:09PM +0100, Colin Cross wrote:
>> include/linux/sched.h implements TASK_SIZE_OF as TASK_SIZE if it
>> is not set by the architecture headers.  TASK_SIZE uses the
>> current task to determine the size of the virtual address space.
>> On a 64-bit kernel this will cause reading /proc/pid/pagemap of a
>> 64-bit process from a 32-bit process to return EOF when it reads
>> past 0xffffffff.
>>
>> Implement TASK_SIZE_OF exactly the same as TASK_SIZE with
>> test_tsk_thread_flag instead of test_thread_flag.
>
> Looks sane to me.
>
>   Acked-by: Will Deacon <will.deacon@arm.com>
>
> I take it you're being bitten by this in real software, hence the CC stable
> tag?
>
> Will

Yes, it causes memory statistics produced by Android's procrank tool
to be completely wrong.  It applies cleanly to at least 3.10.44,
3.12.22, and 3.14.8.
