Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512Ab3EBHjB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 03:39:01 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:39751
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752538Ab3EBHiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 03:38:50 -0400
Date: Thu, 2 May 2013 09:37:21 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        eranian@google.com, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 2/2] perf, x86: Don't allow unusual PEBS raw flags
Message-ID: <20130502073720.GH7521@dyad.programming.kicks-ass.net>
References: <1366844694-2770-1-git-send-email-andi@firstfloor.org>
 <1366844694-2770-2-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366844694-2770-2-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 24, 2013 at 04:04:54PM -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> The PEBS documentation in the Intel SDM 18.6.1.1 states:
> 
> """
> PEBS events are only valid when the following fields of IA32_PERFEVTSELx are all
> zero: AnyThread, Edge, Invert, CMask.
> """
> 
> Since we had problems with this earlier, don't allow cmask, any, edge, invert
> as raw events, except for the ones explicitly listed as pebs_aliases.

If its a simple matter of crap in crap out without affecting anything else we
shouldn't do anything.

The only reason to interfere with the programming is if invalid programming can
affect others like with that MEM_*_RETIRED failure on ivb.
