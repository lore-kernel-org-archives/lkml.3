Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755644Ab3LDAyT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 19:54:19 -0500
Received: from ozlabs.org ([203.10.76.45]:55810 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754450Ab3LDAyS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 19:54:18 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        David Howells <dhowells@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, keescook@chromium.org
Subject: Re: [PATCH 1/2] test: add minimal module for verification testing
In-Reply-To: <1386106054-27636-2-git-send-email-keescook@chromium.org>
References: <1386106054-27636-1-git-send-email-keescook@chromium.org> <1386106054-27636-2-git-send-email-keescook@chromium.org>
User-Agent: Notmuch/0.15.2 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Wed, 04 Dec 2013 10:22:48 +1030
Message-ID: <877gblxzjj.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kees Cook <keescook@chromium.org> writes:
> When doing module loading verification tests (for example, with module
> singing, or LSM hooks), it is very handy to have a module that can be
> built on all systems under test, isn't auto-loaded at boot, and has
> no device or similar dependencies. This creates the "test_module.ko"
> module for that purpose, which only reports its load and unload to printk.

Bikeshed time!

> +#define pr_fmt(fmt) "test_module: " fmt

Perhaps:
        #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

Cheers,
Rusty.
