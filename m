Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933454AbaDIOIE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 10:08:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13006 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932866AbaDIOIB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 10:08:01 -0400
Date: Wed, 9 Apr 2014 16:07:19 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: acme@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        peterz@infradead.org, eranian@google.com, namhyung@kernel.org,
        wcohen@redhat.com, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] perf, tools: Fix metrics calculation with event
 qualifiers
Message-ID: <20140409140719.GE2556@krava.brq.redhat.com>
References: <1395778047-23111-1-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395778047-23111-1-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 25, 2014 at 01:07:27PM -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> Currently in perf IPC and other metrics cannot be directly shown
> separately for both user and kernel in a single run. The problem was
> that the metrics matching code did not check event qualifiers.
> 
> With this patch the following case works correctly.
> 
> % perf stat -e cycles:k,cycles:u,instructions:k,instructions:u true
> 
>  Performance counter stats for 'true':
> 
>            531,718      cycles:k
>            203,895      cycles:u
>            338,151      instructions:k            #    0.64  insns per cycle
>            105,961      instructions:u            #    0.52  insns per cycle
> 
>        0.002989739 seconds time elapsed
> 
> Previously it would misreport the ratios because they were matching
> the wrong value.
> 
> The patch is fairly big, but quite mechanic as it just
> adds context indexes everywhere.
> 
> I didn't support Hypervisor. It's not clear it's worth it.
> 
> Reported-by: William Cohen <wcohen@redhat.com>
> Signed-off-by: Andi Kleen <ak@linux.intel.com>

Acked-by: Jiri Olsa <jolsa@redhat.com>

thanks,
jirka
