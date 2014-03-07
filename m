Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752174AbaCGDko (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 22:40:44 -0500
Received: from ozlabs.org ([203.10.76.45]:42946 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751610AbaCGDkl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 22:40:41 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Kees Cook <keescook@chromium.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrew Honig <ahonig@google.com>, Michal Marek <mmarek@suse.cz>,
        "x86\@kernel.org" <x86@kernel.org>, Tejun Heo <tj@kernel.org>,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        linux-ia64@vger.kernel.org, keescook@chromium.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] kallsyms: handle special absolute symbols
In-Reply-To: <1394152324-26304-3-git-send-email-keescook@chromium.org>
References: <1394152324-26304-1-git-send-email-keescook@chromium.org> <1394152324-26304-3-git-send-email-keescook@chromium.org>
User-Agent: Notmuch/0.15.2 (http://notmuchmail.org) Emacs/23.4.1 (x86_64-pc-linux-gnu)
Date: Fri, 07 Mar 2014 13:55:00 +1030
Message-ID: <8761nqzo4z.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kees Cook <keescook@chromium.org> writes:
> This forces the entire per_cpu range to be reported as absolute without
> losing their linker symbol types. Without this, the variables are
> incorrectly shown as relocated under kASLR.

I like these patches, thanks!

This one's a bit broken, since the zero-based __per_cpu_start/end thing
is an x86-64-ism.  You really do want them relocated on other
platforms, so I think you'll need do make this conditional via
a --per-cpu-absolute flag to kallsyms (which x86-64 would set).

Dumb Q: why don't we actually present these symbols as absolute in
/proc/kallsyms?  Seems like it would be clearer...

Thanks,
Rusty.
