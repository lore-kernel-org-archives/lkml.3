Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600Ab3KOWUi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 17:20:38 -0500
Received: from mga14.intel.com ([143.182.124.37]:7962 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750992Ab3KOWUc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 17:20:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="389296593"
Message-ID: <52869F3E.30702@linux.intel.com>
Date: Fri, 15 Nov 2013 14:25:02 -0800
From: David Cohen <david.a.cohen@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131005 Icedove/17.0.9
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, lenb@kernel.org
Subject: Re: [PATCH 0/3] Bring SFI support to out-of-tree driver modules on
 Intel Mid
References: <1384294420-9124-1-git-send-email-david.a.cohen@linux.intel.com> <20131113081445.GA19388@infradead.org>
In-Reply-To: <20131113081445.GA19388@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/2013 12:14 AM, Christoph Hellwig wrote:
> On Tue, Nov 12, 2013 at 02:13:37PM -0800, David Cohen wrote:
>> Hi,

Hi Christoph,

>>
>> This patchset extends sfi_device() macro support to driver modules.
>> The main use case is to allow external driver modules to be enumerated by SFI
>> on Intel Mid platforms.
>
> How about you merge those module again?  Remember code added to the
> kernel without users isn't testable, and out of tree modules do not
> bring us any value add.

I got your point.
Here's the testable user:
https://patchwork.kernel.org/patch/3179381/
By simply 'make ARCH=i386 allyesconfig' it will be selected.

But I think there is a misunderstanding here :)
My main target is to sync Intel MID codes from our internal tree to
upstream. These patches I am sending are useful to protect Intel MID
from drivers I don't own and not ready for upstreaming.
My main intention is to upstream more Intel MID codes in a faster and
more reliably way (if internal tree == upstream my tests will be
better).

Since Intel MID users are too sensitive to time to market (sorry to
bring this scenario but we can't run from it on embedded world) I can't
prevent drivers not ready yet for upstreaming to use sfi_device() macro.

So, given my intention is to increase upstreamed codes, do you think it
makes sense to have this sfi_device() modularization support?

Br, David Cohen
