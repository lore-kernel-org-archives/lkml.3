Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751937Ab3KTN2M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 08:28:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57842 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750796Ab3KTN2J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 08:28:09 -0500
Date: Wed, 20 Nov 2013 14:27:49 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH] tools lib traceevent: Use helper trace-seq in print
 functions like kernel does
Message-ID: <20131120132749.GE1415@krava.brq.redhat.com>
References: <20131119182937.401668e3@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131119182937.401668e3@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 19, 2013 at 06:29:37PM -0500, Steven Rostedt wrote:
> Jiri Olso reported that his plugin for scsi was chopping off part of

s/Olso/Olsa/ 

;-)

> the output. Investigating this, I found that Jiri used the same
> functions as what is in the kernel, which adds the following:
> 
> 	trace_seq_putc(p, 0);
> 
> This adds a '\0' to the output string. The reason this works in the
> kernel is that the "p" that is passed to the function helper is a
> temporary trace_seq. But in the libtraceevent library, it's the pointer
> to the trace_seq used to output. By adding the '\0', it truncates the
> line and nothing added after that will be printed.
> 
> We can solve this in two ways. One is to have the helper functions for
> the library not add the unnecessary '\0'. The other is to change the
> library to also use a helper trace_seq structure that gets copied to
> the main trace_seq just like the kernel does.
> 
> The latter allows the helper functions in the plugins to be the same as
> the kernel, which is the better solution.
> 
> Reported-by: Jiri Olsa <jolsa@redhat.com>

Tested-by: Jiri Olsa <jolsa@redhat.com>

thanks,
jirka
