Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759885AbaJaUzg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 16:55:36 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:40355 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758932AbaJaUze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 16:55:34 -0400
MIME-Version: 1.0
In-Reply-To: <20141031203304.GA32697@cloud>
References: <20141031162037.GA26233@www.outflux.net>
	<20141031203304.GA32697@cloud>
Date: Fri, 31 Oct 2014 13:55:33 -0700
X-Google-Sender-Auth: qc_8OKhNHEekext3A3zf7DoFJIg
Message-ID: <CAGXu5jKu2uCTJ+cB1pjZs0MevS8mJcv2qH8wtw0B110hrqwqqg@mail.gmail.com>
Subject: Re: [PATCH] x86, boot: add hex output for debugging
From: Kees Cook <keescook@chromium.org>
To: Josh Triplett <josh@joshtriplett.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>, Vivek Goyal <vgoyal@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, Junjie Mao <eternal.n08@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2014 at 1:33 PM,  <josh@joshtriplett.org> wrote:
> On Fri, Oct 31, 2014 at 09:20:37AM -0700, Kees Cook wrote:
>> This is useful for reporting various addresses or other values while
>> debugging early boot.
>>
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>
> You haven't provided any user of this function.  I don't think this
> should get merged without a caller (nor should an artificial caller be
> added).  What's your use case for adding this?

I'll fix that.

> Also, while I realize __putstr already has this problem, ideally all the
> printing functions in this file should go in some separate source file
> that gets omitted when !CONFIG_PRINTK (or possibly
> !CONFIG_EARLY_PRINTK).

Hm, I don't agree: we need error_putstr, not just debug_putstr, and
early_printk is just for serial console, where as __putstr works
against the boot block's defined video area too, IIUC.

-Kees

-- 
Kees Cook
Chrome OS Security
