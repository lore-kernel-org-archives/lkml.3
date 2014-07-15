Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934344AbaGOXXf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 19:23:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45719 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756416AbaGOXXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 19:23:32 -0400
Date: Tue, 15 Jul 2014 16:23:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mathias Krause <minipli@googlemail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joe Perches <joe@perches.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/8] printk: Provide pi_<level> / pe_<level> macros
 for __init / __exit code
Message-Id: <20140715162330.f9b18b79c0f32b84cb7a9071@linux-foundation.org>
In-Reply-To: <1405176212-12175-3-git-send-email-minipli@googlemail.com>
References: <1405176212-12175-1-git-send-email-minipli@googlemail.com>
	<1405176212-12175-3-git-send-email-minipli@googlemail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 12 Jul 2014 16:43:26 +0200 Mathias Krause <minipli@googlemail.com> wrote:

> The memory used for functions marked with __init will be released after
> initialization, albeit static data referenced by such code will not, if
> not explicitly marked this way, too. This is especially true for format
> strings used in messages printed by such code. Those are not marked and
> therefore will survive the __init cleanup -- dangling in memory without
> ever being referenced again.
> 
> Ideally we would like the compiler to automatically recognise such
> constructs but it does not and it's not as simple as it might sound, as
> strings used in initialization code might latter still be used, e.g. as
> a slab cache name. Therefore we need to explicitly mark the strings we
> want to release together with the function itself.
> 
> For a seamless integration of the necessary __init_str() / __exit_str()
> macros to mark the format strings, this patch provides new variants of
> the well known pr_<level>() macros as pi_<level>() for __init code and
> pe_<level>() for __exit code. Changing existing code should thereby be
> as simple as changing a single letter.
> 
> For code that cannot be changed to use the pi_<level>() / pe_<level>()
> macros printk_init() and printk_exit() macros are provided, too.
> 
> One remark, though: We cannot provide appropriate p[ie]_debug() macros
> for the CONFIG_DYNAMIC_DEBUG case as there is (currently) no way to
> remove entries from dyndbg after initialization. But supporting that
> scenario would require more work (and code), therefore not necessarily
> justifying the memory savings.

I assume that if a programmer gets this wrong,
CONFIG_DEBUG_SECTION_MISMATCH will detect and report the error?

Please thoroughly test this if you have not done so.
