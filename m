Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751962AbaBGJE1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 04:04:27 -0500
Received: from mga11.intel.com ([192.55.52.93]:43027 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751288AbaBGJEZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 04:04:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,799,1384329600"; 
   d="scan'208";a="471263918"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH v1 09/11] x86: perf: intel_pt: Add core dump functionality
In-Reply-To: <20140206203601.GB12219@tassilo.jf.intel.com>
References: <1391683834-29868-1-git-send-email-alexander.shishkin@linux.intel.com> <1391683834-29868-10-git-send-email-alexander.shishkin@linux.intel.com> <20140206203601.GB12219@tassilo.jf.intel.com>
User-Agent: Notmuch/0.17+49~gaa57e9d (http://notmuchmail.org) Emacs/23.4.1 (x86_64-pc-linux-gnu)
Date: Fri, 07 Feb 2014 11:03:59 +0200
Message-ID: <87ob2jl2f4.fsf@ashishki-desk.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <ak@linux.intel.com> writes:

>>  			   char *buf)
>> @@ -114,6 +143,7 @@ static ssize_t pt_cap_store(struct device *cdev,
>>  		return -EINVAL;
>>  
>>  	pt_cap_set(cap, new);
>> +	pt_cap_string();
>
> Don't we need some lock here? Otherwise it may leak memory with racing writes
> and become inconsistent.

Good point.

Regards,
--
Alex
