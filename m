Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754557Ab3HETZl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 15:25:41 -0400
Received: from mail-ve0-f179.google.com ([209.85.128.179]:47319 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754136Ab3HETZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 15:25:40 -0400
MIME-Version: 1.0
In-Reply-To: <87siyo3qna.fsf@tassilo.jf.intel.com>
References: <1375721715.22073.80.camel@gandalf.local.home>
	<87siyo3qna.fsf@tassilo.jf.intel.com>
Date: Mon, 5 Aug 2013 12:25:39 -0700
X-Google-Sender-Auth: 5PYzgSrwjf082KL4ek7TsGp6010
Message-ID: <CA+55aFxBQuj1+4XzuqWpBw8YHfguJ6Y42KO0weS9a9mpXQKq7g@mail.gmail.com>
Subject: Re: [RFC] gcc feature request: Moving blocks into sections
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        gcc <gcc@gcc.gnu.org>, Ingo Molnar <mingo@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Daney <ddaney.cavm@gmail.com>,
        Behan Webster <behanw@converseincode.com>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 5, 2013 at 12:04 PM, Andi Kleen <andi@firstfloor.org> wrote:
> Steven Rostedt <rostedt@goodmis.org> writes:
>
> Can't you just use -freorder-blocks-and-partition?
>
> This should already partition unlikely blocks into a
> different section. Just a single one of course.

That's horrible. Not because of dwarf problems, but exactly because
unlikely code isn't necessarily *that* unlikely, and normal unlikely
code is reached with a small branch. Making it a whole different
section breaks both of those.

Maybe some "really_unlikely()" would make it ok.

                  Linus
