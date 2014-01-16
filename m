Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751664AbaAPTNy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 14:13:54 -0500
Received: from mga09.intel.com ([134.134.136.24]:63576 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750933AbaAPTNv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 14:13:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,669,1384329600"; 
   d="scan'208";a="439992120"
Message-ID: <52D82F13.9070309@intel.com>
Date: Thu, 16 Jan 2014 11:12:19 -0800
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: kernel test robot <fengguang.wu@intel.com>
CC: LKML <linux-kernel@vger.kernel.org>, lkp@linux.intel.com
Subject: Re: [slub shrink] 0f6934bf16: +191.9% vmstat.system.cs
References: <20140116030744.GA19349@localhost>
In-Reply-To: <20140116030744.GA19349@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15/2014 07:07 PM, kernel test robot wrote:
> 9a0bb2966efbf30  0f6934bf1695682e7ced973f6  
> ---------------  -------------------------  
>    8235933 ~ 2%     +80.6%   14872911 ~ 3%  lkp-sbx04/micro/will-it-scale/read2
>    8235933          +80.6%   14872911       TOTAL interrupts.RES
> 
> 9a0bb2966efbf30  0f6934bf1695682e7ced973f6  
> ---------------  -------------------------  
>     161531 ~ 7%    +191.9%     471544 ~ 9%  lkp-sbx04/micro/will-it-scale/read2
>     161531         +191.9%     471544       TOTAL vmstat.system.cs
> 
> 9a0bb2966efbf30  0f6934bf1695682e7ced973f6  
> ---------------  -------------------------  
>      32943 ~ 1%     +71.8%      56599 ~ 3%  lkp-sbx04/micro/will-it-scale/read2
>      32943          +71.8%      56599       TOTAL vmstat.system.in

I suspect that something is wrong with that system.  My 160-cpu system
does about 40,000 interrupts/sec and ~4300 context switches/sec when
running 160 read2_processes.  I wonder if you're hitting swap or the
dirty limits or something.  Are you running it with way more threads
than it has CPUs?

Also, are those will-it-scale tests the threaded or process versions?
