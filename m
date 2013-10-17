Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757433Ab3JQPfu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 11:35:50 -0400
Received: from mail.skyhub.de ([78.46.96.112]:44286 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756580Ab3JQPfq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 11:35:46 -0400
Date: Thu, 17 Oct 2013 17:35:29 +0200
From: Borislav Petkov <bp@alien8.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Chen Gong <gong.chen@linux.intel.com>, tony.luck@intel.com,
        joe@perches.com, naveen.n.rao@linux.vnet.ibm.com, arozansk@redhat.com,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/9] Extended H/W error log driver
Message-ID: <20131017153529.GJ5036@pd.tnic>
References: <1381935366-11731-1-git-send-email-gong.chen@linux.intel.com>
 <20131016160550.GG13608@pd.tnic>
 <20131016125646.7141b580@gandalf.local.home>
 <20131016180038.GO13608@pd.tnic>
 <20131016181117.GP13608@pd.tnic>
 <20131017143348.GA3891@gchen.bj.intel.com>
 <20131017112541.166a44fb@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131017112541.166a44fb@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 17, 2013 at 11:25:41AM -0400, Steven Rostedt wrote:
> On Thu, 17 Oct 2013 10:33:48 -0400
> Chen Gong <gong.chen@linux.intel.com> wrote:
> 
> 
> > > Gong, can you try moving the CREATE_TRACE_POINTS line to a new file -
> > > arch/x86/ras/ras.c and define it there and not anywhere else, i.e. move
> > > it away from edac_mc.c. Does that help?
> > 
> > In current kernel we haven't arch/x86/ras/ras.c. You mean I create
> > a new one there and just add some trace macro definition?
> 
> The CREATE_TRACE_POINTS will cause the TRACE_EVENT() macro to define
> the functions used for tracing. If you have it defined more than once,
> it will either cause a kernel compile error (variables declared more
> than once), or if used in modules, will cause confusion (as well as
> bloat) because different functions and variables will be defined for
> the same tracepoint.
> 
> If you need to create a separate file that you can have it defined in a
> single place, then please do so!

Yes, the plan was this all along to have arch/x86/ras/ras.c or
arch/x86/ras/core.c where CREATE_TRACE_POINTS is done, among other
things.

Btw, Gong, there's an easier way to test this, if you wanna:

simply make sure EDAC is disabled in the kernel with your patches -
i.e., CONFIG_EDAC is not set in your config. It should work then.

But, the final solution should be what Steve says with the file I'm
suggesting :)

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
