Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750906Ab3HSQzU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 12:55:20 -0400
Received: from mga02.intel.com ([134.134.136.20]:1538 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750780Ab3HSQzT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 12:55:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,914,1367996400"; 
   d="scan'208";a="389628520"
Message-ID: <52124DE7.8070502@intel.com>
Date: Mon, 19 Aug 2013 09:55:03 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Jerome Marchand <jmarchan@redhat.com>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mm: add overcommit_kbytes sysctl variable
References: <1376925478-15506-1-git-send-email-jmarchan@redhat.com> <1376925478-15506-2-git-send-email-jmarchan@redhat.com>
In-Reply-To: <1376925478-15506-2-git-send-email-jmarchan@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/19/2013 08:17 AM, Jerome Marchand wrote:
> Some applications that run on HPC clusters are designed around the
> availability of RAM and the overcommit ratio is fine tuned to get the
> maximum usage of memory without swapping. With growing memory, the
> 1%-of-all-RAM grain provided by overcommit_ratio has become too coarse
> for these workload (on a 2TB machine it represents no less than
> 20GB).
> 
> This patch adds the new overcommit_kbytes sysctl variable that allow a
> much finer grain.

Instead of introducing yet another tunable, why don't we just make the
ratio that comes in from the user more fine-grained?

	sysctl overcommit_ratio=0.2

We change the internal 'sysctl_overcommit_ratio' to store tenths or
hundreths of a percent (or whatever), then parse the input as two
integers.  I don't think we need fully correct floating point parsing
and rounding here, so it shouldn't be too much of a chore.  It'd
probably end up being less code than you have as it stands.
