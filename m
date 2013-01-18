Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754374Ab3ARXZJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 18:25:09 -0500
Received: from mga03.intel.com ([143.182.124.21]:53983 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752646Ab3ARXZI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 18:25:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,495,1355126400"; 
   d="scan'208";a="245800899"
Date: Fri, 18 Jan 2013 15:25:07 -0800
From: Andi Kleen <ak@linux.intel.com>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        acme@redhat.com, jolsa@redhat.com, namhyung.kim@lge.com
Subject: Re: [PATCH v6 11/18] perf tools: add mem access sampling core support
Message-ID: <20130118232507.GM4051@tassilo.jf.intel.com>
References: <1358264386-24633-1-git-send-email-eranian@google.com>
 <1358264386-24633-12-git-send-email-eranian@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358264386-24633-12-git-send-email-eranian@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2013 at 04:39:39PM +0100, Stephane Eranian wrote:
> This patch adds the sorting and histogram support
> functions to enable profiling of memory accesses.
> 
> The following sorting orders are added:
>  - symbol_daddr: data address symbol (or raw address)
>  - dso_daddr: data address shared object
>  - weight: access cost
>  - locked: access uses locked transaction
>  - tlb : TLB access
>  - mem : memory level of the access (L1, L2, L3, RAM, ...)
>  - snoop: access snoop mode

Do they actually sort? I found that the sort keys do not actually
sort in most cases. This is mostly an issue with numbers like
"weight" and of course not added by your patch.


-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
