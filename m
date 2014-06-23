Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756854AbaFWUHA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 16:07:00 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:38357 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753812AbaFWUG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 16:06:59 -0400
MIME-Version: 1.0
In-Reply-To: <53A88806.1060908@intel.com>
References: <1403084656-27284-1-git-send-email-qiaowei.ren@intel.com>
 <1403084656-27284-3-git-send-email-qiaowei.ren@intel.com> <53A884B2.5070702@mit.edu>
 <53A88806.1060908@intel.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 23 Jun 2014 13:06:37 -0700
Message-ID: <CALCETrXYZZiZsDiUvvZd0636+qHP9a0sHTN6wt_ZKjvLaeeBzw@mail.gmail.com>
Subject: Re: [PATCH v6 02/10] x86, mpx: add MPX specific mmap interface
To: Dave Hansen <dave.hansen@intel.com>
Cc: Qiaowei Ren <qiaowei.ren@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        X86 ML <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2014 at 1:03 PM, Dave Hansen <dave.hansen@intel.com> wrote:
> On 06/23/2014 12:49 PM, Andy Lutomirski wrote:
>> On 06/18/2014 02:44 AM, Qiaowei Ren wrote:
>>> This patch adds one MPX specific mmap interface, which only handles
>>> mpx related maps, including bounds table and bounds directory.
>>>
>>> In order to track MPX specific memory usage, this interface is added
>>> to stick new vm_flag VM_MPX in the vma_area_struct when create a
>>> bounds table or bounds directory.
>>
>> I imagine the linux-mm people would want to think about any new vm flag.
>>  Why is this needed?
>
> These tables can take huge amounts of memory.  In the worst-case
> scenario, the tables can be 4x the size of the data structure being
> tracked.  IOW, a 1-page structure can require 4 bounds-table pages.
>
> My expectation is that folks using MPX are going to be keen on figuring
> out how much memory is being dedicated to it.  With this feature, plus
> some grepping in /proc/$pid/smaps one could take a pretty good stab at it.
>
> I know VM flags are scarce, and I'm open to other ways to skin this cat.
>

Can the new vm_operation "name" be use for this?  The magic "always
written to core dumps" feature might need to be reconsidered.

There's also arch_vma_name, but I just finished removing for x86, and
I'd be a little sad to see it come right back.

--Andy
