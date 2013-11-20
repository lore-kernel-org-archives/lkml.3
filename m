Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766Ab3KTRZd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 12:25:33 -0500
Received: from mga02.intel.com ([134.134.136.20]:1925 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754424Ab3KTRZc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 12:25:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="438650369"
From: Andi Kleen <andi@firstfloor.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] Add a text_poke syscall
References: <1384820855-27790-1-git-send-email-andi@firstfloor.org>
	<528AF5D7.7000308@zytor.com>
	<20131119184959.GE29695@two.firstfloor.org>
	<528CE65B.6020300@zytor.com>
Date: Wed, 20 Nov 2013 09:25:31 -0800
In-Reply-To: <528CE65B.6020300@zytor.com> (H. Peter Anvin's message of "Wed,
	20 Nov 2013 08:42:03 -0800")
Message-ID: <87mwkzvvck.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:
>
> We're talking user space here, which has different requirement (COW,
> memory protection, ...) which means it is not really the same code.  You
> can't take a page fault while patching the kernel.

The syscall pins the page, then it calls the kernel code.
There are no page faults during patching.

> I'm referring to if some thread actually stumbles over INT 3, which is
> indeed not very long for one patch site (as long as you don't end up
> with page faults.)  However, for tracing, you may want to do tens of
> thousands of patches, and you really want to batch them.

For tens of thousand of patches you very likely don't want 
live patching, but a stop everything approach.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
