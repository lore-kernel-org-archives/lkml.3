Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933064Ab3BOQcu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 11:32:50 -0500
Received: from mail1.windriver.com ([147.11.146.13]:57614 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758340Ab3BOQcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 11:32:48 -0500
Message-ID: <511E6329.5050903@windriver.com>
Date: Fri, 15 Feb 2013 11:32:41 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>
CC: LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        Richard Weinberger <richard@nod.at>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] futex: avoid kernel taint caused by get_robust_list
References: <1360943688-12502-1-git-send-email-paul.gortmaker@windriver.com> <CAGXu5jJxPU2Skr12u07fTeg+8im6L4JHv23+TrB+qVWMY36F_w@mail.gmail.com>
In-Reply-To: <CAGXu5jJxPU2Skr12u07fTeg+8im6L4JHv23+TrB+qVWMY36F_w@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.146.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13-02-15 11:18 AM, Kees Cook wrote:
> On Fri, Feb 15, 2013 at 7:54 AM, Paul Gortmaker
> <paul.gortmaker@windriver.com> wrote:
>> commit ec0c4274e33c0373e476b73e01995c53128f1257 ("futex: Mark
>> get_robust_list as deprecated") added these two WARN_ONCE calls.
>>
>> However, WARN_ONCE taints the kernel, and we shouldn't be allowing
>> any user who wanders by to do this.  For example, the system fuzzer
>> "trinity" uses the tainted state as a metric for when to stop,
>> assuming that it has caused significant wreckage (and indeed
>> that tool is what actually led me to this change).
>>
>> The ability to deprecate this code has been called into question[1],
>> but if that remains to be finalized, then making this change in the
>> interim seems to make sense.
>>
>> [1] http://lkml.indiana.edu/hypermail/linux/kernel/1208.0/01081.html
>>
>> Cc: Dave Jones <davej@redhat.com>
>> Cc: Richard Weinberger <richard@nod.at>
>> Cc: Kees Cook <keescook@chromium.org>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: stable@vger.kernel.org      # 3.4+
>> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
> 
> I Acked the original revert. I thought there was agreement that it was
> needed for checkpointing to work?

There were several acks in the original thread, but for some unknown
reason (at least unknown to me and Richard), it never made it in tree...

P.
--

> 
> -Kees
> 
