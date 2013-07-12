Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933098Ab3GLMIs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 08:08:48 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:60192 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933067Ab3GLMIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 08:08:46 -0400
Date: Fri, 12 Jul 2013 14:08:43 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Dave Hansen <dave@sr71.net>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] x86: perf: fix incorrect use of do_div() in nmi warning
Message-ID: <20130712120843.GA21708@gmail.com>
References: <20130708214404.B0B6EA66@viggo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130708214404.B0B6EA66@viggo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dave Hansen <dave@sr71.net> wrote:

> 
> From: Dave Hansen <dave.hansen@linux.intel.com>
> 
> This fixes a bug present in 3.10 and introduced here:
> 
> commit 2ab00456ea8a0d79acb1390659b98416111880b2
> Author: Dave Hansen <dave.hansen@linux.intel.com>
> Date:   Fri Jun 21 08:51:35 2013 -0700
> 
>     x86: Warn when NMI handlers take large amounts of time
> 
> I completely botched understanding the calling conventions of
> do_div().  I assumed that do_div() returned the result instead
> of realizing that it modifies its argument and returns a
> remainder.  The side-effect from this would be bogus numbers
> for the "msecs" value in the warning messages:
> 
> 	INFO: NMI handler (perf_event_nmi_handler) took too long to run: 0.114 msecs
> 
> Note, there was a second fix posted by Stephane Eranian for
> a separate patch which I also botched:
> 
> 	http://lkml.kernel.org/r/20130704223010.GA30625@quad
> 
> Both of these fixes need to get pulled in to Linus's tree and
> the 3.10 stable tree.

This is a brand new v3.11 commit.

It should not be included in any -stable tree, is it?

Thanks,

	Ingo
