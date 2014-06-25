Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755432AbaFYWXz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 18:23:55 -0400
Received: from mga02.intel.com ([134.134.136.20]:65217 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752104AbaFYWXy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 18:23:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,548,1400050800"; 
   d="scan'208";a="563492708"
Message-ID: <53AB4BF1.3000504@intel.com>
Date: Wed, 25 Jun 2014 15:23:45 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Konstantin Khlebnikov <koct9i@gmail.com>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>
CC: Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] mm: catch memory commitment underflow
References: <20140624201606.18273.44270.stgit@zurg> <20140624201614.18273.39034.stgit@zurg>
In-Reply-To: <20140624201614.18273.39034.stgit@zurg>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24/2014 01:16 PM, Konstantin Khlebnikov wrote:
> reserve;
>  
> +#ifdef CONFIG_DEBUG_VM
> +	WARN_ONCE(percpu_counter_read(&vm_committed_as) <
> +			-(s64)vm_committed_as_batch * num_online_cpus(),
> +			"memory commitment underflow");
> +#endif

Why not use VM_WARN_ON_ONCE()?
