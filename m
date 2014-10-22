Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752260AbaJVOQJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 10:16:09 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:53195 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511AbaJVOQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 10:16:07 -0400
Date: Wed, 22 Oct 2014 16:15:47 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        kan.liang@intel.com, adrian.hunter@intel.com, acme@infradead.org
Subject: Re: [PATCH v5 11/20] x86: perf: Intel PT and LBR/BTS are mutually
 exclusive
Message-ID: <20141022141547.GO12706@worktop.programming.kicks-ass.net>
References: <1413207948-28202-1-git-send-email-alexander.shishkin@linux.intel.com>
 <1413207948-28202-12-git-send-email-alexander.shishkin@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413207948-28202-12-git-send-email-alexander.shishkin@linux.intel.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 13, 2014 at 04:45:39PM +0300, Alexander Shishkin wrote:
> Intel PT cannot be used at the same time as LBR or BTS and will cause a
> general protection fault if they are used together. In order to avoid
> fixing up GPs in the fast path, instead we use flags to indicate that
> that one of these is in use so that the other avoids MSR access altogether.
> 

Yeah, don't like this. Like I've said many times before we should simply
disallow creating PT events when there are LBR events and vice versa.

