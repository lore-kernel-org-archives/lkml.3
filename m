Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758229AbaGWQU3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 12:20:29 -0400
Received: from mga02.intel.com ([134.134.136.20]:30790 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758144AbaGWQU1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 12:20:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,718,1400050800"; 
   d="scan'208";a="547840471"
Message-ID: <53CFE0C6.905@intel.com>
Date: Wed, 23 Jul 2014 09:20:22 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Qiaowei Ren <qiaowei.ren@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
CC: x86@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v7 08/10] x86, mpx: add prctl commands PR_MPX_REGISTER,
 PR_MPX_UNREGISTER
References: <1405921124-4230-1-git-send-email-qiaowei.ren@intel.com> <1405921124-4230-9-git-send-email-qiaowei.ren@intel.com>
In-Reply-To: <1405921124-4230-9-git-send-email-qiaowei.ren@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/20/2014 10:38 PM, Qiaowei Ren wrote:
> +	pr_debug("MPX BD base address %p\n", mm->bd_addr);
> +	return 0;
> +}

Please remove all of the pr_debug()s.  They're not appropriate for
common paths in production code.

There's another one in allocate_bt(), btw.
