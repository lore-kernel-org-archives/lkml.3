Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933476Ab3ECOeP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 10:34:15 -0400
Received: from mga02.intel.com ([134.134.136.20]:3636 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762240Ab3ECOeM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 10:34:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,605,1363158000"; 
   d="scan'208";a="331006863"
Date: Fri, 3 May 2013 07:34:11 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org, eranian@google.com
Subject: Re: [PATCH 2/3] perf, x86, lbr: Fix LBR filter
Message-ID: <20130503143411.GO19487@tassilo.jf.intel.com>
References: <20130503121122.931661809@chello.nl>
 <20130503121256.158211806@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130503121256.158211806@chello.nl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +	} else {
> +		/*
> +		 * The LBR logs any address in the IP, even if the IP just
> +		 * faulted. This means userspace can control the from address.
> +		 * Ensure we don't blindy read any address by validating it is
> +		 * a known text address.
> +		 */
> +		if (kernel_text_address(from))

Sorry doing it this way is just incredible expensive and dumb.

After all the tool is called "perf" and not "non perf"

-Andi
