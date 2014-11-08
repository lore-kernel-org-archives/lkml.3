Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753217AbaKHAEQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 19:04:16 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:52979 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752256AbaKHAEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 19:04:15 -0500
Date: Fri, 7 Nov 2014 19:04:13 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Rabin Vincent <rabin@rab.in>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] tracing: don't busy wait in buffer splice
Message-ID: <20141107190413.28a2ae84@gandalf.local.home>
In-Reply-To: <20141107132106.0c318068@gandalf.local.home>
References: <1415309167-2373-1-git-send-email-rabin@rab.in>
	<20141107132106.0c318068@gandalf.local.home>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Nov 2014 13:21:06 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:


> This also needs to be marked for stable. I'll start looking at how far
> this goes back. I'm thinking it may go back as far as the splice code
> was created.

Actually, it is broken back to 3.16. 3.15 and before was safe because
it was still using the mockup poll_wait_pipe() that would wake up every
1/10 of a second to see if something was in the buffer.

See commit: b1169cc69ba9 "tracing: Remove mock up poll wait function"

-- Steve
