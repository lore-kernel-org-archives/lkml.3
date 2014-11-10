Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751423AbaKJSLW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 13:11:22 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48058 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751138AbaKJSLV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 13:11:21 -0500
Date: Mon, 10 Nov 2014 19:11:14 +0100
From: Petr Mladek <pmladek@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC][PATCH 07/12 v3] tracing: Have seq_buf use full buffer
Message-ID: <20141110181113.GA1943@dhcp128.suse.cz>
References: <20141104155237.228431433@goodmis.org>
 <20141104160222.502133196@goodmis.org>
 <20141105163150.GI4570@pathway.suse.cz>
 <20141105152130.09779ccf@gandalf.local.home>
 <20141105160618.6c684f23@gandalf.local.home>
 <20141106153107.GH2001@dhcp128.suse.cz>
 <20141106142402.0daada65@gandalf.local.home>
 <20141107091107.GA1136@dhcp128.suse.cz>
 <20141107133729.503c9b5d@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141107133729.503c9b5d@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2014-11-07 13:37:29, Steven Rostedt wrote:
> 
> Some more touch ups.
> 
> -- Steve
> 
> From 7e724556c21178a9890b31ff57f69761b41f435a Mon Sep 17 00:00:00 2001
> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> Date: Wed, 29 Oct 2014 15:26:09 -0400
> Subject: [PATCH] tracing: Have seq_buf use full buffer
> 
> Currently seq_buf is full when all but one byte of the buffer is
> filled. Change it so that the seq_buf is full when all of the
> buffer is filled.
> 
> Some of the functions would fill the buffer completely and report
> everything was fine. This was inconsistent with the max of size - 1.
> Changing this to be max of size makes all functions consistent.
> 
> Link: http://lkml.kernel.org/r/20141104160222.502133196@goodmis.org
> 
> Tested-by: Jiri Kosina <jkosina@suse.cz>
> Acked-by: Jiri Kosina <jkosina@suse.cz>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Reviewed-by: Petr Mladek <pmladek@suse.cz>

This patch might need a refresh if you add the extra buffer overflow
check into seq_buf_set_overflow() in the 3rd patch. Anyway, changes
in this patch looks good.

I am happy with all the changes in the patchset. Thanks a lot for
driving it forward.

Best Regards,
Petr
