Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752153AbaA2Ia2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 03:30:28 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:54762 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829AbaA2Ia0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 03:30:26 -0500
Date: Wed, 29 Jan 2014 00:30:19 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Dave Hansen <dave@sr71.net>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, cl@linux-foundation.org,
        penberg@kernel.org, mpm@selenic.com, pshelar@nicira.com,
        Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH] mm: slub: fix page->_count corruption (again)
In-Reply-To: <52E842CF.7090102@sr71.net>
Message-ID: <alpine.DEB.2.02.1401290029120.12210@chino.kir.corp.google.com>
References: <20140128231722.E7387E6B@viggo.jf.intel.com> <20140128152956.d5659f56ae279856731a1ac5@linux-foundation.org> <52E842CF.7090102@sr71.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Jan 2014, Dave Hansen wrote:

> It has measurable performance benefits, and the benefits go up as the
> cost of en/disabling interrupts goes up (like if it takes you a hypercall).
> 
> Fengguang, could you run a set of tests for the top patch in this branch
> to see if we'd be giving much up by axing the code?
> 
> 	https://github.com/hansendc/linux/tree/slub-nocmpxchg-for-Fengguang-20140128
> 
> I was talking with one of the distros about turning it off as well.
> They mentioned that they saw a few performance regressions when it was
> turned off.  I'll share details when I get them.
> 

FWIW, I've compared netperf TCP_RR on all machine types I have available 
with and without cmpxchg_double and I've never measured a regression.
