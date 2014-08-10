Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751480AbaHJPpW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 11:45:22 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:58498 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134AbaHJPpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 11:45:20 -0400
Date: Sun, 10 Aug 2014 17:45:15 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: x86-ml <x86@kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jason Baron <jbaron@akamai.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC PATCH] Flipped jump labels
Message-ID: <20140810154515.GA27199@gmail.com>
References: <20140809105742.GA5910@pd.tnic>
 <20140810061103.GA13968@gmail.com>
 <20140810061303.GA14206@gmail.com>
 <20140810153539.GA9490@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140810153539.GA9490@pd.tnic>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Borislav Petkov <bp@alien8.de> wrote:

> On Sun, Aug 10, 2014 at 08:13:03AM +0200, Ingo Molnar wrote:
> > Wouldn't using STATIC_KEY_INIT_TRUE and static_key_true() [instead of
> > !static_key_false()] result in the same good code placement effects?
> 
> Nope, not really. static_key_true() is !static_key_false() and we're not
> changing anything, logically. ASM looks non-optimal here, in any case,
> with the "true" version.

Indeed - but could we use that interface to cleanly expose the 
arch_static_branch_active() code you've written, or do we need new 
variants?

Thanks,

	Ingo
