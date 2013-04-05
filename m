Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765520Ab3DEXSv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 19:18:51 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:49800 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759881Ab3DEXSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 19:18:50 -0400
MIME-Version: 1.0
In-Reply-To: <20130405204306.GA14092@pd.tnic>
References: <1365106055-22939-1-git-send-email-keescook@chromium.org>
	<1365106055-22939-4-git-send-email-keescook@chromium.org>
	<20130405144954.GC29290@pd.tnic>
	<CAKyRK=iEXpq9KnG_VJMYW-tpBxU_2TGaO_hZRkNY=J+7SNoQkA@mail.gmail.com>
	<20130405204306.GA14092@pd.tnic>
Date: Fri, 5 Apr 2013 16:18:49 -0700
X-Google-Sender-Auth: fk6TXHAxrzZiQb6n9cEzgU9jGhw
Message-ID: <CAGXu5jJtBgUXwMm6D=JnUvP3kv6YN2MwaF81-2GC-d+pJJFy6w@mail.gmail.com>
Subject: Re: [PATCH 3/3] x86: kernel base offset ASLR
From: Kees Cook <keescook@chromium.org>
To: Borislav Petkov <bp@alien8.de>, Julien Tinnes <jln@google.com>,
        Kees Cook <keescook@chromium.org>, LKML <linux-kernel@vger.kernel.org>,
        "kernel-hardening@lists.openwall.com" 
	<kernel-hardening@lists.openwall.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "x86@kernel.org" <x86@kernel.org>,
        Jarkko Sakkinen <jarkko.sakkinen@intel.com>,
        Matthew Garrett <mjg@redhat.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Eric Northup <digitaleric@google.com>,
        Dan Rosenberg <drosenberg@vsecurity.com>,
        Will Drewry <wad@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 5, 2013 at 1:43 PM, Borislav Petkov <bp@alien8.de> wrote:
> On Fri, Apr 05, 2013 at 01:19:39PM -0700, Julien Tinnes wrote:
>> I think it'd be perfectly ok for OOPS to print out the kernel base.
>
> Yeah, ok, this still would need some massaging of the oops output per
> script, but it shouldn't be a big problem.
>
> Also, you probably need to make clear in the oops itself that the
> addresses have been randomized. Or, is the mere presence of kernel base
> going to imply that?

There is already a hook in the patch that prints the offset:

+dump_kernel_offset(struct notifier_block *self, unsigned long v, void *p)
+{
+       pr_emerg("Kernel Offset: 0x%lx\n",
+                (unsigned long)&_text - __START_KERNEL);
...
+       atomic_notifier_chain_register(&panic_notifier_list,
+                                       &kernel_offset_notifier);

But of course, this can get improved.

-Kees

--
Kees Cook
Chrome OS Security
