Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754510AbaCJT6J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 15:58:09 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:63160 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753384AbaCJT6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 15:58:07 -0400
MIME-Version: 1.0
In-Reply-To: <20140310120657.80aa5569714e5b53c6662798@linux-foundation.org>
References: <1394240425-11647-1-git-send-email-keescook@chromium.org>
	<20140310120657.80aa5569714e5b53c6662798@linux-foundation.org>
Date: Mon, 10 Mar 2014 12:58:06 -0700
X-Google-Sender-Auth: QCLAbKmebgSuW6e_fC5YKnmaHFQ
Message-ID: <CAGXu5j+9Qt2p+dqdqcecMQ4RRb8tBVMqMDBdRGFjiRQHmDaatQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] kallsyms: handle special absolute symbols
From: Kees Cook <keescook@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Honig <ahonig@google.com>, Michal Marek <mmarek@suse.cz>,
        "x86@kernel.org" <x86@kernel.org>, Tejun Heo <tj@kernel.org>,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        linux-ia64@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 10, 2014 at 12:06 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Fri,  7 Mar 2014 17:00:23 -0800 Kees Cook <keescook@chromium.org> wrote:
>> Handles 0-based per_cpu variables as being absolute so they are
>> not relocated under kASLR on x86_64.
>
> Would it be prudent to revert 0f55159d091cb1e5 ("kallsyms: fix absolute
> addresses for kASLR") then sort all this out for 3.15?

My opinion is that if it breaks a real-life case (avr32), it should be
reverted. The only people affected by the kallsyms per_cpu relocation
reporting bug are those using kASLR on x86, and even then the bug is a
corner case on live kernel debugging.

I am fine either way.

-Kees

-- 
Kees Cook
Chrome OS Security
