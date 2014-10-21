Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933749AbaJUWQa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 18:16:30 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:42616 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932998AbaJUWQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 18:16:29 -0400
MIME-Version: 1.0
In-Reply-To: <54468063.4070408@zytor.com>
References: <1412186248-18672-1-git-send-email-bobby.prani@gmail.com>
 <CAJhHMCDhhoxj25pmkxO2AhLwj6ur9ga3yRcViuH+DU-8K+Ch5g@mail.gmail.com>
 <20141021101412.GS23531@worktop.programming.kicks-ass.net> <54468063.4070408@zytor.com>
From: Pranith Kumar <bobby.prani@gmail.com>
Date: Tue, 21 Oct 2014 18:15:58 -0400
Message-ID: <CAJhHMCAEEiumQVx93K069GY-XQ3RzyDOSK6-9qL9BSEc4z23YQ@mail.gmail.com>
Subject: Re: [PATCH] cmpxchg: Discard unnecessary cast to volatile
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "maintainer:X86 ARCHITECTURE..." <x86@kernel.org>,
        Borislav Petkov <bp@suse.de>,
        "open list:X86 ARCHITECTURE..." <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2014 at 11:48 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 10/21/2014 03:14 AM, Peter Zijlstra wrote:
>> On Mon, Oct 20, 2014 at 04:22:27PM -0400, Pranith Kumar wrote:
>>>> Generating a volatile pointer is really not necessary here. This is the only
>>>> location where a volatile pointer is being generated for use in asm.
>>>>
>>>> This commit removes the unnecessary volatile pointer being created.
>>>>
>>>> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
>>
>> Seems sane enough to me.
>>
>
> However, it seems like unnecessary churn.  Does the volatile hurt in any
> way?

Removing 4 lines of unnecessary code seems to be worthwhile to me.
Also, we reduce the unnecessary use of 'volatile' data types which
IMHO makes this a good little clean up.

I am not sure if the use of volatile actually causes any loss of
chances of optimization. I've tried to come up with cases where this
happens and was unsuccessful.

-- 
Pranith
