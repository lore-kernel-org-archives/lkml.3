Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755760Ab3FGVSf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 17:18:35 -0400
Received: from mx4-phx2.redhat.com ([209.132.183.25]:59439 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752746Ab3FGVSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 17:18:34 -0400
Date: Fri, 7 Jun 2013 17:18:24 -0400 (EDT)
From: Jonathan Lebon <jlebon@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, "Frank Ch. Eigler" <fche@redhat.com>,
        systemtap@sourceware.org,
        yrl pp-manager tt <yrl.pp-manager.tt@hitachi.com>
Message-ID: <1762661340.20262318.1370639904525.JavaMail.root@redhat.com>
In-Reply-To: <1370552806.9844.50.camel@gandalf.local.home>
References: <20130605031216.15285.2001.stgit@mhiramat-M0-7522> <1370552806.9844.50.camel@gandalf.local.home>
Subject: Re: [PATCH -tip ] [BUGFIX] kprobes: Fix arch_prepare_kprobe to
 handle copy insn failures
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.82.11]
X-Mailer: Zimbra 8.0.3_GA_5664 (ZimbraWebClient - FF21 (Linux)/8.0.3_GA_5664)
Thread-Topic: kprobes: Fix arch_prepare_kprobe to handle copy insn failures
Thread-Index: 1QRvT6lgyeAtwIPcRIUFEbp1uXwt/g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tested-by: Jonathan Lebon <jlebon@redhat.com>

Stress-tested overnight in a VM with no problems.

Jonathan

----- Original Message -----
From: "Steven Rostedt" <rostedt@goodmis.org>
To: "Masami Hiramatsu" <masami.hiramatsu.pt@hitachi.com>
Cc: "Ingo Molnar" <mingo@redhat.com>, linux-kernel@vger.kernel.org, "Ingo Molnar" <mingo@kernel.org>, "Frank Ch. Eigler" <fche@redhat.com>, systemtap@sourceware.org, "yrl pp-manager tt" <yrl.pp-manager.tt@hitachi.com>
Sent: Thursday, June 6, 2013 5:06:46 PM
Subject: Re: [PATCH -tip ] [BUGFIX] kprobes: Fix arch_prepare_kprobe to handle copy insn failures

On Wed, 2013-06-05 at 12:12 +0900, Masami Hiramatsu wrote:
> Fix arch_prepare_kprobe() to handle failures in copy instruction
> correctly. This fix is related to the previous fix: 8101376
> which made __copy_instruction return an error result if failed,
> but caller site was not updated to handle it. Thus, this is the
> other half of the bugfix.
> 
> This fix is also related to the following bug-report:
> 
>    https://bugzilla.redhat.com/show_bug.cgi?id=910649
> 
> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Cc: Frank Ch. Eigler <fche@redhat.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

> Cc: Ingo Molnar <mingo@kernel.org>
> ---
>  arch/x86/kernel/kprobes/core.c |   14 ++++++++++----
>  1 file changed, 10 insertions(+), 4 deletions(-)
> 


