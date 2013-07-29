Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752334Ab3G2JHB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 05:07:01 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56141 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751652Ab3G2JG7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 05:06:59 -0400
Date: Mon, 29 Jul 2013 11:06:53 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        masami.hiramatsu.pt@hitachi.com, rostedt@goodmis.org,
        tglx@linutronix.de, fengguang.wu@intel.com,
        tip-bot for Jiri Kosina <tipbot@zytor.com>,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] kprobes/x86: Call out into INT3 handler directly
 instead of using notifier
In-Reply-To: <51EFE5A8.1060109@linux.intel.com>
Message-ID: <alpine.LNX.2.00.1307291106260.18809@pobox.suse.cz>
References: <alpine.LNX.2.00.1307231007490.14024@pobox.suse.cz> <tip-17f41571bb2c4a398785452ac2718a6c5d77180e@git.kernel.org> <51EFE5A8.1060109@linux.intel.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Jul 2013, H. Peter Anvin wrote:

> > Commit-ID:  17f41571bb2c4a398785452ac2718a6c5d77180e
> > Gitweb:     http://git.kernel.org/tip/17f41571bb2c4a398785452ac2718a6c5d77180e
> > Author:     Jiri Kosina <jkosina@suse.cz>
> > AuthorDate: Tue, 23 Jul 2013 10:09:28 +0200
> > Committer:  Ingo Molnar <mingo@kernel.org>
> > CommitDate: Tue, 23 Jul 2013 10:12:57 +0200
> > 
> > kprobes/x86: Call out into INT3 handler directly instead of using notifier
> > 
> > In fd4363fff3d96 ("x86: Introduce int3 (breakpoint)-based
> > instruction patching"), the mechanism that was introduced for
> > notifying alternatives code from int3 exception handler that and
> > exception occured was die_notifier.
> > 
> > This is however problematic, as early code might be using jump
> > labels even before the notifier registration has been performed,
> > which will then lead to an oops due to unhandled exception. One
> > of such occurences has been encountered by Fengguang:
> > 
> 
> Please note that putting this patch in perf/core means x86/jumplabel is
> completely nonfunctional by itself.

I'd like to point out that this is still the case ... TIA,

-- 
Jiri Kosina
SUSE Labs
