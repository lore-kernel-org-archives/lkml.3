Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753438AbaJQHC7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 03:02:59 -0400
Received: from mga01.intel.com ([192.55.52.88]:40794 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753416AbaJQHC5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 03:02:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,737,1406617200"; 
   d="scan'208";a="615951895"
Date: Thu, 16 Oct 2014 17:45:07 -0400
From: Matthew Wilcox <willy@linux.intel.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v11 13/21] ext2: Remove ext2_xip_verify_sb()
Message-ID: <20141016214507.GI11522@wil.cx>
References: <1411677218-29146-1-git-send-email-matthew.r.wilcox@intel.com>
 <1411677218-29146-14-git-send-email-matthew.r.wilcox@intel.com>
 <20141016121802.GK19075@thinkos.etherlink>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141016121802.GK19075@thinkos.etherlink>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2014 at 02:18:02PM +0200, Mathieu Desnoyers wrote:
> On 25-Sep-2014 04:33:30 PM, Matthew Wilcox wrote:
> > Jan Kara pointed out that calling ext2_xip_verify_sb() in ext2_remount()
> > doesn't make sense, since changing the XIP option on remount isn't
> > allowed.  It also doesn't make sense to re-check whether blocksize is
> > supported since it can't change between mounts.
> 
> By "doesn't make sense", do you mean it is never actually used, or that
> it is possible for a current user to trigger issues by changing XIP
> option on remount ? If it is the case, then this patch should probably
> be flagged as a "Fix".

I mean that we're checking for a condition that can't actually happen,
so it's safe to just delete the check.
