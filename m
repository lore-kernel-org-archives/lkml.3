Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751892AbaANXUg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 18:20:36 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:61039 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751574AbaANXUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 18:20:31 -0500
Date: Tue, 14 Jan 2014 18:20:29 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Petr Mladek <pmladek@suse.cz>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
        x86@kernel.org
Subject: Re: [PATCH v6 1/8] x86: allow to handle errors in text_poke
 function family
Message-ID: <20140114182029.27fa13f9@gandalf.local.home>
In-Reply-To: <1386690140-19941-2-git-send-email-pmladek@suse.cz>
References: <1386690140-19941-1-git-send-email-pmladek@suse.cz>
	<1386690140-19941-2-git-send-email-pmladek@suse.cz>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


FYI, for future patches, start the subject with a capital letter. ie:
 x86: Allow to handle errors in text_poke function family

On Tue, 10 Dec 2013 16:42:13 +0100
Petr Mladek <pmladek@suse.cz> wrote:

> The text_poke functions called BUG() in case of error. This was too strict.
> There are situations when the system is still usable even when the patching
> has failed, for example when enabling the dynamic ftrace.
> 
> This commit modifies text_poke and text_poke_bp functions to return an error
> code instead of calling BUG(). They used to return the patched address. But
> the address was just copied from the first parameter. It was no extra
> information and it has not been used anywhere yet.
> 
> There are some situations where it is hard to recover from an error. Masami
> Hiramatsu <masami.hiramatsu.pt@hitachi.com> suggested to create
> text_poke*_or_die() variants for this purpose.

I don't like the "_or_die()". Although I don't care much about it, I'm
thinking the x86 maintainers might not like it either.

What about just doing the test in the places that would call "or_die"?

	ret = text_poke*();
	BUG_ON(ret);

?

-- Steve

> 
> Last but not least, we modify return value of the text_poke_early() function.
> It is not capable of returning an error code. Let's return void to make
> it clear.
> 
> Finally, we also need to modify the few locations where text_poke functions
> were used and the error code has to be handled now.
> 
> Signed-off-by: Petr Mladek <pmladek@suse.cz>
> ---

