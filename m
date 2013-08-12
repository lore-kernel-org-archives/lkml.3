Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756134Ab3HLXu6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 19:50:58 -0400
Received: from mga14.intel.com ([143.182.124.37]:14790 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755807Ab3HLXu5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 19:50:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,865,1367996400"; 
   d="scan'208";a="345389660"
Message-ID: <520974DC.60802@intel.com>
Date: Mon, 12 Aug 2013 16:50:52 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] x86: Fix booting with DEBUG_PAGE_ALLOC with more than
 512G RAM
References: <1376351004-4015-1-git-send-email-yinghai@kernel.org>
In-Reply-To: <1376351004-4015-1-git-send-email-yinghai@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/12/2013 04:43 PM, Yinghai Lu wrote:
>> > commit 8170e6bed465b4b0c7687f93e9948aca4358a33b
>> > Author: H. Peter Anvin <hpa@zytor.com>
>> > Date:   Thu Jan 24 12:19:52 2013 -0800
>> >
>> >     x86, 64bit: Use a #PF handler to materialize early mappings on demand
> Before that, we have maping from [0,512M) in head_64.S, and we can
> spare two pages [0-1M).  After that change, we can not reuse pages anymore.
> 
> When we have more than 512M ram, we need extra page for pgd page with
> [512G, 1024g).
> 
> Increase pages in BRK for page table to solve the booting problem.

So how much does this get us up to?  1TB?  That's actually _fairly_
small today.  I've got a fairly old machine with that much in it, and
it's only half full of DIMMs.

It's also a bit worrying that this is completely disconnected from the
other code in the kernel that is concerned with the amount of total
address space in the system: MAX_PHYSADDR_BITS.


