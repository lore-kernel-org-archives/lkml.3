Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752051Ab3ASMer (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2013 07:34:47 -0500
Received: from mail-qc0-f177.google.com ([209.85.216.177]:63261 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414Ab3ASMeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2013 07:34:46 -0500
MIME-Version: 1.0
In-Reply-To: <50FA0661.2060400@linux.intel.com>
References: <87sjaaj3cx.fsf@xmission.com>
	<1348529239-17943-1-git-send-email-hpa@linux.intel.com>
	<20121010125927.0968dd8b@dev.queued.net>
	<20130118164043.29674d75@dev.queued.net>
	<50F9EBEA.9020805@linux.intel.com>
	<50F9F152.1000907@laptop.org>
	<50FA0661.2060400@linux.intel.com>
Date: Sat, 19 Jan 2013 06:34:45 -0600
X-Google-Sender-Auth: wpNSYO_m-g9uBUsfYGuwdGwSqzs
Message-ID: <CAMLZHHSxC+hAuo4Rjz8EhcXD+wGZmN8FFfPv6QwyZ=nZ+p-r8g@mail.gmail.com>
Subject: Re: [Techteam] [RFC PATCH] x86-32: Start out eflags and cr4 clean
From: Daniel Drake <dsd@laptop.org>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Mitch Bradley <wmb@laptop.org>, Jeremy Fitzhardinge <jeremy@goop.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Vivek Goyal <vgoyal@in.ibm.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Dave Jones <davej@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        David Woodhouse <dwmw2@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        techteam <techteam@lists.laptop.org>,
        Yinghai Lu <yhlu.kernel@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2013 at 8:35 PM, H. Peter Anvin <hpa@linux.intel.com> wrote:
> Can we simply disable paging before mucking with CR4?  The other option
> that I can see is to always enable PSE and PGE, since they are simply
> features opt-ins that don't do any harm if unused.  At the same time,
> though, entering the kernel through the default_entry path with paging
> enabled is definitely not anything the kernel expects.
>
> Does this patch work for you?  Since we have ditched 386 support, we can
> mimic x86-64 (yay, one more difference gone!) and just use a predefined
> value for %cr0 (the FPU flags need to change if we are on an FPU-less
> chip, but that happens during FPU probing.)

The patch fixes boot on XO-1.5. Thanks for the quick response!

Daniel
