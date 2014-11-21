Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532AbaKUU37 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 15:29:59 -0500
Received: from mga09.intel.com ([134.134.136.24]:19899 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751944AbaKUU36 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 15:29:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,432,1413270000"; 
   d="scan'208";a="612014386"
Message-ID: <546FA0C4.1000402@intel.com>
Date: Fri, 21 Nov 2014 12:29:56 -0800
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Vikas Shivappa <vikas.shivappa@linux.intel.com>,
        linux-kernel@vger.kernel.org
CC: vikas.shivappa@intel.com, hpa@zytor.com, tglx@linutronix.de,
        mingo@kernel.org, tj@kernel.org, matt.flemming@intel.com,
        will.auld@intel.com, peterz@infradead.org
Subject: Re: [PATCH] x86: Intel Cache Allocation Technology support
References: <1416445539-24856-1-git-send-email-vikas.shivappa@linux.intel.com>
In-Reply-To: <1416445539-24856-1-git-send-email-vikas.shivappa@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/19/2014 05:05 PM, Vikas Shivappa wrote:
> +	/*
> +	 * Hard code the checks and values for HSW SKUs.
> +	 * Unfortunately! have to check against only these brand name strings.
> +	 */
> +
> +	for (i = 0; i < 5; i++)
> +		if (!strcmp(hsw_brandstrs[i], c->x86_model_id)) {
> +			c->x86_cqe_closs = 4;
> +			c->x86_cqe_cbmlength = 20;
> +			return true;
> +		}

Please use ARRAY_SIZE() here.  Otherwise, I guarantee the next string
you add to hsw_brandstrs[] gets silently ignored.

Are there really only 5 CPUs?  This:

> http://ark.intel.com/products/family/78583/Intel-Xeon-Processor-E5-v3-Family#@Server

lists 32 skus.
