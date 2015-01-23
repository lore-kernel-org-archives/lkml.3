Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229AbbAWIjw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 03:39:52 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:60228 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031AbbAWIjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 03:39:48 -0500
Date: Fri, 23 Jan 2015 09:39:31 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, vincent.weaver@maine.edu,
        cl@linux.com, paulus@samba.org, acme@redhat.com
Subject: Re: [PATCH] perf/rapl: fix crash in rapl_scale()
Message-ID: <20150123083931.GD2896@worktop.programming.kicks-ass.net>
References: <20150122203834.GA10228@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150122203834.GA10228@thinkpad>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2015 at 09:38:34PM +0100, Stephane Eranian wrote:
> 
> This patch fixes a systematic crash in rapl_scale()
> due to an invalid pointer.
> 
> The bug was introduced by commit:
> commit 89cbc76768c2fa4ed95545bf961f3a14ddfeed21
> Author: Christoph Lameter <cl@linux.com>
> Date:   Sun Aug 17 12:30:40 2014 -0500
> 
>     x86: Replace __get_cpu_var uses
> 
> 
> The fix is simple. Just put the parenthesis where it needs
> to be, i.e., around rapl_pmu. To my surprise, the compiler
> was not complaining about passing an integer instead of a
> pointer.
> 
> Reported-by: Vince Weaver <vincent.weaver@maine.edu>
> Signed-off-by: Stephane Eranian <eranian@google.com>
> Tested-by: Vince Weaver <vincent.weaver@maine.edu>

Thanks!
