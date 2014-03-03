Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753749AbaCCHBv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 02:01:51 -0500
Received: from mga09.intel.com ([134.134.136.24]:48439 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751878AbaCCHBs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 02:01:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,576,1389772800"; 
   d="scan'208";a="492676968"
Message-ID: <531428D9.1060101@linux.intel.com>
Date: Mon, 03 Mar 2014 15:01:45 +0800
From: "Li, Aubrey" <aubrey.li@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: "David E. Box" <david.e.box@linux.intel.com>, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com
CC: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V5 0/2] x86: IOSF: Add loadable module support
References: <1393609674-2999-1-git-send-email-david.e.box@linux.intel.com> <1393641652-7222-1-git-send-email-david.e.box@linux.intel.com>
In-Reply-To: <1393641652-7222-1-git-send-email-david.e.box@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

I'm probably too late to catch this thread. Just one question, what's
the relationship between
	arch/x86/kernel/iosf_mbi.c
and
	drivers/platform/x86/intel_baytrail.c

Thanks,
-Aubrey

On 2014/3/1 10:40, David E. Box wrote:
> From: "David E. Box" <david.e.box@linux.intel.com>
> 
> This patch series adds missing functionalty that mostly affected loadable
> modules.
> 
> The first patch adds dummy functions to allow drivers not completely
> dependant on the IOSF MBI driver to compile on systems that don't have it.
> 
> The second makes MBI driver built in.
> 
> Changes from V4:
> 
> 	- Put back Kconfig prompt for IOSF_MBI.
> 
> Changes from V3:
> 
> 	- Code is agreed to be small enough to not warrant forcing for
> 	  non-EXPERT only
> 
> Changes from V2:
> 
> 	- Remove non linux style externs from iosf_mbi.h
> 
> Changes from V1:
> 
> 	- Force default y for non-EXPERT to allow easier custom configuration
> 	  as suggested by hpa <hpa@zytor.com>
> 	- Add WARN() to dummy functions, other than iosf_mbi_available(), to
> 	  signal incorrect use as suggested by Alan <gnomes@lxorguk.ukuu.org.uk>
> 	  Also return EPERM in these functions
> 	- Splits single patch into two patch series
> 
> David E. Box (2):
>   x86: IOSF: add dummy functions for loadable modules
>   x86: IOSF: Change IOSF_MBI Kconfig to default y
> 
>  arch/x86/Kconfig                |    7 ++-----
>  arch/x86/include/asm/iosf_mbi.h |   33 +++++++++++++++++++++++++++++++++
>  arch/x86/kernel/iosf_mbi.c      |    6 ++++++
>  3 files changed, 41 insertions(+), 5 deletions(-)
> 

