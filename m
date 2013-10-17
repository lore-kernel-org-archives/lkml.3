Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756903Ab3JQPZs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 11:25:48 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:55980 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756745Ab3JQPZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 11:25:47 -0400
Date: Thu, 17 Oct 2013 11:25:41 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Chen Gong <gong.chen@linux.intel.com>
Cc: Borislav Petkov <bp@alien8.de>, tony.luck@intel.com, joe@perches.com,
        naveen.n.rao@linux.vnet.ibm.com, arozansk@redhat.com,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/9] Extended H/W error log driver
Message-ID: <20131017112541.166a44fb@gandalf.local.home>
In-Reply-To: <20131017143348.GA3891@gchen.bj.intel.com>
References: <1381935366-11731-1-git-send-email-gong.chen@linux.intel.com>
	<20131016160550.GG13608@pd.tnic>
	<20131016125646.7141b580@gandalf.local.home>
	<20131016180038.GO13608@pd.tnic>
	<20131016181117.GP13608@pd.tnic>
	<20131017143348.GA3891@gchen.bj.intel.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Oct 2013 10:33:48 -0400
Chen Gong <gong.chen@linux.intel.com> wrote:


> > Gong, can you try moving the CREATE_TRACE_POINTS line to a new file -
> > arch/x86/ras/ras.c and define it there and not anywhere else, i.e. move
> > it away from edac_mc.c. Does that help?
> 
> In current kernel we haven't arch/x86/ras/ras.c. You mean I create
> a new one there and just add some trace macro definition?

The CREATE_TRACE_POINTS will cause the TRACE_EVENT() macro to define
the functions used for tracing. If you have it defined more than once,
it will either cause a kernel compile error (variables declared more
than once), or if used in modules, will cause confusion (as well as
bloat) because different functions and variables will be defined for
the same tracepoint.

If you need to create a separate file that you can have it defined in a
single place, then please do so!

-- Steve
