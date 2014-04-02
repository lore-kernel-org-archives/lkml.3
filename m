Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932594AbaDBQdN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 12:33:13 -0400
Received: from mga09.intel.com ([134.134.136.24]:61306 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932330AbaDBQdL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 12:33:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,780,1389772800"; 
   d="scan'208";a="513412829"
Message-ID: <533C362E.1020605@intel.com>
Date: Wed, 02 Apr 2014 09:09:18 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Li Zhong <zhong@linux.vnet.ibm.com>, LKML <linux-kernel@vger.kernel.org>
CC: nfont@linux.vnet.ibm.com, gregkh@linuxfoundation.org
Subject: Re: [RFC PATCH] memory driver: make phys_index/end_phys_index reflect
 the start/end section number
References: <1396429018.2913.19.camel@ThinkPad-T5421.cn.ibm.com>
In-Reply-To: <1396429018.2913.19.camel@ThinkPad-T5421.cn.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/2014 01:56 AM, Li Zhong wrote:
> I noticed the phys_index and end_phys_index under 
> /sys/devices/system/memory/memoryXXX/ have the same value, e.g.
> (for the test machine, one memory block has 8 sections, that is 
>  sections_per_block equals 8)
> 
> # cd /sys/devices/system/memory/memory100/
> # cat phys_index end_phys_index 
> 00000064
> 00000064
> 
> Seems they should reflect the start/end section number respectively, which 
> also matches what is said in Documentation/memory-hotplug.txt

This changes a user-visible interface.  Won't this break userspace?
