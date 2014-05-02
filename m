Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753125AbaEBWeN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 18:34:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49387 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752923AbaEBWeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 18:34:12 -0400
Date: Fri, 2 May 2014 15:34:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Mateusz Guzik <mguzik@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
        Mel Gorman <mgorman@suse.de>, Kay Sievers <kay@vrfy.org>
Subject: Re: [RFC PATCH] cmdline: Hide "debug" from /proc/cmdline
Message-Id: <20140502153409.329d3b5b426275e8197251a2@linux-foundation.org>
In-Reply-To: <87wqf1oi22.fsf@rustcorp.com.au>
References: <20140402144219.4cafbe37@gandalf.local.home>
	<20140402221212.GD16570@mguzik.redhat.com>
	<CA+55aFyZSr4G2a1X5+EeSgKGtZvzBfBg0D0L39g-DB9TLi+ZEw@mail.gmail.com>
	<87wqf1oi22.fsf@rustcorp.com.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 07 Apr 2014 14:24:45 +0930 Rusty Russell <rusty@rustcorp.com.au> wrote:

> Subject: param: hand arguments after -- straight to init
> 
> The kernel passes any args it doesn't need through to init, except it
> assumes anything containing '.' belongs to the kernel (for a module).
> This change means all users can clearly distinguish which arguments
> are for init.
> 
> For example, the kernel uses debug ("dee-bug") to mean log everything to
> the console, where systemd uses the debug from the Scandinavian "day-boog"
> meaning "fail to boot".  If a future versions uses argv[] instead of
> reading /proc/cmdline, this confusion will be avoided.
> 
> eg: test 'FOO="this is --foo"' -- 'systemd.debug="true true true"'
> 
> Gives:
> argv[0] = '/debug-init'
> argv[1] = 'test'
> argv[2] = 'systemd.debug=true true true'
> envp[0] = 'HOME=/'
> envp[1] = 'TERM=linux'
> envp[2] = 'FOO=this is --foo'

This (user-facing) feature doesn't seem to have been documented
anywhere.  Documentation/kernel-parameters.txt, I guess.
