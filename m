Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756109AbaA1Xwv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 18:52:51 -0500
Received: from www.sr71.net ([198.145.64.142]:36133 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755862AbaA1Xwu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 18:52:50 -0500
Message-ID: <52E842CF.7090102@sr71.net>
Date: Tue, 28 Jan 2014 15:52:47 -0800
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org, cl@linux-foundation.org,
        penberg@kernel.org, mpm@selenic.com, pshelar@nicira.com,
        Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH] mm: slub: fix page->_count corruption (again)
References: <20140128231722.E7387E6B@viggo.jf.intel.com> <20140128152956.d5659f56ae279856731a1ac5@linux-foundation.org>
In-Reply-To: <20140128152956.d5659f56ae279856731a1ac5@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28/2014 03:29 PM, Andrew Morton wrote:
> On Tue, 28 Jan 2014 15:17:22 -0800 Dave Hansen <dave@sr71.net> wrote:
> This code is borderline insane.

No argument here.

> Yes, struct page is special and it's worth spending time and doing
> weird things to optimise it.  But sheesh.
> 
> An alternative is to make that cmpxchg quietly go away.  Is it more
> trouble than it is worth?

It has measurable performance benefits, and the benefits go up as the
cost of en/disabling interrupts goes up (like if it takes you a hypercall).

Fengguang, could you run a set of tests for the top patch in this branch
to see if we'd be giving much up by axing the code?

	https://github.com/hansendc/linux/tree/slub-nocmpxchg-for-Fengguang-20140128

I was talking with one of the distros about turning it off as well.
They mentioned that they saw a few performance regressions when it was
turned off.  I'll share details when I get them.

