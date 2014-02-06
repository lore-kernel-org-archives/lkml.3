Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754697AbaBFUgE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 15:36:04 -0500
Received: from mga11.intel.com ([192.55.52.93]:60493 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751894AbaBFUgC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 15:36:02 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,795,1384329600"; 
   d="scan'208";a="477187179"
Date: Thu, 6 Feb 2014 12:36:01 -0800
From: Andi Kleen <ak@linux.intel.com>
To: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH v1 09/11] x86: perf: intel_pt: Add core dump functionality
Message-ID: <20140206203601.GB12219@tassilo.jf.intel.com>
References: <1391683834-29868-1-git-send-email-alexander.shishkin@linux.intel.com>
 <1391683834-29868-10-git-send-email-alexander.shishkin@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391683834-29868-10-git-send-email-alexander.shishkin@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  			   char *buf)
> @@ -114,6 +143,7 @@ static ssize_t pt_cap_store(struct device *cdev,
>  		return -EINVAL;
>  
>  	pt_cap_set(cap, new);
> +	pt_cap_string();

Don't we need some lock here? Otherwise it may leak memory with racing writes
and become inconsistent.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only
