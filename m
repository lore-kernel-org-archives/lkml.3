Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757533AbaDHRce (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 13:32:34 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:34216 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756377AbaDHRcd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 13:32:33 -0400
Date: Tue, 8 Apr 2014 13:32:31 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [for-next][PATCH 14/14] tracing: Get trace_array ref counts
 when accessing trace files
Message-ID: <20140408133231.3b62f3da@gandalf.local.home>
In-Reply-To: <53442DC4.6010909@oracle.com>
References: <20130702202216.623562799@goodmis.org>
	<20130702202427.455930200@goodmis.org>
	<53401A3E.2090302@oracle.com>
	<20140408123638.7f340dd5@gandalf.local.home>
	<53442934.8010107@oracle.com>
	<20140408130645.548ae58f@gandalf.local.home>
	<53442DC4.6010909@oracle.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 08 Apr 2014 13:11:32 -0400
Sasha Levin <sasha.levin@oracle.com> wrote:

> >>
> >> Although when I mount everything for the fuzzer I do it with '-onoexec,nosuid'
> >> and the fuzzer is banned from testing mount(), so I'm not sure how it would
> >> do that thing on it's own.
> > 
> > What does the -onoexec do? Not change the exec flag of files?
> 
> It lets you set it as executable, but it won't let you actually exec it.
> 
> > Also, I wonder if this has something to do with the syscall being a
> > compat sys_exec and not a native one. Is userspace on your vm 32bit? Or
> > does the fuzzer just try the different compat calls?
> 
> Right, everything is 64bit but the fuzzer tries 32bit calls as well.

When this bug is triggered, is there a way to let the fuzzer tell us
what exactly the last syscall it sent was? That is, the syscall number
plus all its arguments?

-- Steve
