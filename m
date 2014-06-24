Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753051AbaFXABp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 20:01:45 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:63614 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242AbaFXABn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 20:01:43 -0400
MIME-Version: 1.0
In-Reply-To: <53A8BB5A.5090103@intel.com>
References: <1403084656-27284-1-git-send-email-qiaowei.ren@intel.com>
 <1403084656-27284-9-git-send-email-qiaowei.ren@intel.com> <53A8874A.3050301@mit.edu>
 <53A88966.5080400@intel.com> <CALCETrX7B8yxrNgojCR8YNH+6zHX8vq+GMFn0RjdWXdLmhA-Fg@mail.gmail.com>
 <53A8BB5A.5090103@intel.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 23 Jun 2014 17:01:22 -0700
Message-ID: <CALCETrVXn5HAcifiU1TnGUckNz8g7ZEw1FeMjLwVCpd6G+pq3g@mail.gmail.com>
Subject: Re: [PATCH v6 08/10] x86, mpx: add prctl commands PR_MPX_REGISTER, PR_MPX_UNREGISTER
To: Dave Hansen <dave.hansen@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Qiaowei Ren <qiaowei.ren@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2014 at 4:42 PM, Dave Hansen <dave.hansen@intel.com> wrote:
> On 06/23/2014 03:00 PM, Andy Lutomirski wrote:
>> Hmm.  How about PR_SET/GET_MPX_BOUNDS_TABLE, to update the kernel's
>> copy.  No fpu magic needed.
>>
>> This has an added benefit: CRIU will need updating for MPX, and
>> they'll appreciate having the required interface already exist.
>> (They'll want a way to allocate "MPX" memory, too, but that's probably
>> somewhat less important, and it won't result in duplicated
>> functionality.)
>
> I like the idea of the most minimal interface possible.  If the kernel
> ever needed or wanted to cache more of the register setup, we wouldn't
> need to change the interface.  For CRIU, I don't know much about the
> phases of how it sets itself up, but I guess the difference would be
> whether userspace has to do a register save and restore and a prctl() or
> just a plain prctl() with extra arguments.  Doesn't seem fundamentally
> different to me.
>
> BTW, it's not a pointer to a bounds table, it's the bounds directory.
> There are two levels of the tables.

I suspect that the existence of the get operation matters more.  What
if the checkpointed process has the cached copy out of sync with the
register copy?  More realistically, what if the checkpointed process
doesn't want to use kernel MPX assistance at all?  CRIU won't be able
to detect this with the current proposed interface.

--Andy
