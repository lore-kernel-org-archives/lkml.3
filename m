Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585Ab3FNP5r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 11:57:47 -0400
Received: from mga02.intel.com ([134.134.136.20]:19169 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750930Ab3FNP5p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 11:57:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,867,1363158000"; 
   d="scan'208";a="329537243"
Message-ID: <51BB3D78.2070907@intel.com>
Date: Fri, 14 Jun 2013 08:57:44 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        "Theodore Ts'o" <tytso@mit.edu>, Jan kara <jack@suse.cz>
Subject: Re: ext4 extent status tree LRU locking
References: <51B7B128.60909@intel.com> <20130614140940.GA20401@gmail.com>
In-Reply-To: <20130614140940.GA20401@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2013 07:09 AM, Zheng Liu wrote:
> -	INIT_LIST_HEAD(&scanned);
> -
>  	spin_lock(&sbi->s_es_lru_lock);
> +	list_sort(NULL, &sbi->s_es_lru, ext4_inode_touch_time_cmp);
>  	list_for_each_safe(cur, tmp, &sbi->s_es_lru) {

How long can this list get?  I have the feeling this might get a bit
painful, especially on a NUMA machine.

But, it definitely eliminates the spinlock contention that I was seeing.
 The top ext4 function in my profiles is way down under 1% of CPU time
now.  Thanks for the quick response, and please let me know if you need
any further testing.
