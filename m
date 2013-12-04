Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755894Ab3LDQUa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 11:20:30 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:44633 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755623Ab3LDQU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 11:20:28 -0500
Date: Wed, 4 Dec 2013 08:19:56 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Jiang Liu <liuj97@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Shaohua Li <shli@kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>, Jiri Kosina <trivial@kernel.org>,
        Wang YanQing <udknight@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: Re: [RFC PATCH v3 00/19] simplify generic cross CPU function call
 implementation
Message-ID: <20131204161956.GA6094@infradead.org>
References: <1386173591-28514-1-git-send-email-liuj97@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386173591-28514-1-git-send-email-liuj97@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 05, 2013 at 12:12:51AM +0800, Jiang Liu wrote:
> Since commit 9a46ad6d6df3b54 "smp: make smp_call_function_many() use
> logic similar to smp_call_function_single()", single and multiple
> (mask version) cross CPU function calls are handled in the same way,
> and generic_smp_call_function_interrupt() becomes an aliases of
> generic_smp_call_function_single_interrupt(), so only one interrupt
> is needed for arch code to support generic SMP function call interfaces.
> This patch series simplifies arch code by killing the redundant
> interrupt for cross CPU function calls.
> 
> We choose to keep generic_smp_call_function_interrupt() instead of
> generic_smp_call_function_single_interrupt() because the former is
> more generic.

Maybe drop the generic as well to get the name down to a reasonable
length? :)

