Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932729AbaJWDFq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 23:05:46 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:59693 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932379AbaJWDFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 23:05:45 -0400
Date: Thu, 23 Oct 2014 05:05:41 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>, Mike Galbraith <efault@gmx.de>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        kan.liang@intel.com, adrian.hunter@intel.com, acme@infradead.org
Subject: Re: [PATCH v5 02/20] perf: Add AUX area to ring buffer for raw data
 streams
Message-ID: <20141023030537.GA14570@lerouge>
References: <1413207948-28202-1-git-send-email-alexander.shishkin@linux.intel.com>
 <1413207948-28202-3-git-send-email-alexander.shishkin@linux.intel.com>
 <20141022123547.GL12706@worktop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141022123547.GL12706@worktop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2014 at 02:35:47PM +0200, Peter Zijlstra wrote:
> On Mon, Oct 13, 2014 at 04:45:30PM +0300, Alexander Shishkin wrote:
> > +	struct kref			aux_refcount;
> 
> I'm not a fan of kref, pointless obfuscation that.

It has a good potential for debugging though. Sure right now
the get/put simple APIs only performs counting sanity checks
but I've seen patches that extend it to object debugging.

Sounds quite valuable on complicated object lifecycles like
perf events.
