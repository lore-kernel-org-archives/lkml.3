Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278Ab3GWFjm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 01:39:42 -0400
Received: from smtpauth05.mfg.siteprotect.com ([64.26.60.144]:50148 "EHLO
	smtpauth05.mfg.siteprotect.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751583Ab3GWFjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 01:39:41 -0400
Date: Tue, 23 Jul 2013 01:40:40 -0400 (EDT)
From: Vince Weaver <vince@deater.net>
X-X-Sender: vince@pianoman.cluster.toy
To: Andi Kleen <andi@firstfloor.org>
cc: acme@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 1/2] tools, perf: Add a precise event qualifier v2
In-Reply-To: <1374501138-13496-1-git-send-email-andi@firstfloor.org>
Message-ID: <alpine.DEB.2.02.1307230137160.18617@pianoman.cluster.toy>
References: <1374501138-13496-1-git-send-email-andi@firstfloor.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-CTCH-Spam: Unknown
X-CTCH-RefID: str=0001.0A020209.51EE171C.00AC,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Jul 2013, Andi Kleen wrote:

> From: Andi Kleen <ak@linux.intel.com>
> 
> Add a precise qualifier, like cpu/event=0x3c,precise=1/

So you're adding this to "events/" but not to "format/"?

This breaks the ABI, which specifies that the only fields
that can appear in a sysfs events specifier must exist under
the format directory.

This was what I worried about when I said people are going to start 
leaking perf tool specific events into the kernel sysfs tree.

This will break various existing programs.

Vince
