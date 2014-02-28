Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751510AbaB1Jjz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 04:39:55 -0500
Received: from merlin.infradead.org ([205.233.59.134]:50212 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957AbaB1Jjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 04:39:53 -0500
Date: Fri, 28 Feb 2014 10:39:40 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Vince Weaver <vincent.weaver@maine.edu>, "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: perf_fuzzer compiled for x32 causes reboot
Message-ID: <20140228093940.GH27965@twins.programming.kicks-ass.net>
References: <20140224141329.1cd3bb52@gandalf.local.home>
 <20140224193043.GP6835@laptop.programming.kicks-ass.net>
 <530C12CA.6070308@zytor.com>
 <alpine.DEB.2.10.1402250904400.23234@vincent-weaver-1.um.maine.edu>
 <dde99a03-9f97-4cd9-aeef-cb0dcc62a7dc@email.android.com>
 <20140225094352.73e0e28c@gandalf.local.home>
 <alpine.DEB.2.10.1402251032230.23234@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1402261003390.18730@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1402271621000.2571@vincent-weaver-1.um.maine.edu>
 <20140227173150.4e5ed747@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140227173150.4e5ed747@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 27, 2014 at 05:31:50PM -0500, Steven Rostedt wrote:
> Well, the perf ring buffer is vmalloced, right? That can cause a page
> fault too.

On x86 they're typically not -- although we have a debug CONFIG option
to test that code on x86 too. On SPARC/ARM etc.. we have to use
vmalloc_user() because of cache aliasing (yay for VIPT).
