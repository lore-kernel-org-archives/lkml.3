Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874AbaI2LmQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 07:42:16 -0400
Received: from casper.infradead.org ([85.118.1.10]:37335 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786AbaI2LmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 07:42:15 -0400
Date: Mon, 29 Sep 2014 13:42:12 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: dave@sr71.net, linux-kernel@vger.kernel.org, mingo@kernel.org,
        eranian@google.com, x86@kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/2] Use faster check for modules in backtrace on 64bit
Message-ID: <20140929114212.GG5430@worktop>
References: <1411774277-4198-1-git-send-email-andi@firstfloor.org>
 <1411774277-4198-2-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411774277-4198-2-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2014 at 04:31:16PM -0700, Andi Kleen wrote:
> 
> This has the (small) potential to get a false positive on a pointer to a
> data segment in a module.  However since we also use the frame pointer
> chain as initial sanity check I think the danger of this is very low.
> 

So this has come up several times; and the answer has always been, why
not make the __module_address() thing a rb-tree instead of a linear
loop. So I suppose I'll ask that again, why not?


