Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752854AbaBUCbA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 21:31:00 -0500
Received: from ozlabs.org ([203.10.76.45]:35631 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751706AbaBUCa7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 21:30:59 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Howells <dhowells@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [RFC PATCH] Fix: module signature vs tracepoints: add new TAINT_UNSIGNED_MODULE
In-Reply-To: <20140220103033.32860caf@gandalf.local.home>
References: <1392074600-21977-1-git-send-email-mathieu.desnoyers@efficios.com> <20140211072738.GA24232@gmail.com> <20140211234534.6bc34e57@gandalf.local.home> <877g8zg0ed.fsf@rustcorp.com.au> <20140213161156.3548df43@gandalf.local.home> <878uteecu0.fsf@rustcorp.com.au> <20140220103033.32860caf@gandalf.local.home>
User-Agent: Notmuch/0.15.2 (http://notmuchmail.org) Emacs/23.4.1 (x86_64-pc-linux-gnu)
Date: Fri, 21 Feb 2014 09:39:18 +1030
Message-ID: <87lhx59yap.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt <rostedt@goodmis.org> writes:
> I need to clean out my email box. This email was hidden in between a
> pile of other crap email.
>
> On Fri, 14 Feb 2014 11:21:19 +1030
> Rusty Russell <rusty@rustcorp.com.au> wrote:
>
>> Steven Rostedt <rostedt@goodmis.org> writes:
>> > On Thu, 13 Feb 2014 13:54:42 +1030
>> > Rusty Russell <rusty@rustcorp.com.au> wrote:
>> >
>> >
>> >> I'm ambivalent towards out-of-tree modules, so not tempted unless I see
>> >> a bug report indicating a concrete problem.  Then we can discuss...
>> >
>> > As I replied in another email, this is a concrete problem, and affects
>> > in-tree kernel modules.
>> >
>> > If you have the following in your .config:
>> >
>> > CONFIG_MODULE_SIG=y
>> > # CONFIG_MODULE_SIG_FORCE is not set
>> > # CONFIG_MODULE_SIG_ALL is not set
>> 
>> This means you've set the "I will arrange my own module signing" config
>> option:
>> 
>> 	  Sign all modules during make modules_install. Without this option,
>> 	  modules must be signed manually, using the scripts/sign-file tool.
>> 
>> comment "Do not forget to sign required modules with scripts/sign-file"
>> 	depends on MODULE_SIG_FORCE && !MODULE_SIG_ALL
>> 
>> Then you didn't do that.  You broke it, you get to keep both pieces.
>
> In this case we should fail the module load all together, and require
> insmod to add the --force flag to load it. Why the hell are we setting
> a FORCED_MODULE flag when no module was forced????

If this mistake of creating unsigned modules is common, then it would be
friendly to do something about it, yes.

Perhaps we should append UNSIGNED to vermagic, and then strip that out
when we sign the module?  That would have this effect.

Cheers,
Rusty.
