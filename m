Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756739Ab3GKVgl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 17:36:41 -0400
Received: from mga03.intel.com ([143.182.124.21]:15235 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756203Ab3GKVgk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 17:36:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,647,1367996400"; 
   d="scan'208";a="363924649"
Message-ID: <51DF2566.8000806@linux.intel.com>
Date: Thu, 11 Jul 2013 14:36:38 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Jiri Kosina <jkosina@suse.cz>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Steven Rostedt <rostedt@goodmis.org>, Jason Baron <jbaron@akamai.com>,
        Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2 v3] x86: introduce int3-based instruction patching
References: <alpine.LNX.2.00.1307102213140.25858@pobox.suse.cz> <alpine.LNX.2.00.1307112221110.29788@pobox.suse.cz> <51DF1B3C.8040603@linux.intel.com> <20130711210452.GE8900@pd.tnic>
In-Reply-To: <20130711210452.GE8900@pd.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/2013 02:04 PM, Borislav Petkov wrote:
> On Thu, Jul 11, 2013 at 01:53:16PM -0700, H. Peter Anvin wrote:
>> Has anyone talked to AMD or VIA about this at all?
> 
> I guess I can try to take care of the AMD part. Just to confirm, is this
> the exact sequence we're interested in:
> 
> 1. Setup int3 handler for fixup.
> 
> 2. Put a breakpoint (int3) on the first byte of modifying region, and
> synchronize code on all CPUs.
> 
> 3. Modify other bytes of modifying region.
> 
> 4. Modify the first byte of modifying region, and synchronize code on
> all CPUs.
> 
> 5. Clear int3 handler.
> 
> If a suitable int3 handler is left permanently in place then the
> synchronization in step 4 is unnecessary.
> 

Correct.

	-hpa

