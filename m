Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755399AbbAGXZQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 18:25:16 -0500
Received: from mail-la0-f52.google.com ([209.85.215.52]:53592 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945AbbAGXZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 18:25:14 -0500
MIME-Version: 1.0
In-Reply-To: <54ADBEB1.7000902@linux.intel.com>
References: <cover.1419900414.git.luto@amacapital.net> <d5efe02b133f6d9fb4cb9d03e0f0b9e17211c06f.1419900414.git.luto@amacapital.net>
 <54A64E6D.1020304@linux.intel.com> <87mw5x0xjz.fsf@tassilo.jf.intel.com>
 <54AAFFA3.6000901@linux.intel.com> <CALCETrUeMS7zwjXfSMN-6A8-gpLc68n7U5Y6SPdzgw6hSbYGNg@mail.gmail.com>
 <54ADBEB1.7000902@linux.intel.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 7 Jan 2015 15:24:52 -0800
Message-ID: <CALCETrWcG8SBoY6Zcb_2O-9hV5tbevjDYZ_SpfzB=km+tLW94g@mail.gmail.com>
Subject: Re: [PATCH 3.19 3/3] x86, mpx: Change the MPX enable/disable API to arch_prctl
To: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Andi Kleen <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 7, 2015 at 3:18 PM, Dave Hansen <dave.hansen@linux.intel.com> wrote:
> On 01/05/2015 03:04 PM, Andy Lutomirski wrote:
>> Anyway, if it's actually a problem to change it, I have no real
>> problem keeping it, but I think we *really* need to validate the rest
>> of the arguments at the very least.
>
> If we "validate" the arguments like you suggested, then a call like this:
>
>         prctl(PR_MPX_DISABLE_MANAGEMENT);
>
> ends up returning -EINVAL:
>
>> prctl(0x2b /* PR_??? */, 0x7fffffd3, 0x7f360955e9e0, 0x2c, 0x7f3609314840) = -1 EINVAL (Invalid argument)
>
> A quick grep through ltp and some other source I have laying around does
> *not* show folks adding 0's to these calls for "empty" arguments.  Is
> this really something we want to do?
>
>         prctl(PR_MPX_DISABLE_MANAGEMENT, 0, 0, 0, 0);

Yes, because we might want to do prctl(PR_MPX_ENABLE_MANAGEMENT, x, y,
z, 0) some day.

--Andy

-- 
Andy Lutomirski
AMA Capital Management, LLC
