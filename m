Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753683AbaA3TwL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 14:52:11 -0500
Received: from mail-vc0-f177.google.com ([209.85.220.177]:58082 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165AbaA3TwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 14:52:10 -0500
MIME-Version: 1.0
In-Reply-To: <1391110034.945.5.camel@wall-e.seibold.net>
References: <1391078953-1575-1-git-send-email-stefani@seibold.net>
 <1391078953-1575-2-git-send-email-stefani@seibold.net> <CALCETrXqnrDu=rceAm++bGLicj44FfYsxm9-KvqU=B1zkei9TA@mail.gmail.com>
 <1391110034.945.5.camel@wall-e.seibold.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 30 Jan 2014 11:51:49 -0800
Message-ID: <CALCETrUvKLwPccVVNpmLwxemAuE4DrmOB0C-jGTBTqcH5zPdCA@mail.gmail.com>
Subject: Re: [PATCH 1/4] Make vsyscall_gtod_data handling x86 generic
To: Stefani Seibold <stefani@seibold.net>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        John Stultz <john.stultz@linaro.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        andriy.shevchenko@linux.intel.com, Martin.Runge@rohde-schwarz.com,
        Andreas.Brief@rohde-schwarz.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 30, 2014 at 11:27 AM, Stefani Seibold <stefani@seibold.net> wrote:
> Am Donnerstag, den 30.01.2014, 10:05 -0800 schrieb Andy Lutomirski:
>> On Thu, Jan 30, 2014 at 2:49 AM,  <stefani@seibold.net> wrote:
>> > diff --git a/arch/x86/include/asm/compat.h b/arch/x86/include/asm/compat.h
>> > index 59c6c40..45ba688 100644
>> > --- a/arch/x86/include/asm/compat.h
>> > +++ b/arch/x86/include/asm/compat.h
>> > @@ -295,6 +295,10 @@ static inline compat_uptr_t ptr_to_compat(void __user *uptr)
>> >
>> >  static inline void __user *arch_compat_alloc_user_space(long len)
>> >  {
>> > +#ifdef CONFIG_X86_32
>> > +       struct pt_regs *regs = task_pt_regs(current);
>> > +       return (void __user *)regs->sp - len;
>>
>> Is there some reason this doesn't need to be aligned?
>>
>
> The reason is that this function will not used for 32 bit kernels, but
> will the header will be included... This prevents an error!

Then why not just guard the whole function with an ifdef?  Having a
piece of actual code that's not intended to be used (and might not
work) seems like a bad idea.

--Andy
