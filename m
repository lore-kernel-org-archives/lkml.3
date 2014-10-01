Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751552AbaJAFY6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 01:24:58 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:47288 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187AbaJAFY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 01:24:57 -0400
MIME-Version: 1.0
In-Reply-To: <542B8C7F.70108@fds-team.de>
References: <cover.1412138935.git.luto@amacapital.net> <0e906bdeba3660c9766248d3d7229e78a423ca5b.1412138935.git.luto@amacapital.net>
 <542B8C7F.70108@fds-team.de>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 30 Sep 2014 22:24:35 -0700
Message-ID: <CALCETrVNMhvn6z_5=+6UavkR1m8cABrkSWsLpP_dLdG_3OipBA@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] x86_64,entry: Filter RFLAGS.NT on entry from userspace
To: Sebastian Lackner <sebastian@fds-team.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, X86 ML <x86@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Anish Bhatt <anish@chelsio.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chuck Ebbert <cebbert.lkml@gmail.com>, stable <stable@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2014 at 10:09 PM, Sebastian Lackner
<sebastian@fds-team.de> wrote:
>> +     testl $X86_EFLAGS_NT,EFLAGS(%rsp)       /* saved EFLAGS match cpu */
>> +     jz 1f
>> +     pushq_cfi $(X86_EFLAGS_IF|X86_EFLAGS_FIXED)
>> +     popfq_cfi
>> +1:
>> +
>
> Do you think it makes sense to change the order here, so that no jump happens if
> NT is not set (which happens a bit more often, than the other way round)? Just a
> guess though, haven't measured if pipeline effects have such a big influence in this
> case. ;)
>

It should be immeasurable in a tight loop, since it will predict
correctly almost every time.  And, unless cfi state works across
.pushsection (does it?), getting the cfi annotations right will be
more complicated.

--Andy

-- 
Andy Lutomirski
AMA Capital Management, LLC
