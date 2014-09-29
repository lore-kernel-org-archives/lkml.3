Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221AbaI2PVr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 11:21:47 -0400
Received: from mga09.intel.com ([134.134.136.24]:3835 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751420AbaI2PVq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 11:21:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,620,1406617200"; 
   d="scan'208";a="610322669"
Date: Mon, 29 Sep 2014 08:21:45 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, dave@sr71.net,
        linux-kernel@vger.kernel.org, mingo@kernel.org, eranian@google.com,
        x86@kernel.org
Subject: Re: [PATCH 1/2] Use faster check for modules in backtrace on 64bit
Message-ID: <20140929152145.GB1629@tassilo.jf.intel.com>
References: <1411774277-4198-1-git-send-email-andi@firstfloor.org>
 <1411774277-4198-2-git-send-email-andi@firstfloor.org>
 <20140929114212.GG5430@worktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140929114212.GG5430@worktop>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2014 at 01:42:12PM +0200, Peter Zijlstra wrote:
> On Fri, Sep 26, 2014 at 04:31:16PM -0700, Andi Kleen wrote:
> > 
> > This has the (small) potential to get a false positive on a pointer to a
> > data segment in a module.  However since we also use the frame pointer
> > chain as initial sanity check I think the danger of this is very low.
> > 
> 
> So this has come up several times; and the answer has always been, why
> not make the __module_address() thing a rb-tree instead of a linear
> loop. So I suppose I'll ask that again, why not?

Why do things complicated, if they can be done simple too?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
