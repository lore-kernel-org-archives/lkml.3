Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751435Ab3ELS40 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 14:56:26 -0400
Received: from mail-vb0-f45.google.com ([209.85.212.45]:51815 "EHLO
	mail-vb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174Ab3ELS4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 14:56:25 -0400
MIME-Version: 1.0
In-Reply-To: <1368363048.6828.16.camel@gandalf.local.home>
References: <20130511001206.477862307@goodmis.org>
	<CA+55aFyftw6uxJ=pO4DgN7ZrKxE5X-cbQahMjKKu6Rb++EGhqQ@mail.gmail.com>
	<1368324689.6828.13.camel@gandalf.local.home>
	<1368325352.6828.14.camel@gandalf.local.home>
	<1368363048.6828.16.camel@gandalf.local.home>
Date: Sun, 12 May 2013 11:56:24 -0700
X-Google-Sender-Auth: TCJbd2pgK8Vuw2LHN68FSlf0dZI
Message-ID: <CA+55aFyHntuNYvVhev7+ApoAtX-ywZa-r1m4131qYe8yioG4mw@mail.gmail.com>
Subject: Re: [PATCH 00/18] tracing/kprobes: Update kprobes with new ftrace changes
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>, Michal Marek <mmarek@suse.cz>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 12, 2013 at 5:50 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
>
> Hmm, I'm still not able to reproduce this. Can you do a make mrproper
> and rebuild and see if you still get that warning.

Hmm. It *may* indicate some kind of build problem. The build I got
that for was an allmodconfig build, but I had interrupted the previous
one in the middle, because I wanted to re-do the build with the proper
version number. I wonder if there's some race where if you ^C the
build at just the right time the CRC's don't get done right?

Michal: any ideas? The errors are of the type:

   WARNING: "ring_buffer_event_data" [*/*/*.ko] has no CRC!

and maybe there's a problem with genksyms.c leaving an empty (or
incomplete) file around when interrupted, and it then gets reused the
next time around?

            Linus
