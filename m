Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176Ab3H1N6f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 09:58:35 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:31122 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752854Ab3H1N6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 09:58:34 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=jxQzypR4wcoA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=qWrlR9Lw5PkA:10 a=PXpbpN4H8RDWqTHrRzIA:9 a=CjuIK1q_8ugA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Wed, 28 Aug 2013 09:58:33 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: FTRACE_WARN_ON((rec->flags & ~FTRACE_FL_MASK) == 0))
Message-ID: <20130828095833.103ccdf0@gandalf.local.home>
In-Reply-To: <20130828095408.37c3dd83@gandalf.local.home>
References: <20130828034627.GA30596@redhat.com>
	<20130828095408.37c3dd83@gandalf.local.home>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Aug 2013 09:54:08 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> OK, this is a hint. The __unregister_ftrace_function returned an error
> code, and called ftrace_shutdown(). This is an error path that is not
> tested much. So perhaps you did find another place that can cause the
> accounting to get out of sync.

I'll take that back. The ftrace_shutdown() is called on success, thus
this is a normal path. I have to find out what perf is doing. Do you
have any clue to what calls are being made to perf?

-- Steve

